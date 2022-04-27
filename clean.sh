read -p 'Enter netid: ' netid

hdfs dfs -rm -r soccerAnalytics
impala-shell -i hc08.nyu.cluster -f scripts/cleanHiveImpala.sql --var=netid=$netid;

