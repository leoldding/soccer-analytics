# check for which datasets to process and set appropriate variable values
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

# submit and run hive file
beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1 --hiveconf tableBase=$tableBase;

# remove old file if it exists
rm impalaOutputs/$fileName
# submit and run impala file
impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 --var=tableBase=$tableBase -B -o impalaOutputs/$fileName --output_delimiter=',' --print_header;

# remove old output directory
rm -r sparkOutputs/$dirName
# submit and run spark file
spark-shell --deploy-mode client -i scripts/spark.scala --conf spark.driver.args="$1 $dirName $tableBase"

# bring all outputs to local file system
hdfs dfs -copyToLocal soccerAnalytics/sparkOutputs/$dirName sparkOutputs/
# move and rename outputs
mv sparkOutputs/$dirName/$tableBase'AwayPredictions'/part* sparkOutputs/$dirName/$tableBase'AwayPredictions.csv'
mv sparkOutputs/$dirName/$tableBase'AwayStatistics'/part* sparkOutputs/$dirName/$tableBase'AwayStatistics.csv'
mv sparkOutputs/$dirName/$tableBase'AwayValues'/part* sparkOutputs/$dirName/$tableBase'AwayValues.csv'
mv sparkOutputs/$dirName/$tableBase'HomePredictions'/part* sparkOutputs/$dirName/$tableBase'HomePredictions.csv'
mv sparkOutputs/$dirName/$tableBase'HomeStatistics'/part* sparkOutputs/$dirName/$tableBase'HomeStatistics.csv'
mv sparkOutputs/$dirName/$tableBase'HomeValues'/part* sparkOutputs/$dirName/$tableBase'HomeValues.csv'

# manipulate silhouette score file if working with all data
if [ $3 -eq 4 ] 
  then
    mv sparkOutputs/$dirName/$tableBase'Silhouette'/part* sparkOutputs/$dirName/$tableBase'Silhouette.csv'
fi

# remove empty directories
rm -r sparkOutputs/$dirName/*/



