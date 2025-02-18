### Package Manager Pre-Publish
Prepares Jam City package manager packages to be published on GitHub artifactory repository.
This action runs locally on the build machine and triggers the `Upload Package`
workflow on the GitHub artifactory repository.

---
Parameters:
* `token` - The repo's access token.
* `packageZip` - Local path the zip file of the package to publish.
* `packageJson` - Local path to the package.json.
* `packageName` - The name of the package being published. Usually 'JamCity.Something'.
  If not specified, the name will be extracted from the `packageJson`.
* `packageVersion` - A valid semver2 version string.
  If not specified, the version will be extracted from the `packageJson`.
* `branchRef` - The value of `${{github.ref}}`. Optional, see below.
* `extras` - Comma-separated list of additional files to publish alongside the package.
* `releaseRepo` - The JCPM repository to use for released packages. Defaults to `jcpm-release-local`.
* `prereleaseRepo` - The JCPM repository to use for pre-released packages. Defaults to `jcpm-snapsho-local`.
* `isTest` - If `true`, the package will be published to the release or pre-release repository's develop branch. Defaults to `false`.

If `branchRef` is present, the pre-publishing process will check that the version
being published matches the branch it came from to prevent mistakes. This will verify that
if `branchRef` is `main` or `master`, then `packageVersion` *must not* contain any pre-release tags.
Similarly, if `branchRef` is `develop`, the `packageVersion` *must* contain a pre-release tag.
Publishing the package will fail if either of the above is violated. To avoid this check, omit
`branchRef`.

---
#### Using JCPM core repositories 

- The following will prepare publishing to `jcpm-release-local` or `jcpm-snapshot-local` repository:
```yaml
- name: Pre-Publish
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
```
The package name and version will be extracted from the `package.json` file. If the version is a pre-release version
(e.g. 1.0.0-SNAPSHOT), the package will be published to the pre-release (`jcpm-snapshot-local`) repository; otherwise,
it will be published to the release (`jcpm-release-local`) repository.

- The following will prepare publishing only to `jcpm-release-local` repository:
```yaml
- name: Pre-Publish
  if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master'
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
```
The package version must be a release version (e.g. 1.0.0) for the package to be published to the release repository.

- The following will prepare publishing only to `jcpm-snapshot-local` repository:
```yaml
- name: Pre-Publish
  if: github.ref == 'refs/heads/develop'
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
```
The package version must be a pre-release version (e.g. 1.0.0-SNAPSHOT) for the package to be published to the pre-release repository.

---
#### Using JCPM custom team repositories

To use custom repositories, specify the `releaseRepo` and `prereleaseRepo` parameters:

- The following will prepare publishing to custom release and pre-release repositories:
```yaml
- name: Pre-Publish
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
    releaseRepo: 'jcpm-custom-release-repo'
    prereleaseRepo: 'jcpm-custom-snapshot-repo'
```

- The following will prepare publishing only to custom release repository:
```yaml
- name: Pre-Publish
  if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master'
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
    releaseRepo: 'jcpm-custom-release-repo'
```
The package version must be a release version (e.g. 1.0.0) for the package to be published to the release repository.

- The following will prepare publishing only to custom pre-release repository:
```yaml
- name: Pre-Publish
  if: github.ref == 'refs/heads/develop'
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{ github.ref }}
    prereleaseRepo: 'jcpm-custom-snapshot-repo'
```
The package version must be a pre-release version (e.g. 1.0.0-SNAPSHOT) for the package to be published to the pre-release repository.

---
#### Using JCPM repositories for testing

To publish to the release or pre-release repository's develop branch, set the `isTest` parameter to `true`. As recommended,
this should be used for testing purposes only, so the SDK repository's branch must not be `main`, `master`, or `develop`.

- The following will prepare publishing to the release or pre-release repository's develop branch:
```yaml
- name: Pre-Publish
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    isTest: true
```
The package will be published to the release or pre-release repository's develop branch based on the package version.

The previous sample does not validate the package version against the branch it came from. To enforce this validation, specify the `branchRef` parameter
according to the package version. For example, to publish to the release repository's develop branch, set `branchRef` to `refs/heads/main` or `refs/heads/master`;
to publish to the pre-release repository's develop branch, set `branchRef` to `refs/heads/develop`.

- The following will prepare publishing to the release repository and validate the package version:
```yaml
- name: Pre-Publish
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: '/refs/heads/main'
    isTest: true
```
Make sure the package version is a release version (e.g. 1.0.0).

- The following will prepare publishing to the pre-release repository and validate the package version:
```yaml
- name: Pre-Publish
  uses: mindjolt/actions/package-manager-prepublish-github@v2
  with:
    token: ${{ secrets.JCPM_PAT }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: '/refs/heads/develop'
    isTest: true
```
Make sure the package version is a pre-release version (e.g. 1.0.0-SNAPSHOT).

