#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Implementation <sec:impl>
  
== Development Sprints

MovieCrush was built over three months in an iterative way, split into three sprints. Before the first sprint, a full discovery phase was completed and presented as a product pitch.

=== Initial Presentation - Discovery Phase

Before any coding started, a detailed product presentation was prepared. It became the foundation for all decisions that followed. At this stage the following was completed:

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

In parallel, data modeling was completed: 26 tables were designed with data types, sizes, and constraints defined, entity relationships and join tables were built (movie_genres, movie_countries). Load was estimated across three growth scenarios, and the 1-9-90 rule was applied to the comments table. Total database size at full load was estimated at ~6.4 GB. RPS was also calculated for conservative, realistic, and optimistic scenarios.

An important decision made during this sprint was the approach to AI recommendations. Three services were reviewed - OpenAI, DeepSeek, and Hugging Face Inference API - along with two recommendation strategies: Embedding API + similarity and LLM generation. DeepSeek was selected as the external AI service, and the idea of an in-app AI chat (similar to ChatGPT but limited to film topics) was dropped in favor of a single AI assistant button that generates personalized recommendations.

A preliminary tech stack was defined (Redis for caching, DeepSeek API, AWS for deployment) along with initial architecture diagrams. Both the stack and the diagrams changed significantly during implementation - this is covered in the relevant sections.

*Retrospective:* No coding was done in this sprint intentionally - the priority was solid research and architecture planning. The number of database tables changed between planning and implementation: from 26 designed to 17 built, as some tables turned out to be unnecessary or were replaced by a different approach (for example, a separate movies table was replaced by the tmdb_media_cache strategy).

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

*Authentication.* A full auth flow was built: registration with validation (username, password, optional first and last name), email confirmation, login, and password recovery via email. Validation runs on the frontend before any request is sent; errors appear under each field individually using a touched state. On the backend, passwords are compared using bcrypt - even if the user does not exist, the comparison still runs against a dummy hash to prevent timing attacks. After a successful login, the accessToken and refreshToken are saved and navigation fully resets to Home so the user cannot go back.

*Home Screen.* A header with the MovieCrush logo and a button to go to the user's profile, a footer for tab navigation. Four horizontal content rows: Trending Movies This Week, Trending Series This Week, Upcoming, and Top Rated All Time. Each row is a separate component that takes a title, a data array, and a type (movie or tv) and renders a horizontal FlatList with the first 10 items. Four TMDB requests run in parallel via Promise.all when the screen mounts - no repeated requests when navigating back.

*Search.* Live search with 500ms debounce and a minimum of 2 characters. Three tabs: All, Media, and Cast - switching tabs automatically restarts the search. User search was added in the next sprint.

*Movie Screen.* Poster, title, IMDb rating, adding to lists (Watched /Watchlist/Favorite/custom), dislike, movie details, trailer link, gallery of film stills, cast with links to actor pages, similar movies. Comments system: signed or anonymous, with or without spoilers, like/dislike, editing and deleting own comments. Rating system: overall score (1-10), detailed score across five criteria, mood after watching, best actor pick, and rating reset. When a movie page opens, four TMDB requests run in parallel: main info, cast, gallery, and similar movies.

*Series and Episode Screen.* Same as Movie Screen plus season and episode counts. Each season can be expanded to show its description and episode list. Each episode can be opened to view details, be marked as watched, and receive a rating. The series status is shown: ongoing, finished, or cancelled.

*Person Screen.* Photo, name, place and date of birth, age, biography with read more / read less, filmography with Acting and Crew tabs and links to each title, and known-as names.

*Profile Screen.* Photo, username, full name, registration date, linked Telegram and Instagram, counters for friends, followers, following, watched movies, series, and episodes. Default and custom lists with the ability to view contents, remove movies, manage privacy, and delete non-default lists.

*Settings Screen.* Change username, name, and password. Link Instagram and Telegram. Toggle consent for the Soulmate feature. Log out and delete account.

*Recommendation Screen.* Cold start recommendations using the TMDB /discover endpoint with filters for genre, year, country, and rating. If multiple content types are selected (movies + series), requests run in parallel via Promise.all and results are merged without duplicates. A "New batch" button changes the seed to load the next batch of results.

*Data protection.* Every request that changes data goes through authMiddleware - without a valid token the server returns 401 Unauthorized. When deleting a list, the server checks not just the list ID but also that it belongs to the current user

*Content storage.* Movies are not stored in the database - only the tmdb_id. Details are fetched from TMDB on demand.

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

*Soulmate.* A feature that finds the user with the most similar taste. Participation is opt-in - controlled in Settings. The algorithm filters eligible candidates (active accounts, with consent, at least 5 watched movies), computes a similarity score for each one, and saves the best match to the user_soulmate_matches table if the score is above the minimum threshold. Recompute is available once per day.

