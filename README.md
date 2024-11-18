Github Actions
==============

This repo contains a collection of Jam City github actions for use in
[Github Action](https://docs.github.com/en/actions) workflows.

* [confluence](confluence/README.md) - Posts markdown and pdf documents to confluence.
* [confluence-mac](confluence-mac/README.md) - Same as above but intended to run on a Mac without docker.
* [config](config/README.md) - Simple action for updating config service roots.
* [package-manager-publish](package-manager-publish/README.md) - Publishes Jam City Package Manager packages to JC artifactory.
* [nuget-publish](nuget-publish/README.md) - Publishes nuget packages to JC artifactory.
* [nuget-publish-mac](nuget-publish-mac/README.md) - Same as above but intended to run on a Mac without docker.
* [sbt-unity](sbt-unity/README.md) - Action for building SDKs using the JC sbt plugin.
* [build-tags](build-tags/README.md) - Action for generating a list of standard docker image tags.
* [package-json-env](package-json-env/README.md) - Converts a `package.json` to github actions environment variables.
* [k6-perf-test](k6-perf-test/README.md) - Action for running a performance test using k6.
* [snapshot-bump](snapshot-bump/README.md) - Action for bumping snapshot versions.
* [openapi-publis](openapi-publish/README.md) - Action for publishing OpenAPI YAML to our API doc site.


## Releases

Feature branches should be created off of the (default) `develop` branch, and
[Conventional Commits](https://www.conventionalcommits.org/) should be used in
order to drive appropriate semver bumps and changelogs. Once changes are merged
to develop, a release can be kicked off using the following process:
1. Merge `develop` into `main`
2. Wait for CI to run, which will create a release-pr against `main`, including a semver bump and a changelog.
3. Merge the release PR.
4. Wait for CI, which will produce the builds and merge the changes back to the `develop` branch.


If you don't use conventional commits, then you can inform release-please of your indended version bump by committing as follows:
```shell
git commit --allow-empty -m "chore: release 2.0.0" -m "Release-As: 2.0.0"
```
Push that to `main` to kick off the release process.

## Note

Docker based actions explicitly reference `v2` tags. Next time we do a major version update, we'll want to update these as well.
We may also want to factor the actions into their own repos so they can be versioned individually at that time.
