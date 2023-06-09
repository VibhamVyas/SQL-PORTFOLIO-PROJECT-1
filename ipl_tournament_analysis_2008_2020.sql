use ipl_analysis;

SELECT 
    *
FROM
    ipl_2008_2020;

CREATE TABLE ipl_matches (
    id INT,
    city VARCHAR(225),
    date DATE,
    plyare_of_match VARCHAR(225),
    venue TEXT,
    neutral_venue INT,
    team1 VARCHAR(225),
    team2 VARCHAR(225),
    toss_winner VARCHAR(225),
    toss_decision VARCHAR(225),
    winner VARCHAR(225),
    result VARCHAR(225),
    result_margin INT,
    eliminator VARCHAR(20),
    method VARCHAR(25),
    umpire1 VARCHAR(225),
    umpire2 VARCHAR(225)
);




show VARIABLES like 'local_infile';

set GLOBAL local_infile =1;

load data local infile 'C:/Users/vibha/Downloads/IPL SQL PORTFOLIO PROJECT/IPL Ball-by-Ball 2008-2020.csv'
into table ipl_2008_2020
fields terminated by ',' 
ignore 1 rows;

/*show VARIABLES like 'local_infile';

set GLOBAL local_infile =1;

load data local infile 'C:/Users/vibha/Downloads/IPL SQL PORTFOLIO PROJECT/IPL Ball-by-Ball 2008-2020.csv'
into table ipl_2008_2020
fields terminated by ',' 
ignore 1 rows;*/

SELECT 
    *
FROM
    ipl_2008_2020;

 set sql_safe_updates = 0;
 
load data local infile 'C:/Users/vibha/Downloads/IPL SQL PORTFOLIO PROJECT/IPL Matches 2008-2020.csv'
into table ipl_matches
fields terminated by ',' 
ignore 1 rows;

SELECT 
    *
FROM
    ipl_matches;
SELECT 
    *
FROM
    ipl_2008_2020;

SELECT 
    COUNT(*)
FROM
    ipl_matches;

COMMIT;

-- TOURNAMENT SPECIFIC ANALYSIS

SELECT 
    COUNT(DISTINCT ID) AS TOTAL_MATCHES_PLAYED,
    COUNT(DISTINCT batsman) AS TOTAL_BATSMAN,
    COUNT(DISTINCT bowler) AS TOTAL_BOWLERS,
    ROUND(SUM(BALL) / 8, 0) AS TOTAL_APPROX_OVERS_BOWLED,
    SUM(TOTAL_RUNS) AS TOTAL_RUNS_SCORED,
    SUM(BALL) AS TOTAL_BOWLS_BOWLED,
    SUM(IS_WICKET) AS TOTAL_NUMBER_OF_WICKETS,
    SUM(EXTRA_RUNS) AS TOTAL_EXTRA_RUNS
FROM
    ipl_2008_2020;
    
    -- TORNAMENT duration Q2

SELECT 
    DATEDIFF(MAX(Date), MIN(Date)) AS TOTAL_DAYS,
    ROUND((DATEDIFF(MAX(date), MIN(date)) / 30), 2) AS TOTAL_MONTHS,
    ROUND((DATEDIFF(MAX(date), MIN(date)) / 365),
            2) AS TOTAL_YEARS
FROM
    IPL_Matches;
    
    
-- Number of matches per SEASONS Q3

SELECT 
    IPL_EDITION, COUNT(DISTINCT id) AS NUMBER_OF_MATCHES
FROM
    (SELECT 
        YEAR(date) AS IPL_EDITION, id
    FROM
        ipl_matches) subquery
GROUP BY IPL_EDITION;

-- Most playesr of the match or man of the match Q4

SELECT 
    (plyare_of_match) AS MAN_OF_THE_MATCH,
    COUNT(plyare_of_match) AS COUNT
FROM
    ipl_matches
GROUP BY plyare_of_match
ORDER BY COUNT(plyare_of_match) DESC;

-- Most playesr of the match or man of the match/season Q5

select * from
(select IPL_EDITION, (plyare_of_match) AS PLAYER, MoM, rank() over(PARTITION BY IPL_EDITION ORDER BY MoM desc) rnk from
(select year(date) as IPL_EDITION, plyare_of_match, count(plyare_of_match) as MoM from ipl_matches
GROUP BY plyare_of_match, year(date))a)b
where rnk=1 ;

 -- VENUES WHERE MATCH IS PLAYED Q6
 
SELECT 
    CITY, VENUE, COUNT(VENUE) AS 'NUMBER OF MATCHES'
FROM
    ipl_matches
GROUP BY VENUE , CITY
ORDER BY COUNT(VENUE) DESC;
 
SELECT 
    *
FROM
    IPL_MATCHES;
 
-- VENUES WITH TOSS METRICS Q7
SELECT 
    CITY,
    VENUE,
    COUNT(*) AS TOTAL_MATCH_PLAYED,
    SUM(CASE
        WHEN toss_decision = 'bat' THEN 1
        ELSE 0
    END) AS BAT_FIRST,
    SUM(CASE
        WHEN toss_decision = 'field' THEN 1
        ELSE 0
    END) AS FIELD_FIRST,
    CONCAT(ROUND(SUM(CASE
                        WHEN toss_decision = 'bat' THEN 1
                        ELSE 0
                    END) * 100 / COUNT(*),
                    2),
            '%') AS BAT_FIRST_PERCENTAGE,
    CONCAT(ROUND(SUM(CASE
                        WHEN toss_decision = 'field' THEN 1
                        ELSE 0
                    END) * 100 / COUNT(*),
                    2),
            '%') AS FIELD_FIRST_PERCENTAGE
