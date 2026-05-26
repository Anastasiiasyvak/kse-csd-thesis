#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("design-title", lang:option.lang) <sec:design>

== Business Process Research

=== Stakeholder Analysis

Understanding who is affected by MovieCrush and how they interact with
the product is essential for making the right design decisions. The
table below outlines the key stakeholders, their interests, influence
on the project, and the engagement strategy.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: left,
    [*Stakeholder*], [*Interest*], [*Influence*], [*Risk / Opportunity*], [*Strategy*],
    [End users (film enthusiasts)],
    [Discover content, track watches, find like-minded people],
    [HIGH. They define product success],
    [Risk: low loyalty, low premium conversion],
    [Deep user research, fast iteration based on feedback],

    [Streaming services (Netflix, MEGOGO)],
    [Grow and retain subscribers],
    [MEDIUM. May or may not provide affiliate opportunities],
    [Opportunity: affiliate revenue. Risk: refusal to cooperate],
    [Position MovieCrush as a traffic source for their platforms],

    [Data providers (TMDb API)],
    [Monetize their database, grow API usage],
    [HIGH. Without their data the app is impossible],
    [Risk: API terms change, price increases, quota limits],
    [Use free tier at launch, plan migration to paid tier at scale],

    [AI providers (Google Gemini)],
    [Monetize AI models],
    [HIGH. Recommendation quality defines product uniqueness],
    [Risk: high API costs, unpredictable policy changes],
    [Optimize requests, budget for AI costs from the start],

    [Competitors (Letterboxd, TV Time)],
    [Protect market share],
    [MEDIUM. May copy features or run aggressive marketing],
    [Risk: user churn],
    [Focus on unique features (Soulmate, Wrapped)],
  ),
  caption: [MovieCrush stakeholder analysis]
)

#pagebreak()
== System Architecture

#pagebreak()
== Technology Stack

#pagebreak()
== Database Design

#pagebreak()
== Data Flow