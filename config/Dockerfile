FROM debian:testing-slim
USER root

## Install some basic stuff we need
RUN apt-get update && apt-get install -y jq httpie && \
# cleanup    
    apt-get autoremove -y && apt-get clean

COPY config-service.sh /config-service.sh
