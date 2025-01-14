#!/bin/bash

[[ -n "$INPUT_USER" ]] && user="$INPUT_USER" || user="$SECRETS_ARTIFACTORY_USER"
[[ -n "$INPUT_PASSWORD" ]] && password="$INPUT_PASSWORD" || password="$SECRETS_ARTIFACTORY_PASSWORD"
[[ -n "$INPUT_ROOTURL" ]] && root="$INPUT_ROOTURL" || root="$SECRETS_ARTIFACTORY_ROOT"

# Set the API key for GitHub NuGet registry
dotnet nuget add source --username "$user" --password "$password" --store-password-in-clear-text --name github "https://nuget.pkg.github.com/${user}/index.json"

path="$INPUT_PACKAGEPATH"
[[ ! -e "$path" ]] && [[ "${path}" == *"+"* ]] && path="${path%+*}.nupkg"

# Push the package to GitHub NuGet registry
dotnet nuget push "${path}" --source "github"