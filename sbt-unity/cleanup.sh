#!/bin/bash

[[ -e "$GITHUB_WORKSPACE" ]] && rm -rf $GITHUB_WORKSPACE/project/project $GITHUB_WORKSPACE/project/target $GITHUB_WORKSPACE/target

exit 0

