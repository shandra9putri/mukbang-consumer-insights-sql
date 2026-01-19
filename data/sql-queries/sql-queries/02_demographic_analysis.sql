-- DEMOGRAPHIC ANALYSIS
-- Objective: Understand sample characteristics and viewing patterns
-- Business Value: Identifies target audience segments for mukbang marketing

-- Query 1: Sample Demographics Overview

-- Shows distribution of respondents by age and gender
-- Helps identify which demographic segments are most engaged with mukbang content

SELECT 
    age_group,
    gender,
    COUNT(*) AS respondent_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM survey_responses), 1) AS percentage
FROM survey_responses
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- Query 2: Mukbang Viewing Frequency Distribution

-- Analyzes how often respondents watch mukbang videos
-- Key insight: Heavy viewers (Daily/Weekly) are primary target for brand partnerships

SELECT 
    viewing_frequency,
    COUNT(*) AS respondent_count,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM survey_responses), 1) AS percentage
FROM survey_responses
GROUP BY viewing_frequency
ORDER BY 
    CASE viewing_frequency
        WHEN 'Daily' THEN 1
        WHEN 'Weekly' THEN 2
        WHEN 'Monthly' THEN 3
        WHEN 'Rarely' THEN 4
    END;

-- Query 3: Tzuyang Follower Analysis

-- Compares behavior between Tzuyang followers vs non-followers
-- Tests if following status correlates with higher purchase intent

SELECT 
    follows_tzuyang,
    COUNT(*) AS count,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent,
    ROUND(AVG((credibility_trustworthy + credibility_honest + credibility_knowledgeable + 
               credibility_authentic + credibility_persuasive) / 5.0), 2) AS avg_credibility_score,
    COUNT(CASE WHEN has_purchased = 'Yes' THEN 1 END) AS actual_purchasers,
    ROUND(COUNT(CASE WHEN has_purchased = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS conversion_rate
FROM survey_responses
GROUP BY follows_tzuyang;


-- Query 4: Age Group Behavioral Differences

-- Identifies which age groups have highest engagement and conversion
-- Critical for media buying and influencer partnership decisions

SELECT 
    age_group,
    COUNT(*) AS total_respondents,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent,
    ROUND(AVG(brand_loyalty), 2) AS avg_brand_loyalty,
    COUNT(CASE WHEN has_purchased = 'Yes' THEN 1 END) AS purchased_count,
    ROUND(COUNT(CASE WHEN has_purchased = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 1) AS conversion_rate
FROM survey_responses
GROUP BY age_group
ORDER BY age_group;


-- Query 5: Gender Differences in Mukbang Engagement

-- Examines if gender affects mukbang consumption patterns

SELECT 
    gender,
    COUNT(*) AS respondents,
    ROUND(AVG(CASE 
        WHEN viewing_frequency = 'Daily' THEN 4
        WHEN viewing_frequency = 'Weekly' THEN 3
        WHEN viewing_frequency = 'Monthly' THEN 2
        ELSE 1 
    END), 2) AS avg_engagement_score,
    ROUND(AVG((brand_recall + brand_interest + brand_search_online + 
               brand_quality_perception + brand_reputation_influence) / 5.0), 2) AS avg_brand_equity
FROM survey_responses
GROUP BY gender;

-- Query 6: Cross-Tabulation: Age x Viewing Frequency

-- Detailed breakdown showing which age groups watch mukbang most frequently

SELECT 
    age_group,
    viewing_frequency,
    COUNT(*) AS respondents,
    ROUND(AVG(purchase_intention), 2) AS avg_purchase_intent
FROM survey_responses
GROUP BY age_group, viewing_frequency
ORDER BY age_group, 
    CASE viewing_frequency
        WHEN 'Daily' THEN 1
        WHEN 'Weekly' THEN 2
        WHEN 'Monthly' THEN 3
        WHEN 'Rarely' THEN 4
    END
