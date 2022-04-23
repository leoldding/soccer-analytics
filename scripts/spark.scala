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

val spark = SparkSession.builder().appName("SparkML").enableHiveSupport().getOrCreate()

val homeData = spark.sql("SELECT * FROM ld2425.home_stats WHERE full_time_result = 1 OR full_time_result = -1")
val awayData = spark.sql("SELECT * FROM ld2425.away_stats WHERE full_time_result = 1 OR full_time_result = -1")

homeData.describe().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/homeStats")
awayData.describe().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "true").save("soccerAnalytics/sparkOutputs/awayStats")

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
homePreds.drop("features").drop("rawPrediction").drop("probability").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header","true").save("soccerAnalytics/sparkOutputs/homePreds")

val awayModel = pipeline.fit(awayTrain)
val awayPreds = awayModel.transform(awayTest)
awayPreds.drop("features").drop("rawPrediction").drop("probability").coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header","true").save("soccerAnalytics/sparkOutputs/awayPreds")

val homeModelVals = homeModel.stages(2).asInstanceOf[LogisticRegressionModel].coefficients.toArray
val homeVals = List(evaluator.evaluate(homePreds), homeModelVals(0), homeModelVals(1), homeModelVals(2), homeModelVals(3), homeModelVals(4), homeModelVals(5), homeModelVals(6), homeModelVals(7), homeModelVals(8), homeModel.stages(1).asInstanceOf[StringIndexerModel].labels(0).toInt, homeModel.stages(1).asInstanceOf[StringIndexerModel].labels(1).toInt)
homeVals.toDF().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "false").save("soccerAnalytics/sparkOutputs/homeVals")

val awayModelVals = awayModel.stages(2).asInstanceOf[LogisticRegressionModel].coefficients.toArray
val awayVals = List(evaluator.evaluate(awayPreds), awayModelVals(0), awayModelVals(1), awayModelVals(2), awayModelVals(3), awayModelVals(4), awayModelVals(5), awayModelVals(6), awayModelVals(7), awayModelVals(8), awayModel.stages(1).asInstanceOf[StringIndexerModel].labels(0).toInt, awayModel.stages(1).asInstanceOf[StringIndexerModel].labels(1).toInt)
awayVals.toDF().coalesce(1).write.format("com.databricks.spark.csv").mode("overwrite").option("header", "false").save("soccerAnalytics/sparkOutputs/awayVals")

spark.close()
System.exit(0)
