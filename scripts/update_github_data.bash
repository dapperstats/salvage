#!/bin/bash

# Set up git on dapperdeploy user

git config --global user.email "deploy@dapperstats.com"
git config --global user.name "DAPPER Deploy Bot"

git checkout master
git add data/* 
git commit -m "updating_data Travis build: $TRAVIS_BUILD_BUMBER"

git remote add deploy https://${GITHUB_DEPLOY_PAT}@github.com/dapperstats/salvage.git > /dev/null 2>&1

git push --quiet --set-upstream deploy master

# git push --quiet deploy master > /dev/null 2>&1
# git push --quiet deploy --tags > /dev/null 2>&1
# curl -v -i -X POST -H "Content-Type:application/json" -H "Authorization: token $GITHUB_RELEASE_PAT" https://api.github.com/repos/dapperstats/salvage/releases -d "{\"tag_name\":\"$current_date\"}"