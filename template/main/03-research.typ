#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("analysis-title", lang:option.lang) <sec:analysis>

== Research Methodology

To validate the problem and understand user needs before building
MovieCrush, three complementary research methods were used:

- *Quantitative survey* - a structured questionnaire distributed to
  262 respondents to measure user behavior, pain points, and feature
  demand at scale.
- *Qualitative user interviews* - five in-depth interviews conducted
  to uncover motivations, frustrations, and unmet needs that surveys
  cannot capture.
- *Competitor analysis* - a systematic review of existing film tracking
  platforms to identify gaps in the market and opportunities for
  differentiation.

All three methods were applied before development began, ensuring that
product decisions were driven by real user needs and market evidence
rather than assumptions.

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

== Product Discovery and Business Analysis

Before writing any code, a business analysis was done to define
what the product should be, who it is for, and how users would
move through it. The full discovery board is available at:
#link("https://miro.com/app/board/uXjVJtM7d80=/?share_link_id=552779233196")[Miro Board - MovieCrush Business Analysis].

The board shows the original product vision from before development
started. Some features changed or were removed during the process
based on what was realistic to build - this is mentioned throughout
the thesis where it matters.

=== Vision and Mission

*Vision:* To create a home for movie lovers - a place to share
impressions, discover new films through friends, and relive every
emotion. MovieCrush helps you find not just your next favorite film,
but also the people who will love it with you.

*Mission:* To solve the "what should I watch?" problem for good.
Using personalization and community to help users discover, track,
and share movies they will truly love - making every viewing decision
easy and every opinion heard.

=== Value Proposition

The Value Proposition Canvas below shows the main user problems,
what users are trying to do, and what MovieCrush offers in response.

#figure(
  image("/resources/img/discovery/value-proposition.png", width: 100%),
  caption: [Value Proposition Canvas developed during the discovery phase],
)

=== Customer Journey

The customer journey map covers five stages: Awareness,
Consideration, Purchase, Engagement, and Renewal. It shows how
users find out about MovieCrush, what makes them sign up, and
what keeps them using it.

#figure(
  image("/resources/img/discovery/customer-journey.png", width: 100%),
  caption: [Customer Journey Map - from discovery to long-term retention],
)

== Quantitative Research: User Survey

The survey consisted of 5 blocks of questions:

- *Demographics:* age, content language, profession
- *Digital habits:* streaming subscriptions, monthly spend
- *Viewing habits & pain points:* how many films per week, how they
  currently track films, what they like/dislike about existing apps
- *Feature validation:* interest in MovieCrush features (AI recommendations,
  Wrapped, Soulmate, detailed ratings, challenges)
- *Monetization:* attitude to ads, willingness to pay for premium (3 USD/month)

The full survey is available #link("https://forms.gle/uJkXFPWZnedKP3RD8")[here].
Raw responses from all 262 respondents are available in
#link("https://docs.google.com/spreadsheets/d/1sg3BYpskjJtzLKM6CNylXhvHl8sPKL8gcCBF0TerDdY")[Google Sheets].

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
significantly higher than typical KSE Slack posts that receive 2-6.

#figure(
  image("../resources/img/survey/reactions.png", width: 40%),
  caption: [Community reactions - 43 emoji responses to the announcement]
)

Both winners were contacted and confirmed receipt of their cinema tickets.

#figure(
  image("../resources/img/survey/winners.png", width: 90%),
  caption: [Winner confirmation messages]
)

=== Demographics

The survey collected 262 responses. The majority of respondents -
*90.5%* - were aged 18-24, which reflects the author's social circle
and the primary target audience for MovieCrush. *82.7%* have active
streaming subscriptions, confirming high purchasing power and an
established habit of paying for digital content.

#figure(
  image("../resources/img/survey/age-distribution.png", width: 80%),
  caption: [Age distribution of survey respondents]
)

In terms of content language, *42.4%* consume content in a mix of
Ukrainian and English, *36.3%* primarily in Ukrainian, and *21.4%*
in English only - confirming that the app must support both languages.
Some respondents mentioned russian-language content. The author's
position is clear: russian will not be supported. MovieCrush targets
Ukraine, Europe, and the US - not the CIS market.

#figure(
  image("../resources/img/survey/content-language.png", width: 80%),
  caption: [Language in which respondents consume film content]
)

=== Viewing Habits & Pain Points

*43.1%* of respondents watch 2-5 films or series per week - the core
active audience that needs tools for tracking and recommendations.

#figure(
  image("../resources/img/survey/viewing-frequency.png", width: 80%),
  caption: [Average number of films or series watched per week]
)

