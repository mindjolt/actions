#!/bin/bash

repo="$INPUT_REPO"
relType="$INPUT_TYPE"
token="$INPUT_TOKEN"

Error () {
  echo "$*"
  exit 1
}

#gitRoot=git@github.com:mindjolt
gitRoot="https://$token@github.com/mindjolt"
baseDir=/tmp
relDate=$(date '+%Y-%m-%d')


git config --global user.name "msandrofJC"
git config --global user.email "msandrof@jamcity.com"
git config -l


cd $baseDir
rm -rf $baseDir/$repo
git clone $gitRoot/$repo $repo >/dev/null 2>&1 || Error "Failed cloning $repo"
cd $repo

git checkout main >/dev/null 2>&1 || Error "Failed 'git checkout main'"
git checkout develop >/dev/null 2>&1 || Error "Failed 'git checkout develop'"
[ "$(git rev-list main..develop --count)" -le 2 ] && Error "No commits in the develop branch to release!"


git checkout main >/dev/null 2>&1 || Error "Failed 'git checkout main'"
curVer=$(sed -n 's/version := "\(.*\)"/\1/p' build.sbt)
read -r -a parts <<< "${curVer//./ }"
major=${parts[0]}
minor=${parts[1]}
patch=${parts[2]}

if [ "$relType" == "patch" ]; then
  relVer="$major.$minor.$((patch+1))"
  nextVer="$major.$((minor+1)).0"
elif [ "$relType" == "major" ]; then
  relVer="$((major+1)).0.0"
  nextVer="$((major+1)).1.0"
elif [ "$relType" == "minor" ]; then
  relVer="$major.$((minor+1)).0"
  nextVer="$major.$((minor+2)).0"
fi 

echo "Current Version: $curVer"
echo "Release Version: $relVer"
echo "Next Version: $nextVer"

git checkout develop >/dev/null 2>&1 || Error "Failed 'changing to develop branch'"

cat >> .git/config <<EOF
[gitflow "branch"]
        master = main
        develop = develop
[gitflow "prefix"]
        feature = feature/
        release = release/
        hotfix = hotfix/
        support = support/
        versiontag = 
EOF

git flow release start $relVer >/dev/null 2>&1 || Error "Failed `git flow release start`"

grep -q "\*Unreleased\*" CHANGES.md || Error 'Missing "Unreleased" label in CHANGES.md'
sed -i.bak "s/\*Unreleased\*/*$relDate*/" CHANGES.md
sed -i.bak -E -e "/[0-9]+\.[0-9]+\.[0-9]+/{s//$relVer/;:p" -e "n;bp" -e "}" CHANGES.md

grep -q 'version := \".*-SNAPSHOT\"' build.sbt || Error 'Missing identifiable SNAPSHOT version in build.sbt'
sed -i.bak "s/version := \".*-SNAPSHOT\"/version := \"$relVer\"/" build.sbt

git add CHANGES.md build.sbt >/dev/null 2>&1 || Error "Failed `git add CHANGES.md build.sbt`"
git commit -m "updated version" >/dev/null 2>&1 || Error "Failed `git commit`"

GIT_MERGE_AUTOEDIT=no  git flow release finish -m "$relVer" "$relVer" >/dev/null 2>&1 || Error "Failed `git flow release finish`"

delim=$(head -c ${#nextVer} < /dev/zero | tr '\0' '-')

sed -i.bak "/${relVer//./\\.}/i\\
$nextVer\\
$delim\\
\\
*Unreleased*\\
\\
**Features**\\
\\
\\
" CHANGES.md

sed -i.bak "s/version := \".*\"/version := \"$nextVer-SNAPSHOT\"/" build.sbt

git add CHANGES.md build.sbt >/dev/null 2>&1 || Error "Failed `git add CHANGES.md build.sbt`"
git commit -m "updated version" >/dev/null 2>&1 || Error "Failed `git commit`"


echo "Pushing develop branch version $nextVer-SNAPSHOT"
git checkout develop
git push $gitRoot/$repo 

echo "Pushing main branch version $relVer"
git checkout main
git push $gitRoot/$repo 
git push --tags
