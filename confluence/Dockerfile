FROM debian:testing-slim
USER root

ARG DEBIAN_FRONTEND=noninteractive

## Install some basic stuff we need
RUN apt-get update && \
    apt-get install -y curl jq && \
# Add pandoc
    apt-get install -y pandoc texlive-latex-recommended texlive-fonts-recommended && \
# cleanup    
    apt-get autoremove -y && apt-get clean

COPY confluence.sh /confluence.sh
COPY default.latex /usr/share/pandoc/data/templates/default.latex
