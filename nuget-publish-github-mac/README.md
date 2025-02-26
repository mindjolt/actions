### Nuget Publish (non-docker)
Publishes nuget packages to github.

Parameters:

* `user` - The artifactory user to use.
* `password` - The password/token for the `user`.
* `packagePath` - The path to the nupkg to publish.

```yaml
- name: Publish nuget
  uses: mindjolt/actions/nuget-publish-github-mac@v2
  with:
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packagePath: target/${{env.PACKAGE_NAME}}.${{env.PACKAGE_VERSION}}.nupkg
```

The Mac needs to have Homebrew installed with the following components:

```shell
brew install nuget
brew uninstall basictex
brew install --cask mactex-no-gui
````