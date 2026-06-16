#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Implementation <sec:impl>
  
== Development Sprints

MovieCrush was built over three months in an iterative way, split into three sprints. Before the first sprint, a full discovery phase was completed and presented as a product pitch.

=== Initial Presentation - Discovery Phase

Before any coding started, a detailed product presentation was prepared. At this stage the following was completed:

- Vision and Mission of the product
- Goals and reasoning for why the idea is promising
- Full market analysis and competitor research
- Description of unique features and how they differ from existing solutions
- Target audience profile and stakeholder analysis
- Business analysis: monetization model, pricing strategy, user growth projections
- Risk assessment and mitigation plan
- First logo ideas
- Design mockups in Figma for five key screens

Deliverables set for Sprint 1:
- Software Architecture Description
- Technology Stack Selection & Justification
- Cost Breakdown & Initial Infrastructure Setup
- Business Process Research Finalization
- MVP implementation

=== Sprint 1 - Month 1: Research and Architecture

*Goals:* finish the research phase, design the architecture, and prepare the technical base before coding began.

*What was done:*

The main outcome of this sprint was a large quantitative study: a survey of 262 respondents distributed through the KSE Slack community. It measured demand for product features, willingness to pay, and current pain points of the target audience. After analyzing the data, charts, and conclusions for each feature - AI recommendations, Wrapped, Soulmate, detailed ratings - Product-Segment Fit was confirmed for the 18-24 age group.

In parallel, data modeling was completed: 26 tables were designed with data types, sizes, and constraints defined, entity relationships and join tables were built (movie_genres, movie_countries). Load was estimated across three growth scenarios, and the 90/9/1 rule was applied to the comments table. Total database size at full load was estimated at ~6.4 GB. RPS was also calculated for conservative, realistic, and optimistic scenarios.

AI recommendations were also scoped this sprint. Three services were reviewed - OpenAI, DeepSeek, and Hugging Face Inference API - along with two recommendation strategies: Embedding API + similarity and LLM generation. DeepSeek was selected as the external AI service, and the idea of an in-app AI chat (similar to ChatGPT but limited to film topics) was dropped in favor of a single AI assistant button that generates personalized recommendations.

A preliminary tech stack was defined (Redis for caching, DeepSeek API, AWS for deployment) along with initial architecture diagrams. Both the stack and the diagrams changed significantly during implementation - this is covered in the relevant sections.

*Retrospective:* No coding was done in this sprint intentionally - the priority was solid research and architecture planning. The number of database tables changed between planning and implementation: from 26 designed to 18 built, as some tables turned out to be unnecessary or were replaced by a different approach (for example, a separate movies table was replaced by the tmdb_media_cache strategy).

Deliverables set for Sprint 2:
- Stack setup
- Registration and login
- Movie search
- Adding movies to lists and creating custom lists
- Rating movies and writing comments
- Movie, series, and actor detail pages
- Following other users

=== Sprint 2 - Month 2: MVP

*Goals:* build the core of the product - authentication, content catalog, rating system, and main screens.

*What was done:*

*Authentication.* A full auth flow was built: registration with field validation, email confirmation, login, and password recovery. Validation runs on the client before any request, with per-field errors shown on a touched state. On the backend, bcrypt verifies passwords, and the comparison always runs - against a dummy hash even when the user does not exist - so account existence is not leaked through response timing. After login, the access and refresh tokens are stored and navigation resets to Home, so the user cannot return into the auth flow.

*Core screens.* The main screens - Home, Search, Movie, Series, Person, Profile, Settings, and the cold-start Recommendation screen - were implemented; their layout and visuals are covered in the UX section and the screen gallery (@sec:screen-gallery). A few implementation details are worth noting: search uses a 500 ms debounce with a 2-character minimum, and the Home and Movie screens fetch all their data in parallel via `Promise.all`, so returning to a screen triggers no refetch. When a movie page opens, its TMDB data - details, cast, gallery, videos, and similar titles - is fetched together with the user's own rating and list state in a single batched request.

*Data protection.* Every state-changing request passes through `authMiddleware`, which returns 401 without a valid access token and rejects refresh tokens on protected endpoints. Ownership is enforced at the query level - deleting a custom list, for example, checks both the list ID and that it belongs to the current user.

