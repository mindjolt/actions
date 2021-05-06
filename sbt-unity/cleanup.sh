#!/bin/bash

# Remove build artifacts to prevent some permissioning issues
[[ -e "$GITHUB_WORKSPACE" ]] && find "$GITHUB_WORKSPACE" -uid $(id -u) -exec rm -r {} \; >/dev/null 2>&1

# Remove snapshots that might have been cached
find ~/.nuget/packages -name "*-snapshot" -exec rm -rf {} \; >/dev/null 2>&1
find ~/.ivy2/cache -name "*-SNAPSHOT" -exec rm -rf {} \; >/dev/null 2>&1
rm -rf ~/.ivy2/local

exit 0

