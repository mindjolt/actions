#!/bin/bash

[ -z "$INPUT_SERVICE" ] && echo "Required parameter 'service' missing" && exit 1
[ -z "$INPUT_ROOT" ] && echo "Required parameter 'root' missing" && exit 1
[ -z "$INPUT_SANDBOX" ] && INPUT_SANDBOX=prod
[ -z "$INPUT_JSON" ] && INPUT_JSON="{}"

URL="$INPUT_SERVICE/sandboxes/$INPUT_SANDBOX"

# Check if already exists and exit if so.
if [ "$INPUT_OVERWRITE" == "true" ]; then
  json=$(http -F --check-status GET "$URL/contents" | jq ".roots | select(.\"$INPUT_ROOT\" != null)")
  [ $? -ne 0 ] && exit 1
  [ -n "$json" ] && echo "Config root for $INPUT_ROOT already exists, skipping..." && exit 0
fi 

# Update the roots
json=$(http -F --check-status GET "$URL/contents" | jq ".roots=(.roots + { \"$INPUT_ROOT\" : $INPUT_JSON })")
[ $? -ne 0 ] && exit 1
echo $json | http -F --check-status PUT "$URL/contents"

[ $? -ne 0 ] && exit 1
echo "Config root $INPUT_ROOT updated."
exit 0


