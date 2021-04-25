#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --user)
    artifactoryUser="$2"
    shift; shift
    ;;
    --password)
    artifactoryPassword="$2"
    shift; shift
    ;;
    --page)
    confluencePage="$2"
    shift; shift
    ;;
    --files)
    files="$2"
    shift; shift
    ;;
    --title)
    title="$2"
    shift; shift
    ;;
    --url)
    confluenceUrl="$2"
    shift; shift
    ;;
    --space)
    confluenceSpace="$2"
    shift; shift
    ;;
    --toc)
    [[ "$2" == "true" ]] && toc=true
    shift; shift
    ;;
    --toPdf)
    [[ "$2" == "true" ]] && toPdf=true
    shift; shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

[[ $(uname) == 'Darwin' ]] && {
  missing=""
  brew list curl jq pandoc >/dev/null || printf -v missing "%s\n  brew install curl jq pandoc" "$missing"  
  brew list --cask mactex >/dev/null || printf -v missing "%s\n  brew uninstall basictex\n  brew install --cask mactex" "$missing"
  [[ -n "$missing" ]] && {
    printf "Missing required homebrew packages. Run the following on the machine to install them:%s" "$missing"
    exit 1
  }
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

AUTH="$artifactoryUser:$artifactoryPassword"

[ -z "$artifactoryUser" ] && echo "Missing user parameter" && exit 1
[ -z "$artifactoryPassword" ] && echo "Missing password parameter" && exit 1

if [ -z "$confluenceUrl" ]; then
  confluenceUrl="https://socialgamingnetwork.jira.com/wiki/rest/api/content"
fi

[ -z "$confluenceSpace" ] && confluenceSpace="GS"

OIFS=$IFS
IFS=","
files=($files)
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
    "$confluenceUrl/$confluencePage/child/attachment"
    "$confluenceUrl/$confluencePage/child/attachment" | jq '. | select(.statusCode != 200) | error(.message)'
  [[ $? -ne 0 ]] && exit 1
  echo "<ac:structured-macro ac:name=\"viewpdf\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"6475fe31-7130-4438-bb8f-9cba0389b07c\"><ac:parameter ac:name=\"name\"><ri:attachment ri:filename=\"$(basename $file)\" ri:version-at-save=\"1\" /></ac:parameter></ac:structured-macro>" >>"$body"
}

for file in "${files[@]}"; do
  ext="${file##*.}"
  name=$(basename $file)
  if [ -n "$toPdf" ] && [ "$ext" != "pdf" ]; then

    ptoc=""
    [ -n "$toc" ] && ptoc="--toc"
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

version=$(curl --silent --user $AUTH --request GET --header 'Accept: application/json' --url "$confluenceUrl/$confluencePage?expand=version" | jq ".version.number")
version=$(($version + 1))

body=$(cat "$body" | sed -e 's/"/\\"/g')

if [ -z "$toc" ] || [ -n "$toPdf" ]; then
  toc=""
else
  toc='<ac:structured-macro ac:name=\"toc\" ac:schema-version=\"1\" data-layout=\"default\" ac:macro-id=\"b3cd01d8-c9b6-40c6-8331-66b9b952e095\"/>'
fi

cat >/tmp/body.json <<EOF
{
  "id": "$confluencePage",
  "type":"page",
  "title":"$title",
  "space":{"key":"$confluenceSpace"},
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
  -d @/tmp/body.json --url "$confluenceUrl/$confluencePage" |  jq '. | select(.statusCode != 200) | error(.message)'
if [ $? -ne 0 ]; then
  exit $?
fi
