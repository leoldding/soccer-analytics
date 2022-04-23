hdfs dfs -rm -r soccerAnalytics/data

if [ $2 -eq 1 ]
then
hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/englishPremierLeague /user/$1/soccerAnalytics/data
fileName='englishPremierLeague.csv'
fi
if [ $2 -eq 2 ]
then
hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/spanishLaLiga /user/$1/soccerAnalytics/data
fileName='spanishLaLiga.csv'
fi
if [ $2 -eq 3 ]
then
hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/italianSerieA /user/$1/soccerAnalytics/data
fileName='italianSerieA.csv'
fi
if [ $2 -eq 4 ]
then
hadoop jar combineAndClean/combineAndClean.jar combineAndClean soccerAnalytics/seasonsData /user/$1/soccerAnalytics/data
fileName='allLeagues.csv'
fi

hdfs dfs -mv soccerAnalytics/data/part-r-00000 soccerAnalytics/data/$fileName
hdfs dfs -rm soccerAnalytics/data/_SUCCESS

rm mapreduceOutputs/$fileName
hdfs dfs -copyToLocal soccerAnalytics/data/$fileName
mv $fileName mapreduceOutputs/

