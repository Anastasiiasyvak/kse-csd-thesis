#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#show figure.where(kind: table): set block(breakable: true)
#pagebreak()
= #i18n("design-title", lang:option.lang) <sec:design>

== Architecture Overview and Requirements Alignment

The MovieCrush architecture targets the requirements from the domain analysis: personalized recommendations, user data storage, and social features between users.

The system is built as a modular monolith for the main backend, plus a separate machine learning microservice for recommendations. This approach keeps the main business logic clear and easy for one developer to maintain, while moving heavy ML calculations into an independent service that can be updated and scaled separately.

=== Functional Requirements

==== Personalized Movie Recommendations

Recommendations use a hybrid pipeline: ALS collaborative filtering generates candidates, TMDB Discover adds variety, and Gemini re-ranks the combined pool into a final categorized list, with a separate cold-start path for new users during onboarding. The full algorithm is detailed in @sec:algorithms.

==== Social Features and "Soulmate" Matching
The social system works on a follower model between users. In addition, there is a "movie soulmate" search feature - the user with the most similar taste. Similarity is calculated as a weighted combination of five metrics (rating, watched, actor, mood, and disliked overlap), detailed with their weights in @sec:algorithms. The resulting similarity_score is stored in PostgreSQL for fast sorting and matching. Search is only performed among users who have explicitly agreed to take part in this feature.

==== Comprehensive Rating System
The rating architecture supports both a simple overall score (scale 1-10) and a detailed aspect rating: direction, acting, script, music, and visual effects (each on a scale 1-5). This allows leaving either a quick rating or a detailed review.

==== Search and Content Discovery
Information about movies and series is obtained through the catalog module, which calls the TMDB API. The module uses lazy loading: detailed movie data is fetched only when the user opens its page. At the same time, metadata is stored in a PostgreSQL table (tmdb_media_cache), so the next request goes to the local database instead of TMDB - faster and cheaper. This cache is also used when generating annual Wrapped statistics. The cache follows a Read-Through strategy - metadata is fetched from TMDB on first access and stored locally for future use. There is currently no TTL on cached entries, as fields like title, genres, cast, and release year rarely change after a title's release.

==== User Engagement Features
The MovieCrush Wrapped module collects user actions over a year (views, ratings, moods, favorite actors) and builds personalized statistics. Calculations rely on cached movie metadata, so dozens of requests to TMDB are not needed at generation time.

=== Non-Functional Requirements

- *Performance*. Critical read operations are optimized with two-level caching: movie metadata is stored in a PostgreSQL table (tmdb_media_cache), and frequently used data is kept in the application's in-memory LRU cache. This reduces load on both the external TMDB API and the database. Gemini re-ranking results are cached for 24 hours.

- *Data Consistency*. For critical operations (ratings, lists, social connections), ACID transactions in PostgreSQL are used. Integrity is also ensured by foreign keys and constraints at the database schema level.

- *Scalability*. The modular monolith with clear boundaries between modules (auth, profile, movies, soulmate, recommendations, and so on) allows individual parts to be extracted into independent services in the future. The ML component is already a separate service, deployed and scaled independently.

- *Security*. The system uses JWT authentication with short-lived access tokens and long-lived refresh tokens. Passwords are hashed with the bcrypt algorithm. The API is protected by security HTTP headers (helmet), rate limiting, and CORS policies. The mobile app communicates with the backend over HTTPS - Render automatically provides a TLS certificate for all public services.

- *Reliability*. Both services run as Docker containers, and the database is co-located with the backend, removing an extra network hop. The recommendation model is currently retrained manually; scheduled retraining is planned (see Limitations).

== System Architecture and Major Decisions

=== Modular Monolith Architecture Decision

**Decision:** Implement a modular monolith architecture with clear boundaries between domains instead of a microservices architecture.

**Reasoning:** Given the team size (one developer), project timeline, and current system scale, a modular monolith provides several benefits:

- *Development efficiency.* One developer does not waste time setting up inter-service communication, distributed queues, and separate deployments for each service. This allows faster feature implementation and easier system debugging.

