FROM debian:testing-slim
USER root

ARG DEBIAN_FRONTEND=noninteractive

## Install some basic stuff we need
RUN apt-get update && apt-get install -y nuget && \
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0 && \
    # cleanup    
    apt-get autoremove -y && apt-get clean

COPY publish.sh /publish.sh