*Content storage.* The movie catalog is not duplicated in the database - only `tmdb_id` references are stored, and full metadata is fetched from TMDB on demand and cached.

*Retrospective:* Following other users was not finished in this sprint and was moved to Sprint 3 as a priority. It also became clear that DeepSeek would not work for AI recommendations - the committee pointed out that the model could ignore a large prompt or return irrelevant results. Finding an alternative became a task for the next sprint.

Deliverables set for Sprint 3:
- Wrapped analytics
- Improved AI recommendations
- Soulmate matching algorithm
- Following users and social features
- Challenges, Instagram share templates, language switch, PDF export, premiere notifications (planned, not implemented due to reprioritization)

=== Sprint 3 - Month 3: Key Features and AI

*Goals:* build the features that make MovieCrush different - Soulmate, Wrapped, the social layer, and AI recommendations. Rethink the recommendation engine.

*What was done:*

*Social Features / Follows.* A full follower model was built: following and unfollowing other users, viewing their public and default lists, and mutual follow status (friends). When two users are friends, their Instagram or Telegram contacts can optionally be visible to each other. Users can be found through the global search. On movie, series, and episode pages, ratings from followed users are now shown.

*Soulmate.* An opt-in feature (toggled in Settings) that finds the user with the most similar film taste. The weighted five-metric scoring, eligibility filtering, and the once-per-day recompute are described in full in @sec:algorithms; this sprint delivered the feature end to end, from candidate filtering to the result UI.

*MovieCrush Wrapped.* Personalized yearly statistics: total watch time, number of movies, series, and episodes, top genre, top director, top actors, most common mood after watching, typical watch time (cinema ritual), and time spent with the favorite actor. Calculations use cached metadata from tmdb_media_cache - no TMDB requests are needed at generation time. Regeneration is available once per day for testing purposes.

*AI Recommendations - New approach.* During this sprint, a research study was done: 9 models were tested with 5 different prompts each - Claude Opus 4.7, Claude Haiku 4.7, Claude Sonnet 4.6, GPT 5.4, GPT 5.4 mini, GPT 5.5, Gemini Flash, Gemini Pro, and Gemini Thinking. The prompt design was informed by two papers: @sun2024grouplens recommended passing up to 75 movies with ratings and is_liked/is_disliked flags, and using a composition rule for result categories (strong_match, diversity, hidden_gem). @kusano2025prompt showed that prompt structure matters more than model choice, and that cheaper models like Gemini Flash give comparable quality at ~90% lower cost.

The full model comparison, prompt designs, and per-model outputs are documented at: #link("https://app.notion.com/p/AI-recommendations-34d197e7fb1680f484f0fedc52ee2909")[AI Recommendations Research - Notion].

However, the committee raised concerns about a purely LLM-based approach: the model couldn't return art-house picks, get lost in a long prompt, or miss context when given many movies. This led to the decision to move to a hybrid pipeline with collaborative filtering.

*CF Service - New recommendation engine.* A separate Python/FastAPI microservice was built around an ALS collaborative-filtering model, with Gemini repurposed from the main recommendation source into a re-ranker over a pre-filtered candidate pool. An onboarding flow was added to collect initial signals (favorite actors and movies) so new users get recommendations until ALS has enough data. The full three-stage pipeline and the cold-start path are detailed in @sec:algorithms; this sprint delivered the working end-to-end implementation.

*Retrospective:* Several planned deliverables were intentionally not built - after reviewing survey results, the top priorities were clear: Wrapped (rated 4.24/5), AI recommendations, and social features. Not implemented: Challenges, Instagram share templates, language switch, PDF export, and premiere push notifications. These are planned for future development.

== UX Design

=== Design Philosophy

MovieCrush uses a dark theme as the only design option. This was a deliberate choice - film posters are colorful by nature, and a dark background makes them stand out without competing visual noise. All screens share the same color palette, typography, and spacing system for a consistent feel.

=== Visual Identity

*Color palette.* The palette uses four main colors: pure black (`#000000`) as the background, gold (`#FFD700`) as the primary action color, soft pink (`#FFAFCC`) as the accent used for the logo and headings, and white (`#FFFFFF`) for body text. Card surfaces use `#111111` and `#1A1A1A` to create subtle depth without breaking the dark theme. Error states use red (`#FF4D4D`) and success states use green (`#00CC66`).

