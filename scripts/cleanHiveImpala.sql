-- use your own database
use ${var:netid};

-- remove all tables that have been used
DROP TABLE IF EXISTS english;
DROP TABLE IF EXISTS english_away;
DROP TABLE IF EXISTS english_home;
DROP TABLE IF EXISTS spanish;
DROP TABLE IF EXISTS spanish_away;
DROP TABLE IF EXISTS spanish_home;
DROP TABLE IF EXISTS italian;
DROP TABLE IF EXISTS italian_away;
DROP TABLE IF EXISTS italian_home;
DROP TABLE IF EXISTS all_leagues;
DROP TABLE IF EXISTS all_leagues_away;
DROP TABLE IF EXISTS all_leagues_home;
