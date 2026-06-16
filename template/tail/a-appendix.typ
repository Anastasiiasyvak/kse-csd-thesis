#import "@preview/hei-synd-thesis:0.1.1": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("appendix-title", lang: option.lang) <sec:appendix>

== Survey Materials <sec:survey-materials>

#figure(
  image("../resources/img/survey/slack-announcement.png", width: 90%),
  caption: [Survey announcement in KSE Slack]
)

#figure(
  image("../resources/img/survey/reactions.png", width: 40%),
  caption: [Community reactions - 43 emoji responses to the announcement]
)

=== Raffle Process

#figure(
  image("../resources/img/survey/raffle-wheel.png", width: 50%),
  caption: [Random wheel spinner used to select raffle winners]
)

#figure(
  image("../resources/img/survey/messages.png", width: 70%),
  caption: [Messages from participants requesting to join the raffle]
)

#figure(
  image("../resources/img/survey/winners.png", width: 90%),
  caption: [Winner confirmation messages]
)

== Additional Survey Charts <sec:additional-charts>

=== Demographics

#figure(image("../resources/img/survey/age-distribution.png", width: 80%), caption: [Age distribution of survey respondents])

#figure(image("../resources/img/survey/content-language.png", width: 80%), caption: [Language in which respondents consume film content])

=== Viewing Habits

#figure(image("../resources/img/survey/viewing-frequency.png", width: 80%), caption: [Average number of films or series watched per week])

#figure(image("../resources/img/survey/tracking-habits.png", width: 90%), caption: [How respondents currently track films])

=== Recommendation & Social

#figure(image("../resources/img/survey/recommendation-sources.png", width: 90%), caption: [Where respondents look for recommendations])

#figure(image("../resources/img/survey/social-features.png", width: 90%), caption: [Most important social features])

=== Feature Validation & Monetization

#figure(image("../resources/img/survey/willingness-to-pay-features.png", width: 90%), caption: [Features respondents would pay for])

#figure(image("../resources/img/survey/ads-attitude.png", width: 80%), caption: [Attitude toward ads])

#figure(image("../resources/img/survey/pricing.png", width: 80%), caption: [Maximum monthly price for premium])

=== Wrapped Statistics Feature Rating

The Wrapped feature received the highest average rating of all tested
features - *4.24 out of 5* - making it the most anticipated feature
among respondents. 53.8% gave it the maximum score of 5.

#figure(
  image("../resources/img/survey/wrapped-rating.png", width: 90%),
  caption: [Rating distribution for the Wrapped statistics feature — average 4.24/5]
)

=== Monthly Spending on Subscriptions

#figure(
  image("../resources/img/survey/subscription-spending.png", width: 80%),
  caption: [Monthly spending on content subscriptions among respondents]
)

=== Active Streaming Subscriptions

#figure(
  image("../resources/img/survey/streaming-subscriptions.png", width: 90%),
  caption: [Active streaming subscriptions among respondents]
)

#figure(
  image("../resources/img/survey/subscriptions-table.png", width: 70%),
  caption: [Streaming subscription summary - 82.7% have at least one active subscription]
)

=== Respondent Profession & Field of Activity

_Note: this profession breakdown is based on 237 responses (an earlier snapshot); the final survey count was 262._

Segmenting professions was challenging because 89.9% of respondents were
aged 18-24, meaning most were students. Some listed only "student", others
listed their specialization, and those already working listed only their
job title. To handle this, three separate breakdowns were created:

+ *General table* - all segments combined
+ *Profession table* - "Student" as a category plus job titles of those
  already working
+ *Field of activity table* - students filtered by their area of study,
  regardless of employment status

Of the respondents: 69 are not working, 51 did not answer, and
approximately 117 indicated a profession (though some may have listed
their future profession rather than a current job).

#figure(
  image("../resources/img/survey/profession-tables.png", width: 90%),
  caption: [Three-way breakdown of respondent profession and field of activity]
)
== Screen Gallery <sec:screen-gallery>

#figure(
  image("../resources/img/screens/onboarding.png", width: 100%),
  caption: [Onboarding - actor and movie selection for cold start],
)

#figure(
  image("../resources/img/screens/search.png", width: 80%),
  caption: [Search - live results across media, cast, and users],
)

#figure(
  image("../resources/img/screens/series.png", width: 100%),
  caption: [Series - seasons and per-episode tracking],
)

#grid(
  columns: 3,
  gutter: 10pt,
  figure(image("../resources/img/screens/profile.png"), caption: [Profile - stats and lists]),
  figure(image("../resources/img/screens/actor.png"), caption: [Actor - bio and filmography]),
  figure(image("../resources/img/screens/home.png"), caption: [Home - trending and search]),
)

=== Competitor Visibility (AppMagic) <sec:appmagic>

#figure(
  image("../resources/img/competitors/appmagic-comparison.png", width: 100%),
  caption: [Featuring Score and chart rankings across four competitors, Jan 2021 - Jan 2026 (AppMagic)],
)

== Discovery Artifacts <sec:discovery-artifacts>

#figure(
  image("../resources/img/discovery/value-proposition.png", width: 100%),
  caption: [Value Proposition Canvas developed during the discovery phase],
)

#figure(
  image("../resources/img/discovery/customer-journey.png", width: 100%),
  caption: [Customer Journey Map - from discovery to long-term retention],
)

== ML Evaluation Results <sec:ml-results>

=== Iterative Optimization

#figure(image("../resources/img/evaluation/baseline_results.png", width: 75%), caption: [Iteration 1 - baseline results])

#figure(image("../resources/img/evaluation/iteration2_results.png", width: 75%), caption: [Iteration 2 - after algorithmic fixes (Hit Rate\@10 tripled)])

#figure(image("../resources/img/evaluation/iteration3_results.png", width: 75%), caption: [Iteration 3 - after realistic data generation])

#figure(image("../resources/img/evaluation/iteration4_results.png", width: 75%), caption: [Iteration 4 - Hit Rate and NDCG])

#figure(image("../resources/img/evaluation/iteration4_roc.png", width: 75%), caption: [Iteration 4 - Precision, Recall, F1, ROC AUC = 0.8946])

=== Grid Search

#figure(image("../resources/img/evaluation/grid_search_results.png", width: 100%), caption: [Grid search - 60 hyperparameter combinations])

=== Final Results

#figure(image("../resources/img/evaluation/final_results_ranking.png", width: 75%), caption: [Final - Hit Rate and NDCG])

#figure(image("../resources/img/evaluation/final_results_precision.png", width: 75%), caption: [Final - Precision, Recall, F1])

#figure(image("../resources/img/evaluation/final_results_roc.png", width: 75%), caption: [Final ROC AUC = 0.8771])