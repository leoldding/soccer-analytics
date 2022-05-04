# read in variables
read -p 'Enter netid: ' netid

# remove hdfs directory used in project
hdfs dfs -rm -r soccerAnalytics
# removes all hive/impala tables used in project
impala-shell -i hc08.nyu.cluster -f scripts/cleanHiveImpala.sql --var=netid=$netid;