*Typography.* The entire app uses Poppins - a geometric sans-serif font with four weights: Regular, Medium, SemiBold, and Bold. Poppins was chosen for its clean look on small screens and its good readability at both large display sizes and small caption sizes. All font constants are centralized in a single file so that changing a weight applies consistently across the whole app.

*Logo.* The MovieCrush logo combines the letters M and C using the brand's gold-to-pink gradient. The C is styled to suggest a heart shape, reinforcing the "crush" concept. The icon was designed to hold up at small sizes - as seen on the home screen and in the app drawer alongside Netflix and Spotify.

#figure(
  image("/resources/img/screens/logo.png", width: 40%),
  caption: [MovieCrush app icon],
)

=== Screen Overview

The three screens below carry the core experience. The remaining screens - Onboarding, Home, Search, Series, Profile, and Actor - are collected in the screen gallery (#ref(<sec:screen-gallery>, supplement: "Appendix")).

#figure(
  image("/resources/img/screens/movie.png", width: 60%),
  caption: [Movie Screen - hero backdrop, action bar, Info and Rate tabs],
)

The Movie Screen is the heart of the app: a full-width backdrop with the poster overlaid, four quick actions (Favorite, Watchlist, Watched, Dislike), and two tabs - Info (details, trailer, gallery, cast, similar titles, comments) and Rate.

#figure(
  image("/resources/img/screens/ratings.png", width: 60%),
  caption: [Rate tab - star score, 5-criteria breakdown, mood picker, best performance],
)

The Rate tab carries the full rating system: a 10-star overall score, a breakdown across five criteria (Direction, Script, Visuals, Soundtrack, Acting - each 1-5), a six-option mood picker, and a Best Performance vote.

#figure(
  image("/resources/img/screens/wrapped_soulmate.png", width: 60%),
  caption: [Challenges Screen - Soulmate result and Wrapped yearly stats],
)

The Challenges Screen hosts the two signature features. Soulmate shows the matched user with a compatibility percentage and a per-metric breakdown; Wrapped presents Spotify-style full-screen slides for top genre, director, actors, and more.

=== Design Decisions

*Figma mockups.* Initial screen layouts were designed in Figma before coding began. The mockups covered the five core screens. During implementation some layouts changed - new ideas came up and certain components were improved beyond the original design. The Figma file is available at: #link("https://www.figma.com/design/Z3bgpR99JjAwGxUYFmctoG/MovieCrush?node-id=0-1")[MovieCrush Figma].

*Logo concept.* The logo ideas are documented at: #link("https://app.notion.com/p/Ideas-of-logo-2e9197e7fb1680369452e55c023d6a7c")[Logo Ideas - Notion].

*Dark theme only.* A light theme was considered but dropped - the app is used mostly in low-light settings, and poster art reads better on a dark background.

*Emoji as visual language.* Section headers and filter chips use emoji alongside text labels. This was a deliberate choice to keep the interface feeling friendly and expressive rather than corporate - consistent with the target audience of 18-24 year olds.

== Key Algorithms <sec:algorithms>

=== Soulmate Similarity Algorithm

The Soulmate feature finds the user whose film taste is closest to yours. The algorithm computes a similarity score between two users based on five independent metrics, combines them into a single weighted score, and saves the best match if it passes a minimum threshold.

==== Five Similarity Metrics

Each metric measures a different dimension of taste overlap and uses a different mathematical technique suited to the nature of the data.

*Metric 1 - Rating Cosine Similarity (weight: 0.45).* This is the strongest signal. For every movie both users have rated, the algorithm builds two parallel numeric vectors and computes cosine similarity between them: a user who consistently rates 9/10 and a user who rates 7/10 for the same films still show high similarity if their relative preferences match. A minimum overlap of 3 jointly rated movies is required - below that, the score defaults to 0.

*Metric 2 - Watched Overlap / Jaccard (weight: 0.22).* Measures what share of total watched titles both users have in common, so the score naturally accounts for users with very different library sizes - a user with 10 watched movies and a user with 200 are compared fairly.

*Metric 3 - Actor Overlap / Jaccard (weight: 0.16).* Each time a user rates a movie, they can vote for the best actor in that film. This metric computes @jaccard similarity between the two users' sets of voted actors - capturing a deeper layer of taste alignment that goes beyond genre preferences.

