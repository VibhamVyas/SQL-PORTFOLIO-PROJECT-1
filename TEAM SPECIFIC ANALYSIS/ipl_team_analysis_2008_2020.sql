-- TEAM SPECIFIC ANALYSIS


SELECT * FROM IPL_2008_2020;
select * from ipl_matches;


-- TEAMS ANALYSIS

 -- TOTAL TEAMS Q1
 
  SELECT  DISTINCT WINNER AS IPL_TEAMS, COUNT(WINNER) as MATCHES_WIN FROM ipl_matches
  WHERE WINNER NOT IN ('BAT', 'FIELD', 'NA')
  GROUP BY WINNER
  order by MATCHES_WIN DESC;
 
 -- TOTAL NUMBER OF MATCH PLAYED, 4S, 6S , RUNS AND WICKETS BY SEASON Q2
 
 SELECT year(date) as IPL_EDITION, COUNT(DISTINCT I.ID) AS MATCHES_PLAYED, SUM(I.TOTAL_RUNS = 4) AS TOTAL_FOURS,
 SUM(I.TOTAL_RUNS = 6) AS TOTAL_SIXES,
 sum(i.total_runs) as TOTAL_RUNS, count(i.is_wicket) as TOTAL_WICKETS -- MIN(M.DATE) AS START_DATE, MAX(M.DATE) AS END_DATE
FROM IPL_2008_2020 I
JOIN IPL_MATCHES M ON I.ID = M.ID
GROUP BY IPL_EDITION
ORDER BY IPL_EDITION;

-- ORANGE CAP HOLDERS Q3

SELECT IPL_EDITION, ORANGE_CAP_HOLDER, RUNS_SCORED, TEAM
FROM
( SELECT YEAR(M.DATE) AS IPL_EDITION,
B.BATSMAN AS ORANGE_CAP_HOLDER,
SUM(B.BATSMAN_RUNS) AS RUNS_SCORED,
B.BATTING_TEAM AS TEAM,
RANK() OVER (PARTITION BY YEAR(M.DATE) ORDER BY SUM(B.BATSMAN_RUNS) DESC) RNK
FROM IPL_2008_2020 B
JOIN IPL_MATCHES M ON B.ID = M.ID
GROUP BY YEAR(M.DATE), B.BATSMAN, B.BATTING_TEAM) AS SUBQUERY
WHERE RNK = 1;

-- PURPLE CAP HOLDERS Q4

SELECT IPL_EDITION, PURPLE_CAP_HOLDER, WICKETS_TAKEN, TEAM
FROM
(
SELECT YEAR(M.DATE) AS IPL_EDITION,
B.BOWLER AS PURPLE_CAP_HOLDER,
SUM(B.IS_WICKET) AS WICKETS_TAKEN,
B.BOWLING_TEAM AS TEAM,
RANK() OVER (PARTITION BY YEAR(M.DATE) ORDER BY SUM(B.IS_WICKET) DESC) RNK
FROM IPL_2008_2020 AS B
JOIN IPL_MATCHES M ON B.ID = M.ID
GROUP BY YEAR(M.DATE), B.BOWLER, B.BOWLING_TEAM) AS A
WHERE RNK = 1 AND PURPLE_CAP_HOLDER <> 'SP Narine';

-- TOTAL RUNS SCORED BY EACH TEAM Q5

SELECT BATTING_TEAM AS TEAM,
    SUM(TOTAL_RUNS) AS RUNS_SCORED
FROM IPL_2008_2020
GROUP BY TEAM
ORDER BY RUNS_SCORED DESC
LIMIT 15;
      
-- TOTAL WICKETS TAKEN BY EACH TEAM Q6
SELECT
BOWLING_TEAM AS TEAM,
    SUM(IS_WICKET) AS WICKET_TAKEN
FROM IPL_2008_2020
GROUP BY TEAM
ORDER BY WICKET_TAKEN DESC
LIMIT 15;


-- TOTAL RUNS CONCEDED BY EACH TEAM Q7

SELECT
BOWLING_TEAM AS TEAM,
    SUM(TOTAL_RUNS) AS RUNS_CONCEDED
FROM IPL_2008_2020
GROUP BY TEAM
ORDER BY RUNS_CONCEDED DESC
LIMIT 15;

-- WINNER, RESULT BY RUNS OR WICKET Q8

