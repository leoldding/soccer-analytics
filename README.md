# Soccer Analytics
NYU Processing Big Data for Analytics Applications Project

## How To Run
*This assumes that you are affiliated with NYU and are able to access the university's High Performance Cluster (HPC)*
*NOTE: Scripts rely on passing of variables. Windows systems seem to end variables in a way that messes with variable values and thus will cause the program to not run properly.* 

1. Upload whole soccerAnalytics folder into HPC login node. (i.e. scp -r soccerAnalytics *netid*@peel.hpc.nyu.edu:/home/*netid*)
2. Make sure the current directory is the soccerAnalytics directory. To do so, enter the *cd soccerAnalytics* command.
3. Make sure that all .sh files are executable. If they are not, running *chmod 755 (fileName).sh* will allow for file execution. There are four .sh files in total: setup.sh, runProject.sh, scripts/datamr.sh, scripts/stats.sh. 
4. Run the *setup.sh* file by entering *./setup.sh* into the terminal.
5. Run the *runProject.sh* file by entering *./runProject.sh* into the terminal.
6. Respond to the initial text prompts from *runProject.sh*.
7. Wait patiently for all scripts to finish running.
8. Feel free to repeat steps 5 through 7 for the other datasets.

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
* \*Preds.csv files contain model input data along with labels and final predictions.
* \*Vals.csv files contain, in this order, model AUC ROC score, model coefficients of all 9 inputs, model intercept, and outcome labels.
* \*Stats.csv files contain descriptive statistics for the home and away data sets with only wins and losses. 



