#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *

#let entry-list = (
  (
    key: "als",
    short: "ALS",
    long: "Alternating Least Squares",
    description: "A collaborative filtering algorithm that learns hidden user and item factors by solving for one set while keeping the other fixed, then switching - the alternating part. It is a common choice for implicit feedback data such as views, clicks, or purchases.",
  ),
  (
    key: "cf",
    short: "CF",
    long: "Collaborative Filtering",
    description: "A recommendation technique based on the idea that users who agreed in the past will likely agree in the future. If two users rated the same movies in a similar way, a movie one liked can be suggested to the other.",
  ),
  (
    key: "bm25",
    short: "BM25",
    long: "Best Matching 25",
    description: "A weighting method from information retrieval. When applied to a user-item matrix, it reduces the influence of very frequent interactions so that the most active users or most popular items do not dominate the model.",
  ),
  (
    key: "rocauc",
    short: "ROC AUC",
    long: "Receiver Operating Characteristic - Area Under Curve",
    description: "A metric that measures how well a model ranks a relevant item above an irrelevant one. A value of 0.5 means random guessing, and 1.0 means a perfect ranking.",
  ),
  (
    key: "mrr",
    short: "MRR",
    long: "Mean Reciprocal Rank",
    description: "A metric that checks how high up the first correct recommendation appears in a ranked list. The higher the correct item, the better the score.",
  ),
  (
    key: "ndcg",
    short: "NDCG",
    long: "Normalized Discounted Cumulative Gain",
    description: "A ranking metric that rewards placing relevant items near the top of the list and gives less credit to relevant items lower down.",
  ),
  (
    key: "coldstart",
    short: "cold start",
    long: "Cold Start Problem",
    description: "In recommender systems, the situation when there is not enough data about a new user or item to make good recommendations.",
  ),
  (
    key: "jaccard",
    short: "Jaccard similarity",
    long: "Jaccard Index",
    description: "A similarity measure for two sets: the size of their intersection divided by the size of their union. Ranges from 0 (no overlap) to 1 (identical sets).",
  ),
  (
    key: "cosine",
    short: "cosine similarity",
    long: "Cosine Similarity",
    description: "A measure of similarity between two vectors based on the angle between them rather than their magnitude. Two users who rate films in the same relative pattern score high even if one rates consistently higher.",
  ),
  (
    key: "hitrate",
    short: "Hit Rate@K",
    long: "Hit Rate at K",
    description: "The share of test cases where the relevant item appears in the model's top-K recommendations. Hit Rate@10 = 0.52 means the correct film was in the top 10 about half the time.",
  ),
  (
    key: "precision",
    short: "Precision@K",
    long: "Precision at K",
    description: "Of the top-K items the model recommends, the share that are actually relevant. Higher means fewer irrelevant suggestions near the top.",
  ),
  (
    key: "csr",
    short: "CSR",
    long: "Compressed Sparse Row",
    description: "A memory-efficient format for storing sparse matrices that keeps only the non-zero entries - suited to a user-item matrix where most pairs have no interaction.",
  ),
  (
    key: "loo",
    short: "LOO",
    long: "Leave-One-Out",
    description: "An evaluation method where one known relevant item is hidden per user, and the model is scored on how well it ranks that held-out item among others.",
  ),
)

#let make_glossary(
  gloss:true,
  title: i18n("gloss-title", lang: option.lang),
) = {[
  #if gloss == true {[
    #pagebreak()
    #set heading(numbering: none)
    = #title <sec:glossary>
    #print-glossary(
      entry-list,
      // show all term even if they are not referenced, default to true
      show-all: true,
      // disable the back ref at the end of the descriptions
      disable-back-references: false,
    )
  ]} else{[
    #set text(size: 0pt)
    #title <sec:glossary>
    #print-glossary(
      entry-list,
      // show all term even if they are not referenced, default to true
      show-all: true,
      // disable the back ref at the end of the descriptions
      disable-back-references: false,
    )
  ]}
]}