*MovieCrush Wrapped.* Personalized yearly statistics: total watch time, number of movies, series, and episodes, top genre, top director, top actors, most common mood after watching, typical watch time (cinema ritual), and time spent with the favorite actor. Calculations use cached metadata from tmdb_media_cache - no TMDB requests are needed at generation time. Regeneration is available once per day for testing purposes.

*AI Recommendations - New approach.* During this sprint, a research study was done: 9 models were tested with 5 different prompts each - Claude Opus 4.7, Claude Haiku 4.7, Claude Sonnet 4.6, GPT 5.4, GPT 5.4 mini, GPT 5.5, Gemini Flash, Gemini Pro, and Gemini Thinking. The prompt design was informed by two papers: GroupLens 2024 recommended passing up to 75 movies with ratings and is_liked/is_disliked flags, and using a composition rule for result categories (strong_match, diversity, hidden_gem). NEC 2025 showed that prompt structure matters more than model choice, and that cheaper models like Gemini Flash give comparable quality at ~90% lower cost.

The full model comparison, prompt designs, and per-model outputs are documented at: #link("https://app.notion.com/p/AI-recommendations-34d197e7fb1680f484f0fedc52ee2909")[AI Recommendations Research - Notion].

However, the committee raised concerns about a purely LLM-based approach: the model couldn't return art-house picks, get lost in a long prompt, or miss context when given many movies. This led to the decision to move to a hybrid pipeline with collaborative filtering.

*CF Service - New recommendation engine.* A separate Python microservice on FastAPI was built with an ALS model from the implicit library. The model is trained on a user-item interaction matrix (views, ratings, favorites) with BM25 weighting. Gemini stayed in the final architecture but in a different role - not as the main recommendation source, but as a re-ranker: it receives candidates from ALS and TMDB Discover and picks the 15 best ones with a category label (strong_match, diversity, hidden_gem).

For new users without enough watch history, an Onboarding flow was added: users pick favorite actors and movies at the start, and initial recommendations are served through TMDB Discover based on those signals until enough data is collected for ALS.

*Retrospective:* Several planned deliverables were intentionally not built - after reviewing survey results, the top priorities were clear: Wrapped (rated 4.24/5), AI recommendations, and social features. Not implemented: Challenges, Instagram share templates, language switch, PDF export, and premiere push notifications. These are planned for future development.
  

== UX Design

=== Design Philosophy

MovieCrush uses a dark theme as the only design option. This was a deliberate choice - film posters are colorful by nature, and a dark background makes them stand out without competing visual noise. All screens share the same color palette, typography, and spacing system, which creates a consistent feel as the user moves through the app.

=== Visual Identity

*Color palette.* The palette uses four main colors: pure black (`#000000`) as the background, gold (`#FFD700`) as the primary action color, soft pink (`#FFAFCC`) as the accent used for the logo and headings, and white (`#FFFFFF`) for body text. Card surfaces use `#111111` and `#1A1A1A` to create subtle depth without breaking the dark theme. Error states use red (`#FF4D4D`) and success states use green (`#00CC66`).

*Typography.* The entire app uses Poppins - a geometric sans-serif font with four weights: Regular, Medium, SemiBold, and Bold. Poppins was chosen for its clean look on small screens and its good readability at both large display sizes and small caption sizes. All font constants are centralized in a single file so that changing a weight applies consistently across the whole app.

*Logo.* The MovieCrush logo combines the letters M and C using the brand's gold-to-pink gradient. The C is styled to suggest a heart shape, reinforcing the "crush" concept. The icon was designed to hold up at small sizes - as seen on the home screen and in the app drawer alongside Netflix and Spotify.

#figure(
  image("/resources/img/screens/logo.png", width: 40%),
  caption: [MovieCrush app icon],
)

=== Screen Overview

#figure(
  image("/resources/img/screens/onboarding.png", width: 70%),
  caption: [Onboarding - actor selection, movie swipe cards, and optional ratings],
)

The Onboarding flow runs once when a new user signs up and serves as the foundation for cold start recommendations. It has three steps. First, the user picks favorite actors from a curated grid. Second, a swipe card interface shows popular movies, series, anime, and cartoons one by one - the user swipes right if they have seen it or left if not, or uses the buttons below. If a user has not seen anything in the first batch, a second batch of 20 different titles is shown automatically to ensure at least some signal is collected. Third, for every title marked as watched, the user can optionally leave a star rating. All of this data feeds directly into the cold start recommendation engine.

#figure(
  image("/resources/img/screens/home.png", width: 30%),
  caption: [Home Screen - trending movies and series, search bar, bottom navigation],
)

The Home Screen is the entry point of the app. It shows four horizontal content rows fetched from TMDB: Trending Movies This Week, Trending Series This Week, Upcoming, and Top Rated All Time. The MovieCrush logo in pink sits in the top left, with a profile avatar button on the right. The bottom navigation bar has three tabs: Discover, For You, and Challenges.

