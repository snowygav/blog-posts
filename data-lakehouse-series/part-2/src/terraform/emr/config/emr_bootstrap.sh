#!/bin/bash
set -euo pipefail

sudo python3 -m pip install --upgrade pip
sudo yum -y install git-core python3-devel unixODBC-devel
sudo wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/1.0.0/delta-core_2.12-1.0.0.jar -P /usr/lib/spark/jars/

clone_repo()
{
  REPO=$1
  BRANCH='main'
  GITHUB_TOKEN=`aws secretsmanager get-secret-value --secret-id github_master_token | jq -r '.SecretString'`
  REPO_URL="https://jreissup:$GITHUB_TOKEN@github.com/jreissup/"
  CMD="git clone $REPO_URL$REPO.git --single-branch --branch $BRANCH"
  cd ~ || exit
  # Executing and retrying three times if there is an error in cloning
  RETRIES=3
  n=1
  until [ $n -ge $((RETRIES+1)) ]
  do
    date
    echo "Attempt number: $n"
    eval "$CMD"
    ERROR_CODE=$?
    if [ $ERROR_CODE -eq 0 ]
    then
      break # Success
    else
      echo "ERROR running: $CMD"
      if [ $n -eq $RETRIES ]
      then
        echo "Error Code: $ERROR_CODE - $RETRIES attempts - Can't run: $CMD"
        exit $ERROR_CODE        # exiting with error code <> 0
      fi
    fi

    sleep $((RANDOM % 10))
    sleep $((3**n))         # exponential back-off
    n=$((n+1))
  done
}
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

cd /home/hadoop/
clone_repo "blog-posts" "main"
export PATH=$PATH:/usr/local/bin:/home/hadoop/.local/bin

pip3 install -r /home/hadoop/blog-posts/data-lakehouse-series/part-2/src/requirements.txt