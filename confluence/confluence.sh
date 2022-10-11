#!/bin/bash

AUTH="$INPUT_USER:$INPUT_PASSWORD"

[ -z "$INPUT_USER" ] && echo "Missing user parameter" && exit 1
[ -z "$INPUT_PASSWORD" ] && echo "Missing password parameter" && exit 1

if [ -z "$INPUT_URI" ]; then
  INPUT_URI="https://socialgamingnetwork.jira.com/wiki/rest/api/content"
fi

[ -z "$INPUT_SPACE" ] && INPUT_SPACE="GS"

# backward compatibility
if [ ! -z "$INPUT_FILE" ]; then
  INPUT_FILES="$INPUT_FILE"
fi

OIFS=$IFS
IFS=","
files=($INPUT_FILES)
IFS=$OIFS

body="/tmp/body.html"
rm -f "$body" >/tmp/null 2>&1

function AddPdf() {
  file=$1
  curl --silent \
    -u "$AUTH" \
    -X PUT \
    -H "X-Atlassian-Token: nocheck" \
    -F "file=@$file" \
    "$INPUT_URI/$INPUT_PAGE/child/attachment"
    "$INPUT_URI/$INPUT_PAGE/child/attachment" | jq '. | select(.statusCode != 200) | error(.message)'
  [[ $? -ne 0 ]] && exit 1
  echo "<ac:structured-macro ac:name=\"viewpdf\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"6475fe31-7130-4438-bb8f-9cba0389b07c\"><ac:parameter ac:name=\"name\"><ri:attachment ri:filename=\"$(basename $file)\" ri:version-at-save=\"1\" /></ac:parameter></ac:structured-macro>" >>"$body"
}

for file in "${files[@]}"; do
  ext="${file##*.}"
  name=$(basename $file)
  if [ "$INPUT_TOPDF" == "true" ] && [ "$ext" != "pdf" ]; then

    ptoc=""
    [ "$INPUT_TOC" == "true" ] && ptoc="--toc"
    pushd "$(dirname $file)" >/dev/null
    pandoc "$name" $ptoc -V colorlinks -V geometry:margin=0.5in -f markdown_mmd-implicit_figures -o "/tmp/${name}.pdf"
    popd >/dev/null
    AddPdf ""/tmp/${name}.pdf""

  elif [ "$ext" = "md" ]; then

    # The sed fixes code blocks in confluence
    pandoc "$file" -t json | sed 's/\\n/\\\\n/g' | pandoc -f json -t html -o /tmp/bodypart.html
    cat /tmp/bodypart.html >>"$body"

  elif [ "$ext" = "pdf" ]; then

    AddPdf "$file"

  else

    cat "$file" >>"$body"

  fi
done


version=$(curl --silent --user $AUTH --request GET --header 'Accept: application/json' --url "$INPUT_URI/$INPUT_PAGE?expand=version" | jq ".version.number")
version=$(($version + 1))

body=$(cat "$body" | tr '\n' ' ' | sed 's/<a[^>]*>//g' | sed 's/<\/a>//g' | sed -e 's/"/\\"/g')

if [ "$INPUT_TOC" != "true" ] || [ "$INPUT_TOPDF" == "true" ]; then
  toc=""
else
  toc='<ac:structured-macro ac:name=\"toc\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"b3cd01d8-c9b6-40c6-8331-66b9b952e095\"/>'
fi

cat >/tmp/body.json <<EOF
{
  "id": "$INPUT_PAGE",
  "type":"page",
  "title":"$INPUT_TITLE",
  "space":{"key":"$INPUT_SPACE"},
  "body": {
    "storage": {
      "value":"$toc$body",
      "representation": "storage"
    }
  },
  "version":{"number":$version}
}
EOF

curl \
  --silent \
  -u $AUTH \
  -X PUT \
  -H 'Content-Type: application/json' \
  -d @/tmp/body.json --url "$INPUT_URI/$INPUT_PAGE" |  jq '. | select(.statusCode != 200) | error(.message)'
if [ $? -ne 0 ]; then
  exit $?
fi