#figure(
  image("/resources/img/screens/search.png", width: 70%),
  caption: [Search Screen - live search with All, Media, Cast, and Users tabs],
)

The Search Screen activates from the search bar on the Home Screen. Results are shown in a 3-column poster grid with ratings and year. Four filter tabs let the user switch between All, Media, Cast, and Users results.

#figure(
  image("/resources/img/screens/movie.png", width: 70%),
  caption: [Movie Screen - hero backdrop, action bar, info tab, cast, comments],
)

The Movie Screen opens with a full-width backdrop image at the top, with the poster overlaid in the bottom-left corner. Below the hero are four quick actions: Favorite, Watchlist, a large Watched button, and Dislike. Two tabs - Info and Rate - split the movie details from the rating interface. The Info tab shows runtime, director, writers, year, genre, country, overview, trailer link, gallery, cast with links to actor pages, similar movies, and a comments section. Comments can be signed or anonymous, with or without a spoiler warning.

#figure(
  image("/resources/img/screens/ratings.png", width: 70%),
  caption: [Rate tab - star rating, detailed 5-criteria score, mood picker, and best performance],
)

The Rate tab shows a 10-star rating input, a detailed breakdown across five criteria (Direction, Script, Visuals, Soundtrack, Acting - each rated 1-5), a mood picker with six options (Happy, Inspired, Scared, Sad, Thoughtful, Excited), and a Best Performance section where the user votes for the standout actor.

#figure(
  image("/resources/img/screens/series.png", width: 70%),
  caption: [Series Screen - series info, mark all episodes dialog, and season episode list],
)

The Series Screen follows the same structure as the Movie Screen with additional season and episode tracking. When marking a series as watched, a dialog asks whether to mark just the series or all individual episodes as well. Each season can be expanded to show individual episodes with their air date, runtime, TMDB rating, and a short description. Each episode can be marked as watched separately. An episode page shows details and allows the user to leave a rating just for that episode.

#figure(
  image("/resources/img/screens/wrapped_soulmate.png", width: 70%),
  caption: [Challenges Screen, Soulmate result, and Wrapped yearly stats],
)

The Challenges Screen is the entry point for two signature features. The Soulmate card launches the matching algorithm and shows the result: the matched user's profile, a compatibility percentage, and a breakdown of why they match - with gold progress bars for Ratings, Watched, and Actors similarity. The Wrapped feature presents a series of full-screen gradient slides inspired by Spotify Wrapped, each focusing on one personal stat: top genre, top director, top actors with vote counts, and more.

#figure(
  image("/resources/img/screens/profile.png", width: 30%),
  caption: [Profile Screen - avatar, social stats, content counters, and movie lists],
)

The Profile Screen shows the user's avatar with a gold ring border, username in pink, full name, membership date, and optional Instagram button. Three counters show social stats (Friends, Followers, Following) and three more show content stats (Movies, Series, Episodes watched). Below are the user's lists in a scrollable tab layout: Watched, Favorites, Watchlist, and custom lists.

#figure(
  image("/resources/img/screens/actor.png", width: 30%),
  caption: [Actor Screen - bio, Acting and Crew filmography tabs],
)

The Actor Screen shows a gold-bordered portrait photo, key facts (gender, birth date, birthplace, age), a biography, and a filmography split into Acting and Crew tabs. Each filmography item is a poster card with a rating badge and a link to the title's page.

=== Design Decisions

*Figma mockups.* Initial screen layouts were designed in Figma before coding began. The mockups covered the five core screens. During implementation some layouts changed - new ideas came up and certain components were improved beyond the original design. The Figma file is available at: #link("https://www.figma.com/design/Z3bgpR99JjAwGxUYFmctoG/MovieCrush?node-id=0-1")[MovieCrush Figma].

*Logo concept.* The logo ideas are documented at: #link("https://app.notion.com/p/Ideas-of-logo-2e9197e7fb1680369452e55c023d6a7c")[Logo Ideas - Notion].

*Dark theme only.* A light theme was considered but dropped. The app is used primarily in evening and low-light settings, and movie poster art looks significantly better on a dark background.

*Emoji as visual language.* Section headers and filter chips use emoji alongside text labels. This was a deliberate choice to keep the interface feeling friendly and expressive rather than corporate - consistent with the target audience of 18-24 year olds.

== Key Algorithms

=== Soulmate Similarity Algorithm

The Soulmate feature finds the user whose film taste is closest to yours. The algorithm computes a similarity score between two users based on five independent metrics, combines them into a single weighted score, and saves the best match if it passes a minimum threshold.

==== Five Similarity Metrics

Each metric measures a different dimension of taste overlap and uses a different mathematical technique suited to the nature of the data.