*Metric 4 - Mood Cosine Similarity (weight: 0.11).* After watching a film, users select a mood: Happy, Inspired, Scared, Sad, Thoughtful, or Excited. Each user's mood history is treated as a frequency vector - how many times each mood was selected - and @cosine is computed across the shared mood space. Two users who consistently feel the same emotions after watching the same types of films are considered more compatible.

*Metric 5 - Disliked Overlap / Jaccard (weight: 0.06).* Shared dislikes are a weak but real signal - if two users consistently dislike the same films, their tastes are likely to align in the opposite direction as well. Jaccard similarity is computed on each user's set of disliked titles.

==== Weighted Score

The five metrics are combined into a single final score using fixed weights that sum to exactly 1.0. Rating carries the highest weight because numeric ratings are the most explicit and precise signal a user provides. Watched overlap is second - a shared viewing history is a strong implicit signal even without explicit ratings. Actor preferences and mood patterns follow as secondary signals. Shared dislikes have the lowest weight: agreement on what to avoid is meaningful but less decisive than positive preference alignment.

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Metric*], [*Method*], [*Weight*]),
    [Rating similarity], [Cosine similarity], [0.45],
    [Watched overlap], [Jaccard similarity], [0.22],
    [Actor overlap], [Jaccard similarity], [0.16],
    [Mood similarity], [Cosine similarity (bag of counts)], [0.11],
    [Disliked overlap], [Jaccard similarity], [0.06],
  ),
  caption: [Soulmate similarity metrics and their weights]
)

==== Full Search Flow

The algorithm first filters eligible candidates - active users who have given consent to the feature and have watched at least 5 movies. For each candidate, all five metrics are computed in parallel to minimize latency, and the weighted score is calculated. The algorithm keeps track of the highest-scoring candidate across all comparisons.

A match is saved only if the final score exceeds the minimum threshold of 0.30 - below this value the algorithm returns no match rather than suggesting a low-quality result. The result is stored in the `user_soulmate_matches` table with the full metric breakdown, so the UI can show the user exactly why they were matched - for example, Ratings 99%, Watched 18%, Actors 16%. Recompute is limited to once per 24 hours.

=== Hybrid Recommendation Pipeline

The recommendation system is a three-stage pipeline: collaborative filtering generates candidates, TMDB Discover adds diversity, and Gemini re-ranks the combined pool into a final list.

==== Stage 1 - ALS Collaborative Filtering (Python CF Service)

The CF service is a separate Python microservice on FastAPI. It trains an ALS model from the `implicit` library @frederickson2022implicit on a user-item interaction matrix built directly from the PostgreSQL database.

*Interaction matrix construction.* Each user-movie interaction is converted to a preference score that reflects the strength of the signal. Adding a movie to favorites scores highest (5.0), followed by high ratings (4.0 for 8+, 3.0 for 6-7, 2.0 for 4-5), then watchlist additions (1.5), and finally movies that were only marked as watched without a rating (1.0). The resulting matrix is stored in scipy @csr format - since most user-item pairs have no interaction at all, a sparse representation keeps memory usage low.

*BM25 weighting.* Before training, @bm25 weighting @robertson2009bm25 is applied to the matrix so that users with very large watch histories do not dominate the model's learned representations, while less active users still contribute meaningfully to the training signal.

*Model training.* The ALS model learns latent factor representations for both users and items by alternately solving for user factors and item factors while keeping the other fixed. @hu2008collaborative The model parameters (factors=24, iterations=30, regularization=1.0, alpha=20.0) were selected through a grid search optimizing Hit Rate\@10 and @mrr. The trained model and index mappings are saved to disk so that inference does not require retraining on every request.

*Inference.* At request time, the model computes a score for every item the user has not yet interacted with and returns the top N candidates as TMDB IDs. Already watched and disliked titles are filtered out before returning results.

==== Stage 2 - TMDB Discover Candidates

ALS only recommends items that were present in the training matrix. To add variety and cover cases where a user's taste is unusual or their history is small, a second candidate source is built from the TMDB Discover API @tmdb. The system builds a user profile from watch history - top 3 genre IDs, top voted actor, and allowed content buckets (movie, tv, anime, dorama, animation) - and fires parallel Discover requests for each content type the user has shown interest in. Results are deduplicated and merged into a single candidate pool, each item tagged with its source (ALS or Discover).

