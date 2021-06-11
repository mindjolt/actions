### Package Manager Publish
Publishes Jam City package manager packages to artifactory.
This action runs locally on the build machine and requires the 
following be installed: `bash`, `jq`, `curl`.

Parameters:

* `rootUrl` - The artifactory root URL.
* `user` - The artifactory user to use.
* `password` - The password/token for the `user`.
* `packageJson` - Local path to the package.json.
* `packageZip` - Local path the the zip file of the package to publish.
* `packageName` - The name of the package being published. Usually 'JamCity.Something'.
  If not specified, the name will be extracted from the `packageJson`.
* `packageVersion` - A valid semver2 version string.
  If not specified, the version will be extracted from the `packageJson`.
* `extras` - Comma-separated list of additional files to publish along side the package.
* `branchRef` - The value of `${{github.ref}}`. Optional, see below.
* `releaseRepo` - The artifactory repo to use for released packages. Defaults to `jcpm-release-local`.
* `prereleaseRepo` - The artifactory repo to use for prereleased packages. Defaults to `jcpm-snapsho-local`.
* `legacyPublish` - If `true`, also publish to the legacy release repo. Defaults to false.

By default, this action publishes to the release repository unless the `packageVersion`
includes the pre-release tag, such as `-SNAPSHOT`. In that case, the package
is published to the pre-release repo.

If `branchRef` is present, the publishing process will check that the version
being published matches the branch it came from to prevent mistakes. This will verify that
if `branchRef` is main or master, then `packageVersion` *must not* contain any pre-release tags.
Similarly, if `branchRef` is develop, the `packageVersion` *must* contain a pre-release tag.
Publishing the package will fail if either of the above is violate. To avoid this check, omit
`branchRef`.

The following will publish to release repository:

```yaml
- name: Publish
  uses: mindjolt/actions/package-manager-publish@v2
  with:
    rootUrl: ${{ secrets.ARTIFACTORY_ROOT }}
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{github.ref}}
```

The following will publish to pre-release repository:

```yaml
- name: Publish
  uses: mindjolt/actions/package-manager-publish@v2
  with:
    rootUrl: ${{ secrets.ARTIFACTORY_ROOT }}
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packageZip: 'target/package.zip'
    packageJson: 'target/package.json'
    branchRef: ${{github.ref}}
```
