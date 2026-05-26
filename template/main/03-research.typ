#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("analysis-title", lang:option.lang) <sec:analysis>

== Research Methodology

To validate the problem and understand user needs before building
MovieCrush, two research methods were used: a quantitative survey
and qualitative user interviews. Both were conducted before development
began, ensuring that product decisions were driven by real user needs
rather than assumptions.

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
    [*Name*], [Anna],
    [*Age*], [25],
    [*Status*], [Junior specialist, active schedule],
    [*Platforms*], [Netflix, HD Rezka, YouTube],
    [*Discovery*], [TikTok edits, Instagram, friends],
    [*Tracking*], [Phone notes — finds it inconvenient],
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

== Key Findings

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

#table(
  columns: (auto, auto),
  [*Competitor Gap*], [*MovieCrush Solution*],
  [Poor personalized recommendations], [Hybrid recommendation system: ALS + Gemini re-ranking],
  [No TV series or anime], [Unified catalog of films and series],
  [No statistics], [Annual Wrapped with personal analytics],
  [Outdated UI], [Modern design with Ukrainian localization],
  [Fragmented lists across platforms], [Single unified watchlist],
  [No social layer], [Follows, Soulmate, friend activity feed],
)

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
with TMDB Discover for candidate generation, and AI Gemini for
re-ranking - a more technically sound solution to the same user need.

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

#table(
  columns: (auto, auto),
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