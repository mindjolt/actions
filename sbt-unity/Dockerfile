FROM debian:stable-slim
USER root

## Install some basic stuff we need
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y apt-transport-https curl apt-utils gzip tar wget jq git httpie && \
# Install python
    apt-get install -y python python3 python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install requests && \
# Install mono tools
    apt-get install -y gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch  main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-devel && \
# Install .NET core
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && \
    apt-get install -y dotnet-sdk-2.2 && \
# Get nuget and update to latest version
    apt-get install -y nuget && \
    nuget update -self && \
# Java
    apt-get install -y openjdk-11-jdk && \
# SBT
    cd /usr/local; curl -L https://github.com/sbt/sbt/releases/download/v1.4.8/sbt-1.4.8.tgz | tar xzf - && \
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
# Android
    apt-get install -y android-sdk-build-tools && \
# JFrog
    cd /usr/bin; curl -fL https://getcli.jfrog.io | sh && \
# Add pandoc
    apt-get install -y pandoc texlive texlive-latex-extra texlive-fonts-extra && \
# Cleanup
    apt-get autoremove -y && apt-get clean


COPY build.sh /build.sh
COPY cleanup.sh /cleanup.sh
COPY default.latex /usr/share/pandoc/data/templates/default.latex
COPY eisvogel.latex /usr/share/pandoc/data/templates/eisvogel.latex
