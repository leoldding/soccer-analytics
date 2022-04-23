beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1;

if [ $3 -eq 1 ] 
then
fileName='englishPremierLeagueStatistics.csv'
dirName='englishModels'
fi
if [ $3 -eq 2 ] 
then
fileName='spanishLaLigaStatistics.csv'
dirName='spanishModels'
fi
if [ $3 -eq 3 ] 
then
fileName='italianSerieAStatistics.csv'
dirName='italianModels'
fi
if [ $3 -eq 4 ] 
then
fileName='allLeaguesStatistics.csv'
dirName='allModels'
fi

rm impalaOutputs/$fileName
impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 -B -o impalaOutputs/$fileName --output_delimiter=',' --print_header;

rm -r sparkOutputs/$dirName
spark-shell --deploy-mode client -i scripts/spark.scala --conf spark.driver.args="$1 $dirName"
hdfs dfs -copyToLocal soccerAnalytics/sparkOutputs/$dirName sparkOutputs/
mv sparkOutputs/$dirName/awayPreds/part* sparkOutputs/$dirName/awayPreds.csv
mv sparkOutputs/$dirName/awayStats/part* sparkOutputs/$dirName/awayStats.csv
mv sparkOutputs/$dirName/awayVals/part* sparkOutputs/$dirName/awayVals.csv
mv sparkOutputs/$dirName/homePreds/part* sparkOutputs/$dirName/homePreds.csv
mv sparkOutputs/$dirName/homeStats/part* sparkOutputs/$dirName/homeStats.csv
mv sparkOutputs/$dirName/homeVals/part* sparkOutputs/$dirName/homeVals.csv
rm -r sparkOutputs/$dirName/*/



