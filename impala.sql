invalidate metadata ${var:username}.soccer_analytics;

use ${var:username};

SELECT AVG(full_time_home_goals), AVG(full_time_away_goals) FROM soccer_analytics;





