#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#show figure.where(kind: table): set block(breakable: true)
#pagebreak()
= Validation <sec:validation>

== Requirements Validation

The tables below list all key requirements, how each one was tested, and the result.

=== Functional Requirements

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Requirement*], [*How tested*], [*Result*]),
    [Personalized recommendations based on user behavior], [Offline evaluation - ROC AUC 0.8771], [Pass],
    [Cold start for new users], [Manual testing with a new account], [Pass],
    [Onboarding flow for cold start signal collection], [Manual testing with a new account], [Pass],
    [Ratings - overall (1-10) and detailed (5 criteria)], [Manual testing + DB check], [Pass],
    [Search for movies, series, actors, and users], [Manual live search testing], [Pass],
    [Lists - Watched, Watchlist, Favorites, custom], [Manual testing + DB check], [Pass],
    [Social features - follows, friends' ratings], [Manual testing between two accounts], [Pass],
    [Soulmate - finding a user with similar taste], [Unit tests (soulmate_math) + manual testing], [Pass],
    [Wrapped - personal yearly statistics], [Unit tests (wrapped) + manual testing], [Pass],
    [Comments with anonymous and spoiler options], [Manual testing of all comment modes], [Pass],
    [Episode tracking for series], [Unit tests (episode_helpers) + manual testing], [Pass],
    [Mood tagging after watching], [Manual testing + DB check], [Pass],
    [Actor page with filmography], [Manual testing], [Pass],
    [Movie page with full content], [Manual testing], [Pass],
    [Registration and login with validation], [Unit tests (auth_validators) + manual testing], [Pass],
    [Email confirmation and password recovery], [Manual flow testing], [Pass],
    [JWT authentication with refresh token rotation], [Unit tests + middleware type check], [Pass],
    [Challenges and premiere notifications], [-], [Planned],
    [Public iOS distribution], [-], [Requires Apple Developer account],
  ),
  caption: [Functional requirements - testing method and result]
)

=== Non-Functional Requirements

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    table.header([*Requirement*], [*How tested*], [*Result*]),
    [Rate limiting - 200 requests per minute per IP], [Response headers check], [Pass],
    [HTTPS for all public endpoints], [Verified via Render dashboard], [Pass],
    [Two-level cache - LRU in-memory + PostgreSQL], [Code review + manual response time check], [Pass],
    [CI/CD pipeline with automated checks], [GitHub Actions run on every push], [Pass],
    [Password hashing with bcrypt], [Code review - no plain text passwords stored], [Pass],
    [Health check endpoint], [GET /health returns status ok], [Pass],
  ),
  caption: [Non-functional requirements - testing method and result]
)

== Unit Testing

The backend uses Jest together with ts-jest for TypeScript support. All tests live in the `__tests__` folder and run automatically in the CI pipeline on every push. The focus is on critical business logic - the parts of the system where a bug directly affects data correctness or security.

=== What Is Covered

==== soulmate_math.test.ts

Covers all the math behind the Soulmate algorithm - cosine similarity, Jaccard similarity, cosineSimilarityFromCounts, weightedSum, buildRatingVectors, and isRecomputeThrottled.

Special attention is paid to edge cases: empty vectors, zero norms (to avoid division by zero), vectors of different lengths, and cooldown logic with different time intervals. This matters because any bug in these functions directly affects the quality of user matching.

Examples of what is checked:
- two identical vectors produce similarity = 1.0
- two orthogonal vectors produce similarity = 0
- weightedSum with all zero metrics returns 0
- cooldown returns true if less than 24 hours have passed, false if more or if lastComputedAt is null

==== als_service.test.ts

Covers helper functions in the recommendation service: getCfRatio, filterValidItems, sliceToLimit, cacheRowToAlsItem, mediaTypeFromTmdb, and releaseYearFromTmdb.

A key check is the threshold that switches between cold start and the ALS pipeline via getCfRatio - when watchedCount is 50 or more, the higher CF ratio (0.7) is returned; below that, the lower one (0.5). filterValidItems is also tested to confirm it correctly skips items without a title and preserves the order coming from ALS.

==== wrapped_test.ts

Covers the calculation of personal yearly statistics: top genre, top actor based on vote count, cinema ritual (the most common watch time of day), and total watch time in minutes.

==== auth_validators.test.ts

34 tests covering input validation for registration and login. Checks include email format (with and without subdomains, dots, special characters), username rules (minimum and maximum length, allowed characters), and password requirements (minimum length, presence of digits and letters).

This is important from a security perspective - the validators are the first line of defense before any data reaches the backend.

