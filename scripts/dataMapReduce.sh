# check for which datasets to process and set appropriate variable values
# removes old output directory so MapReduce runs properly
# runs MapReduce program
if [ $2 -eq 1 ]
  then
    data='englishData'
    hdfs dfs -rm -r soccerAnalytics/$data
    hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/englishPremierLeague /user/$1/soccerAnalytics/$data
    fileName='englishPremierLeague.csv'
fi

if [ $2 -eq 2 ]
  then
    data='spanishData'
    hdfs dfs -rm -r soccerAnalytics/$data
    hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/spanishLaLiga /user/$1/soccerAnalytics/$data
    fileName='spanishLaLiga.csv'
fi

if [ $2 -eq 3 ]
  then
    data='italianData'
    hdfs dfs -rm -r soccerAnalytics/$data
    hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/italianSerieA /user/$1/soccerAnalytics/$data
    fileName='italianSerieA.csv'
fi

if [ $2 -eq 4 ]
  then
    data='all_leaguesData'
    hdfs dfs -rm -r soccerAnalytics/$data
    hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData /user/$1/soccerAnalytics/$data
    fileName='allLeagues.csv'
fi

# rename output file
hdfs dfs -mv soccerAnalytics/$data/part-r-00000 soccerAnalytics/$data/$fileName
# remove status file (setup for hive external table)
hdfs dfs -rm soccerAnalytics/$data/_SUCCESS

# remove old file
rm mapreduceOutputs/$fileName
# bring output file to local file system
hdfs dfs -copyToLocal soccerAnalytics/$data/$fileName
# move file into its output directory
mv $fileName mapreduceOutputs/

