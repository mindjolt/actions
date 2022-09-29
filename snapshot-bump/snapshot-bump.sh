#!/bin/bash

function help {
  echo 'usage: ./snapshot-bump.sh [args]'
  echo " "
  echo "Bumps some semver style version property to the next SNAPSHOT version."
  echo " "
  echo "--file, -f            the properties file that the version is in. default: gradle.properties"
  echo "--prop, -p            the version property that will be bumped. default: packageVersion"
  echo "--help, -g            show this help blurb"
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
      export FILE=$1
      shift
      ;;
    -p|--prop)
      shift
      PROP=$1
      shift
      ;;
    *)
      echo "unknown option $1"
      shift
      ;;
  esac
done

if [ -z $FILE ]; then
  FILE=gradle.properties
  echo "using default file: gradle.properties"
fi

if [ -z $PROP ]; then
  PROP=packageVersion
  echo "using default property: packageVersion"
fi

if ! [[ `grep $PROP $FILE` ]]; then
  echo "property $PROP not found in file $FILE. bailing"
  help;
fi

VERSION_PROP=`grep packageVersion gradle.properties` # ex. packageVersion=1.7.8
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

VERSION_PATCH=$((VERSION_PATCH+1))

SNAPSHOT_VERSION=$VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH-SNAPSHOT

echo "new version: $SNAPSHOT_VERSION"

sed -i "s/$VERSION_PROP/$PROP=$SNAPSHOT_VERSION/" $FILE

echo 'done'
