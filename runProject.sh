echo Enter netid:
read netid

echo Enter password:
read -s password

echo Which dataset do you want to analyze?
echo Enter dataset number:
echo 1: English Premier League
echo 2: Spanish La Liga
echo 3: Italian Serie A
echo 4: All Leagues
read league

./scripts/datamr.sh $netid $league
./scripts/stats.sh $netid $password $league
