FROM curlimages/curl:7.68.0

LABEL "com.github.actions.name"="Post Release Status To Slack"
LABEL "com.github.actions.description"="Post Release Success/Failure/Cancel job status to Slack using bot"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="green"

LABEL version="1.0.0"
LABEL repository="http://github.com/mindjolt/actions/slack-message"
LABEL homepage="http://github.com/mindjolt/actions/slack-message"
LABEL maintainer="Mindjolt"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]