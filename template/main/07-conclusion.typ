#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("conclusion-title", lang:option.lang) <sec:conclusion>

== Project Summary

MovieCrush is a cross-platform mobile application that unifies film and TV tracking, personalized recommendations, social discovery, and personal analytics in a single product. The system was built over three months as a solo project, resulting in a React Native mobile client, a Node.js and Express backend with 11 domain modules, a PostgreSQL database with 18 tables, and a separate Python microservice running an ALS collaborative filtering model.

The recommendation engine is a three-stage hybrid pipeline: ALS collaborative filtering generates candidates, TMDB Discover adds variety, and Google Gemini 2.5 Flash re-ranks the combined pool and assigns each result a category - strong match, diversity, or hidden gem. For new users, a dedicated cold start service uses onboarding signals to serve initial recommendations until enough watch history accumulates for ALS. The Soulmate feature finds the user with the most similar taste using a weighted combination of five metrics: rating cosine similarity, watched overlap, actor overlap, mood similarity, and disliked overlap. The Wrapped feature generates personalized yearly statistics across top genres, directors, actors, moods, and total watch time.

The ALS model was tuned across five optimization iterations on a synthetically generated dataset, reaching a final ROC AUC of 0.877 - substantially above the random baseline of 0.5. Thirteen external users tested the app and provided feedback that directly influenced product decisions and surfaced a performance bug that was found and fixed during testing.

== Comparison with Initial Objectives

The core objectives set at the start of the project were met. The full application was built and deployed end to end. The backend, the Python CF service, and the PostgreSQL database run on Render, while the React Native client is distributed to other people as an Android APK. The hybrid recommendation pipeline (ALS, TMDB Discover, Gemini), the Soulmate algorithm, and Wrapped analytics were all implemented and tested. Wrapped was especially well received - several testers compared it directly to Spotify Wrapped.

Several planned features were not implemented within the timeline, mainly Challenges and gamification and Instagram Stories share templates. They were consciously deprioritized after survey results showed that Wrapped (rated 4.24 out of 5), AI recommendations, Soulmate, and social features mattered most to the target audience. The app is fully cross-platform, but public iOS distribution was left out because it requires a paid Apple Developer account - the iOS version runs on a personal device through Expo Go.


== Encountered Difficulties

The hardest part of this project was the recommendation system - not technically, but in terms of decision-making. The overall approach to recommendations changed four times before settling on the final pipeline.

The first plan was to use an AI chat assistant similar to ChatGPT but limited to film topics. This was dropped early in favor of a single AI assistant button that generates personalized recommendations using DeepSeek. DeepSeek was then dropped after the committee pointed out that a purely LLM-based approach could ignore large prompts, lose context when given many films, or return irrelevant results. Nine models across the Claude, GPT, and Gemini families were tested with five prompts each, before the same concern was confirmed: a pure LLM approach was too unpredictable for personalization at scale.

The final solution was a hybrid pipeline where collaborative filtering does the heavy lifting and Gemini acts only as a re-ranker on a pre-filtered candidate pool. This architecture is more reliable, more explainable, and produces better results - but it took four iterations of rethinking to get there. Looking back, this iterative process of forming a hypothesis, testing it, and being willing to throw it away and start again was the most valuable engineering lesson of the whole project.

Other notable challenges included the AWS account being blocked due to a billing issue; the Neon + Render split database setup adding latency and exposing the database to the public internet, solved by moving everything to Render Postgres; and a director_similarity metric in the Soulmate algorithm that was computing against an empty table, silently wasting part of the weight budget until it was caught in a code review and removed, after which the remaining five weights were rebalanced to sum to 1.0.

== Future Perspectives

The most immediate next steps are automated ALS model retraining on a cron schedule, a custom domain for Resend to enable email verification for all users, and a public release on the App Store and Google Play (which also requires moving the TMDB API to a paid plan to handle the request volume).

On the product side, the most requested features are Instagram Stories templates for Wrapped and Soulmate, a permanent country filter in recommendations, streaming availability on film pages, a PDF/CSV watch-list importer, and Challenges with achievements. A Ukrainian language switch, the Pro subscription, and custom profile photos are already stubbed in Settings as upcoming.

Longer term, as the real user base grows and the interaction matrix becomes larger and denser, the ALS model is expected to improve - the current evaluation used a synthetic dataset of 208 users, and real behavioral patterns at scale will provide a much richer training signal. At that point, online evaluation with A/B testing would replace the current offline metrics.