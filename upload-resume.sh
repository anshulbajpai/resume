#!/usr/bin/env sh

echo "Starting resume json server"

nohup ./node_modules/.bin/resume serve --theme kendall &
SERVER_PROCESS_ID=$!

echo "SERVER_PROCESS_ID=${SERVER_PROCESS_ID}"

echo "Started resume json server"
echo "Switching to github pages directoy"

cd ../anshulbajpai.github.io || exit

echo "Sleeping while server starts"
sleep 3

echo "Downloading resume at ${PWD}/resume.html"
curl http://localhost:4000 > resume.html

echo "Resume diff"

git diff resume.html

push_resume () {
  echo "Committing resume changes"
  git add resume.html
  git commit -m "Updated resume"
  git push
}

while true; do
    read -p "Do you wish to push this change? (y/n)" yn
    case $yn in
        [Yy]* ) push_resume; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

cd - || exit

echo "Killing resume server"
kill -9 ${SERVER_PROCESS_ID}