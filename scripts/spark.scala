import org.apache.spark.sql.SparkSession
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.ml.feature.VectorAssembler
import org.apache.spark.ml.feature.StringIndexer
import org.apache.spark.ml.feature.StringIndexerModel
import org.apache.spark.ml.classification.LogisticRegression
import org.apache.spark.ml.classification.LogisticRegressionModel
import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.evaluation.BinaryClassificationEvaluator
import org.apache.spark.ml.clustering.KMeans
import org.apache.spark.ml.evaluation.ClusteringEvaluator

val spark = SparkSession.builder().appName("SparkML").enableHiveSupport().getOrCreate()

val args = spark.sparkContext.getConf.get("spark.driver.args").split("\\s+")
val netid = args(0)
val dir = args(1)
val tableBase = args(2)
val homeData = spark.sql("SELECT * FROM " + netid + "." + tableBase + "_home WHERE full_time_result = 1 OR full_time_result = -1")
val awayData = spark.sql("SELECT * FROM " + netid + "." + tableBase + "_away WHERE full_time_result = 1 OR full_time_result = -1")

homeData.describe().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "HomeStatistics")
awayData.describe().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "AwayStatistics")

val Array(homeTrain, homeTest) = homeData.randomSplit(Array(0.8,0.2), 42)
val Array(awayTrain, awayTest) = awayData.randomSplit(Array(0.8,0.2), 42)

val columns = Array("full_time_goals", "half_time_goals", "shots", "shots_target", "fouls", "corners", "yellows", "reds", "half_time_result")

val assembler = new VectorAssembler().setInputCols(columns).setOutputCol("features")
val indexer = new StringIndexer().setInputCol("full_time_result").setOutputCol("label")
val logisticRegression = new LogisticRegression().setMaxIter(100).setRegParam(0.2).setElasticNetParam(0.8)
val stages = Array(assembler, indexer, logisticRegression)
val pipeline = new Pipeline().setStages(stages)
val evaluator = new BinaryClassificationEvaluator().setLabelCol("label").setRawPredictionCol("prediction").setMetricName("areaUnderROC")

val homeModel = pipeline.fit(homeTrain)
val homePreds = homeModel.transform(homeTest)
homePreds.drop("features").drop("rawPrediction").drop("probability").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header","true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "HomePredictions")

val awayModel = pipeline.fit(awayTrain)
val awayPreds = awayModel.transform(awayTest)
awayPreds.drop("features").drop("rawPrediction").drop("probability").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header","true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "AwayPredictions")

val homeModelVals = homeModel.stages(2).asInstanceOf[LogisticRegressionModel].coefficients.toArray
val homeVals = Seq((evaluator.evaluate(homePreds), homeModelVals(0), homeModelVals(1), homeModelVals(2), homeModelVals(3), homeModelVals(4), homeModelVals(5), homeModelVals(6), homeModelVals(7), homeModelVals(8), homeModel.stages(1).asInstanceOf[StringIndexerModel].labels(0).toInt, homeModel.stages(1).asInstanceOf[StringIndexerModel].labels(1).toInt))
homeVals.toDF("ROC", "full_time_goals_coeff", "half_time_goals_coeff", "shots_coeff", "shots_target_coeff", "fouls_coeff", "corners_coeff", "yellows_coeff", "reds_coeff", "half_time_result_coeff", "negativeLabel", "positiveLabel").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "HomeValues")

val awayModelVals = awayModel.stages(2).asInstanceOf[LogisticRegressionModel].coefficients.toArray
val awayVals = Seq((evaluator.evaluate(awayPreds), awayModelVals(0), awayModelVals(1), awayModelVals(2), awayModelVals(3), awayModelVals(4), awayModelVals(5), awayModelVals(6), awayModelVals(7), awayModelVals(8), awayModel.stages(1).asInstanceOf[StringIndexerModel].labels(0).toInt, awayModel.stages(1).asInstanceOf[StringIndexerModel].labels(1).toInt))
awayVals.toDF("ROC", "full_time_goals_coeff", "half_time_goals_coeff", "shots_coeff", "shots_target_coeff", "fouls_coeff", "corners_coeff", "yellows_coeff", "reds_coeff", "half_time_result_coeff", "negativeLabel", "positiveLabel").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "AwayValues")

if(tableBase == "all_leagues")
{
    val data = spark.sql("SELECT * FROM " + netid + "." + tableBase)
  
    val columns = Array("full_time_home_goals", "full_time_away_goals", "full_time_result", "half_time_home_goals", "half_time_away_goals", "half_time_result", "home_shots", "away_shots", "home_shots_target", "away_shots_target", "home_fouls", "away_fouls", "home_corners", "away_corners", "home_yellows", "away_yellows", "home_reds", "away_reds")
    val assembler = new VectorAssembler().setInputCols(columns).setOutputCol("features")
    val featureData = assembler.transform(data)

    val k = 0
    val evaluator = new ClusteringEvaluator() 
    val buffer = scala.collection.mutable.ListBuffer.empty[Double]    

    for(k<-2 to 6)
    {
	val kMeans = new KMeans().setK(k).setSeed(42)
	val kMeansModel = kMeans.fit(featureData)
	val kMeansPreds = kMeansModel.transform(featureData)

	val silhouette = evaluator.evaluate(kMeansPreds)
	buffer += silhouette	 
    }
    buffer.toList.toDF().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "false").save("soccerAnalytics/sparkOutputs/" + dir + "/" + tableBase + "Silhouette")
}

spark.close()
System.exit(0)
