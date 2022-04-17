# Soccer Analytics
NYU Processing Big Data for Analytics Applications Project

## How To Run
*This assumes that you are affiliated with NYU and are able to access the university's High Performance Cluster (HPC)*

1. Load all files into HPC login node.
2. Make sure that all .sh files are executable.
- If they are not, running *chmod 755 (fileName)* will allow for file execution. 
3. Run the *runProject.sh* file by inputting ./runProject.sh into the terminal.
4. Follow the prompts and wait until all scripts are finished.


## Outputs
The MapReduce portion of the code will join and clean all of the datasets and output the file into *mroutput*.
The Hive/Impala section will create a table using the MapReduce output and run summary statistics on it and output a file into *impalaoutput*.




