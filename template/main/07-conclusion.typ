#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("conclusion-title", lang:option.lang) <sec:conclusion>

== Project Summary

MovieCrush is a fully functional cross-platform mobile application that unifies film and TV tracking, personalized recommendations, social discovery, and personal analytics in a single product. The system was built over three months as a solo project, resulting in a React Native mobile client, a Node.js and Express backend with 11 domain modules, a PostgreSQL database with 17 tables, and a separate Python microservice running an ALS collaborative filtering model.

The recommendation engine is a three-stage hybrid pipeline: ALS collaborative filtering generates candidates, TMDB Discover adds variety, and Google Gemini 2.5 Flash re-ranks the combined pool and assigns each result a category - strong match, diversity, or hidden gem. For new users, a dedicated cold start service uses onboarding signals to serve initial recommendations until enough watch history accumulates for ALS. The Soulmate feature finds the user with the most similar taste using a weighted combination of five metrics: rating cosine similarity, watched overlap, actor overlap, mood similarity, and disliked overlap. The Wrapped feature generates personalized yearly statistics across top genres, directors, actors, moods, and total watch time.

The ALS model was evaluated across five optimization iterations on a synthetically generated dataset, reaching a final ROC AUC of 0.8771 - substantially above the random baseline of 0.5. Three external users tested the app and provided feedback that directly influenced product decisions and surfaced a performance bug that was found and fixed during the session.

== Comparison with Initial Objectives

The core objectives set at the start of the project were met. A fully functional Android app was built and distributed as an APK. The hybrid recommendation pipeline combining ALS, TMDB Discover, and Gemini was implemented and evaluated. The Soulmate algorithm was built, tested, and deployed. Wrapped analytics were implemented and well received by testers - one tester compared it directly to Spotify Wrapped and said they would love to share their film stats in Instagram Stories.

Two planned features were not implemented within the project timeline: Challenges and gamification, and push notifications for premiere dates. Both were consciously deprioritized after reviewing survey results, which showed that Wrapped (rated 4.24 out of 5), AI recommendations, and social features were the top priorities for the target audience. Public iOS distribution was not completed due to the cost of an Apple Developer account, though the app is cross-platform compatible.

== Encountered Difficulties

The hardest part of this project was the recommendation system - not technically, but in terms of decision-making. The approach changed four times over the course of development.

The first plan was to use an AI chat assistant similar to ChatGPT but limited to film topics. This was dropped early in favor of a single AI assistant button that generates personalized recommendations using DeepSeek. DeepSeek was then dropped after the committee pointed out that a purely LLM-based approach could ignore large prompts, lose context when given many films, or return irrelevant results. Nine models were tested with five different prompts each - Claude Opus 4.7, Claude Haiku 4.7, Claude Sonnet 4.6, GPT 5.4, GPT 5.4 mini, GPT 5.5, Gemini Flash, Gemini Pro, and Gemini Thinking - before the same concern was confirmed: a pure LLM approach was too unpredictable for personalization at scale.

The final solution was a hybrid pipeline where collaborative filtering does the heavy lifting and Gemini acts only as a re-ranker on a pre-filtered candidate pool. This architecture is more reliable, more explainable, and produces better results - but it took four iterations of rethinking to get there. Looking back, this iterative process of forming a hypothesis, testing it, and being willing to throw it away and start again was the most valuable engineering lesson of the whole project.

Other notable challenges included the AWS account being blocked due to a billing issue mid-project; the Neon + Render split database setup adding latency and exposing the database to the public internet, which was solved by moving everything to Render Postgres; and a director_similarity metric in the Soulmate algorithm that was computing against a table that nothing ever populated, silently burning 10% of the weight budget until it was caught in a code review and removed.

== Future Perspectives

The most immediate next steps are automated ALS model retraining on a cron schedule, and a custom domain for Resend to enable full email verification for all users rather than just the account owner.

On the product side, the features that testers and survey respondents asked for most are: Instagram Stories share templates for Wrapped and Soulmate results, a permanent country filter in recommendations, streaming availability information on film pages (showing which platform a film is available on), and Challenges with achievements and viewing goals.

On the business side, the planned monetization path is a freemium model with a MovieCrush Pro subscription at 1.99 USD per month on the annual plan, unlocking AI recommendations, Soulmate search, and no ads. Affiliate partnerships with streaming platforms in the style of JustWatch are also planned as an additional revenue stream.

Longer term, as the real user base grows and the interaction matrix becomes larger and denser, the ALS model is expected to improve significantly - the current evaluation was conducted on a synthetic dataset of 208 users, and real behavioral patterns at scale will provide much richer training signal. At that point, online evaluation with A/B testing would replace the current offline metric approach and give a more accurate picture of recommendation quality in production.