-- ================================================
-- MUKBANG CONSUMER RESEARCH DATABASE SETUP
-- ================================================
-- Author: Ayushandra Putri Hapsari
-- Date: January 2025
-- Purpose: Consumer insights analysis of mukbang influencer marketing impact
-- Research Framework: Ohanian (1990) Source Credibility Model + Keller (1993) Brand Equity

-- ================================================
-- CREATE TABLE: survey_responses
-- ================================================
-- This table stores survey data from 100 respondents examining how mukbang
-- influencer Tzuyang impacts consumer perceptions of fried chicken brands

CREATE TABLE IF NOT EXISTS survey_responses (
    respondent_id INTEGER PRIMARY KEY,
    age_group TEXT NOT NULL,
    gender TEXT,
    viewing_frequency TEXT,
    follows_tzuyang TEXT,
    
    -- Credibility Metrics (Ohanian, 1990 framework)
    -- Measures influencer credibility across 5 dimensions
    credibility_trustworthy INTEGER CHECK(credibility_trustworthy BETWEEN 1 AND 5),
    credibility_honest INTEGER CHECK(credibility_honest BETWEEN 1 AND 5),
    credibility_knowledgeable INTEGER CHECK(credibility_knowledgeable BETWEEN 1 AND 5),
    credibility_authentic INTEGER CHECK(credibility_authentic BETWEEN 1 AND 5),
    credibility_persuasive INTEGER CHECK(credibility_persuasive BETWEEN 1 AND 5),
    
    -- Brand Perception Metrics (Keller, 1993 framework)
    -- Measures consumer-based brand equity components
    brand_recall INTEGER CHECK(brand_recall BETWEEN 1 AND 5),
    brand_interest INTEGER CHECK(brand_interest BETWEEN 1 AND 5),
    brand_search_online INTEGER CHECK(brand_search_online BETWEEN 1 AND 5),
    brand_quality_perception INTEGER CHECK(brand_quality_perception BETWEEN 1 AND 5),
    brand_reputation_influence INTEGER CHECK(brand_reputation_influence BETWEEN 1 AND 5),
    
    -- Purchase Behavior Metrics
    has_purchased TEXT CHECK(has_purchased IN ('Yes', 'No')),
    purchase_intention INTEGER CHECK(purchase_intention BETWEEN 1 AND 5),
    brand_loyalty INTEGER CHECK(brand_loyalty BETWEEN 1 AND 5)
);

-- ================================================
-- CREATE VIEW: Aggregate Credibility Score
-- ================================================
-- Calculates average credibility score across 5 dimensions for each respondent
-- Used for H1 hypothesis testing (credibility → trust)

CREATE VIEW IF NOT EXISTS credibility_scores AS
SELECT 
    respondent_id,
    age_group,
    gender,
    viewing_frequency,
    ROUND((credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
           credibility_authentic + credibility_persuasive) / 5.0, 2) AS avg_credibility_score
FROM survey_responses;

-- ================================================
-- CREATE VIEW: Aggregate Brand Equity Score
-- ================================================
-- Calculates average brand equity score across 5 dimensions
-- Used for H3 hypothesis testing (mukbang → brand equity)

CREATE VIEW IF NOT EXISTS brand_equity_scores AS
SELECT 
    respondent_id,
    age_group,
    viewing_frequency,
    ROUND((brand_recall + brand_interest + brand_search_online + 
           brand_quality_perception + brand_reputation_influence) / 5.0, 2) AS avg_brand_equity_score
FROM survey_responses;

-- ================================================
-- CREATE VIEW: Purchase Conversion Metrics
-- ================================================
-- Tracks purchase funnel from awareness to actual purchase
-- Used for H4 hypothesis testing (engagement → purchase)

CREATE VIEW IF NOT EXISTS purchase_metrics AS
SELECT 
    respondent_id,
    viewing_frequency,
    CASE 
        WHEN viewing_frequency = 'Daily' THEN 4
        WHEN viewing_frequency = 'Weekly' THEN 3
        WHEN viewing_frequency = 'Monthly' THEN 2
        ELSE 1
    END AS engagement_level,
    purchase_intention,
    has_purchased,
    CASE WHEN has_purchased = 'Yes' THEN 1 ELSE 0 END AS converted
FROM survey_responses;

-- ================================================
-- DATA QUALITY CHECKS
-- ================================================

-- Check total records
SELECT 'Total Records' AS metric, COUNT(*) AS value FROM survey_responses;

-- Check for missing values in critical fields
SELECT 
    'Missing Credibility Scores' AS metric,
    COUNT(*) AS value
FROM survey_responses
WHERE credibility_trustworthy IS NULL 
   OR credibility_honest IS NULL
   OR credibility_knowledgeable IS NULL;

-- Check data distribution across key segments
SELECT 
    'Age Distribution' AS metric,
    age_group AS category,
    COUNT(*) AS value
FROM survey_responses
GROUP BY age_group;

SELECT 
    'Viewing Frequency Distribution' AS metric,
    viewing_frequency AS category,
    COUNT(*) AS value
FROM survey_responses
GROUP BY viewing_frequency;
```

   Add database setup and schema queries
