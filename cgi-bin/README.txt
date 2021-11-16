1.Start git

download git from [..]
git config --global user.name "Wojciech Marzec"
git config --global user.email "wojomc81@gmail.com"
git config --global core.ignorecase false

2.Cloning repository
git clone https://gitlab.com/wojomc/arrakis.git

3.Pushing to git
git push -u origin master

4. PAT (Personal Access Token) 
4.1 Creating (first time)
git remote set-url origin https://ghp_TOgC3zAw3uZ3IC8uMPJ3Ectz9vlTBx3vMDKf@github.com/zlotnik/arrakis

4.2 Updating
git remote  set-url  --push origin https://ghp_2olg0PqdiN2OYhrT4iavitBzNGrYzl1KO1gM@github.com/zlotnik/arrakis/

5. How to run tool 
Tool isn't available for cygwin environment the only environment that works is Windows

perl .\surebetCrafter .\input\ekstraklasaSelector.xml .\output\realData\ekstraKlasaResults.xml

6. How to run tests
6.1 

7. Module responsibilities
8. Cron activities need to run machinery
40 10,18,23,3 * * * /var/www/cgi-bin/jobs/runWhole_harvest_process.sh
20 10,18,23,3 * * * find /var/www/cgi-bin/tmp -type f -mtime +3 -name '*' -execdir rm -- '{}' \;

9.Tags
9.1 Show tag history
git log --no-walk --tags --pretty="%h %d %s" --decorate=full
9.2
git tag -ln
