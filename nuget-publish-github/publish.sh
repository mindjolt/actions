#!/bin/bash

# Check if user and password are provided, otherwise use secrets
[[ -n "$INPUT_USER" ]] && user="$INPUT_USER" || user="$SECRETS_GITHUB_USER"
[[ -n "$INPUT_PASSWORD" ]] && password="$INPUT_PASSWORD" || password="$SECRETS_GITHUB_TOKEN"

# Set the API key for GitHub NuGet registry
dotnet nuget add source --username "$user" --password "$password" --store-password-in-clear-text --name github "https://nuget.pkg.github.com/mindjolt/index.json"

# Set Path
path="$INPUT_PACKAGEPATH"
[[ ! -e "$path" ]] && [[ "${path}" == *"+"* ]] && path="${path%+*}.nupkg"

# Check if the package path contains "SNAPSHOT"
if [[ "$path" == *"SNAPSHOT"* ]]; then
  echo "Snapshot version detected, skipping publish."
else
  # Push the package to GitHub NuGet registry with API key
  dotnet nuget push "${path}" --source "github" --api-key "$password"
fi