# E-commerce Checkout Funnel: Revenue Leak & Recovery Modeling

**Author:** Isha Jangid
**One-line finding:** [TBD — fill in after Day 5]

## The question
Where does revenue leak in an e-commerce checkout funnel between the
user landing on the site and completing a purchase, and which
interventions would recover the most lost revenue?

## Why this matters
Funnel analysis is the single most-applied analytical pattern in
e-commerce, payments, and on-demand delivery — three of the largest
sectors hiring junior analysts in India today. A clean funnel analysis
paired with counterfactual revenue modelling mirrors the work a real
Business Analyst at Razorpay (payments funnel), Amazon (checkout
funnel), or Swiggy (order funnel) would deliver weekly.

## Scope
- **Dataset:** Online Shoppers Purchasing Intention Dataset
  (UCI Machine Learning Repository)
- **Volume:** 12,330 user sessions
- **Outcome variable:** Revenue (Yes/No, ~15% baseline conversion)
- **Funnel stages:** Landed → Engaged Browse → Checkout Intent → Purchased
- **Segmentation:** Visitor type, Weekend, Month, Special Day proximity,
  Traffic Type, Region

## The 5 business questions
1. Where in the funnel does the biggest drop-off happen?
2. What is each stage-level leak worth in recoverable revenue?
3. How do leaks differ by customer segment (new vs returning, weekend
   vs weekday, month)?
4. Do special shopping days actually lift conversion?
5. What separates "engaged-but-didn't-buy" sessions from
   "engaged-and-bought" sessions?

## Method
1. Load the CSV into MySQL — one fact table `sessions` with all 18 columns
2. Define the 4-stage funnel using session-behavior rules:
   - Landed: all sessions
   - Engaged Browse: ProductRelated >= 2 OR ProductRelated_Duration > 0
   - Checkout Intent: PageValues > 0
   - Purchased: Revenue = TRUE
3. Write 8–10 SQL queries answering the 5 business questions using
   CTEs, window functions, and segment-level CASE logic
4. Cross-validate each SQL output in Excel pivot tables
5. Build a 3-page Power BI dashboard:
   - Page 1: Funnel Overview (KPIs + headline funnel)
   - Page 2: Segment Deep-Dive (heatmap + filterable comparison)
   - Page 3: Counterfactual & Recommendations (what-if sliders +
     ranked interventions)
6. Write a 1-page recommendation memo to a hypothetical Head of Growth

## Tools
MySQL · Excel (Power Query, Pivot Tables) · Power BI

## Findings
[TBD]

## Recommendation
[TBD — 1-page memo]
