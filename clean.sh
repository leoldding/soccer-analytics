read -p 'Enter netid: ' netid

password=`systemd-ask-password --timeout=0 "Enter password:"`

hdfs dfs -rm -r soccerAnalytics
beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $netid -p $password -f scripts/cleanHive.hql --hiveconf netid=$netid;
impala-shell -i hc08.nyu.cluster -f scripts/cleanImpala.sql --var=netid=$netid;

