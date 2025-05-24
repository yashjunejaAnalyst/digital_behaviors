use social;
   
SELECT DISTINCT * FROM social_media_vs_productivity;
  
  SELECT * FROM social_media_vs_productivity
  WHERE daily_social_media_time != ''
  AND age != ''
  AND gender != ''
  AND job_type != ''
  AND social_platform_preference != ''
  AND number_of_notifications != ''
  AND work_hours_per_day != ''
  AND perceived_productivity_score != ''
  AND actual_productivity_score != ''
  AND stress_level != ''
  AND sleep_hours != ''
  AND screen_time_before_sleep != ''
  AND breaks_during_work != ''
  AND uses_focus_apps != ''
  AND has_digital_wellbeing_enabled != ''
  AND coffee_consumption_per_day != ''
  AND days_feeling_burnout_per_month != ''
  AND weekly_offline_hours != ''
  AND job_satisfaction_score != ''

 -- 1 Social Media hours Vs Productivity

 SELECT 
    ROUND(daily_social_media_time, 0) AS social_media_hours,
    COUNT(*) AS users,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(stress_level), 2) AS avg_stress
FROM social_media_vs_productivity
GROUP BY social_media_hours
ORDER BY social_media_hours;

 -- 2 Platform Preference impact

SELECT 
    social_platform_preference,
    COUNT(*) AS users,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(perceived_productivity_score), 2) AS avg_perceived,
    ROUND(AVG(stress_level), 2) AS avg_stress
FROM social_media_vs_productivity
GROUP BY social_platform_preference
ORDER BY avg_productivity DESC;

 -- 3 Focus App usage benefits

SELECT 
    uses_focus_apps,
    COUNT(*) AS users,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_satisfaction,
    ROUND(AVG(days_feeling_burnout_per_month), 2) AS avg_burnout
FROM social_media_vs_productivity
GROUP BY uses_focus_apps;

 -- 4 Screen time before sleep impact

SELECT 
    ROUND(screen_time_before_sleep, 1) AS screen_time,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(stress_level), 2) AS avg_stress
FROM social_media_vs_productivity
GROUP BY screen_time
ORDER BY screen_time;

 -- 5 Job type analysis

SELECT 
    job_type,
    COUNT(*) AS employees,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_satisfaction
FROM social_media_vs_productivity
GROUP BY job_type
ORDER BY avg_productivity DESC;

 -- 6 Notifications and stress

SELECT 
    FLOOR(number_of_notifications / 10) * 10 AS notification_range,
    COUNT(*) AS users,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_satisfaction
FROM social_media_vs_productivity
GROUP BY notification_range
ORDER BY notification_range;

 -- 7 Work hours and burnout

SELECT 
    ROUND(work_hours_per_day, 0) AS work_hours,
    ROUND(AVG(days_feeling_burnout_per_month), 2) AS avg_burnout,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_satisfaction
FROM social_media_vs_productivity
GROUP BY work_hours
ORDER BY work_hours;

 -- 8 Breaks and satisfaction

SELECT 
    breaks_during_work,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_satisfaction,
    ROUND(AVG(stress_level), 2) AS avg_stress
FROM social_media_vs_productivity
GROUP BY breaks_during_work
ORDER BY breaks_during_work;

----------------------------------------------------------------------------------

 -- 1 Do employees who use focus apps have higher productivity scores than those who don't?
 
SELECT 
    uses_focus_apps,
    COUNT(*) AS user_count,
    ROUND(AVG(actual_productivity_score), 2) AS avg_actual_productivity,
    ROUND(AVG(perceived_productivity_score), 2) AS avg_perceived_productivity
FROM social_media_vs_productivity
WHERE actual_productivity_score IS NOT NULL
  AND perceived_productivity_score IS NOT NULL
GROUP BY uses_focus_apps;

 -- 2 Is there a significant difference in job satisfaction among different age groups?

SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+' 
    END AS age_group,
    COUNT(*) AS total_people,
    ROUND(AVG(job_satisfaction_score), 2) AS avg_job_satisfaction,
    ROUND(STDDEV(job_satisfaction_score), 2) AS std_dev_satisfaction
FROM social_media_vs_productivity
WHERE job_satisfaction_score IS NOT NULL AND age IS NOT NULL
GROUP BY age_group
ORDER BY age_group;

 -- 3 How does social media platform preference influence perceived productivity?"

