FROM debian:testing-slim

ARG DEBIAN_FRONTEND=noninteractive

COPY snapshot-bump.sh /snapshot-bump.sh

ENTRYPOINT /snapshot-bump.sh --file $INPUT_FILE --prop $INPUT_PROPERTY
