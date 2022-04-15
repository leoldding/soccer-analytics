echo Enter netid:
read netid

echo Enter password:
read -s password

beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $netid -p $password -f scripts/hive.hql --hiveconf netid=$netid;

echo Enter output file name:
read fileName

mkdir impalaoutput

impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$netid -B -o impalaoutput/$fileName --output_delimiter=',' --print_header;






