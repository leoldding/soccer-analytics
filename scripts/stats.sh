beeline -u jdbc:hive2://hm-1.hpc.nyu.edu:10000/ -n $1 -p $2 -f scripts/hive.hql --hiveconf netid=$1;

if [ $3 -eq 1 ] 
then
fileName='englishPremierLeagueStatistics.csv'
fi
if [ $3 -eq 2 ] 
then
fileName='spanishLaLigaStatistics.csv'
fi
if [ $3 -eq 3 ] 
then
fileName='italianSerieAStatistics.csv'
fi
if [ $3 -eq 4 ] 
then
fileName='allLeaguesStatistics.csv'
fi

rm impalaoutput/$fileName
impala-shell -i hc08.nyu.cluster -f scripts/impala.sql --var=netid=$1 -B -o impalaoutput/$fileName --output_delimiter=',' --print_header;






