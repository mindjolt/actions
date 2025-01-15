#!/bin/bash

[[ -n "$INPUT_USER" ]] && user="$INPUT_USER" || user="$SECRETS_GITHUB_USER"
[[ -n "$INPUT_PASSWORD" ]] && password="$INPUT_PASSWORD" || password="$SECRETS_GITHUB_TOKEN"

# Set the API key for GitHub NuGet registry
dotnet nuget add source --username "$user" --password "$password" --store-password-in-clear-text --name github "https://nuget.pkg.github.com/mindjolt/index.json"

# Set Path
path="$INPUT_PACKAGEPATH"
[[ ! -e "$path" ]] && [[ "${path}" == *"+"* ]] && path="${path%+*}.nupkg"

# Push the package to GitHub NuGet registry
dotnet nuget push "${path}" --source "github"