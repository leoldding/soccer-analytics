# Soccer Analytics
NYU Processing Big Data for Analytics Applications Project

## Data
The data used for any analysis can be found in the *seasonsData* directory.
Data comes from the three sources below. License: Open Data Commons
1. https://datahub.io/sports-data/english-premier-league
2. https://datahub.io/sports-data/spanish-la-liga
3. https://datahub.io/sports-data/italian-serie-a

## How To Run
*This assumes that you are affiliated with NYU and are able to access the university's High Performance Cluster (HPC)*

1. Upload soccerAnalytics folder into HPC login node. (i.e. scp -r soccerAnalytics *netid*@peel.hpc.nyu.edu:/home/*netid*)
2. Login to HPC. 
3. Make sure the current directory is the soccerAnalytics directory. To do so, enter the *cd soccerAnalytics* command.
4. Ensure that all .sh files are executable. 
4-1. If they are not, running *chmod 755 (fileName).sh* will allow for file execution. There are five .sh files in total: setup.sh, runProject.sh, scripts/dataMapReduce.sh, scripts/analysis.sh, clean.sh.
4-2. Windows users may potentially face an issue with CRLF line endings messing with shell execution. If this is the case, please use *vi (filename).sh* to edit the shell file and enter *:set fileformat=unix* to change  line endings to LF. Enter *:wq* to save and exit the file. 
5. Run the *setup.sh* file by entering *./setup.sh* into the terminal.
6. Run the *runProject.sh* file by entering *./runProject.sh* into the terminal.
6-1. Respond to the text prompts from *runProject.sh*.
7. Wait patiently for all scripts to finish running.
8. Feel free to repeat steps 5 through 7 for the other datasets.
9. Download output folders if desired.
10. Can run *clean.sh* to remove the HDFS directories and Hive/Impala tables that the program created. 

## Outputs

### MapReduce
* Joins and cleans selected datasets.
* Outputs into *mapreduceOutputs*.

### Hive/Impala
* Creates tables to hold data.
* Runs summary statistics over whole dataset.
* Outputs into *impalaOutputs*.

### Spark
* Runs logistic regression models on separated home and away data for only wins and losses.
* Outputs into *sparkOutputs*
* \*Predictions.csv files contain model input data along with labels and final predictions.
* \*Statistics.csv files contain descriptive statistics for the home and away data sets with only wins and losses.
* \*Values.csv files contain, in this order, model AUC ROC score, model coefficients of all 9 inputs, model intercept, and outcome labels.
* Also runs KMeans for k = 2 to 6, but only when all leagues are selected.
* \*Silhouette.csv file contains the silhouette scores in order for k = 2 to 6.
