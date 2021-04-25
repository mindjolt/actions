#!/bin/bash

[[ -n "$INPUT_USER" ]] && user="$INPUT_USER" || user="$SECRETS_ARTIFACTORY_USER"
[[ -n "$INPUT_PASSWORD" ]] && password="$INPUT_PASSWORD" || password="$SECRETS_ARTIFACTORY_PASSWORD"
[[ -n "$INPUT_ROOTURL" ]] && root="$INPUT_ROOTURL" || root="$SECRETS_ARTIFACTORY_ROOT"
nuget setapikey "${user}:${password}" -Source "${root}/api/nuget/nuget-local"
path="$INPUT_PACKAGEPATH"
[[ ! -e "$path" ]] && [[ "${path}" == *"+"* ]] && path="${path%+*}.nupkg"
nuget push "${path}" -src "${root}/api/nuget/nuget-local"
