FROM debian:testing-slim
USER root

ARG DEBIAN_FRONTEND=noninteractive

## Install some basic stuff we need
RUN apt-get update && \
    apt-get install -y git git-flow && \
# cleanup    
    apt-get autoremove -y && apt-get clean

COPY release.sh /release.sh
