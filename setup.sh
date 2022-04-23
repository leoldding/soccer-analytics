rm -r mapreduceOutputs 
rm -r impalaOutputs
rm -r sparkOutputs
mkdir mapreduceOutputs
mkdir impalaOutputs
mkdir sparkOutputs

hdfs dfs -rm -r soccerAnalytics
hdfs dfs -mkdir soccerAnalytics
hdfs dfs -put seasonsData soccerAnalytics

cd combineAndClean
javac -classpath `yarn classpath` -d . combineAndCleanMapper.java
javac -classpath `yarn classpath` -d . combineAndCleanReducer.java
javac -classpath `yarn classpath`:. -d . combineAndClean.java
jar -cvf combineAndClean.jar *.class
cd ..