When asked how they currently track films, *49.8%* said they use phone
notes - a clear signal that no proper tool exists. Only 19.8% use
dedicated services like Letterboxd or IMDb, suggesting low awareness
or poor fit with existing solutions. Additionally, 7.6% use TikTok or
Instagram to save films - a new behavioral pattern no existing app
addresses. 24.9% do not track films at all, representing untapped
latent demand.

#figure(
  image("../resources/img/survey/tracking-habits.png", width: 90%),
  caption: [How respondents currently track films they want to watch or have watched]
)

=== Competitor Pain Points

When asked what bothers them about existing services like IMDb and
Letterboxd, respondents highlighted recurring problems:

- *Poor recommendation algorithms* - platforms suggest popular content,
  not personalized picks
- *No TV series or anime* - Letterboxd ignores a huge segment of content
- *No statistics* - users want a Spotify Wrapped equivalent for films
- *Outdated interface* - IMDb is losing younger users due to poor design
- *No Ukrainian language* - a barrier for the mass Ukrainian audience
- *Fragmented lists* - content saved across multiple platforms with no unified view

At the same time, users value what currently works: trust in IMDb
ratings, seeing what friends watch, viewing diaries, and watchlists.
These became the foundation for MovieCrush's core feature set.

=== Where Users Look for Recommendations

*83.6%* of respondents look for recommendations on social media
(Instagram, TikTok, Twitter), and *76%* rely on friends. Only *7.3%*
use specialized apps like Letterboxd or TV Time. This confirms that
existing platforms are failing at discovery.

#figure(
  image("../resources/img/survey/recommendation-sources.png", width: 90%),
  caption: [Where respondents usually look for recommendations on what to watch]
)

*58%* actively discuss films with friends and family, and *37%* do so
occasionally - confirming strong demand for social features.

=== Feature Validation

Respondents were asked which features they would be willing to pay for.
The top two were the *hybrid recommendation system* (42%) and *personal
statistics/Wrapped* (35.9%). Social features like Soulmate (14.5%)
showed lower willingness to pay but high viral potential - making them
a strong fit for the free tier.

#figure(
  image("../resources/img/survey/willingness-to-pay-features.png", width: 90%),
  caption: [Features respondents would be willing to pay for separately]
)

It is worth noting that during the survey, the planned feature was
described as an "AI assistant." In the final implementation, this became
a hybrid recommendation system combining ALS collaborative filtering
with TMDB Discover for candidate generation, and Gemini for re-ranking -
a more technically sound solution to the same user need.

The personal statistics feature (Wrapped) received an average rating
of *4.24 out of 5* - the highest of all features tested. Full rating
distribution is available in the Appendix.

=== Social Features

When asked which social feature mattered most, *48.9%* chose seeing
what their friends are watching and rating. *38.5%* wanted shared
lists, and *35.1%* wanted to compare tastes with friends. This
strongly validates the social layer of MovieCrush.

#figure(
  image("../resources/img/survey/social-features.png", width: 90%),
  caption: [Most important social features according to respondents]
)

=== Monetization Insights

*67.6%* of respondents would accept ads in a free version, validating
the freemium model. *23.3%* said ads would bother them even in a free
version - this segment is the guaranteed base for premium conversion.

#figure(
  image("../resources/img/survey/ads-attitude.png", width: 80%),
  caption: [Respondent attitude toward ads in the app]
)

On pricing, *75.5%* of respondents would consider paying 3 USD or more
per month for a premium package including AI recommendations, extended
statistics, Soulmate search, and no ads. Only *9.9%* said they would
not pay at all.

#figure(
  image("../resources/img/survey/pricing.png", width: 80%),
  caption: [Maximum monthly price respondents would consider for a premium subscription]
)

=== Open-ended Responses

The final open-ended question asked what would motivate users to switch
to a new film app. The most frequent themes across 262 responses were:

#figure(
  table(
    columns: (auto, auto),
    align: left,
    [*Theme*], [*Mentions*],
    [AI / Personalized recommendations], [25+],
    [Clean and beautiful interface], [20+],
    [Statistics / Wrapped], [15+],
    [Social features (friends, lists)], [15+],
    [Large library / anime / series], [12+],
    [Support for Ukrainian product], [10+],
    [Unique features (Soulmate, challenges)], [8+],
    [Price / free access], [7+],
    [Niche content], [5+],
  ),
  caption: [Most frequent themes in open-ended responses]
)

=== Ideal Customer Profile

Based on all survey findings, the target segment is:

- *Age:* 18-24 years old (90.5% of respondents)
- *Status:* Students (32.3%) and young IT professionals (17.7%)
- *Language:* Mix of Ukrainian and English (42.4%)
- *Viewing habits:* 2-5 films/series per week (43.1%)
- *Spending:* up to 25 USD/month on subscriptions
- *Pain point:* Using phone notes to track films (49.8%)
- *Wants:* hybrid AI recommendations (42%) and personal statistics (35.9%)

