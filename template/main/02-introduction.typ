#import "@preview/hei-synd-thesis:0.1.1": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("introduction-title", lang:option.lang) <sec:intro>

== Context and Motivation

I have been obsessed with films and series for as long as I can remember. My friends know that if they want to talk about cinema, I am always available. Films help me switch off, step into another world, experience someone else's problems, and discover something new. If I had grown up in California instead of Ukraine, I would probably have studied acting, not computer science.

This personal connection is also what made me notice the problems with existing tools. For two years I used both Letterboxd and TV Time, and over that time I found enough frustrations to fill a product backlog. I started with phone notes - a list of films I wanted to watch, and eventually moved to Letterboxd because I wanted to actually track what I had seen and follow friends to see what they were watching. But even there, things were missing. No series support. No personalized recommendations. Statistics locked behind a paywall. No Ukrainian language. And the social layer felt thin.

The decision to build MovieCrush came from a simple idea: instead of renting someone else's apartment and living with their design choices, build your own - with exactly the layout you always wanted. I am the target audience of this product, which made every design and product decision easier to reason about. I was not building for an imaginary user. I was building for myself and people like me.

The problem is bigger than my own experience. Most people still track films in phone notes and discover what to watch through social media instead of a dedicated app - this was confirmed by a survey carried out for this project and is covered in detail in the Research chapter. Existing solutions each cover only part of the user journey - Letterboxd handles films but ignores series, TV Time covers series but has weak recommendations and no social transparency, and IMDb is a reference database rather than a personal tracking tool. The core question "what should I watch tonight?" remains poorly answered by all of them.

== Objectives

The goal of this capstone project is to design, build, and evaluate a cross-platform mobile app that brings film and TV tracking, recommendations, social discovery, and analytics into one product.

The specific objectives are:

- Build a cross-platform mobile app with React Native and Expo. The same codebase runs on both Android and iOS. For this project, the app was distributed to other people as an Android APK file, while the iOS version was run on a personal device through Expo Go
- Implement a hybrid recommendation engine combining ALS collaborative filtering with TMDB Discover candidate generation and Google Gemini re-ranking
- Design and evaluate a Soulmate matching algorithm that finds users with the most similar taste using a weighted combination of five similarity metrics
- Build a Wrapped feature that generates personalized yearly viewing statistics
- Validate the recommendation model using standard information retrieval metrics and evaluate the product through real user testing

== Research Approach

Before writing a single line of code, three complementary research methods were applied: a quantitative survey of 262 respondents, five qualitative in-depth interviews, and a structured competitor gap analysis covering Letterboxd, IMDb, TV Time, and Moviebase. So product decisions rested on real user needs, not guesses.

Development followed an iterative sprint model over three months. The recommendation system went through five optimization iterations - each starting with a problem, forming a hypothesis, running an experiment, and measuring the result. This approach is documented in full in the Validation section.

== Structure of This Thesis

The thesis is organized as follows:

- *Research* - user research findings, competitor gap analysis, business model, and domain-specific technical challenges
- *Design* - system architecture, technology stack decisions, database schema, capacity planning, and load estimation
- *Implementation* - development sprints, UX design, key algorithms (Soulmate similarity and hybrid recommendation pipeline), and deployment setup
- *Validation* - unit testing, ML model evaluation across five iterations, manual testing with real user feedback, requirements validation, and limitations