#!/bin/bash

[ -z "$INPUT_SBT" ] && echo "Missing SBT commands" && exit 1
[ -z "$INPUT_PACKAGEJSON" ] && echo "Missing package.json path" && exit 1

ROOT=/root

[ -z "$ARTIFACTORY_REALM" ] && export ARTIFACTORY_REALM=artifactory.sgn.com
[ -z "$AWS_REGION" ] && export AWS_REGION=us-west-2

mkdir -p $ROOT/.sbt/1.0

echo "credentials += Credentials(\"Artifactory Realm\", \"${ARTIFACTORY_REALM}\", \"${ARTIFACTORY_USER}\", \"${ARTIFACTORY_PASSWORD}\")" > $ROOT/.sbt/1.0/globals.sbt

if [ -n "$SLACK_TOKEN" ]; then
  echo "$SLACK_TOKEN" > $ROOT/.slacktoken
fi

nuget sources | grep -q Artifactory_Realm || (
  nuget sources Add -Name Artifactory_Realm -Source https://artifactory.sgn.com/artifactory/api/nuget/nuget-local &&
  nuget setapikey "${ARTIFACTORY_USER}:${ARTIFACTORY_PASSWORD}" -Source https://artifactory.sgn.com/artifactory/api/nuget/nuget-local
)  

mkdir $ROOT/.aws
cat <<EOF > $ROOT/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

cat <<EOF > $ROOT/.aws/config
[default]
region = $AWS_REGION
EOF

#[[ -n "$GITHUB_WORKSPACE" ]] && (
#  mkdir -p $GITHUB_WORKSPACE/.ivy2 $GITHUB_WORKSPACE/.sbt
#  ln -s $GITHUB_WORKSPACE/.ivy2 /root/.ivy2
#  ln -s $GITHUB_WORKSPACE/.sbt /root/.sbt
#)

mkdir -p ~/.ivy2 ~/.sbt
ln -s ~/.ivy2 /root/.ivy2
ln -s ~/.sbt /root/.sbt
  
CMD="sbt $INPUT_SBT"
eval $CMD

if [ -e "$INPUT_PACKAGEJSON" ]; then
  cat "$INPUT_PACKAGEJSON" | jq -r 'to_entries[] | "PACKAGE_\(.key | [ splits("(?=[A-Z])") ] | map(select(. != "")) | join("_") | ascii_upcase)=\(.value)"' >> $GITHUB_ENV
fi 