==== episode_helpers.test.ts

27 tests for the parseTmdbId helper, which solves a real bug found during development: PostgreSQL stores BIGINT but the pg driver returns it as a string to avoid losing precision on 64-bit values. The helper accepts both numeric and string formats and returns the correct number or null for invalid input.

Tested cases include: regular numbers, numeric strings, negative numbers, strings with letters, null, undefined, and empty string.

==== tmdb_helpers.test.ts

Helper functions for working with TMDB API responses - detecting media type (movie or tv) and parsing release dates.

=== Results

All tests pass. The CI pipeline runs them automatically via `npm test` on every push to main and feature branches - if any test fails, the build does not pass and deployment does not happen.

One limitation worth noting: there are no integration tests for complex end-to-end flows such as the full recommendation pipeline, since those require live database and CF service connections. Is noted as an area for future improvement.

== Manual Testing

=== Testing Setup

The app was tested manually throughout the development process. Three external testers used the app through Expo Go on my personal Android device. An Android APK was also built via EAS Build for direct distribution without the Play Store, though the main testing session was conducted through Expo Go. iOS is compatible but requires an Apple Developer account for public distribution, so it was demonstrated on a personal device only.

=== User Feedback

All three testers praised the interface and said the app felt comfortable and polished to use. All feedback was given in Ukrainian and is translated here for this document.

*Tester 1:*

#infobox[
I really like that this app has a dark theme, a light one would definitely not work here. As soon as you open the app you start thinking about what you want to watch, you feel comfortable, and you immediately imagine the atmosphere of a cinema or a cozy evening at home under a warm blanket with a series and a cup of tea.
]

They also noted that the social layer was a highlight - especially seeing friends' ratings directly on a movie or episode page, and that Wrapped analytics felt exciting and natural for a generation that loves tracking everything.

Two improvement requests came up: the "More Like This" section felt like it could show better recommendations, and they would like to see streaming availability directly on the movie page (for example, whether a film is on Netflix or Kyivstar TV). The "More Like This" issue was already addressed by switching from the TMDB `/similar` endpoint to `/recommendations` with a fallback. Streaming availability is planned for future development.

*Tester 2:*

#infobox[
The interface is very intuitive - you really understand where to find everything, as if the app was built from a template, the developer clearly understood what goes where. The analytics part amazed me. On Spotify I wait to see my Wrapped like it's a holiday, I love sharing it in my Instagram stories so everyone knows how cool I am. I would really love to share film analytics in stories too. The recommendations are great - I saw films in my recommendations that I had already watched and loved, I just hadn't added them to my watched list in the app yet. And I watched one film from the list and gave it 9 out of 10. So I am very happy.
]

This was a strong real-world signal that the hybrid ALS + Gemini pipeline was working as intended - without any explanation of how the system works, the tester independently noticed that the recommendations matched their actual taste.

*Tester 3:*

#infobox[
I really like the colors - they don't hurt your eyes and they match each other. I was pleasantly surprised by the onboarding because I use Letterboxd and I have never seen anything like it there. I am really glad that I can immediately enter what I like and get recommendations based on that. I love that I can go to an actor's page and see where they appeared - sometimes I get really into an actor and now instead of googling I just go to their page from a film I watched and browse their filmography. And the fact that there is a split between Acting and Crew tabs means I can immediately open just the Acting tab. I also like that the rating is shown right on the poster so I don't have to open the film to see it. And I really appreciated the filter in recommendations especially the tab "russia is a terrorist state" - that is a nice reminder. In the future I would love a permanent filter where I can set that I never want to see content from a specific country in my recommendations at all.
]

=== Bug Found and Fixed During Testing

During the session with Tester 3, a performance issue was discovered. Opening a profile list with 30 films triggered 30 parallel requests to TMDB through the backend proxy. Switching between lists quickly exceeded the rate limit and returned 429 Too Many Requests errors.

The fix was a new `POST /tmdb/media/batch` endpoint - a single request that reads all metadata from `tmdb_media_cache` in one SQL query using `WHERE tmdb_id = ANY(...)` and only fetches missing entries from TMDB. Instead of 30 requests, the list now loads with 1. The cache is shared across users, so popular films are fetched from TMDB only once for the entire service.

== ML Model Evaluation

=== Problem Statement

The goal was to build a collaborative filtering recommendation system that, based on user behavior (watched films, ratings, favorites), produces personalized recommendations - films the user is likely to want to watch next.