SELECT 
    social_platform_preference,
    COUNT(*) AS user_count,
    ROUND(AVG(perceived_productivity_score), 2) AS avg_perceived_productivity,
    ROUND(STDDEV(perceived_productivity_score), 2) AS std_dev
FROM social_media_vs_productivity
WHERE perceived_productivity_score IS NOT NULL
  AND social_platform_preference IS NOT NULL
GROUP BY social_platform_preference
ORDER BY avg_perceived_productivity DESC;

 -- 4 What is the relationship between screen time before sleep and stress level?

WITH ScreenTimeGroups AS (
    SELECT
        CASE 
            WHEN screen_time_before_sleep < 0.5 THEN '0-0.5 hrs'
            WHEN screen_time_before_sleep BETWEEN 0.5 AND 1 THEN '0.5-1 hrs'
            WHEN screen_time_before_sleep BETWEEN 1 AND 2 THEN '1-2 hrs'
            ELSE '2+ hrs'
        END AS screen_time_range,
        stress_level
    FROM social_media_vs_productivity
    WHERE screen_time_before_sleep IS NOT NULL AND stress_level IS NOT NULL
)
SELECT 
    screen_time_range,
    COUNT(*) AS user_count,
    ROUND(AVG(stress_level), 2) AS avg_stress_level,
    ROUND(STDDEV(stress_level), 2) AS std_dev_stress
FROM ScreenTimeGroups
GROUP BY screen_time_range
ORDER BY screen_time_range;

 -- 5 Do more frequent breaks during work reduce the number of burnout days per month?

WITH BreakGroups AS (
    SELECT 
        CASE 
            WHEN breaks_during_work BETWEEN 0 AND 2 THEN '0-2 breaks'
            WHEN breaks_during_work BETWEEN 3 AND 5 THEN '3-5 breaks'
            WHEN breaks_during_work BETWEEN 6 AND 8 THEN '6-8 breaks'
            ELSE '9+ breaks'
        END AS break_range,
        days_feeling_burnout_per_month
    FROM social_media_vs_productivity
    WHERE breaks_during_work IS NOT NULL 
      AND days_feeling_burnout_per_month IS NOT NULL
)
SELECT 
    break_range,
    COUNT(*) AS user_count,
    ROUND(AVG(days_feeling_burnout_per_month), 2) AS avg_burnout_days,
    ROUND(STDDEV(days_feeling_burnout_per_month), 2) AS std_dev
FROM BreakGroups
GROUP BY break_range
ORDER BY break_range;

 -- 6 Does working more hours per day increase actual productivity or just stress?

WITH WorkHourGroups AS (
    SELECT
        CASE 
            WHEN work_hours_per_day < 5 THEN '<5 hrs'
            WHEN work_hours_per_day BETWEEN 5 AND 7 THEN '5-7 hrs'
            WHEN work_hours_per_day BETWEEN 7 AND 9 THEN '7-9 hrs'
            ELSE '9+ hrs'
        END AS work_hour_range,
        actual_productivity_score,
        stress_level
    FROM social_media_vs_productivity
    WHERE work_hours_per_day IS NOT NULL 
      AND actual_productivity_score IS NOT NULL
      AND stress_level IS NOT NULL
)
SELECT 
    work_hour_range,
    COUNT(*) AS user_count,
    ROUND(AVG(actual_productivity_score), 2) AS avg_productivity,
    ROUND(AVG(stress_level), 2) AS avg_stress,
    ROUND(STDDEV(actual_productivity_score), 2) AS productivity_stddev,
    ROUND(STDDEV(stress_level), 2) AS stress_stddev
FROM WorkHourGroups
GROUP BY work_hour_range
ORDER BY work_hour_range;

 -- 7 Is there a difference in digital wellbeing tool adoption between job types?

SELECT 
    job_type,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN has_digital_wellbeing_enabled = 'TRUE' THEN 1 ELSE 0 END) AS adopters,
    ROUND(SUM(CASE WHEN has_digital_wellbeing_enabled = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS adoption_rate_percent
FROM social_media_vs_productivity
WHERE job_type IS NOT NULL AND has_digital_wellbeing_enabled IS NOT NULL
GROUP BY job_type
ORDER BY adoption_rate_percent DESC;
