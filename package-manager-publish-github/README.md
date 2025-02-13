### Package Manager Publish Github
Publishes Jam City package manager packages to JCPM Github repository.
This has to be used in the JCPM repository where the package is being published.

parameters:
* `sdkRepo` - The source SDK GitHub repository reference to download artifacts from.
* `token` - The repo's access token.
* `packageName` - The name of the package.
* `packageVersion` - The version of the package.
* `branchRef` - The branch reference where the package is being published.
  If not specified, the default is `refs/heads/main`. For testing, use `refs/heads/develop`.
* `artifactId` - The artifact ID to be downloaded from the `sdkRepo`.
  If not specified, the default is `test`.

---
#### Publishing to JCPM Github repository

- The following will publish a release version:
```yaml
- name: Publish
  uses: mindjolt/actions/package-manager-publish-github@v2
  with:
    sdkRepo: 'unity-something-sdk'
    token: ${{ secrets.JCPM_PAT }}
    packageName: 'JamCity.Something'
    packageVersion: '1.0.0'
    artifactId: ${{ inputs.artifactId }}
```

- The following will publish a pre-release version:
```yaml
- name: Publish
  uses: mindjolt/actions/package-manager-publish-github@v2
  with:
    sdkRepo: 'unity-something-sdk'
    token: ${{ secrets.JCPM_PAT }}
    packageName: 'JamCity.Something'
    packageVersion: '1.0.0-SNAPSHOT'
    artifactId: ${{ inputs.artifactId }}
```
Both examples require the `artifactId` input to be specified, which is the artifact ID to be downloaded from the `sdkRepo` repository.
It's retrieved from the `pre-publish` step in the workflow ([package-manager-prepublish-github](../package-manager-prepublish-github/README.md)).

---
#### Publishing to JCPM Github repository for testing

To publish to the release or pre-release repository's develop branch, set the `artifactId` parameter to `test` or omit it. This also
requires a previous step to simulate the package's files creation

- The following will publish to the release or pre-release repository's develop branch:
```yaml
- name: Create dummy package files
  run: |
    mkdir -p /tmp/artifacts-test
    echo "Dummy content" > /tmp/artifacts-test/package.zip
    echo '{"name": "Test.Package", "version": "${{ env.PACKAGE_VERSION }}"}' > /tmp/artifacts-test/package.json
    cd /tmp/artifacts-test
    zip test.zip package.zip package.json
    rm /tmp/artifacts-test/package.zip /tmp/artifacts-test/package.json
  shell: bash

- name: Run upload package files
  uses: mindjolt/actions/package-manager-publish-github@v2
  with:
    sdkRepo: 'test-sdk'
    token: 'TEST_TOKEN'
    packageName: 'Test.Package'
    packageVersion: ${{ env.PACKAGE_VERSION }}
    branchRef: 'refs/heads/develop'
```
This example requires the `PACKAGE_VERSION` environment variable to be set, which is the version of the package to be published, so
use a pre-release version to publish to the pre-release repository or an official version to publish to the release repository.



