echo Does directory exist with data? '[yes/no]'
read res
if [ $res = 'no' ]
then
hdfs dfs -mkdir soccerAnalytics
hdfs dfs -put seasonsData soccerAnalytics
fi

cd combineAndClean
javac -classpath `yarn classpath` -d . combineAndCleanMapper.java
javac -classpath `yarn classpath` -d . combineAndCleanReducer.java
javac -classpath `yarn classpath`:. -d . combineAndClean.java
jar -cvf combineAndClean.jar *.class

echo Enter netid:
read netid

echo Which dataset do you want to be used?
echo Enter number:
echo 1 englishPremierLeague
echo 2 spanishLaLiga
echo 3 italianSerieA
echo 4 all
read directory

if [ $res = 'yes' ] 
then
hdfs dfs -rm -r soccerAnalytics/data
fi

if [ $directory -eq 1 ]
then
hadoop jar combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/englishPremierLeague /user/$netid/soccerAnalytics/data
fi
if [ $directory -eq 2 ]
then
hadoop jar combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/spanishLaLiga /user/$netid/soccerAnalytics/data
fi
if [ $directory -eq 3 ]
then
hadoop jar combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/italianSerieA /user/$netid/soccerAnalytics/data
fi
if [ $directory -eq 4 ]
then
hadoop jar combineAndClean.jar combineAndClean soccerAnalytics/seasonsData /user/$netid/soccerAnalytics/data
fi

cd ..
echo Enter data file name:
read fileName
hdfs dfs -mv soccerAnalytics/data/part-r-00000 soccerAnalytics/data/$fileName
hdfs dfs -rm soccerAnalytics/data/_SUCCESS

mkdir mroutput
rm mroutput/$fileName
hdfs dfs -copyToLocal soccerAnalytics/data/$fileName
mv $fileName mroutput