==== Stage 3 - Gemini Re-ranking

The tagged candidate pool is sent to Google Gemini 2.5 Flash @gemini along with a 10-film sample of the user's watch history, picked to span the full rating range - one film per rating level from 10 down to 1, so the model sees both what the user loves and what they dislike (with favorite and disliked flags included).

==== Cold Start Strategy

New users do not yet have enough watch history for ALS to produce meaningful results. For these users, a dedicated cold start service runs instead. During onboarding, users select favorite actors and rate a curated set of movies. The cold start service analyzes these signals: genre weights are computed per movie with higher-rated movies contributing more weight (rating 8+ contributes weight 3, rating 6-7 contributes weight 2), content buckets are inferred from the types of content the user responded positively to, and three parallel TMDB Discover queries run - by actor, by genre, and by popularity. Results from all three sources are merged using an interleaving strategy to keep the content type distribution balanced across the final batch of 25 recommendations. Once a user accumulates enough watch history, the system automatically switches to the full ALS + Gemini pipeline on the next recommendation request.

== Deployment and CI/CD <sec:deployment>

=== Deployment Process

==== Infrastructure Decisions

Choosing where to host MovieCrush went through two iterations before landing on the final setup.

*AWS (dropped).* The original plan was to deploy on AWS. However, the AWS account had previously been blocked due to an outstanding balance. The decision was made not to restore it and look for an alternative - the risk of getting blocked again in the middle of active development was too high.

*Render + Neon (intermediate).* The next setup was Render for the backend and Neon as a separate managed PostgreSQL provider. This worked but had two real problems. First, the database was outside Render's network, which meant every query from the backend had to travel over the public internet to reach it. This added latency to every single request. Second, having the database reachable from the public internet is a security concern in itself - the database was not inside a private network with the backend, so it was exposed in a way that a production system should avoid.

*Render only (final).* Moving both the backend and the database to Render solved both problems. Render Postgres is managed PostgreSQL hosted in the same infrastructure as the backend services. Queries between the backend and the database stay inside Render's private network - no public internet hop, lower latency, and the database is not exposed outside the private network. Render also provides automatic daily backups and handles PostgreSQL maintenance automatically.

==== Docker Multi-stage Build

Both the backend and the CF service are packaged as Docker images using multi-stage builds. The multi-stage approach keeps the final image small: a build stage compiles TypeScript or installs all Python dependencies, and a separate runtime stage copies only what is needed to run.

For the backend, the build stage installs all dependencies including dev tools and compiles TypeScript to `dist/`. The runtime stage starts fresh, installs only production dependencies, and copies just the compiled output. This means the final image does not carry TypeScript, ts-node, or any other build-time tooling.

Both services are deployed on Render as separate web services. They can be updated and redeployed independently - for example, retraining the ALS model and redeploying the CF service does not require touching the backend.

==== Mobile Distribution

The mobile app is built using EAS Build (Expo Application Services). Building in the cloud removes the need for a local Mac to produce the iOS-compatible bundle. For Android testing and distribution, EAS produces an APK that can be shared directly - no Play Store account is required for this stage.

=== CI/CD Pipeline

The CI pipeline runs on GitHub Actions on every push to `main` and on feature, fix, and chore branches, as well as on pull requests to `main`. It has four jobs that run in a defined order.

*Job 1 - Backend: TypeScript + tests.* Installs Node.js 20, runs `npm ci`, then performs three checks in sequence: TypeScript type check, the Jest unit test suite, and a production build. All three must pass before the Docker build job is allowed to start.

*Job 2 - Mobile: TypeScript check.* Installs dependencies for the React Native project and runs a TypeScript type check. This catches type errors in the mobile codebase without needing to run a full Expo build on every push.

*Job 3 - CF Service: install + import check.* Sets up Python 3.11, installs requirements, and runs a quick import check to confirm that the core modules load without errors. This catches broken dependencies or import-time failures before a broken CF service image gets built.

*Job 4 - Docker: build images.* Runs only after the backend and CF service checks pass. Builds both Docker images to confirm that the full containerized build works end to end.

Deployment to Render is triggered automatically on every commit. Render detects the new commit and redeploys the service without any manual steps - so a passing CI run and a successful deploy happen together as part of the same push.
