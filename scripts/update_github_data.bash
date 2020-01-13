#!/bin/bash

# Set up git on dapperdeploy user

git config --global user.email "deploy@dapperstats.com"
git config --global user.name "DAPPER Deploy Bot"

git checkout master
git add data/* 
git commit -m "updating_data"

git remote add deploy https://${GITHUB_DEPLOY_PAT}@github.com/dapperstats/salvage.git > /dev/null 2>&1

current_date=`date -I | head -c 10`
git tag $current_date

git push --quiet deploy master > /dev/null 2>&1
git push --quiet deploy --tags > /dev/null 2>&1