#infobox()[
  *Strong Product-Segment Fit* for: "Ukrainian tech-oriented youth aged 18-24,
  actively consuming content, unsatisfied with existing solutions, and willing
  to pay 3 USD/month for a quality personalized experience."
]

== Qualitative Research: User Interviews

Five in-depth interviews were conducted with target users before
development began. Recordings are available at:
#link("https://t.me/+FMhVK6VUUOtjNjBi")[Telegram channel].

=== Methodology

In-depth interviews were chosen over surveys because open-ended questions
force respondents to formulate their own opinions rather than selecting
from predefined options. Individual format allows the interviewer to follow
unexpected threads and uncover insights that are not on the surface.
Group interviews were avoided to prevent social influence on answers.

Respondents were selected to represent different life situations: two
students, one working professional, and two family respondents. The only
selection criterion was an interest in watching films or series. Unlike
the quantitative survey - where 90.5% of respondents were aged 18-24 -
the interview participants represented a broader age range. This was
intentional: to capture different behavioral patterns and avoid confirming
only the assumptions of one demographic group.

Each interview was conducted at a convenient time and location for the
respondent. All participants gave verbal consent to recording and further
use of the data.

=== Interview Findings

*Time spent searching varies dramatically.* Some respondents find
something in 5 minutes, others spend up to 3 hours. Regardless of
the actual time, all respondents considered the search process
cognitively exhausting:

#infobox()[
  "If within 2-3 minutes I can't find anything - the desire just passes
  and I don't watch anything at all."
]

*Phone notes are universally used but universally disliked.* Every
respondent who keeps lists uses phone notes or saved TikToks. All of
them described this as inconvenient:

#infobox()[
  "It's not convenient because there are too many actions - you always
  need to adjust it, add things, delete things."
]

*TikTok and Instagram edits are the primary discovery tool.* Respondents
do not rely on streaming algorithms to discover new content. Instead,
they use short video edits to decide whether a film matches their mood
before committing to watch it.

*Friends' recommendations are trusted more than ratings.* IMDb ratings
were specifically criticized for being misleading:

#infobox()[
  "I don't like IMDb ratings - they often spoil my impression of a film.
  I would rate it 10, but IMDb shows 3."
]

*Filters are the most requested feature.* When asked what they want in
an app, almost every respondent mentioned filters:

#infobox()[
  "The more filters, the better - the faster you can find what you want."
]

*A successful recommendation creates a strong emotional reaction.* When
asked how they feel after finding the perfect film, respondents used
words like "euphoria" and "delight" - confirming that the emotional
payoff of a good recommendation is significant.

=== User Persona

Based on the interviews, the following persona was developed:

#figure(
  table(
    columns: (auto, auto),
    align: left,
    [*Name*], [Anna],
    [*Age*], [25],
    [*Status*], [Junior specialist, active schedule],
    [*Platforms*], [Netflix, HD Rezka, YouTube],
    [*Discovery*], [TikTok edits, Instagram, friends],
    [*Tracking*], [Phone notes - finds it inconvenient],
    [*Pain point*], [Spends too much time searching, recommendations don't match expectations],
    [*Motivation*], [Emotional relief after a busy week],
    [*Key request*], [Better filters, see what friends watch],
  ),
  caption: [User persona derived from qualitative interviews]
)

=== Implications for MovieCrush

The interviews directly shaped the following product decisions:

- *Mood-based filters* - respondents choose films by mood, not genre alone
- *Social feed* - seeing what friends watch is more trusted than any algorithm
- *Detailed ratings with comments* - numeric ratings are not trusted without context
- *Simple onboarding* - "the more actions required, the less likely people are to use it"
- *Watchlist and tracking* - replacing phone notes with a proper tool was a universal need

== Competitor Analysis

=== Overview of Existing Solutions

// TODO: add detailed competitor overview

=== Competitor Gap Analysis

