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
    --rootUrl)
    artifactoryRoot="$2"
    shift; shift
    ;;
    --name)
    packageName="$2"
    shift; shift
    ;;
    --version)
    packageVersion="$2"
    shift; shift
    ;;
    --zip)
    packageZip="$2"
    shift; shift
    ;;
    --json)
    packageJson="$2"
    shift; shift
    ;;
    --extras)
    OIFS=$IFS
    IFS=","
    extras=($2)
    IFS=$OIFS
    shift; shift
    ;;
    --branch)
    branchRef="$2"
    shift; shift
    ;;
    --releaseRepo)
    releaseRepo="$2"
    shift; shift
    ;;
    --prereleaseRepo)
    prereleaseRepo="$2"
    shift; shift
    ;;
    --legacyPublish)
    legacyPublish="$2"
    shift; shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

[[ -z "$artifactoryUser" ]] && artifactoryUser="$SECRETS_ARTIFACTORY_USER"
[[ -z "$artifactoryPassword" ]] && artifactoryPassword="$SECRETS_ARTIFACTORY_PASSWORD"
[[ -z "$artifactoryRoot" ]] && artifactoryRoot="$SECRETS_ARTIFACTORY_ROOT"

cat "$packageJson" | jq -r 'to_entries[] | "export PACKAGE_\(.key | [ splits("(?=[A-Z])") ] | map(select(. != "")) | join("_") | ascii_upcase)='\''\(.value)'\''"'  > /tmp/env
. /tmp/env

[[ -z "$packageName" ]] && packageName="$PACKAGE_NAME"
[[ -z "$packageVersion" ]] && packageVersion="$PACKAGE_VERSION"

[[ "$packageVersion" == *"-"* ]] && isPrerelease=true || isPrerelease=false

if [[ -n "$branchRef" ]]; then
  { [[ "$branchRef" == *"/main" ]] || [[ "$branchRef" == "main" ]] || [[ "$branchRef" == *"/master" ]] || [[ "$branchRef" == "master" ]]; }  &&
    [[ "$isPrerelease" == "true" ]] && echo "Can't publish pre-release version $packageVersion to release repo" && exit 1
  { [[ "$branchRef" == *"/develop" ]] || [[ "$branchRef" == "develop" ]]; } && 
    [[ "$isPrerelease" == "false" ]] && echo "Can't publish release version $packageVersion to pre-release repo" && exit 1
fi

if [ "$isPrerelease" == "true" ]; then
  echo Publishing $packageName $packageVersion to pre-release repository 
  uri="${artifactoryRoot}/${prereleaseRepo}/${packageName/.//}/$packageVersion"
else
  echo Publishing $packageName $packageVersion to release repository 
  uri="${artifactoryRoot}/${releaseRepo}/${packageName/.//}/$packageVersion"
fi


curl -f -s -X PUT -u "$artifactoryUser:$artifactoryPassword" --data-binary "@$packageZip" "$uri/${packageName}.zip" > /tmp/curl.out 2>&1 || { cat /tmp/curl.out && exit 1; }
curl -f -s -X PUT -u "$artifactoryUser:$artifactoryPassword" --data-binary "@$packageJson" "$uri/package.json" > /tmp/curl.out 2>&1 || { cat /tmp/curl.out && exit 1; }
[ ${#extras[@]} -gt 0 ] && {
  for file in "${extras[@]}"; do
    curl -f -s -X PUT -u "$artifactoryUser:$artifactoryPassword" --data-binary "@$file" "$uri/$(basename $file)" > /tmp/curl.out 2>&1 || { cat /tmp/curl.out && exit 1; }
  done
}

# Legacy
if [[ "$legacyPublish" == "true" ]] && [[ "$isPrerelease" == "false" ]]; then
  uri="${artifactoryRoot}/libs-release-local/${packageName/.//}/$packageVersion"
  curl -f -s -X PUT -u "$artifactoryUser:$artifactoryPassword" --data-binary "@$packageZip" "$uri/${packageName}.zip" > /tmp/curl.out 2>&1 || { cat /tmp/curl.out && exit 1; }
fi  

exit 0