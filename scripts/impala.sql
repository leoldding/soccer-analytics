-- invalidate newly created hive tables
invalidate metadata ${var:netid}.${var:tableBase};
invalidate metadata ${var:netid}.${var:tableBase}_home;
invalidate metadata ${var:netid}.${var:tableBase}_away;

-- use own database
use ${var:netid};

-- find averages of all numeric columns
SELECT AVG(full_time_home_goals), AVG(full_time_away_goals), AVG(half_time_home_goals), AVG(half_time_away_goals), AVG(home_shots), AVG(away_shots), AVG(home_shots_target), AVG(away_shots_target), AVG(home_fouls), AVG(away_fouls), AVG(home_corners), AVG(away_corners), AVG(home_yellows), AVG(away_yellows), AVG(home_reds), AVG(away_reds) FROM ${var:tableBase};
-- find standard deviation of all numeric columns
SELECT STDDEV(full_time_home_goals), STDDEV(full_time_away_goals), STDDEV(half_time_home_goals), STDDEV(half_time_away_goals), STDDEV(home_shots), STDDEV(away_shots), STDDEV(home_shots_target), STDDEV(away_shots_target), STDDEV(home_fouls), STDDEV(away_fouls), STDDEV(home_corners), STDDEV(away_corners), STDDEV(home_yellows), STDDEV(away_yellows), STDDEV(home_reds), STDDEV(away_reds) FROM ${var:tableBase};
-- find variance of all numeric columns
SELECT VARIANCE(full_time_home_goals), VARIANCE(full_time_away_goals), VARIANCE(half_time_home_goals), VARIANCE(half_time_away_goals), VARIANCE(home_shots), VARIANCE(away_shots), VARIANCE(home_shots_target), VARIANCE(away_shots_target), VARIANCE(home_fouls), VARIANCE(away_fouls), VARIANCE(home_corners), VARIANCE(away_corners), VARIANCE(home_yellows), VARIANCE(away_yellows), VARIANCE(home_reds), VARIANCE(away_reds) FROM ${var:tableBase};

-- enter all home related data into home data table
INSERT INTO ${var:tableBase}_home SELECT full_time_home_goals, half_time_home_goals, home_shots, home_shots_target, home_fouls, home_corners, home_yellows, home_reds, half_time_result, full_time_result FROM ${var:tableBase}; 
-- enter all away related data into away data table
INSERT INTO ${var:tableBase}_away SELECT full_time_away_goals, half_time_away_goals, away_shots, away_shots_target, away_fouls, away_corners, away_yellows, away_reds, half_time_result, full_time_result FROM ${var:tableBase};

