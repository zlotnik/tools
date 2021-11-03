1.Start git

download git from [..]
git config --global user.name "Wojciech Marzec"
git config --global user.email "wojomc81@gmail.com"
git config --global core.ignorecase false

2.Cloning repository
git clone https://gitlab.com/wojomc/arrakis.git

3.Pushing to git
git push -u origin master

4.Updating PAT (Personal Access Token) 
git remote set-url origin https://ghp_TOgC3zAw3uZ3IC8uMPJ3Ectz9vlTBx3vMDKf@github.com/zlotnik/arrakis

5. How to run tool 
Tool isn't available for cygwin environment the only environment that works is Windows

perl .\surebetCrafter .\input\ekstraklasaSelector.xml .\output\realData\ekstraKlasaResults.xml

6. How to run tests
6.1 

7. Module responsibilities
8. Cron activities need to run machinery
40 10,18,23,3 * * * /var/www/cgi-bin/jobs/runWhole_harvest_process.sh
20 10,18,23,3 * * * find /var/www/cgi-bin/tmp -type f -mtime +3 -name '*' -execdir rm -- '{}' \;