The initial plan was to use LightFM - a more flexible library with support for content-based and collaborative hybrid filtering. However, LightFM has no official Windows support, which made development impossible in the available environment. The `implicit` library was chosen as a replacement because it implements the same ALS algorithm from the original Hu, Koren, Volinsky (2008) paper, has full Windows support, and supports BM25 weighting and confidence-aware training.

=== Data Flow

The full pipeline from raw data to recommendations:

- PostgreSQL (user_movie_actions, user_detailed_ratings)
- build_matrix() - sparse CSR matrix (users on items)
- BM25 weighting (reduces influence of popular items and superfan users)
- ALS training - user and item embeddings
- .recommend(user_id) - top-N items
- HTTP response - Node.js backend - mobile app

=== Synthetic Training Data

Since there were not enough real users at the time of evaluation, the training dataset was generated synthetically.

The initial generation script (`generate_ratings_for_all_users.py`) split 208 users into 8 fixed genre profiles and selected films randomly from large pools. The problem was that two users with the same profile would watch completely different random films - the overlap between them was tiny, and the model could not learn the pattern "users who watched X also watch Y" because such pairs did not exist in the data.

A new script `generate_realistic_data.py` was built with a fundamentally different approach: films were grouped into 17 semantic clusters (marvel_mcu, john_wick_franchise, nolan_films, tarantino, ghibli, pixar, lotr_hobbit and others) where films inside a cluster are genuinely related - same franchise, director, or style. Each user has 2-4 primary clusters with high ratings, 1-3 affiliated clusters through a cross-cluster affinity graph, 1-2 disliked clusters with low ratings, and 2-4 random films as noise. Real user accounts used for manual testing were protected and excluded from synthetic data generation.

=== Iterative Optimization Process

Development went through 5 iterations, each producing a measurable improvement in metrics. The approach was: baseline, problem, hypothesis, experiment, measurement.

==== Iteration 1 — Baseline

Configuration: 208 synthetic users, 315 films, ~10K interactions. ALS with factors=32, iterations=20, regularization=0.1. No BM25 weighting. Ratings used directly as confidence weights.

#figure(
  image("/resources/img/evaluation/baseline_results.png", width: 70%),
  caption: [Iteration 1 - baseline results],
)

Four problems were found: incorrect LOO methodology where a separate model was trained per user (208 models), missing BM25 weighting, wrong confidence interpretation where ratings were used directly as weights instead of being scaled through the confidence parameter alpha as the original ALS paper requires, and dislikes added as weak positive signals with weight 0.1 which the model interpreted as mild interest rather than rejection.

==== Iteration 2 - Algorithmic Fixes

Changes: single model trained on all users (correct LOO), BM25 weighting added, alpha parameter introduced, dislikes fully removed from the training matrix and used only as a post-filter at inference time, structured preference scoring introduced.

#figure(
  image("/resources/img/evaluation/iteration2_results.png", width: 70%),
  caption: [Iteration 2 - results after algorithmic fixes. Hit Rate\@10 tripled.],
)

==== Iteration 3 - Realistic Data Generation

After switching to the cluster-based generation script:

#figure(
  image("/resources/img/evaluation/iteration3_results.png", width: 70%),
  caption: [Iteration 3 - results after realistic data generation],
)

*Key finding:* data quality turned out to be a more critical factor than all algorithmic fixes combined. Hit Rate\@10 jumped from 17% to 46% - a larger gain than all previous improvements together.

==== Iteration 4 - Full Evaluation (Classification + ROC AUC)

A full set of metrics was added: Precision\@K, Recall\@K, F1\@K, NDCG\@K, and ROC AUC.

*ROC AUC methodology for collaborative filtering.* There is no standard classification scenario in CF, so a negative sampling approach was used: for each test user, 1 known relevant item is taken and 50 random items the user has not watched are sampled as negatives. The model scores all 51 items and the ROC curve is built on (y_true, y_scores).

#figure(
  image("/resources/img/evaluation/iteration4_results.png", width: 70%),
  caption: [Iteration 4 - Hit Rate and NDCG results],
)

#figure(
  image("/resources/img/evaluation/iteration4_roc.png", width: 70%),
  caption: [Iteration 4 - Precision, Recall, F1 and ROC AUC = 0.8946],
)

==== Iteration 5 - Hyperparameter Tuning (Grid Search)

A systematic grid search over 60 combinations was run to find the optimal configuration instead of manual tuning.

Search space: factors {12, 16, 20, 24, 32}, alpha {20, 40, 60, 80}, regularization {0.1, 0.5, 1.0}.

Each combination was trained with fixed random_state=42 on the same train/test split and evaluated on the same test pairs.

