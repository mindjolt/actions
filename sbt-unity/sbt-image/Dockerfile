ARG tag
FROM sgn0/csharp-build-env:${tag}

USER root

RUN \
## Install some basic stuff we need
# Install python
#    apt-get install -y python python3 python3-pip && \
#    pip3 install --upgrade pip && \
#    pip3 install requests && \
# Java
    apt-get install -y openjdk-11-jdk && \
# SBT
    cd /usr/local; curl -L https://github.com/sbt/sbt/releases/download/v1.4.8/sbt-1.4.8.tgz | tar xzf - && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
# Android
    apt-get install -y android-sdk-build-tools && \
# JFrog
    cd /usr/bin; curl -fL https://getcli.jfrog.io | sh && \
# Cleanup
    apt-get autoremove -y && apt-get clean

COPY build.sh /build.sh
COPY cleanup.sh /cleanup.sh
