### Package JSON Environment
Extracts fields in a package.json file to github actions environment variables.
This file will be parsed and the properties of the files will be made available to
subsequent steps as environment variables with the `PACKAGE_` prefix. 

Parameters:

* `packageJson` - Local path to the `package.json`.

```yaml
- name: 'Package.json Environment'
  uses: mindjolt/actions/package-json-env@v2
  with:
    packageJson: 'target/package.json'
```