- *Data consistency.* Critical operations, such as marking a movie as watched, update several tables at once: user_movie_actions, user_lists, and counters in users. All of this runs inside a single ACID PostgreSQL transaction - no complex distributed transaction logic between services.

- *Deployment simplicity.* One Docker container - one deployment. The CI/CD pipeline stays simple and predictable.

- *Future scalability.* The system modules have clear boundaries (auth, profile, movies, lists, follows, soulmate, recommendations, wrapped, etc.) so if needed, a single module can be extracted into an independent service without rewriting the whole application. The resource-heavy ML component is already separated this way - as a separate CF service on Python.

**Trade-offs considered:** A microservices architecture provides independent scaling for each component and technological flexibility. However, its complexity and operational costs greatly outweigh the benefits for the current project with one developer.


== System Context and External Interactions

The system context diagram shows where MovieCrush sits among external services and users. It integrates with external services for content, AI, and email.

#figure(
  image("/resources/img/diagrams/System_Context_Diagram.png", width: 100%),
  caption: [System Context Diagram - MovieCrush Platform Ecosystem. #link("https://drive.google.com/file/d/1cGcTg2rdTOKXIJxj5dMGIUH-Rr3wzSW6/view?usp=sharing")[Available here]],
)

=== Main External Integrations

==== TMDB API
Provides the full catalog of movies and series: metadata, actor information, posters, backdrops, trailers, and external ratings. To stay within free tier limits, two caching levels are implemented: an in-memory LRU cache with a 5-minute TTL for hot requests, and permanent metadata storage in a PostgreSQL table (tmdb_media_cache) for data that does not change often (title, genres, cast, release year).

==== Google Gemini 2.5 Flash
Used for re-ranking recommendations. It receives a candidate list from the ALS model and TMDB Discover, analyzes the user's taste based on their ratings, and picks the 15 best options, assigning a category to each. Results are cached in the database for 24 hours to avoid calling the model on every request.

==== Resend
A transactional email service used to send email verification letters during registration and password recovery emails.

=== Mobile Users
The main users of the platform, who interact with MovieCrush through a mobile app for Android and iOS built on React Native/Expo. The app is built as an APK for Android using EAS Build, the iOS version is cross-platform compatible but requires an Apple Developer account for public distribution.

Users can: search and discover new movies and series, leave detailed ratings, create their own lists, follow other users and find their movie soulmate, and receive personalized recommendations.


== Container Architecture and Service Decomposition

The architecture is described at two levels of the C4 model. The container diagram gives the high-level technical view - the mobile app, the backend as a modular monolith, the separate machine learning (CF) service, the database, and external integrations - and the component diagram then zooms into the backend container to show its internal modules.

#figure(
  image("/resources/img/diagrams/ContainerDiagram.png", width: 100%),
  caption: [Container Diagram - MovieCrush Architecture and Data Flows. #link("https://drive.google.com/file/d/1eCiHUjNHjcKsegtIlhMviZUyPnw36XZQ/view?usp=sharing")[Available here]],
)

The container diagram shows how the parts communicate: the mobile app calls the backend over HTTPS/REST with JWT authentication, the backend persists all data in PostgreSQL, requests recommendation candidates from the CF service over HTTP, and integrates with TMDB, Google Gemini, and Resend. The CF service reads user interactions from the same database. Hosting on Render is shown as a deployment annotation on the containers rather than as a separate node, since it is infrastructure rather than a domain integration.

Zooming into the backend, the component diagram shows its internal structure as a modular monolith - eleven feature modules inside a single deployable container, where only the modules that need external data reach out to the CF service, Gemini, TMDB, and Resend.

#figure(
  image("/resources/img/diagrams/ComponentDiagram.png", width: 100%),
  caption: [Component Diagram - Backend API internal modules. #link("https://drive.google.com/file/d/1F20j4WeaVZRJTNkM_MEgPXTIRPt31_Al/view?usp=sharing")[Available here]],
)

=== Backend Modules

