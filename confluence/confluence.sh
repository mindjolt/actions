#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --user)
    PLUGIN_USER="$2"
    shift; shift
    ;;
    --password)
    PLUGIN_PASSWORD="$2"
    shift; shift
    ;;
    --page)
    PLUGIN_PAGE="$2"
    shift; shift
    ;;
    --files)
    PLUGIN_FILES="$2"
    shift; shift
    ;;
    --title)
    PLUGIN_TITLE="$2"
    shift; shift
    ;;
    --url)
    PLUGIN_URI="$2"
    shift; shift
    ;;
    --space)
    PLUGIN_SPACE="$2"
    shift; shift
    ;;
    --toc)
    [[ "$2" == "true" ]] && PLUGIN_TOC=true
    shift; shift
    ;;
    --toPdf)
    [[ "$2" == "true" ]] && PLUGIN_TOPDF=true
    shift; shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

[[ $(uname) == 'Darwin' ]] && {
  latexPath="$HOME/.local/share/pandoc/templates"
} || {
  latexPath="/usr/share/pandoc/data/templates"
}

[[ ! -e "$latexPath/default.latex" ]] && {
  cp "$GITHUB_ACTION_PATH/eisvogel.latex" "$latexPath/default.latex"
}
[[ ! -e "$latexPath/eisvogel.latex" ]] && {
  cp "$GITHUB_ACTION_PATH/eisvogel.latex" "$latexPath/eisvogel.latex"
}

AUTH="$PLUGIN_USER:$PLUGIN_PASSWORD"

[ -z "$PLUGIN_USER" ] && echo "Missing user parameter" && exit 1
[ -z "$PLUGIN_PASSWORD" ] && echo "Missing password parameter" && exit 1

if [ -z "$PLUGIN_URI" ]; then
  PLUGIN_URI="https://socialgamingnetwork.jira.com/wiki/rest/api/content"
fi

[ -z "$PLUGIN_SPACE" ] && PLUGIN_SPACE="GS"

# backward compatibility
if [ ! -z "$PLUGIN_FILE" ]; then
  PLUGIN_FILES="$PLUGIN_FILE"
fi

OIFS=$IFS
IFS=","
files=($PLUGIN_FILES)
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
    "$PLUGIN_URI/$PLUGIN_PAGE/child/attachment"
    "$PLUGIN_URI/$PLUGIN_PAGE/child/attachment" | jq '. | select(.statusCode != 200) | .message | halt_error(1)'
  [[ $? -ne 0 ]] && exit 1
  echo "<ac:structured-macro ac:name=\"viewpdf\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"6475fe31-7130-4438-bb8f-9cba0389b07c\"><ac:parameter ac:name=\"name\"><ri:attachment ri:filename=\"$(basename $file)\" ri:version-at-save=\"1\" /></ac:parameter></ac:structured-macro>" >>"$body"
}

for file in "${files[@]}"; do
  ext="${file##*.}"
  name=$(basename $file)
  if [ -n "$PLUGIN_TOPDF" ] && [ "$ext" != "pdf" ]; then

    ptoc=""
    [ -n "$PLUGIN_TOC" ] && ptoc="--toc"
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

version=$(curl --silent --user $AUTH --request GET --header 'Accept: application/json' --url "$PLUGIN_URI/$PLUGIN_PAGE?expand=version" | jq ".version.number")
version=$(($version + 1))

body=$(cat "$body" | sed -e 's/"/\\"/g')

if [ -z "$PLUGIN_TOC" ] || [ -n "$PLUGIN_TOPDF" ]; then
  toc=""
else
  toc='<ac:structured-macro ac:name=\"toc\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"b3cd01d8-c9b6-40c6-8331-66b9b952e095\"/>'
fi

cat >/tmp/body.json <<EOF
{
  "id": "$PLUGIN_PAGE",
  "type":"page",
  "title":"$PLUGIN_TITLE",
  "space":{"key":"$PLUGIN_SPACE"},
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
  -d @/tmp/body.json --url "$PLUGIN_URI/$PLUGIN_PAGE" |  jq '. | select(.statusCode != 200) | .message | halt_error(1)'
if [ $? -ne 0 ]; then
  exit $?
fi
