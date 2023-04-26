#!/usr/bin/env sh

echo "Starting resume json server"

nohup $(npm bin)/resume serve -s --theme kendall &
SERVER_PROCESS_ID=$!

echo "SERVER_PROCESS_ID=${SERVER_PROCESS_ID}"

echo "Sleeping while server starts"
sleep 2

echo "Started resume json server"

echo "Downloading new resume at /tmp/new.html"
curl http://localhost:4000 > /tmp/new.html

echo "Killing resume server"
kill -9 ${SERVER_PROCESS_ID}

echo "Downloading existing resume at /tmp/current.html"
curl https://anshulbajpai.github.io/resume/index.html > /tmp/current.html

echo "Resume diff"
diff -bBwu /tmp/current.html /tmp/new.html | colordiff

push_resume () {
  echo "Stashing current changes before switching branch"
  git stash
  echo "Switching to gh-pages branch"
  git checkout gh-pages
  cp -f /tmp/new.html index.html
  echo "Committing resume changes"
  git add index.html
  git commit -m "Updated resume"
  git push
  echo "Updated resume is LIVE now"
  git checkout master
  git stash pop
}

while true; do
    read -p "Do you wish to make this change LIVE? (y/n)" yn
    case $yn in
        [Yy]* ) push_resume; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

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