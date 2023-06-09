
-- BATSMAN ANALYSIS IPL 2008-2020


SELECT 
    COUNT(DISTINCT BATSMAN) AS NUMBER_OF_BATSMANS
FROM
    ipl_2008_2020;-- count of all batsmans Q1
 
SELECT DISTINCT
    BATSMAN AS BATSMAN_NAME
FROM
    ipl_2008_2020
GROUP BY BATSMAN
ORDER BY BATSMAN;
 
 -- TOTAL BATSMAN STATS COMPLETE Q3
 
SELECT 
    COUNT(DISTINCT id) AS MATCH_PLAYED,
    BATSMAN,
    SUM(batsman_runs) AS RUNS_SCORED,
    COUNT(BALL) AS BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STRIKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END) AS GOT_OUT,
    (COUNT(DISTINCT id) - SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END)) AS NOT_OUT,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES,
    ROUND(SUM(CASE
                WHEN BATSMAN_RUNS = 4 OR BATSMAN_RUNS = 6 THEN batsman_runs
                ELSE 0
            END) / SUM(batsman_runs) * 100,
            2) AS BOUNDARY_PERCENTAGE
FROM
    ipl_2008_2020
GROUP BY batsman
ORDER BY BATSMAN;

-- TOP 10 BATSMAN STATS COMPLETE Q4
 
SELECT 
    COUNT(DISTINCT id) AS MATCH_PLAYED,
    BATSMAN,
    SUM(batsman_runs) AS RUNS_SCORED,
    COUNT(BALL) AS BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STRIKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END) AS GOT_OUT,
    (COUNT(DISTINCT id) - SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END)) AS NOT_OUT,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES,
    ROUND(SUM(CASE
                WHEN BATSMAN_RUNS = 4 OR BATSMAN_RUNS = 6 THEN batsman_runs
                ELSE 0
            END) / SUM(batsman_runs) * 100,
            2) AS BOUNDARY_PERCENTAGE
FROM
    ipl_2008_2020
GROUP BY batsman
ORDER BY RUNS_SCORED DESC
LIMIT 10;

-- TOP 50 BATSMAN STATS COMPLETE Q5

SELECT 
    COUNT(DISTINCT id) AS MATCH_PLAYED,
    BATSMAN,
    SUM(batsman_runs) AS RUNS_SCORED,
    COUNT(BALL) AS BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STRIKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END) AS GOT_OUT,
    (COUNT(DISTINCT id) - SUM(CASE
        WHEN IS_WICKET = '1' THEN 1
        ELSE 0
    END)) AS NOT_OUT,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES,
    ROUND(SUM(CASE
                WHEN BATSMAN_RUNS = 4 OR BATSMAN_RUNS = 6 THEN batsman_runs
                ELSE 0
            END) / SUM(batsman_runs) * 100,
            2) AS BOUNDARY_PERCENTAGE
FROM
    ipl_2008_2020
GROUP BY batsman
ORDER BY RUNS_SCORED DESC
LIMIT 50;

-- TOTAL RUNS SCORED BY % OF TOTAL RUNS Q6

SELECT 
    BATSMAN AS BATSMAN_NAME,
    SUM(batsman_runs) AS BATSMAN_RUNS,
    ROUND((SUM(batsman_runs) / (SELECT 
                    SUM(TOTAL_RUNS)
                FROM
                    ipl_2008_2020) * 100),
            2) AS PERCENTAGE_OF_TOTAL_RUNS
FROM
    ipl_2008_2020
GROUP BY batsman
ORDER BY PERCENTAGE_OF_TOTAL_RUNS DESC;-- TOTAL RUNS SCORED BY % OF TOTAL RUNS Q6

-- TOP 10 BATSMAN WITH HIGHEST STRIKE RATE THROUGH SEASON Q 7

SELECT 
    BATSMAN AS BATSMAN_NAME,
    SUM(batsman_RUNS) AS TOTAL_RUNS,
    COUNT(BALL) AS TOTAL_BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STIRKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES
FROM
    ipl_2008_2020
WHERE
    overS < 20
GROUP BY BATSMAN
HAVING TOTAL_BALL_FACED >= 504
    AND total_runs >= 2000
ORDER BY STIRKE_RATE DESC
LIMIT 10;

-- TOP 10 BATSMAN WITH HIGHEST STRIKE RATE IN POWERPLAY THROUGH SEASON Q 8

SELECT 
    BATSMAN AS BATSMAN_IN_POWER_PLAY,
    SUM(batsman_RUNS) AS TOTAL_RUNS,
    COUNT(BALL) AS TOTAL_BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STIRKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES
FROM
    ipl_2008_2020
WHERE
    overS <= 6
GROUP BY BATSMAN
HAVING TOTAL_BALL_FACED >= 436
    AND total_runs >= 1000
ORDER BY STIRKE_RATE DESC
LIMIT 10;