The backend is organized into eleven feature modules, each owning its own routes, controller, and service. Two additional folders - `shared` (common user queries and types) and `tmdb_cache` (an internal caching service) - support these modules but are not standalone modules, so they are not counted among the eleven. Modules that need movie data (Movies, Recommendations, Follows) do not call the TMDB API directly; they access it through the TMDB module, which is the single integration point with the external TMDB API.

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Module*], [*Responsibility*], [*Key Functions*]),
    [Auth], [Authentication], [Registration, login, email verification, password reset],
    [Profile], [User profile], [View and edit name, avatar, Instagram/Telegram links],
    [Settings], [Configuration], [Username, password, soulmate consent, account deletion],
    [Movies], [Movies and series], [Ratings (1-10 + 5-criteria detailed score), mood tagging, comments, best actor vote, episode tracking],
    [Lists], [Lists], [Watchlist, favorites, watched, custom lists with privacy toggle],
    [Follows], [Social connections], [Follow/unfollow, view friends' ratings on a specific title, user search],
    [Soulmate], [Soulmate search], [Similarity score across 5 metrics, result storage, on-demand recompute],
    [Recommendations], [Recommendations], [Hybrid pipeline: ALS via CF service + Gemini reranking, cold start for new users],
    [TMDB], [Catalog], [Movie/series/person details, search, trailers, cast via TMDB API with LRU cache],
    [Onboarding], [Onboarding], [Favourite actors and movies selection during signup for cold start],
    [Wrapped], [Yearly statistics], [top genres, actors, directors, moods, total watch time, cinema vibe],
  ),
  caption: [Backend modules and their responsibilities]
)

=== Data Storage Layers

#figure(
  table(
    columns: (auto, auto),
    align: left,
    table.header([*Storage*], [*Purpose*]),
    [PostgreSQL], [Main database - 18 tables, ACID transactions. Stores everything: accounts, ratings, lists, social connections, TMDB metadata cache, recommendation results],
    [LRU in-memory cache], [Caches TMDB API responses at the process level, TTL 5 minutes, maximum 500 entries],
    [tmdb_media_cache (PostgreSQL)], [Permanent storage of movie metadata (title, genres, cast, year). Used by Wrapped and recommendations],
    [user_ai_recommendations (PostgreSQL)], [Cache for Gemini re-ranking results, TTL 24 hours],
  ),
  caption: [Data storage layers and their purposes]
)


== Technology Stack Selection

=== Frontend - Mobile Application

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Technology*], [*Decision*], [*Justification*]),
    [React Native], [Cross-platform mobile framework], [One codebase for both iOS and Android. As a solo developer, building two separate native apps was not realistic. Expo adds helpful build tools and allows updates without going through app stores.],
    [Expo + EAS Build], [Build and distribution], [EAS Build creates the APK in the cloud, so no local Mac is needed. For Android testing, the APK is shared directly without a Play Store account.],
    [TypeScript], [Type system], [Catches type errors at compile time. With many API response shapes across the app, having typed interfaces makes it much easier to find mismatches between the mobile client and the backend.],
    [React Navigation], [Navigation], [The standard navigation library for React Native. Works well on both platforms and handles all the screen changes in the app.],
  ),
  caption: [Frontend technology decisions]
)

=== Backend

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Technology*], [*Decision*], [*Justification*]),
    [Node.js], [Runtime], [JavaScript on the server means the same language as the mobile client, which reduces switching between languages. The non-blocking I/O model also works well for an API that makes many requests at the same time to TMDB, Gemini, and the CF service.],
    [TypeScript], [Type system], [Strict mode is turned on across the whole codebase. Typed request and response interfaces make code changes safer and reduce the chance of runtime errors in production.],
    [Express.js], [HTTP framework], [Lightweight and simple, which fits the modular monolith structure well. Each module sets up its own router, so the codebase stays organised without the extra weight of a bigger framework.],
    [pg], [PostgreSQL client], [Raw SQL gives full control over queries, which matters for complex joins in the soulmate algorithm and the Wrapped calculations.],
    [bcryptjs], [Password hashing], [Standard for storing passwords securely. Passwords are never stored as plain text.],
    [jsonwebtoken], [Authentication], [JWT with separate short-lived access and long-lived refresh tokens. Stateless tokens work well for a mobile client that cannot keep server-side sessions.],
    [helmet], [Security headers], [Sets HTTP security headers with a single middleware call.],
    [express-rate-limit], [Rate limiting], [Limits each IP to 200 requests per minute on all `/api/*` routes.],
    [lru-cache], [In-memory caching], [Saves TMDB API responses in process memory with a 5-minute lifetime and a maximum of 500 entries. No separate caching service like Redis is needed.],
    [resend], [Email delivery], [Handles verification and password reset emails. Simpler to set up than self-hosted email and has better delivery success.],
    [Jest + ts-jest], [Unit testing], [Used to test the soulmate similarity algorithm, ALS service logic, Wrapped calculations, auth validators, episode helpers, and TMDB helpers.],
  ),
  caption: [Backend technology decisions]
)