FROM
    IPL_MATCHES
GROUP BY city , venue
HAVING BAT_FIRST > 0 AND FIELD_FIRST > 0
ORDER BY TOTAL_MATCH_PLAYED DESC;

 
-- TOP NEUTRAL VENUES WITH TOSS METRICS Q8

SELECT 
    CITY,
    VENUE AS NEUTRAL_VENUE,
    COUNT(*) AS TOTAL_MATCH_PLAYED,
    SUM(CASE
        WHEN toss_decision = 'bat' THEN 1
        ELSE 0
    END) AS BAT_FIRST,
    SUM(CASE
        WHEN toss_decision = 'field' THEN 1
        ELSE 0
    END) AS FIELD_FIRST,
    CONCAT(ROUND(SUM(CASE
                        WHEN toss_decision = 'bat' THEN 1
                        ELSE 0
                    END) * 100 / COUNT(*),
                    2),
            '%') AS BAT_FIRST_PERCENTAGE,
    CONCAT(ROUND(SUM(CASE
                        WHEN toss_decision = 'field' THEN 1
                        ELSE 0
                    END) * 100 / COUNT(*),
                    2),
            '%') AS FIELD_FIRST_PERCENTAGE
FROM
    IPL_MATCHES
WHERE
    neutral_venue = 1
GROUP BY city , venue
HAVING BAT_FIRST > 0 AND FIELD_FIRST > 0
    AND CITY <> 'NA'
ORDER BY TOTAL_MATCH_PLAYED DESC;
    
-- TOURNAMENT DISMISSAL KIND AND COUNT PERCENTAGE Q9

SELECT DISMISSAL_KIND, COUNT(*) AS COUNT, ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS PERCENTAGE
FROM IPL_2008_2020
GROUP BY DISMISSAL_KIND
HAVING DISMISSAL_KIND <> 'NA'
ORDER BY percentage DESC;


-- TOTAL RUN TYPE Q10

SELECT BATSMAN_RUNS AS RUN_TYPE, COUNT(*) as COUNT,
ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS PERCENTAGE
FROM IPL_2008_2020
WHERE BATSMAN_RUNS IN (4, 6, 1, 2, 3)
GROUP BY BATSMAN_RUNS
ORDER BY RUN_TYPE ;

-- UMPIRE NAMES Q11
 
SELECT 
    UMPIRE1 AS UMPIRE_1, UMPIRE2 AS UMPIRE_2
FROM
    ipl_matches
WHERE
    UMPIRE1 <> 'NA' AND UMPIRE2 <> 'NA';
 
 -- COUNT OF UMPIRE_1 WHO UMPIRED MOST THROUGHOUT THE SEASON Q12
 
SELECT 
    UMPIRE1 AS UMPIRE_1, COUNT(UMPIRE1) AS COUNT_OF_UMPIRE_1
FROM
    ipl_matches
GROUP BY UMPIRE1
HAVING UMPIRE1 <> 'NA'
ORDER BY COUNT_OF_UMPIRE_1 DESC
LIMIT 5;

 -- COUNT OF UMPIRE_2 WHO UMPIRED MOST THROUGHOUT THE SEASON Q13
    
SELECT 
    UMPIRE2 AS UMPIRE_2, COUNT(UMPIRE2) AS COUNT_OF_UMPIRE_2
FROM
    ipl_matches
GROUP BY UMPIRE2
HAVING UMPIRE2 <> 'NA'
ORDER BY COUNT_OF_UMPIRE_2 DESC
LIMIT 5;
 
 
 -- MATCH SUMMARY BY EDITION Q14
 
SELECT 
    IPL_EDITION,
    VENUE,
    CITY,
    DATES,
    TEAM1_IRRESPECTIVE_OF_INNING,
    TEAM2_IRRESPECTIVE_OF_INNING,
    FIRST_INNING,
    SECOND_INNING,
    WINNING_TEAM,
    MOM
FROM
    (SELECT 
        YEAR(M.DATE) AS IPL_EDITION,
            M.VENUE AS VENUE,
            M.CITY AS CITY,
            M.DATE AS DATES,
            M.TEAM1 AS TEAM1_IRRESPECTIVE_OF_INNING,
            M.TEAM2 AS TEAM2_IRRESPECTIVE_OF_INNING,
            M.WINNER AS WINNING_TEAM,
            M.plyare_of_match AS MOM,
            CONCAT(SUM(CASE
                WHEN B.inning = 1 THEN B.total_runs
            END), '/', SUM(CASE
                WHEN B.inning = 1 THEN B.is_wicket
            END)) AS first_inning,
            CONCAT(SUM(CASE
                WHEN B.inning = 2 THEN total_runs
            END), '/', SUM(CASE
                WHEN B.inning = 2 THEN B.is_wicket
            END)) AS second_inning
    FROM
        IPL_2008_2020 AS B
    JOIN IPL_MATCHES M ON B.ID = M.ID
    GROUP BY YEAR(M.DATE) , M.DATE , M.TEAM1 , M.TEAM2 , M.WINNER , M.VENUE , MOM , CITY
    HAVING TEAM1 <> '0') AS A;
 
 
 




