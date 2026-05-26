#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("analysis-title", lang:option.lang) <sec:analysis>


#pagebreak()
== Research Methodology

To validate the problem and understand user needs before building
MovieCrush, two research methods were used: a quantitative survey
and qualitative user interviews.

#pagebreak()
== Quantitative Research: User Survey

The survey consisted of 5 blocks of questions:

- *Demographics:* age, content language, profession
- *Digital habits:* streaming subscriptions, monthly spend
- *Viewing habits & pain points:* how many films per week, how they currently track films, what they like/dislike about existing apps
- *Feature validation:* interest in MovieCrush features (AI recommendations, Wrapped, Soulmate, detailed ratings, challenges)
- *Monetization:* attitude to ads, willingness to pay for premium (3 USD/month)

The full survey is available at: #link("https://forms.gle/uJkXFPWZnedKP3RD8")[here]

Raw responses from all 262 respondents are available: #link("https://docs.google.com/spreadsheets/d/1sg3BYpskjJtzLKM6CNylXhvHl8sPKL8gcCBF0TerDdY")[Google Sheets]

=== Survey Distribution & Incentive

To maximize participation, the survey was distributed via Slack to the
KSE student community. To motivate respondents, 4 cinema tickets were
raffled among participants - 2 winners, 2 tickets each for any film
and any date of their choice.

#figure(
  image("../resources/img/survey/slack-announcement.png", width: 90%),
  caption: [Survey announcement in KSE Slack]
)

The announcement generated strong engagement - 43 reactions, which is
significantly higher than typical KSE Slack posts.

#figure(
  image("../resources/img/survey/reactions.png", width: 90%),
  caption: [Community reactions - 43 emoji responses to the announcement]
)

Both winners were contacted and confirmed receipt of their cinema tickets.

#figure(
  image("../resources/img/survey/winners.png", width: 90%),
  caption: [Winner confirmation messages]
)

#pagebreak()
== Qualitative Research: User Interviews

== Key Findings

The survey revealed strong product-segment fit for a specific user group.
Below are the key metrics across three categories.

*Willingness to pay:*

#table(
  columns: (auto, auto, auto),
  [*Metric*], [*Value*], [*Insight*],
  [Have streaming subscriptions], [82.7%], [High purchasing power],
  [Willing to pay for premium], [88.4%], [Demand exceeds supply],
  [Willing to pay 3 USD+/month], [75.5%], [Price point validated],
)

*Competitor pain points:*

#table(
  columns: (auto, auto, auto),
  [*Metric*], [*Value*], [*Insight*],
  [Use phone notes to track films], [49.8%], [No proper tool exists],
  [Unsatisfied with recommendations], [~40%], [Competitors fail here],
  [Don't track films at all], [24.9%], [Latent demand],
)

*Feature interest:*

#table(
  columns: (auto, auto, auto),
  [*Metric*], [*Value*], [*Insight*],
  [AI recommendations - willing to pay], [41.9%], [Main premium driver],
  [Wrapped statistics - willing to pay], [35.3%], [Second key driver],
  [Mentions in open-ended answers], [25+], [Emotional response],
)

=== Ideal Customer Profile

Based on the survey results, the target segment is:

- *Age:* 18-24 years old (89.9% of respondents)
- *Status:* Students (32.3%) and young IT professionals (17.7%)
- *Language:* Mix of Ukrainian and English (43.9%)
- *Viewing habits:* 2-5 films/series per week (43.7%)
- *Spending:* 10-25 USD/month on subscriptions (25%)
- *Pain point:* Using phone notes to track films (49.8%)
- *Wants:* AI recommendations (41.9%) and personal statistics (35.3%)

MovieCrush has demonstrated *strong Product-Segment Fit* for:
"Ukrainian tech-savvy youth aged 18-24, actively consuming content,
unsatisfied with existing solutions, and willing to pay 3 USD/month
for a quality personalized experience."

== Research Limitations

The following limitations should be considered when interpreting these results:

+ *Non-representative sample* - 89.9% of respondents were aged 18-24,
  which correlates with the author's age and social circle.
+ *Narrow demographic* - results reflect the views of students in
  technical and economic fields only.
+ *Conclusion:* We cannot claim full Product Market Fit for the entire
  market. Instead, we found *Product-Segment Fit* for the segment of
  "youth aged 18-24, students, technical specializations."
  Validation on adjacent segments (25-34, non-IT professions) remains
  a goal for future work.