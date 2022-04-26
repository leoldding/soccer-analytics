use ${hiveconf:netid};

DROP TABLE IF EXISTS ${hiveconf:tableBase};
CREATE EXTERNAL TABLE ${hiveconf:tableBase}(division STRING, match_day STRING, home_team STRING, away_team STRING, full_time_home_goals INT, full_time_away_goals INT, full_time_result INT, half_time_home_goals INT, half_time_away_goals INT, half_time_result INT, home_shots INT, away_shots INT, home_shots_target INT, away_shots_target INT, home_fouls INT, away_fouls INT, home_corners INT, away_corners INT, home_yellows INT, away_yellows INT, home_reds INT, away_reds INT) COMMENT 'soccer analytics table' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/${hiveconf:netid}/soccerAnalytics/${hiveconf:tableBase}Data';

DROP TABLE IF EXISTS ${hiveconf:tableBase}_home;
CREATE TABLE ${hiveconf:tableBase}_home(full_time_goals INT, half_time_goals INT, shots INT, shots_target INT, fouls INT, corners INT, yellows INT, reds INT, half_time_result INT, full_time_result INT);

DROP TABLE IF EXISTS ${hiveconf:tableBase}_away;
CREATE TABLE ${hiveconf:tableBase}_away(full_time_goals INT, half_time_goals INT, shots INT, shots_target INT, fouls INT, corners INT, yellows INT, reds INT, half_time_result INT, full_time_result INT);

