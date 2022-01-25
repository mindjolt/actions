# Generate build tags

This action generates a list of tags that enables continuos integration in a safe predictive way.

## Inputs

### `build-version`

**Optional** The current build/package version. Usually this value comes from the service package manager file like `build.gradle`, `build.sbt` or `package.json`

### `tag-separator`

**Default** `\n` (new line)
The tag array will be joint using the `tag-separator` character

### `base-tags`

**Optional**
New line separated list of tags to be included with the generated tags.

## Outputs

### `tags`

Comma separated list of tags.

Examples:

Given a commit sha of `f593409` and a `build-version` input of `0.1.1`.

* For a push to branch `develop` the output will be:
`develop, develop-f593409, 0.1.1-develop, 0.1.1-develop-f593409`

* For a push to branch `main` the output will be:
`main, main-f593409, 0.1.1-main, 0.1.1-main-f593409, 0.1.1, 0.1.1-f593409`

> Note the extra concrete version tags `0.1.1` and `0.1.1-f593409`

* Pull request 9
`pull-9, pull-9-f593409, 0.1.1-pull-9, 0.1.1-pull-9-f593409`

* Release branch `release/0.1.1` push
`0.1.1-rc, 0.1.1-rc-f593409`

> Note the `rc` postfix

* Tag `v0.1.1` push
`v0.1.1, v0.1.1-f593409, 0.1.1, 0.1.1-f593409`

* Tag `v0.1.3` push
`v0.1.3, v0.1.3-f593409, 0.1.3, 0.1.3-f593409`

> The git tag version will take precedence over the input build-version

* Non-version tag `fix-1234` push
`fix-1234, fix-1234-f593409`

## Example usage

```yaml
    - name: Get gradle version
      id: package_version
      run: echo "::set-output name=version::`./gradlew -q printVersion`"

    - uses: mindjolt/actions/build-tags@2.5.0
      id: get_tags
      with:
        build-version: ${{steps.package_version.outputs.version}}

    # Recommended additional docker metadata (like labels)
    - name: Docker meta
      id: docker_meta
      uses: docker/metadata-action@v3
      with:
        tags: "${{steps.get_tags.outputs.tags}}"
        images: ghcr.io/${{ github.repository }}

    # Login and setup ...
    # Tag your image
    - name: Build and push
      uses: docker/build-push-action@v2
      with:
        context: .
        push: true
        build-args: |
          "SERVICE_MAIN_CLASS=${{ steps.read_mainClass.outputs.value }}"
          "COMMIT_HASH=${{ github.sha }}"
        tags: ${{ steps.docker_meta.outputs.tags }}
        labels: ${{ steps.docker_meta.outputs.labels }}
```

## Example usage with extra tags

Use the `base-tags` to add custom generated tags. For example you can use the `docker/metadata-action@v3` [tags syntax](https://github.com/docker/metadata-action#tags-input)

```yaml
    - name: Get gradle version
      id: package_version
      run: echo "::set-output name=version::`./gradlew -q printVersion`"

    - uses: mindjolt/actions/build-tags@2.5.0
      id: get_tags
      with:
        build-version: ${{steps.package_version.outputs.version}}
        base-tags: |
          type=sha,prefix=sha-
          ${{myCustomTag}}

    # Recommended additional docker metadata (like labels)
    - name: Docker meta
      id: docker_meta
      uses: docker/metadata-action@v3
      with:
        tags: "${{steps.get_tags.outputs.tags}}"
        images: ghcr.io/${{ github.repository }}

    # Login and setup ...
    # Tag your image
    - name: Build and push
      uses: docker/build-push-action@v2
      with:
        context: .
        push: true
        build-args: |
          "SERVICE_MAIN_CLASS=${{ steps.read_mainClass.outputs.value }}"
          "COMMIT_HASH=${{ github.sha }}"
        tags: ${{ steps.docker_meta.outputs.tags }}
        labels: ${{ steps.docker_meta.outputs.labels }}
```
