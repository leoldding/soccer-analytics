echo Hive username:
read username 

echo Hive password:
read -s password

beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $username -p $password -f hive.hql --hiveconf username=$username;

impala-shell -i hc08.nyu.cluster -f impala.sql --var=username=$username -B -o output.csv --output_delimiter=',';