#figure(
  image("/resources/img/evaluation/grid_search_results.png", width: 100%),
  caption: [Grid search results - 60 hyperparameter combinations],
)

Key observations: all top-5 configurations by HR\@10 and MRR use alpha=20 - lower than the initial value of 40. For a sparse matrix, lower confidence weighting works better because it does not overfit on popular items. factors=24 showed the best balance. regularization=1.0 was optimal - on a small matrix, stronger smoothing is needed.

Selected configuration: *factors=24, alpha=20, regularization=1.0*.

=== Final Results

#figure(
  image("/resources/img/evaluation/final_results_ranking.png", width: 70%),
  caption: [Final results - Hit Rate and NDCG after all iterations],
)

#figure(
  image("/resources/img/evaluation/final_results_precision.png", width: 70%),
  caption: [Final results - Precision, Recall, and F1],
)

#figure(
  image("/resources/img/evaluation/final_results_roc.png", width: 70%),
  caption: [Final ROC AUC = 0.8771],
)

#figure(
  image("/resources/img/evaluation/roc_curve.png", width: 80%),
  caption: [ROC Curve - ALS Collaborative Filtering. AUC = 0.8771 is substantially above the random baseline of 0.5],
)

ROC AUC = 0.8771 means the model correctly ranks a relevant film above a random irrelevant one in 87.71% of cases.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: left,
    table.header([*K*], [*Hit Rate\@K*], [*Precision\@K*], [*NDCG\@K*]),
    [1], [10.58%], [28.85%], [0.1058],
    [5], [32.69%], [58.37%], [0.2174],
    [10], [51.92%], [74.13%], [0.2802],
    [20], [63.94%], [82.09%], [0.3115],
  ),
  caption: [Final ALS model metrics after all iterations. MRR: 0.2639. Average rank when found: 12.11]
)

=== References

The following academic sources informed the methodology and implementation of the collaborative filtering module:

+ Hu, Y., Koren, Y., & Volinsky, C. (2008). *Collaborative Filtering for Implicit Feedback Datasets.* Proceedings of ICDM 2008. #link("https://dl.acm.org/doi/10.1109/ICDM.2008.22")[ACM Digital Library]

+ Frederickson, B. (2022). *implicit: Fast Python Collaborative Filtering for Implicit Feedback Datasets.* #link("https://github.com/benfred/implicit")[GitHub]

+ Robertson, S., & Zaragoza, H. (2009). *The Probabilistic Relevance Framework: BM25 and Beyond.* Foundations and Trends in Information Retrieval. #link("https://www.researchgate.net/publication/220613776_The_Probabilistic_Relevance_Framework_BM25_and_Beyond")[ResearchGate]

== Limitations and Future Improvements

=== Current Limitations

*Synthetic data for ML evaluation.* The ALS model was evaluated on a generated dataset that models realistic viewing patterns, but not on real users. Production metrics may differ - either better (more data means better embeddings) or worse (real taste patterns are more complex than synthetic ones).

*Small interaction matrix.* The current training matrix is 208on265 - very small for a production system. ALS works better on larger matrices where there are more cross-user signals. As the user base grows, the metrics should improve.

*Manual model retraining.* The model is currently retrained manually. In production, automated cron jobs are needed to keep the model up to date with new user data.

*No TTL on tmdb_media_cache.* Movie metadata is stored in the cache without an expiry time. If TMDB updates a poster or any other information, the cache will not pick up the change. A periodic refresh job with a weekly TTL is planned as a future improvement.

*iOS distribution.* Public distribution on iOS requires an Apple Developer account. At the moment the iOS version is only shown on a personal device through Expo.

*Email verification in the test environment.* The free Resend plan without a custom domain can only send emails to the account owner's address. For testing purposes, email verification was made optional - the mechanism is kept in the codebase and ready for production use.

*Limited external testing.* Three testers had access to the app through Expo Go on my device. Testing across a wider range of devices and OS versions remains a task for the next stage.

=== Planned Improvements

- Automated ALS model retraining on a schedule (cron job)
- Challenges and gamification - achievements, badges, and viewing goals
- Push notifications for premiere dates of tracked series
- Language switch in the app (Ukrainian/English)
- Instagram Stories share templates for Wrapped and Soulmate results
- Public iOS release after getting an Apple Developer account
- Custom domain for Resend with full email verification for all users
- Periodic tmdb_media_cache refresh with a weekly TTL
- Affiliate partnerships with streaming platforms (JustWatch model)
- Monetization through MovieCrush Pro subscription