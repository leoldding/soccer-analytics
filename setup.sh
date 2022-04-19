rm -r mroutput
rm -r impalaoutput
mkdir mroutput
mkdir impalaoutput

hdfs dfs -rm -r soccerAnalytics
hdfs dfs -mkdir soccerAnalytics
hdfs dfs -put seasonsData soccerAnalytics

cd combineAndClean
javac -classpath `yarn classpath` -d . combineAndCleanMapper.java
javac -classpath `yarn classpath` -d . combineAndCleanReducer.java
javac -classpath `yarn classpath`:. -d . combineAndClean.java
jar -cvf combineAndClean.jar *.class
cd ..
