#!/usr/bin/env sh

echo "Starting resume json server"

nohup ./node_modules/.bin/resume serve -s --theme kendall &
SERVER_PROCESS_ID=$!
RESUME_WEBSITE_PATH=${PWD}/../anshulbajpai.github.io

echo "SERVER_PROCESS_ID=${SERVER_PROCESS_ID}"

echo "Sleeping while server starts"
sleep 2

echo "Started resume json server"

echo "Downloading resume at ${PWD}/resume.html"
curl http://localhost:4000 > resume.html

echo "Resume diff"

diff -bBwu ${RESUME_WEBSITE_PATH}/resume.html resume.html | colordiff

push_resume () {
  mv -f resume.html ${RESUME_WEBSITE_PATH}/resume.html
  echo "Switching to github pages directoy"
  cd ${RESUME_WEBSITE_PATH} || exit
  echo "Committing resume changes"
  git add resume.html
  git commit -m "Updated resume"
  git push
  echo "Updated resume is LIVE now"
  cd - || exit
}

while true; do
    read -p "Do you wish to make this change LIVE? (y/n)" yn
    case $yn in
        [Yy]* ) push_resume; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Killing resume server"
kill -9 ${SERVER_PROCESS_ID}

commit_push () {
  git commit -a
  git push
}

git diff

while true; do
    read -p "Do you wish to commit and push these changes? (y/n)" yn
    case $yn in
        [Yy]* ) commit_push; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done