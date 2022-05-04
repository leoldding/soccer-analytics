# read in variables
read -p "Enter netid: " netid

password=`systemd-ask-password --timeout=0 "Enter password:"`

echo "Which dataset do you want to analyze?"
echo "1: English Premier League"
echo "2: Spanish La Liga"
echo "3: Italian Serie A"
echo "4: All Leagues"
read -p "Dataset Number: " league

# run MapReduce files
./scripts/dataMapReduce.sh $netid $league
# run Hive/Impala/Spark files
./scripts/analysis.sh $netid $password $league
