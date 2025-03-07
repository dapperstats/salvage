#!/bin/bash

echo "Updating files on GitHub..."
# Set environment variables
CURRENT_DATE=`date +%Y-%m-%d_%H-%M | head -c 20`

# Set up dapperdeploy as user
git config --global user.email "deploy@dapperstats.com"
git config --global user.name "DAPPER Deploy Bot"

# Checkout the main branch
git fetch --unshallow
git checkout main

# Add .csv data files and the website folder
git add data/*.csv 
git add site/docs/*

# Commit the files with a message tracking the job number and date
git commit -m "updating data cron job: $CURRENT_DATE"

# Remote add the committed files to the deploy branch
git remote add deploy https://${GITHUB_TOKEN}@github.com/dapperstats/salvage.git > /dev/null 2>&1

# Create a tag based on the date
git tag $CURRENT_DATE

# Push the deploy branch to update the main
git push --quiet --set-upstream deploy main

# Push the tag to the branch
git push --quiet deploy --tags > /dev/null 2>&1

# POST the tag as a release
curl -v -i -X POST -H "Content-Type:application/json" -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/dapperstats/salvage/releases -d "{\"tag_name\":\"$CURRENT_DATE\"}"


