# remove old output directories if they exist
rm -r mapreduceOutputs
rm -r impalaOutputs
rm -r sparkOutputs
# create output directories
mkdir mapreduceOutputs
mkdir impalaOutputs
mkdir sparkOutputs

# remove old hdfs directory if it exists
hdfs dfs -rm -r soccerAnalytics
# create hdfs directory
hdfs dfs -mkdir soccerAnalytics
# add all data into hdfs directory
hdfs dfs -put seasonsData soccerAnalytics

# compile MapReduce files
cd combineAndClean
javac -classpath `yarn classpath` -d . combineAndCleanMapper.java
javac -classpath `yarn classpath` -d . combineAndCleanReducer.java
javac -classpath `yarn classpath`:. -d . combineAndClean.java
jar -cvf combineAndClean.jar *.class
cd ..
