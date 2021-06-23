ARG tag
FROM debian:stable-slim
USER root

RUN \
## Install some basic stuff we need
    mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y apt-transport-https curl apt-utils gzip tar wget jq git httpie && \
# Install mono tools
    apt-get install -y gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch  main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-devel && \
# Install .NET core
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-5.0 && \
# Get nuget and update to latest version
    apt-get install -y nuget && \
    nuget update -self && \
# Add pandoc
    apt-get install -y pandoc texlive texlive-latex-extra texlive-fonts-extra && \
# Cleanup
    apt-get autoremove -y && apt-get clean

COPY eisvogel.latex /usr/share/pandoc/data/templates/eisvogel.latex
