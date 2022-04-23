beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1;

if [ $3 -eq 1 ] 
then
fileName='englishPremierLeagueStatistics.csv'
fi
if [ $3 -eq 2 ] 
then
fileName='spanishLaLigaStatistics.csv'
fi
if [ $3 -eq 3 ] 
then
fileName='italianSerieAStatistics.csv'
fi
if [ $3 -eq 4 ] 
then
fileName='allLeaguesStatistics.csv'
fi

rm impalaOutputs/$fileName
impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 -B -o impalaOutputs/$fileName --output_delimiter=',' --print_header;

rm -r sparkOutputs
spark-shell --deploy-mode client -i scripts/spark.scala
hdfs dfs -copyToLocal soccerAnalytics/sparkOutputs
mv sparkOutputs/awayPreds/part* sparkOutputs/awayPreds.csv
mv sparkOutputs/awayStats/part* sparkOutputs/awayStats.csv
mv sparkOutputs/awayVals/part* sparkOutputs/awayVals.csv
mv sparkOutputs/homePreds/part* sparkOutputs/homePreds.csv
mv sparkOutputs/homeStats/part* sparkOutputs/homeStats.csv
mv sparkOutputs/homeVals/part* sparkOutputs/homeVals.csv
rm -r sparkOutputs/*/



