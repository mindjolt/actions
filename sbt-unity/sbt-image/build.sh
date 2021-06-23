#!/bin/bash

[ -z "$INPUT_SBT" ] && echo "Missing SBT commands" && exit 1
[ -z "$INPUT_PACKAGEJSON" ] && echo "Missing package.json path" && exit 1

ROOT=/root

CMD="sbt $INPUT_SBT"
eval $CMD || exit 1

if [ -e "$INPUT_PACKAGEJSON" ]; then
  cat "$INPUT_PACKAGEJSON" | jq -r 'to_entries[] | "PACKAGE_\(.key | [ splits("(?=[A-Z])") ] | map(select(. != "")) | join("_") | ascii_upcase)=\(.value)"' >> $GITHUB_ENV
fi 
