# Generate build tags

This action generates a list of tags that enables continuos integration in a safe predictive way.

## Inputs

### `from-version`

The current version specified in the files

### `to-version`

The version to replace in files

### `files`

The list of files to run the replace in (multiline input with each file on a new line)

Example File Structure:

```yaml
# Block Comment example

# start x-gs-replace-version
version = {version}
# end x-gs-replace-version

# Inline Comment example
version = {version} # x-gs-replace-version
```

```javascript
// Block Comment example

// start x-gs-replace-version
version = {version}
// end x-gs-replace-version

// Inline Comment example
version = {version}// x-gs-replace-version
```

Example Usage:

To replace version 0.1.1 to 0.1.2 in files src/main/java/resources/application.conf and src/main/java/resources/openapi.yml

```yaml
    - uses: mindjolt/actions/version-replace-in-files@main
      with:
        from-version: 0.1.1
        to-version: 0.1.2
        files: |-
          src/main/java/resources/application.conf
          src/main/java/resources/openapi.yml
```


