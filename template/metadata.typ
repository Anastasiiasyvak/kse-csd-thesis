//-------------------------------------
// Document options
//
#let option = (
  //type : "final",
  type : "draft",
  lang : "en",
  //lang : "de",
  //lang : "fr",
  template    : "thesis"
)
//-------------------------------------
// Optional generate titlepage image
//
#import "@preview/fractusist:0.1.1":*
#let project-logo= dragon-curve(
  12,
  step-size: 10,
  stroke-style: stroke(
    paint: gradient.radial(..color.map.rocket),
    thickness: 3pt, join: "round"
  ),
  height: 5cm,
  fit: "contain",
)

//-------------------------------------
// Metadata of the document
//
#let doc= (
  title    : "MovieCrush",
  subtitle : "Movie Tracking Platform with Personalized Recommendations, Detailed Ratings, and Social Features",
  author: (
    name        : "Anastasiia Syvak",
    email       : "asyvak@kse.org.ua",
    degree      : "Bachelor",
    affiliation : "KSE",
    place       : "Kyiv",
    url         : "https://github.com/Anastasiiasyvak",
    signature   : image("resources/img/signature.svg", width:3cm),
    keywords: (
      "MovieCrush",
      "mobile application",
      "recommendation systems",
      "collaborative filtering",
      "ALS",
      "Gemini",
      "React Native",
      "film tracking",
      "social discovery",
      "personalization",
    ),
  ),
)

#let summary-page = (
  logo: project-logo,
  //one sentence with max. 240 characters, with spaces.
  objective: [
    The goal of this thesis is to design and build MovieCrush - a mobile platform that combines personalized movie recommendations using collaborative filtering and LLMs, detailed ratings and social features.
  ],
  //summary max. 1200 characters, with spaces.
  content: [
    This thesis describes the design and development of MovieCrush, a mobile application for tracking movies and TV series. The core problem it addresses is that existing platforms like Letterboxd or IMDb either lack personalization or social interaction that feels meaningful. MovieCrush combines three main components: a hybrid recommendation system that uses ALS-based collaborative filtering for users with watch history and a cold start strategy for new users, with Gemini re-ranking the final results; a detailed rating system where users score films across five dimensions; and social features including follows, a Soulmate algorithm that finds users with similar taste using cosine similarity and a Wrapped feature with personal yearly statistics. The backend is built with Node.js and PostgreSQL, the mobile app with React Native, and the ML service runs as a separate Python FastAPI microservice.
  ],
  address: [Kyiv School of Economics • Mykoly Shpaka St, 3 • Kyiv, Ukraine \ +38 073 248 69 76 • #link("mailto"+"info@kse.ua")[info\@kse.ua] • #link("https://kse.ua")[kse.ua]]
)

#let professor= (
  affiliation: "KSE",
  name: "Denys Zavhorodnii",
  email: "dzavhorodnii@kse.org.ua",
)
#let expert= (
  affiliation: "KSE",
  name: "Expert Name",
  email: "expert@domain.ua",
)
#let school= (
  name: none,
  orientation: none,
  specialisation: none,
)
#if option.lang == "de" {
  school.name = "Kiewer Hochschule für Wirtschaftswissenschaften"
  school.orientation = "Wirtschaft"
  school.specialisation = "Infotronics"
} else if option.lang == "fr" {
  school.name = "École d'économie de Kyiv"
  school.shortname = "EDK"
  school.orientation = "Économie"
  school.specialisation = "Infotronics"
} else {
  school.name = "Kyiv School of Economics"
  school.shortname = "KSE"
  school.orientation = "Software Engineering & Business Analysis"
}

#let date = (
  submission: datetime(year: 2026, month: 6, day: 16),
  mid-term-submission: datetime(year: 2026, month: 6, day: 3),
  today: datetime.today(),
)

#let logos = (
  main: project-logo,
  topleft: if option.lang == "fr" or option.lang == "de" {
    image("resources/img/logos/hei-defr.svg", width: 6cm)
  } else {
    image("resources/img/logos/kse_logo_horizontal_primary.png", width: 6cm)
  },
   topright: image("resources/img/logos/zeva.svg", width: 5cm),
)


//-------------------------------------
// Settings
//
#let tableof = (
  toc: true,
  tof: false,
  tot: false,
  tol: false,
  toe: false,
  maxdepth: 3,
)

#let gloss    = true
#let appendix = true
#let bib = (
  display : true,
  path  : "/tail/bibliography.bib",
  style : "ieee", //"apa", "chicago-author-date", "chicago-notes", "mla"
)
