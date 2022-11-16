#!/bin/bash

function help {
  echo 'usage: ./snapshot-bump.sh [args]'
  echo " "
  echo "Bumps some semver style version property to the next SNAPSHOT version."
  echo " "
  echo "--file, -f, env var: INPUT_FILE         the properties file that the version is in. default: gradle.properties"
  echo "--prop, -p, env var: INPUT_PROPERTY     the version property that will be bumped. default: packageVersion"
  echo ""
  echo "--help, -h                              show this help blurb"
  exit 0
}

ARGS=()

while test $# -gt 0; do
  case $1 in
    -h|--help)
      help
      ;;
    -f|--file)
      shift
      export INPUT_FILE=$1
      shift
      ;;
    -p|--prop)
      shift
      INPUT_PROPERTY=$1
      shift
      ;;
    *)
      echo "unknown option $1"
      shift
      ;;
  esac
done

if [ -z $INPUT_FILE ]; then
  INPUT_FILE=gradle.properties
  echo "using default file: gradle.properties"
fi

if [ -z $INPUT_PROPERTY ]; then
  INPUT_PROPERTY=packageVersion
  echo "using default property: packageVersion"
fi

if ! [[ `grep $INPUT_PROPERTY $INPUT_FILE` ]]; then
  echo "property $INPUT_PROPERTY not found in file $INPUT_FILE. bailing"
  help;
fi

VERSION_PROP=`grep $INPUT_PROPERTY $INPUT_FILE` # ex. packageVersion=1.7.8
VERSION=${VERSION_PROP#*=} # ex. 1.7.8

echo "current version: $VERSION"

if [[ `echo $VERSION | grep SNAPSHOT` ]]; then
  echo "$VERSION is already a snapshot version. no work to be done.";
  exit 0
fi

VERSION="${VERSION#[vV]}"
VERSION_MAJOR="${VERSION%%\.*}"
VERSION_MINOR="${VERSION#*.}"
VERSION_MINOR="${VERSION_MINOR%.*}"
VERSION_PATCH="${VERSION##*.}"

VERSION_MINOR=$((VERSION_MINOR+1))

SNAPSHOT_VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH-SNAPSHOT

echo "new version: $SNAPSHOT_VERSION"

sed -i "s/$VERSION_PROP/$INPUT_PROPERTY=$SNAPSHOT_VERSION/" $INPUT_FILE

echo 'done'
