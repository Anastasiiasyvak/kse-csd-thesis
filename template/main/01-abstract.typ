#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
#heading(numbering:none)[#i18n("abstract-title", lang:option.lang)] <sec:abstract>

Modern film and TV viewers face a fragmented viewing experience:
tracking what they have watched, what they want to watch, and what to
watch next is split across phone notes, social media saves, and
disconnected rating services. A survey of 262 respondents conducted as
part of this work confirmed the problem: 49.8% rely on phone notes to
track films and 83.6% discover content through social media rather
than dedicated platforms. Existing solutions such as Letterboxd, IMDb,
and TV Time each cover only part of the user journey and suffer from
weak personalization, limited social interaction, or incomplete
coverage of both films and TV series within a single catalog.

This capstone project documents the complete development of
*MovieCrush* - a cross-platform mobile application that unifies film
and TV tracking, personalized recommendations, social discovery, and
personal analytics in one product. The system was implemented
as a working product with: a hybrid recommendation
engine combining ALS collaborative filtering with TMDB Discover
candidate generation and Google Gemini re-ranking, annual
"Wrapped"-style analytics with personal viewing statistics, a
Soulmate feature that matches users by taste similarity, an
onboarding flow that solves the cold start problem through actor
selection and rating elicitation, and a social layer with follows,
detailed ratings with comments, and shared lists. The mobile client uses React Native with TypeScript, the backend Node.js and Express, with a PostgreSQL database and a dedicated Python microservice for the collaborative filtering model.

To validate the concept, three complementary research methods were
applied before development began: a quantitative survey of 262
respondents, five qualitative in-depth interviews, and a structured
competitor gap analysis covering Letterboxd, IMDb, TV Time, and
Moviebase. The recommendation model was initially trained on
synthetically generated rating data to simulate early-stage user
behavior and validate recommendation quality before large-scale user
adoption. The model was evaluated using ROC AUC, achieving a score of
0.877 - substantially above the random baseline of 0.5. User research established Product-Segment Fit for the target audience
of 18-24 year old viewers in Ukraine, with 75.5%
of respondents willing to pay for a premium tier. The resulting application shows that a single mobile product can replace the disconnected tools viewers currently use and deliver a personalized, socially-aware discovery experience grounded in user research.

#v(2em)
#if doc.at("keywords", default:none) != none {[

  _*#i18n("keywords", lang: option.lang)*_:

  #enumerating-items(
    items: doc.keywords,
    italic: true
  )
]}