invalidate metadata ${var:netid}.soccer_analytics;

use ${var:netid};

SELECT AVG(full_time_home_goals), AVG(full_time_away_goals), AVG(half_time_home_goals), AVG(half_time_away_goals), AVG(home_shots), AVG(away_shots), AVG(home_shots_target), AVG(away_shots_target), AVG(home_fouls), AVG(away_fouls), AVG(home_corners), AVG(away_corners), AVG(home_yellows), AVG(away_yellows), AVG(home_reds), AVG(away_reds) FROM soccer_analytics;

SELECT STDDEV(full_time_home_goals), STDDEV(full_time_away_goals), STDDEV(half_time_home_goals), STDDEV(half_time_away_goals), STDDEV(home_shots), STDDEV(away_shots), STDDEV(home_shots_target), STDDEV(away_shots_target), STDDEV(home_fouls), STDDEV(away_fouls), STDDEV(home_corners), STDDEV(away_corners), STDDEV(home_yellows), STDDEV(away_yellows), STDDEV(home_reds), STDDEV(away_reds) FROM soccer_analytics;

SELECT VARIANCE(full_time_home_goals), VARIANCE(full_time_away_goals), VARIANCE(half_time_home_goals), VARIANCE(half_time_away_goals), VARIANCE(home_shots), VARIANCE(away_shots), VARIANCE(home_shots_target), VARIANCE(away_shots_target), VARIANCE(home_fouls), VARIANCE(away_fouls), VARIANCE(home_corners), VARIANCE(away_corners), VARIANCE(home_yellows), VARIANCE(away_yellows), VARIANCE(home_reds), VARIANCE(away_reds) FROM soccer_analytics;




