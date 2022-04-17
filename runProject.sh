echo Enter netid:
read netid

echo Enter password:
read -s password

./scripts/datamr.sh $netid
./scripts/stats.sh $netid $password