=== CF Service - Collaborative Filtering

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Technology*], [*Decision*], [*Justification*]),
    [Python], [Language], [The ML ecosystem in Python is much more mature than in Node.js. Running the model in a separate Python service keeps the backend clean and free of heavy libraries.],
    [FastAPI], [HTTP framework], [Async-friendly and minimal. Faster to write than Flask for a service that only exposes a few endpoints.],
    [implicit], [ALS library], [Provides a fast ALS implementation for feedback data. BM25 weighting is applied to the user-item matrix before training to account for different interaction strengths - watched, rated, favourited.],
    [scipy], [Sparse matrices], [The user-item matrix is mostly empty by nature. scipy's CSR format stores only non-zero entries, which keeps training and prediction memory-efficient.],
    [scikit-learn + matplotlib], [Evaluation], [Used offline to measure model quality and to tune settings before deploying the trained model.],
    [psycopg2], [PostgreSQL client], [Reads user interaction data directly from the shared PostgreSQL database to build the training matrix.],
  ),
  caption: [CF service technology decisions]
)

=== Database

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Technology*], [*Decision*], [*Justification*]),
    [PostgreSQL], [Primary database], [ACID-compliant relational database. The data model - users, ratings, lists, social connections, soulmate scores, recommendation cache - is relational with many foreign key constraints and multi-table transactions. JSONB columns are used to store cast data in `tmdb_media_cache`.],
  ),
  caption: [Database technology decisions]
)

=== Infrastructure and Deployment

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Technology*], [*Decision*], [*Justification*]),
    [Docker], [Containerisation], [Multi-stage images (separate build and runtime stages) keep the final runtime small.],
    [Render], [Cloud hosting], [Docker-based deploy with automatic HTTPS and no infrastructure management; chosen after AWS was dropped. Full migration rationale in @sec:deployment.],
    [Render Postgres], [Managed PostgreSQL], [Managed PostgreSQL co-located with the backend, which removes the public-internet hop and keeps the database off the public network; automatic daily backups. Migration story in @sec:deployment.],
    [GitHub Actions], [CI/CD], [Runs TypeScript checks, the Jest suite, a production build, and Docker image builds on every push. Pipeline detailed in @sec:deployment.],
  ),
  caption: [Infrastructure and deployment decisions]
)


== Cross-cutting Concerns

=== Security

==== Authentication and Authorisation
The system uses JWT authentication with two separate tokens. After a successful login, the user receives an access token that lives for 15 minutes and a refresh token that lives for 30 days. The access token is sent in the Authorization header as `Bearer <token>` with every API request. The authMiddleware checks the token signature and makes sure the token type is access, since refresh tokens are rejected on protected endpoints. All backend modules apply this middleware before handling any request.

==== Passwords
Passwords are hashed using bcryptjs before saving. Plain text passwords are never stored anywhere in the system.

==== Data Transfer Security
All communication between the mobile app and the backend happens over HTTPS. Render automatically provides and renews TLS certificates for all public services, so manual certificate management is not needed.

==== API Protection
The backend uses helmet to set security HTTP headers on every response, and express-rate-limit to limit each IP address to 200 requests per minute on all `/api/*` routes.

=== Monitoring and Observability

The current monitoring approach is deliberately simple and matches the scale of the project.