-- TOP 10 BATSMAN WITH HIGHEST STRIKE RATE IN DEATH OVERS THROUGH SEASON Q 9

SELECT 
    BATSMAN AS BATSMAN_IN_DEATH_OVERS,
    SUM(batsman_RUNS) AS TOTAL_RUNS,
    COUNT(BALL) AS TOTAL_BALL_FACED,
    ROUND((SUM(batsman_RUNS) / COUNT(BALL)) * 100,
            2) AS STIRKE_RATE,
    ROUND(SUM(batsman_runs) / (SUM(CASE
                WHEN IS_WICKET = '1' THEN 1
                ELSE 0
            END)),
            2) AS BATTING_AVG,
    SUM(CASE
        WHEN BATSMAN_RUNS = 4 THEN 1
        ELSE 0
    END) AS FOURS,
    SUM(CASE
        WHEN BATSMAN_RUNS = 6 THEN 1
        ELSE 0
    END) AS SIXES
FROM
    ipl_2008_2020
WHERE
    overS >= 16
GROUP BY BATSMAN
HAVING TOTAL_BALL_FACED >= 288
    AND total_runs >= 500
ORDER BY STIRKE_RATE DESC
LIMIT 10;

-- batsman with run% 1s, 2s,3s, 0s Q10

SELECT 
    batsman AS BATSMAN_NAME, 
    COUNT(CASE WHEN batsman_runs = 1 THEN 1 END) AS "1s",
    COUNT(CASE WHEN batsman_runs = 2 THEN 1 END) AS "2s",    -- batsman with run% 1s, 2s,3s, 0s Q10
    COUNT(CASE WHEN batsman_runs = 3 THEN 1 END) AS "3s",
    COUNT(CASE WHEN batsman_runs = 0 THEN 1 END) AS "0s",
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS PERCENTAGE
FROM ipl_2008_2020
GROUP BY batsman
ORDER BY PERCENTAGE DESC;

-- batsman with 0 runs dot ball percentage Q11
    
SELECT 
    BATSMAN AS BATSMAN_NAME,
    SUM(BATSMAN_RUNS) AS TOTAL_RUNS,
    COUNT(BALL) AS TOTAL_BALL_FACED,
    COUNT(CASE
        WHEN batsman_runs = 0 THEN 1
    END) AS ZERO_RUN,
    ROUND(COUNT(CASE
                WHEN batsman_runs = 0 THEN 1
            END) * 100.0 / COUNT(*),
            2) AS DOT_BALL_PERCENTAGE
FROM
    ipl_2008_2020
WHERE
    overS <= 20
GROUP BY batsman
HAVING TOTAL_BALL_FACED >= 504
    AND total_runs >= 2000
ORDER BY DOT_BALL_PERCENTAGE DESC;

-- BATSMAN WITH boundary % Q12

SELECT 
    batsman AS BATSMAN_NAME, 
    COUNT(CASE WHEN batsman_runs = 4 THEN 1 END) AS "4s",
    COUNT(CASE WHEN batsman_runs = 6 THEN 1 END) AS "6s",
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS PERCENTAGE  -- BATSMAN WITH boundary % Q12
FROM ipl_2008_2020
GROUP BY batsman
ORDER BY PERCENTAGE DESC;

-- batsman WITH dismissal kind Q13

SELECT 
    BATSMAN AS BATSMAN_NAME,
    COUNT(*) AS TOTAL_DISMISSALS,
    COUNT(CASE
        WHEN dismissal_kind = 'BOWLED' THEN 1
    END) AS 'BOWLED',
    COUNT(CASE
        WHEN dismissal_kind = 'CAUGHT' THEN 1
    END) AS 'CAUGHT',
    COUNT(CASE
        WHEN dismissal_kind = 'CAUGHT AND BOWLED' THEN 1
    END) AS 'CAUGHT AND BOWLED',
    COUNT(CASE
        WHEN dismissal_kind = 'HIT WICKET' THEN 1
    END) AS 'HIT WICKET',
    COUNT(CASE
        WHEN dismissal_kind = 'LBW' THEN 1
    END) AS 'LBW',
    COUNT(CASE
        WHEN dismissal_kind = 'OBSTRUCTING THE FIELD' THEN 1
    END) AS 'OBSTRUCTING THE FIELD',
    COUNT(CASE
        WHEN dismissal_kind = 'RETIRED HURT' THEN 1
    END) AS 'RETIRED HURT',
    COUNT(CASE
        WHEN dismissal_kind = 'RUN OUT' THEN 1
    END) AS 'RUN OUT',
    COUNT(CASE
        WHEN dismissal_kind = 'STUMPED' THEN 1
    END) AS 'STUMPED'
FROM
    ipl_2008_2020
WHERE
    is_wicket = 1
GROUP BY batsman
ORDER BY total_dismissals DESC;





