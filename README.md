Github Actions
==============

This repo contains a collection of Jam City github actions for use in
[Github Action](https://docs.github.com/en/actions) workflows.

### [Confluence](confluence/action.yml)
The confluence action provide a mechanism for posting markdown and PDFs 
to a confluence page.

Parameters:

* `user` - The confluence user to use when posting the documents.
* `password` - The password/token for the `user`.
* `page` - The confluence page id to post documents to.
* `title` - Title for the page.
* `files` - Comma-separated list of local files to publish. These can be markdown or pdfs (identified by .md or .pdf extension).
* `space` - The Confluence space in which the page exists. Defaults to `GS`.
* `toc` - If true, a table of contents is included. Defaults to false.
* `toPdf` - If true, the files are combined into a PDF and published rather than publishing as confluence native. Defaults to false.

```yaml
- name: Confluence Documentation
  uses: mindjolt/actions/confluence@v1
  with:
    user: ${{ secrets.CONFLUENCE_USER }}
    password: ${{ secrets.CONFLUENCE_PASSWORD }}
    page: 12345675
    title: 'My Documentation'
    files: doc/Unity.md,CHANGES.md
    toc: true
```

This plugin requires pandoc and latex be installed on the host machine. On MacOs, you can do the following: 

```shell
brew install pandoc
brew cask uninstall basictex 
brew install --cask mactex
```

### [Confluence (docker)](confluence-docker/action.yml)
This is the same as the [Confluence](#confluence) action, except it uses a prepared
docker image that contains pandoc and latex. Only works on linux.

### [Config](config/action.yml)
The config action allows for simple set up of config service roots in 
a workflow.

Parameters:

* `service` - The config service URL.
* `root` - The config root to attempt to update.
* `sandbox` - The config sandbox, defaults to `prod`.
* `json` - The JSON for the root, defaults to `{}`.
* `overwrite` - If true, this will replace the current root with `json`. If false, will only update the config root if it doesn't already exist. Defaults to false.

```yaml
- name: Config Root Initialize
  uses: mindjolt/actions/config@v1
  with:
    service: https://origin-prd-config-sdk-settings.jc-gs.com/v1
    root: JamCity.GemSdk
    json: '{ "key": {} }'
```

### [Package Manager Publish](package-manager-publish/action.yml)
Publishes Jam City package manager packages to artifactory.

Parameters:

* `rootUrl` - The artifactory root URL.
* `user` - The artifactory user to use.
* `password` - The password/token for the `user`.
* `packageName` - The name of the package being published. Usually 'JamCity.Something'.
* `packageVersion` - A valid semver2 version string.
* `packageZip` - Local path the the zip file of the package to publish.
* `packageJson` - Local path to the package.json.
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
  uses: mindjolt/actions/package-manager-publish@v1
  with:
    rootUrl: ${{ secrets.ARTIFACTORY_ROOT }}
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packageName: 'JamCity.MyPackage'
    packageVersion: '1.2.0'
    packageZip: 'target/artifactory-package.zip'
    packageJson: 'src/main/package.json'
    branchRef: ${{github.ref}}
```

The following will publish to pre-release repository:

```yaml
- name: Publish
  uses: mindjolt/actions/package-manager-publish@v1
  with:
    rootUrl: ${{ secrets.ARTIFACTORY_ROOT }}
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packageName: 'JamCity.MyPackage'
    packageVersion: '2.1.0-SNAPSHOT'
    packageZip: 'target/artifactory-package.zip'
    packageJson: 'src/main/package.json'
    branchRef: ${{github.ref}}
```

### [Nuget Publish](nuget-publish/action.yml)
Publishes nuget packages to artifactory.

Parameters:

* `rootUrl` - The artifactory root URL.
* `user` - The artifactory user to use.
* `password` - The password/token for the `user`.
* `packagePath` - The path to the nupkg to publish. 

```yaml
- name: Publish nuget
  uses: mindjolt/actions/nuget-publish@v1
  with:
    rootUrl: ${{ secrets.ARTIFACTORY_ROOT }}
    user: ${{ secrets.ARTIFACTORY_USER }}
    password: ${{ secrets.ARTIFACTORY_PASSWORD }}
    packagePath: target/${{env.PACKAGE_NAME}}.${{env.PACKAGE_VERSION}}.nupkg
```