==== Logging
The backend uses structured logging via the pino library instead of plain console output. A shared logger instance writes JSON-formatted logs, with the log level controlled by an environment variable (info in production, debug in development, with pino-pretty for readable local output). HTTP requests are logged automatically through the pino-http middleware, which records method, URL, and status code for every request, while application code logs key events - startup, database connection status, and errors - through the same logger. Render automatically captures this output and shows it in the service dashboard. The CF service follows the same principle using Python's standard logging module, configured centrally with timestamp, level, and logger name, and used for model training progress and recommendation requests.

==== Health Check
The backend has a `/health` endpoint that returns `{ status: "ok" }`. Render uses this to monitor service availability and automatically restarts the container if it stops responding.

==== Possible Improvements
For a production system with higher load, the next steps would be centralised log aggregation across both services, request tracing with correlation IDs propagated from the backend to the CF service, and automated alerts on error rates and response time. In the current version of the project, this was outside the scope.

=== Error Handling

All database operations are wrapped in try/catch blocks. For critical operations that update several tables at once - for example, marking a movie as watched, which updates user_movie_actions, user_lists, and counters in users - explicit transactions with BEGIN, COMMIT, and ROLLBACK are used. If any step inside a transaction fails with an error, all changes are undone and the database stays in a consistent state.

For calls to third-party services (TMDB, Gemini), the current handling is a plain try/catch with a graceful fallback. A production-grade improvement would be a circuit breaker with retry: transient failures (e.g. a 500) are retried after a short delay, and if a service keeps failing, the breaker opens and requests are short-circuited for a cooldown period instead of repeatedly hitting a service that is already down @circuitbreaker. This is noted as a future improvement.

=== Data Consistency

The database schema ensures data integrity at the PostgreSQL level. All tables with user data have foreign keys with ON DELETE CASCADE - for example, ratings, lists, comments, follows, and soulmate matches are automatically deleted if the user itself is deleted. This makes sure no records are left in the database without a link to an existing account.


== Database Design

The database schema was designed before implementation, with each table  in terms of field types, constraints, and storage requirements. For each table, the maximum size per row was calculated in bytes, and then projected across three growth scenarios to estimate total storage needs.

=== Schema Overview

The final implementation contains 18 tables. The schema went through several revisions during development - some tables from the original plan were removed (for example, a separate `movies` table was replaced by the `tmdb_media_cache` approach), and new ones were added based on emerging requirements.

=== Storage Estimation Methodology

For each table, the row size was calculated by summing the maximum byte size of each field. Three projection scenarios were used:

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Scenario*], [*MAU*], [*Registered users (× 2.2)*]),
    [Conservative], [30 000], [~66 000],
    [Realistic], [100 000], [~220 000],
    [Optimistic], [250 000], [~550 000],
  ),
  caption: [Growth scenarios used for storage estimation]
)

The 2.2 coefficient converts MAU to total registered users - it accounts for the typical ratio between accumulated and active audiences in social apps, based on the assumption that around 45-55% of registered users remain active after 12 months.

For the content catalog, the Pareto principle (80/20 rule) was applied: since roughly 20% of titles receive 80% of user interactions, only ~294,000 out of 1.26 million TMDB movies were considered realistic candidates for active caching. This avoided overestimating storage for the media cache table.

User behaviour assumptions were also applied per table - for example, comments were estimated using a 90/9/1 split: 90% of users write zero comments, 9% write 1-5, and 1% write 10-50+, giving an average of ~0.47 comments per user.

=== Key Design Decisions

*Dual ID system in users table.* Each user has an internal `BIGINT id` used for all foreign key relationships and joins, and a separate `CHAR(36) uuid` exposed in public-facing APIs. This prevents internal IDs from being enumerable in API responses.

*Counter columns in users table.* Fields like `movies_watched`, `followers_count`, and `friends_count` are stored as denormalised counters updated by application logic rather than computed on every query. This trades a small write overhead for faster profile reads.

*JSONB for cast data.* The `top_cast` column in `tmdb_media_cache` stores the top 10 actors as a JSONB array rather than a separate join table. Since cast data is always read as a unit and never queried individually, this avoids an unnecessary join on every movie detail request.

*ON DELETE CASCADE on all user-owned data.* Every table that stores user content - ratings, lists, comments, follows, soulmate matches - has a foreign key to `users(id)` with `ON DELETE CASCADE`. Deleting a user account automatically removes all associated data without requiring application-level cleanup logic.