SELECT WINNER AS TEAMS, 
    SUM(CASE WHEN result = 'runs' THEN 1 ELSE 0 END) AS WON_BY_RUNS,
    SUM(CASE WHEN result = 'WICKETS' THEN 1 ELSE 0 END) AS WON_BY_WICKETS
    FROM IPL_MATCHES
    GROUP BY WINNER
    HAVING TEAMS NOT IN ('FIELD','BAT','NA');
    
-- TEAMS TOSS ANALYSIS AND TOSS WIN PERCENTAGE Q9

SELECT TOSS_WINNER AS TEAMS,
COUNT(DISTINCT ID) AS MATCH_PLYAED,
SUM(CASE WHEN TOSS_decision = 'bat' THEN 1 ELSE 0 END) + 
SUM(CASE WHEN TOSS_decision = 'field' THEN 1 ELSE 0 END) AS TOSS_WIN,
SUM(CASE WHEN TOSS_decision NOT IN ('bat', 'field') THEN 1 ELSE 0 END) AS TOSS_LOSS,
SUM(CASE WHEN TOSS_decision = 'bat' THEN 1 ELSE 0 END) AS BAT_FIRST,
SUM(CASE WHEN TOSS_decision = 'field' THEN 1 ELSE 0 END) AS FIELD_FIRST,
ROUND(SUM(CASE WHEN TOSS_decision = 'bat' THEN 1 ELSE 0 END) + 
SUM(CASE WHEN TOSS_decision = 'field' THEN 1 ELSE 0 END)/COUNT(DISTINCT ID)*100,2) AS TOSS_WIN_PERCENTAGE
FROM IPL_MATCHES
GROUP BY TOSS_WINNER
ORDER BY TOSS_WIN_PERCENTAGE DESC;

-- TEAM FIXTURES AND WINNERS Q10

SELECT 
    YEAR(DATE) AS IPL_EDITION, DATE,
   TEAM1, 
    TEAM2, 
    COALESCE(REPLACE(winner, 'NA', 'No Result'), 'No Result') AS WINNER,
COALESCE(REPLACE(RESULT, 'NA', 'No Result'), 'No Result') AS RESULT,
COALESCE(REPLACE(RESULT_MARGIN, 'NA', 'No Result'), 'No Result') AS RESULT_MARGIN
FROM ipl_matches
WHERE winner NOT IN ('BAT', 'FIELD')
ORDER BY IPL_EDITION;


 -- HOW MANY TIMES EACH TEAMS BATSMAN GOT OUT BY DISMISSAL_KIND Q11
 
SELECT BATTING_TEAM AS BATTING_TEAM_GOT_OUT_BY,
SUM(CASE WHEN DISMISSAL_KIND = 'CAUGHT' THEN 1 END) AS CAUGHT,
SUM(CASE WHEN DISMISSAL_KIND = 'CAUGHT AND BOWLED' THEN 1 END) AS CAUGHT_AND_BOWLED,
SUM(CASE WHEN DISMISSAL_KIND = 'RUN OUT' THEN 1 END) AS RUN_OUT,
SUM(CASE WHEN DISMISSAL_KIND = 'BOWLED' THEN 1 END) AS BOWLED,
SUM(CASE WHEN DISMISSAL_KIND = 'LBW' THEN 1 END) AS LBW,
SUM(CASE WHEN DISMISSAL_KIND = 'STUMPED' THEN 1 END) AS STUMPED,
SUM(CASE WHEN DISMISSAL_KIND = 'HIT WICKET' THEN 1 END) AS HIT_WICKET,
SUM(CASE WHEN DISMISSAL_KIND = 'RETIRED HURT' THEN 1 END) AS RETIRED_HURT,
SUM(CASE WHEN DISMISSAL_KIND = 'obstructing the field' THEN 1 END) AS OBSTRUCTING_THE_FIELD
FROM IPL_2008_2020
GROUP BY BATTING_TEAM
ORDER BY CAUGHT DESC
LIMIT 15;

-- HOW MANY TIMES EACH BOWLING_TEAM_TOOK_WICKETS_BY DISMISSAL_KIND Q12
 
