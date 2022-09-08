### SDK Release

Action to perform automated releases of Unity SDK projects
that use sbt as their builder.
This can perform releases of major, minor, or patch version from
the develop branch. It does *NOT* handle hotfix releases (branching
from main for the patch), it can only release what's in develop.
This action only performs branching, tagging and version updating in
project files which it commits back to github. Builds of new release
branches are handled by other workflows that react to changes to the
main branch.

This action uses the git-flow release process to perform the branching
and tagging. In addition to that it will do the following:

In the release branch:

* Sets the released version based on the `type` of the release by modifying
  the current version to bump the release number appropriate to the `type`
  selected (one of the major, minor, or patch values will be incremented by 1).
* Updates the `CHANGES.md` by replacing `*Unreleased*` with the current date.
* Updates the `build.sbt` by replacing the `version := "x.y.z-SNAPSHOT"` with the release version.

In the develop branch:

* Sets the released version based on the `type` of the release by modifying
  the current version to bump the release number appropriate to the `type`
  selected (one of the major, minor, or patch values will be incremented by 1).
* Updates the `CHANGES.md` by adding a new section at the top of the file for changes in
  the develop branch. 
* Updates the `build.sbt` by replacing the `version` with the next SNAPSHOT version.


Parameters:

* `repo` - The mindjolt repo to release. For example, 'unity-common-sdk' or 'analytics-sdk'.
* `type` - The type of the release, one of: patch. minor or major.
* `token` - Github access token with sufficient persmission to checkout and push.

Example:

```yaml
name: Release

on:
  workflow_dispatch:
    inputs:
      type:
        description: 'Release type'
        required: true
        default: 'minor'
        type: choice
        options:
        - minor
        - patch
        - major

jobs:
  release:
    runs-on: [self-hosted, docker]
    steps:
      - name: Release
        uses: mindjolt/actions/sdk-release@v2
        with:
          repo: ${{ github.event.repository.name }}
          type: "${{ inputs.type }}"
          token: "${{ secrets.MJ_GITHUB_TOKEN }}"
```
