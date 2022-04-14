hdfs dfs -mkdir soccerAnalytics
hdfs dfs -put seasonsData soccerAnalytics
cd combineAndClean
javac -classpath `yarn classpath` -d . combineAndCleanMapper.java
javac -classpath `yarn classpath` -d . combineAndCleanReducer.java
javac -classpath `yarn classpath`:. -d . combineAndClean.java
jar -cvf combineAndClean.jar *.class
hdfs dfs -rm -r soccerAnalytics/data
echo Enter netid:
read netid
hadoop jar combineAndClean.jar combineAndClean soccerAnalytics/seasonsData/season-0910_csv.csv soccerAnalytics/seasonsData/season-1011_csv.csv soccerAnalytics/seasonsData/season-1112_csv.csv soccerAnalytics/seasonsData/season-1213_csv.csv soccerAnalytics/seasonsData/season-1314_csv.csv soccerAnalytics/seasonsData/season-1415_csv.csv soccerAnalytics/seasonsData/season-1516_csv.csv soccerAnalytics/seasonsData/season-1617_csv.csv soccerAnalytics/seasonsData/season-1718_csv.csv soccerAnalytics/seasonsData/season-1819_csv.csv /user/$netid/soccerAnalytics/data/
cd ..
echo Enter data file name:
read fileName
hdfs dfs -mv soccerAnalytics/data/part-r-00000 soccerAnalytics/data/$fileName
hdfs dfs -rm soccerAnalytics/data/_SUCCESS
hdfs dfs -copyToLocal soccerAnalytics/data/$fileName



