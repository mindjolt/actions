#!/bin/sh

set -eu

# Lowercase job status
JOB_STATUS=$(echo "$1" | tr '[:upper:]' '[:lower:]')
SLACK_BOT_TOKEN=$2
CHANNEL=$3
VERSION=$4

REPO_NAME=${GITHUB_REPOSITORY##*/}
REPOSITORY=$GITHUB_REPOSITORY
WORKFLOW=$GITHUB_WORKFLOW
RUN_ID=$GITHUB_RUN_ID

slackMsg() {
    title=$1
    color=$2
    msg="{\"channel\":\"$CHANNEL\", \"attachments\": [ { \"title\":\"$title [ $REPO_NAME ] : [ $WORKFLOW ] : [ $VERSION ]\", \"text\": \"https://github.com/$REPOSITORY/actions/runs/$RUN_ID\", \"color\": \"$color\" } ]}"
}

if [ "$JOB_STATUS" = 'success' ]; then
    slackMsg "SUCCESS" "#00FF00"
    elif [ "$JOB_STATUS" = 'cancelled' ]; then
    slackMsg "CANCELLED" "#EE6F47"
else
    slackMsg "FAILURE" "#FF0000"
fi

curl -X POST \
-H "Content-type: application/json" \
-H "Authorization: Bearer $SLACK_BOT_TOKEN" \
-d "$msg" \
https://slack.com/api/chat.postMessage