The full storage calculations and per-field justifications were documented during the discovery phase and are available at: #link("https://docs.google.com/spreadsheets/d/1_dura7XQszr3Q1t2MPR7oEmg-by66hPnrtlbb6_Xav4/edit?usp=sharing")[Data Modelling Spreadsheet].


== User Growth Projections

To estimate system load, realistic user growth targets were defined first. Benchmarking against competitors was considered but rejected because Letterboxd has 17 million monthly users after 13 years on the market, which is not a useful baseline for a new product.

Instead, growth projections were built around four key drivers
specific to MovieCrush:

- *Wrapped virality* - the strongest driver, similar to how Spotify Wrapped generates millions of social media posts every December
- *Soulmate feature* - social motivation to invite friends and find matches
- *AI recommendations* - a useful feature that drives retention
- *Paid marketing* - eventual budget for user acquisition

Three scenarios were defined:

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    table.header([*Scenario*], [*Year 1 MAU*], [*Year 2 MAU*], [*Year 3 MAU*]),
    [Conservative], [30,000], [100,000], [250,000],
    [Realistic], [100,000], [500,000], [1,000,000],
    [Optimistic], [250,000], [1,200,000], [2,500,000],
  ),
  caption: [MAU growth projections across three scenarios]
)

The realistic scenario is grounded in four concrete arguments:

+ Ukraine has ~30 million people. Capturing 0.3% of the population gives 100,000 users - a realistic target for a quality niche app.
+ If 20% of 100,000 users share their Wrapped report on Instagram (20,000 posts) and each brings 2 new users, that adds 40,000
  users through virality alone.
+ Expanding to the US and Europe is a planned next step after the Ukrainian market is established. These markets are
  larger and would make 500 000+ users achievable in year 2-3 with the right positioning.
+ Comparable social apps at launch - Goodreads, early Duolingo - showed similar growth patterns in their first two years.

DAU is estimated at 20% of MAU, which is a standard ratio for social and entertainment apps. These numbers feed directly into the load estimation in the next section.

== Capacity Planning and Load Estimation

Before making architectural decisions, a load estimation was done to understand how many requests the system would need to handle
at different growth stages. The full calculations are available at:
#link("https://docs.google.com/spreadsheets/d/1qcZocZ7fJ2jNEh-gGgsBA1W99wH_F3LBPKEYfw5ocTo/edit?usp=sharing")[Load Estimation Spreadsheet].

One user makes roughly 81 requests per day across all actions: opening the app, searching for films, viewing movie pages, rating,
commenting, and browsing recommendations. Using 20% of MAU as DAU, requests per second (RPS) were calculated for three scenarios:

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    table.header([*Scenario*], [*MAU*], [*DAU*], [*RPS*]),
    [Conservative - Year 1], [30,000], [6,000], [~6],
    [Conservative - Year 2], [100,000], [20,000], [~20],
    [Realistic - Year 1], [100,000], [20,000], [~20],
    [Realistic - Year 2], [500,000], [100,000], [~90],
    [Optimistic - Year 1], [250,000], [50,000], [~50],
    [Optimistic - Year 2], [1,200,000], [240,000], [~220],
  ),
  caption: [RPS estimates across growth scenarios]
)

Request types follow a read-heavy pattern: 70% GET (browsing movies, profiles, recommendations), 20% POST (ratings, comments, lists), 8% PUT (profile and settings updates), and 2% DELETE.

The key findings from this analysis directly shaped architectural decisions:

- *~6 RPS (conservative Year 1)* - a single server handles this
  comfortably. This confirmed that starting with a modular monolith
  on a single Render instance was the right call, with no need for
  load balancing at launch.
- *~90 RPS (realistic Year 2)* - at this level, caching becomes
  critical. This justified the two-level caching strategy: in-memory
  LRU for TMDB responses and PostgreSQL tables for recommendation
  results.
- *220+ RPS (optimistic)* - would require horizontal scaling and
  potentially extracting high-traffic modules into separate services.
  The modular monolith structure was chosen specifically to make
  this transition possible without rewriting the whole system.