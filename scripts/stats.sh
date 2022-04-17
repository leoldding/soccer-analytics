beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1;

echo Enter output file name:
read fileName

mkdir impalaoutput

impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 -B -o impalaoutput/$fileName --output_delimiter=',' --print_header;