SELECT BOWLING_TEAM AS BOWLING_TEAM_TOOK_WICKETS_BY,
SUM(CASE WHEN DISMISSAL_KIND = 'CAUGHT' THEN 1 END) AS CAUGHT,
SUM(CASE WHEN DISMISSAL_KIND = 'CAUGHT AND BOWLED' THEN 1 END) AS CAUGHT_AND_BOWLED,
SUM(CASE WHEN DISMISSAL_KIND = 'RUN OUT' THEN 1 END) AS RUN_OUT,
SUM(CASE WHEN DISMISSAL_KIND = 'BOWLED' THEN 1 END) AS BOWLED,
SUM(CASE WHEN DISMISSAL_KIND = 'LBW' THEN 1 END) AS LBW,
SUM(CASE WHEN DISMISSAL_KIND = 'STUMPED' THEN 1 END) AS STUMPED
FROM IPL_2008_2020
GROUP BY BOWLING_TEAM
ORDER BY CAUGHT DESC
LIMIT 15;

-- CATCH_MAGNETS AS MOST CATCHES TOOK BY PLYERS IN EACH EDITION Q13

SELECT IPL_EDITION, CATCH_MAGNET, CATCHES_TOOK, TEAM
FROM
(
SELECT YEAR(M.DATE) AS IPL_EDITION,
B.FIELDER AS CATCH_MAGNET,
SUM(CASE WHEN B.DISMISSAL_KIND = 'CAUGHT' THEN 1 END) AS CATCHES_TOOK,
B.BOWLING_TEAM AS TEAM,
RANK() OVER (PARTITION BY YEAR(M.DATE) ORDER BY SUM(B.DISMISSAL_KIND = 'CAUGHT') DESC) RNK
FROM IPL_2008_2020 AS B
JOIN IPL_MATCHES M ON B.ID = M.ID
GROUP BY YEAR(M.DATE), B.FIELDER, B.BOWLING_TEAM) AS A
WHERE RNK = 1
ORDER BY IPL_EDITION ;

-- WICKETKEEPER AS MOST STUMPING DONE BY PLYERS IN EACH EDITION Q14

SELECT IPL_EDITION, WICKETKEEPER, STUMPING, TEAM
FROM
(
SELECT YEAR(M.DATE) AS IPL_EDITION,
B.FIELDER AS WICKETKEEPER,
SUM(CASE WHEN B.DISMISSAL_KIND = 'STUMPED' THEN 1 END) AS STUMPING,
B.BOWLING_TEAM AS TEAM,
RANK() OVER (PARTITION BY YEAR(M.DATE) ORDER BY SUM(B.DISMISSAL_KIND = 'STUMPED') DESC) RNK
FROM IPL_2008_2020 AS B
JOIN IPL_MATCHES M ON B.ID = M.ID
GROUP BY YEAR(M.DATE), B.FIELDER, B.BOWLING_TEAM) AS A
WHERE RNK = 1
ORDER BY IPL_EDITION ;

/* SELECT IPL_EDITION, TEAMS, WICKET_TAKEN, MATCH_PLAYED 
FROM
(
SELECT
COUNT(DISTINCT B.ID) AS MATCH_PLAYED,  -- wicket taken by teams in each edition,
YEAR(M.DATE) AS IPL_EDITION,           -- due to faulty data results are not right
SUM(B.IS_WICKET) AS WICKET_TAKEN,
(B.BOWLING_TEAM) AS TEAMS,-- 
CASE
        WHEN (B.BOWLING_TEAM) IN ('Rising Pune Supergiant', 'Rising Pune Supergiants') THEN 'Pune Supergiants'
        ELSE (B.BOWLING_TEAM)
    END AS TEAM
    FROM IPL_2008_2020 AS B
    JOIN IPL_MATCHES AS M ON B.ID =M.ID
    GROUP BY YEAR(M.DATE), (B.BOWLING_TEAM)) AS A
    ORDER BY IPL_EDITION; -- DESC; */
    
    /* SELECT IPL_EDITION, TEAMS, RUNS_SCORED, MATCH_PLAYED
FROM
(
SELECT
COUNT(DISTINCT B.ID) AS MATCH_PLAYED,    -- runs scored by teams in each edition,
YEAR(M.DATE) AS IPL_EDITION,             -- due to faulty data results are not right
SUM(B.TOTAL_RUNS) AS RUNS_SCORED,
(B.BATTING_TEAM) AS TEAMS,-- 
CASE
        WHEN (B.BATTING_TEAM) IN ('Rising Pune Supergiant', 'Rising Pune Supergiants') THEN 'Pune Supergiants'
        ELSE (B.BATTING_TEAM)
    END AS TEAM
    FROM IPL_2008_2020 AS B
    JOIN IPL_MATCHES AS M ON B.ID =M.ID
    GROUP BY YEAR(M.DATE), (B.BATTING_TEAM)) AS A
    ORDER BY RUNS_SCORED DESC
    -- LIMIT 108; */



