#!/bin/bash

# Remove build artifacts to prevent some permissioning issues
[[ -e "$GITHUB_WORKSPACE" ]] && rm -rf $GITHUB_WORKSPACE/project/project $GITHUB_WORKSPACE/project/target $GITHUB_WORKSPACE/target

# Remove snapshots that might have been cached
find ~/.nuget/packages -name "*-snapshot" -exec rm -rf {} \;
find ~/.ivy2/cache -name "*-SNAPSHOT" -exec rm -rf {} \;
rm -rf ~/.ivy2/local

exit 0

