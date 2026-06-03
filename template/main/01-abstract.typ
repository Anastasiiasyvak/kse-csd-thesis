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
personal analytics in one product. The resulting system was implemented
as a fully functional product featuring: a hybrid recommendation
engine combining ALS collaborative filtering with TMDB Discover
candidate generation and Google Gemini re-ranking, annual
“Wrapped”-style analytics with personal viewing statistics, a
Soulmate feature that matches users by taste similarity, an
onboarding flow that solves the cold start problem through actor
selection and rating elicitation, and a social layer with follows,
detailed ratings with comments, and shared lists. The technical
implementation utilized React Native with TypeScript for the mobile
client, a Node.js and Express backend, a PostgreSQL database, and a
dedicated Python microservice running the collaborative filtering
model.

To validate the concept, three complementary research methods were
applied before development began: a quantitative survey of 262
respondents, five qualitative in-depth interviews, and a structured
competitor gap analysis covering Letterboxd, IMDb, TV Time, and
Moviebase. The recommendation model was initially trained on
synthetically generated rating data to simulate early-stage user
behavior and validate recommendation quality before large-scale user
adoption. The model was evaluated using ROC AUC, achieving a score of
0.877 - substantially above the random baseline of 0.5. Furthermore,
user research established Product-Segment Fit for the target audience
of 18-24 year old viewers in Ukraine, with 75.5%
of respondents willing to pay for a premium tier. Ultimately, the
resulting production-ready application demonstrates that a single
mobile product can replace the multiple disconnected tools currently
used by viewers and deliver a personalized, socially-aware film
discovery experience grounded in measurable user research.

#v(2em)
#if doc.at("keywords", default:none) != none {[

  _*#i18n("keywords", lang: option.lang)*_:

  #enumerating-items(
    items: doc.keywords,
    italic: true
  )
]}