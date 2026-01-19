-- INFLUENCER CREDIBILITY & CONSUMER TRUST ANALYSIS

-- Research Hypotheses Tested:
-- H1: Influencer credibility positively affects consumer trust
-- H2: Consumer trust mediates relationship between credibility and engagement
-- Framework: Ohanian (1990) Source Credibility Model


-- Query 1: Credibility Score Distribution

-- Segments respondents by credibility perception (High/Medium/Low)
-- Shows impact of credibility on brand interest and purchase intention

SELECT 
    CASE 
        WHEN avg_credibility >= 4.0 THEN 'High Credibility (4-5)'
        WHEN avg_credibility >= 3.0 THEN 'Medium Credibility (3-4)'
        ELSE 'Low Credibility (1-3)'
    END AS credibility_level,
    COUNT(*) AS respondent_count,
    ROUND(AVG(brand_interest), 2) AS avg_brand_interest,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent,
    ROUND(AVG(brand_loyalty), 2) AS avg_brand_loyalty
FROM (
    SELECT 
        respondent_id,
        ROUND((credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
               credibility_authentic + credibility_persuasive) / 5.0, 2) AS avg_credibility,
        brand_interest,
        purchase_intention,
        brand_loyalty
    FROM survey_responses
) AS credibility_calc
GROUP BY credibility_level
ORDER BY 
    CASE credibility_level
        WHEN 'High Credibility (4-5)' THEN 1
        WHEN 'Medium Credibility (3-4)' THEN 2
        ELSE 3
    END;


-- Query 2: Individual Credibility Dimensions Analysis

-- Breaks down which credibility dimensions score highest/lowest
-- Identifies Tzuyang's strengths and areas for improvement

SELECT 
    'Trustworthiness' AS credibility_dimension,
    ROUND(AVG(credibility_trustworthy), 2) AS avg_score,
    MIN(credibility_trustworthy) AS min_score,
    MAX(credibility_trustworthy) AS max_score,
    COUNT(CASE WHEN credibility_trustworthy >= 4 THEN 1 END) AS high_ratings_count
FROM survey_responses

UNION ALL

SELECT 
    'Honesty' AS credibility_dimension,
    ROUND(AVG(credibility_honest), 2) AS avg_score,
    MIN(credibility_honest) AS min_score,
    MAX(credibility_honest) AS max_score,
    COUNT(CASE WHEN credibility_honest >= 4 THEN 1 END) AS high_ratings_count
FROM survey_responses

UNION ALL

SELECT 
    'Knowledge/Expertise' AS credibility_dimension,
    ROUND(AVG(credibility_knowledgeable), 2) AS avg_score,
    MIN(credibility_knowledgeable) AS min_score,
    MAX(credibility_knowledgeable) AS max_score,
    COUNT(CASE WHEN credibility_knowledgeable >= 4 THEN 1 END) AS high_ratings_count
FROM survey_responses

UNION ALL

SELECT 
    'Authenticity' AS credibility_dimension,
    ROUND(AVG(credibility_authentic), 2) AS avg_score,
    MIN(credibility_authentic) AS min_score,
    MAX(credibility_authentic) AS max_score,
    COUNT(CASE WHEN credibility_authentic >= 4 THEN 1 END) AS high_ratings_count
FROM survey_responses

UNION ALL

SELECT 
    'Persuasiveness' AS credibility_dimension,
    ROUND(AVG(credibility_persuasive), 2) AS avg_score,
    MIN(credibility_persuasive) AS min_score,
    MAX(credibility_persuasive) AS max_score,
    COUNT(CASE WHEN credibility_persuasive >= 4 THEN 1 END) AS high_ratings_count
FROM survey_responses;


-- Query 3: H1 Hypothesis Testing

-- Tests if high credibility correlates with higher trust indicators
-- Trust measured through: quality perception, reputation influence

SELECT 
    CASE 
        WHEN credibility_score >= 4.0 THEN 'High Credibility (4-5)'
        WHEN credibility_score >= 3.0 THEN 'Medium Credibility (3-4)'
        ELSE 'Low Credibility (1-3)'
    END AS credibility_segment,
    COUNT(*) AS respondents,
    ROUND(AVG(brand_quality_perception), 2) AS avg_perceived_quality,
    ROUND(AVG(brand_reputation_influence), 2) AS avg_reputation_trust,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent,
    ROUND(AVG(brand_quality_perception) - 
          (SELECT AVG(brand_quality_perception) FROM survey_responses), 2) AS quality_vs_overall_avg
FROM (
    SELECT 
        (credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
         credibility_authentic + credibility_persuasive) / 5.0 AS credibility_score,
        brand_quality_perception,
        brand_reputation_influence,
        purchase_intention
    FROM survey_responses
) AS credibility_trust
GROUP BY credibility_segment
ORDER BY credibility_segment;


-- Query 4: Credibility Impact by Viewing Frequency

-- Examines if frequent viewers rate credibility higher
-- Tests familiarity effect on credibility perception

SELECT 
    viewing_frequency,
    COUNT(*) AS respondents,
    ROUND(AVG((credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
               credibility_authentic + credibility_persuasive) / 5.0), 2) AS avg_credibility,
    ROUND(AVG(brand_quality_perception), 2) AS avg_trust_indicator,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent
FROM survey_responses
GROUP BY viewing_frequency
ORDER BY 
    CASE viewing_frequency
        WHEN 'Daily' THEN 1
        WHEN 'Weekly' THEN 2
        WHEN 'Monthly' THEN 3
        WHEN 'Rarely' THEN 4
    END;


-- Query 5: Trust as Mediator (H2 Testing)

-- Tests if trust (quality perception) mediates credibility → engagement relationship

SELECT 
    CASE 
        WHEN brand_quality_perception >= 4 THEN 'High Trust (4-5)'
        WHEN brand_quality_perception >= 3 THEN 'Medium Trust (3-4)'
        ELSE 'Low Trust (1-3)'
    END AS trust_level,
    COUNT(*) AS respondents,
    ROUND(AVG((credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
               credibility_authentic + credibility_persuasive) / 5.0), 2) AS avg_credibility,
    ROUND(AVG(brand_interest), 2) AS avg_brand_engagement,
    ROUND(AVG(brand_search_online), 2) AS avg_active_engagement,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent
FROM survey_responses
GROUP BY trust_level
ORDER BY trust_level;
