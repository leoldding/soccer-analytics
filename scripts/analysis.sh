if [ $3 -eq 1 ] 
then
tableBase='english'
fileName='englishPremierLeagueStatistics.csv'
dirName='englishModels'
fi
if [ $3 -eq 2 ] 
then
tableBase='spanish'
fileName='spanishLaLigaStatistics.csv'
dirName='spanishModels'
fi
if [ $3 -eq 3 ] 
then
tableBase='italian'
fileName='italianSerieAStatistics.csv'
dirName='italianModels'
fi
if [ $3 -eq 4 ] 
then
tableBase='all_leagues'
fileName='allLeaguesStatistics.csv'
dirName='allLeaguesModels'
fi

beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1 --hiveconf tableBase=$tableBase;

#rm impalaOutputs/$fileName
#impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 --var=tableBase=$tableBase -B -o impalaOutputs/$fileName --output_delimiter=',' --print_header;

rm -r sparkOutputs/$dirName
spark-shell --deploy-mode client -i scripts/spark.scala --conf spark.driver.args="$1 $dirName $tableBase"
hdfs dfs -copyToLocal soccerAnalytics/sparkOutputs/$dirName sparkOutputs/
mv sparkOutputs/$dirName/$tableBase'AwayPredictions'/part* sparkOutputs/$dirName/$tableBase'AwayPredictions.csv'
mv sparkOutputs/$dirName/$tableBase'AwayStatistics'/part* sparkOutputs/$dirName/$tableBase'AwayStatistics.csv'
mv sparkOutputs/$dirName/$tableBase'AwayValues'/part* sparkOutputs/$dirName/$tableBase'AwayValues.csv'
mv sparkOutputs/$dirName/$tableBase'HomePredictions'/part* sparkOutputs/$dirName/$tableBase'HomePredictions.csv'
mv sparkOutputs/$dirName/$tableBase'HomeStatistics'/part* sparkOutputs/$dirName/$tableBase'HomeStatistics.csv'
mv sparkOutputs/$dirName/$tableBase'HomeValues'/part* sparkOutputs/$dirName/$tableBase'HomeValues.csv'
rm -r sparkOutputs/$dirName/*/