The table below summarizes the key weaknesses identified in competing
platforms and how MovieCrush addresses each of them.

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    [*Competitor*], [*Key Weaknesses*], [*How MovieCrush Addresses Them*],

    [*Letterboxd*],
    [
      1. Films only - no TV series support\
      2. No personalized recommendations\
      3. Limited social interaction (likes and comments only)
    ],
    [
      1. Unified catalog: films, series, and individual episodes\
      2. Hybrid recommendation system: ALS collaborative filtering
         with Gemini re-ranking\
      3. Deep social layer: Soulmate, detailed ratings with comments,
         Best Actor voting
    ],

    [*TV Time*],
    [
      1. Poor UX and outdated interface\
      2. Weak language support\
      3. Cast-only - no directors or screenwriters\
      4. Poor recommendations\
      5. No direct user monetization (revenue from data only)\
      6. Friends' ratings not visible
    ],
    [
      1. Modern, intuitive UI/UX built as a core priority\
      2. Full Ukrainian language support\
      3. Complete credits: actors, directors, screenwriters\
      4. Personalized recommendations via ALS + Gemini\
      5. Direct user monetization through premium subscription\
      6. Social feed showing friends' ratings and activity
    ],

    [*IMDb*],
    [
      1. No social features (no friends, no communities)\
      2. Overloaded, cluttered interface\
      3. Tied to Amazon ecosystem\
      4. No personal analytics beyond basic counters
    ],
    [
      1. Social layer as a core product feature: follows, Soulmate\
      2. Clean, user-experience-focused design\
      3. Independent service with email-based registration\
      4. Deep personal analytics via Wrapped
    ],

    [*Moviebase*],
    [
      1. No social features\
      2. No gamification\
      3. Analytics locked behind paywall\
      4. Narrow geographic reach (53% Brazilian audience)
    ],
    [
      1. Soulmate and social ratings as core free features\
      2. Gamification planned for future development\
      3. Wrapped analytics available to all users\
      4. Designed for Ukrainian, European, and US markets
    ],
  ),
  caption: [Competitor gap analysis and MovieCrush solutions]
)

#infobox()[
  *Core thesis:* MovieCrush combines the strengths of existing platforms while eliminating their key weaknesses, and introduces unique social features.
]

== Research Limitations

#warningbox()[
  These results reflect a non-representative sample - 89.9% of respondents
  were aged 18-24. We found *Product-Segment Fit*, not full Product Market Fit.
]

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

== Domain-Specific Analysis

=== Value Chain

Understanding who contributes value in the film tracking domain helps
clarify MovieCrush's dependencies and strategic position.

#figure(
  table(
    columns: (auto, auto, auto),
    align: left,
    [*Participant*], [*Role*], [*Impact on MovieCrush*],
    [Studios / Rights holders],
    [Own rights to films],
    [Posters and metadata used via TMDb API - direct usage without official API carries DMCA risk],

    [Data aggregators (TMDb)],
    [Collect and maintain metadata: cast, descriptions, posters],
    [Critical dependency. TMDb is the primary data source - open, well-maintained, and best suited for localization],

    [Streaming services (Netflix, MEGOGO)],
    [Final content providers],
    [Their libraries define what users can watch. Their own recommendation engines are direct competitors],

    [Competitors (Letterboxd, TV Time)],
    [Social film tracking platforms],
    [Set UX standards, monetization models, and user expectations],
  ),
  caption: [Value chain analysis for the film tracking domain]
)

=== Technical Challenges

Building a film tracking platform involves several domain-specific
technical challenges that shaped architectural decisions in MovieCrush:

- *AI recommendation complexity:* Unlike music, where taste is often
  genre-based, cinematic taste is *multimodal* - a person may love a
  specific director, cinematographer, actor, atmosphere, or even sound
  design rather than a genre. This makes building a recommendation model
  significantly harder. MovieCrush addresses this with a hybrid approach:
  ALS collaborative filtering learns from behavioral patterns across
  users and has priority as the main source of candidates. TMDB Discover
  serves as an additional candidate source. Google Gemini then re-ranks
  the combined pool based on the individual user's watch history and
  ratings - capturing taste signals that a simple genre filter cannot.

- *Cold start problem:* New users have no watch history, making
  collaborative filtering impossible. MovieCrush solves this with a
  dedicated onboarding flow: users select favorite actors, then receive
  a curated set of films which they mark as watched or not watched and
  rate. The system analyzes content type and genre signals from these
  ratings to seed initial recommendations via TMDB Discover.

- *TMDb caching for analytics:* MovieCrush maintains a local PostgreSQL
  cache of TMDb metadata (title, poster, genres, cast, director) that is
  populated when a user marks a film as watched or adds a rating. This
  cache is used for Wrapped statistics and recommendation building to
  avoid excessive TMDb API calls during computation-heavy operations.
  For regular browsing, the app fetches data directly from TMDb with a
  short-lived in-memory LRU cache to reduce redundant requests within
  the same session.

=== Legal & Economic Constraints

- *Copyright on visuals:* Using posters and metadata for informational
  purposes is generally accepted when sourced through official APIs like
  TMDb. Direct commercial use without proper licensing carries legal risk.
  MovieCrush uses only TMDb-provided assets within their terms of service.