*Metric 1 - Rating Cosine Similarity (weight: 0.45).* This is the strongest signal. For every movie both users have rated, the algorithm builds two parallel numeric vectors and computes cosine similarity between them. The key insight is that cosine similarity measures the angle between vectors rather than their magnitude - so a user who consistently rates 9/10 and a user who rates 7/10 for the same films can still show high similarity if their relative preferences match. A minimum overlap of 3 jointly rated movies is required before this metric is computed - below that threshold, the score defaults to 0.

*Metric 2 - Watched Overlap / Jaccard (weight: 0.22).* Measures what share of total watched titles both users have in common. Jaccard similarity divides the size of the intersection by the size of the union of both watch lists, so the score naturally accounts for users with very different library sizes - a user with 10 watched movies and a user with 200 are compared fairly.

*Metric 3 - Actor Overlap / Jaccard (weight: 0.16).* Each time a user rates a movie, they can vote for the best actor in that film. This metric computes Jaccard similarity between the two users' sets of voted actors - capturing a deeper layer of taste alignment that goes beyond genre preferences.

*Metric 4 - Mood Cosine Similarity (weight: 0.11).* After watching a film, users select a mood: Happy, Inspired, Scared, Sad, Thoughtful, or Excited. Each user's mood history is treated as a frequency vector - how many times each mood was selected - and cosine similarity is computed across the shared mood space. Two users who consistently feel the same emotions after watching the same types of films are considered more compatible.

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

The CF service is a separate Python microservice on FastAPI. It trains an ALS (Alternating Least Squares) model from the `implicit` library on a user-item interaction matrix built directly from the PostgreSQL database.

*Interaction matrix construction.* Each user-movie interaction is converted to a preference score that reflects the strength of the signal. Adding a movie to favorites scores highest (5.0), followed by high ratings (4.0 for 8+, 3.0 for 6-7, 2.0 for 4-5), then watchlist additions (1.5), and finally movies that were only marked as watched without a rating (1.0). The resulting matrix is stored in scipy CSR (Compressed Sparse Row) format - since most user-item pairs have no interaction at all, a sparse representation keeps memory usage low.

*BM25 weighting.* Before training, BM25 weighting is applied to the matrix. BM25 is a technique from information retrieval that normalizes interaction counts - it prevents users with very large watch histories from dominating the model's learned representations and ensures that less active users still contribute meaningfully to the training signal.

*Model training.* The ALS model learns latent factor representations for both users and items by alternately solving for user factors and item factors while keeping the other fixed - this is the "alternating" part of ALS. The model parameters (factors=24, iterations=30, regularization=1.0, alpha=20.0) were selected through a grid search optimizing Hit Rate10 and MRR (Mean Reciprocal Rank). The trained model and index mappings are saved to disk so that inference does not require retraining on every request.

*Inference.* At request time, the model computes a score for every item the user has not yet interacted with and returns the top N candidates as TMDB IDs. Already watched and disliked titles are filtered out before returning results.

==== Stage 2 - TMDB Discover Candidates

ALS only recommends items that were present in the training matrix. To add variety and cover cases where a user's taste is unusual or their history is small, a second candidate source is built from the TMDB Discover API. The system builds a user profile from watch history - top 3 genre IDs, top voted actor, and allowed content buckets (movie, tv, anime, dorama, animation) - and fires parallel Discover requests for each content type the user has shown interest in. Results are deduplicated and merged into a single candidate pool, each item tagged with its source (ALS or Discover).

==== Stage 3 - Gemini Re-ranking

The tagged candidate pool is sent to Google Gemini 2.5 Flash along with a sample of the user's watch history and ratings. Gemini selects the 15 best titles from the pool and assigns each a category: *strong_match* (clearly fits the user's established taste), *diversity* (different from usual but plausibly enjoyable), or *hidden_gem* (lesser-known or underrated title worth discovering). Results are cached in the `user_ai_recommendations` table with a 24-hour TTL to avoid calling the model on every request. If Gemini fails, the system falls back to returning the ALS-priority candidates without re-ranking.

==== Cold Start Strategy

New users do not yet have enough watch history for ALS to produce meaningful results. For these users, a dedicated cold start service runs instead. During onboarding, users select favorite actors and rate a curated set of movies. The cold start service analyzes these signals: genre weights are computed per movie with higher-rated movies contributing more weight (rating 8+ contributes weight 3, rating 6-7 contributes weight 2), content buckets are inferred from the types of content the user responded positively to, and three parallel TMDB Discover queries run - by actor, by genre, and by popularity. Results from all three sources are merged using an interleaving strategy to keep the content type distribution balanced across the final batch of 25 recommendations. Once a user accumulates enough watch history, the system automatically switches to the full ALS + Gemini pipeline on the next recommendation request.

== Deployment and CI/CD

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
