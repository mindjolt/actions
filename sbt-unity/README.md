### Sbt Unity
Executes SBT commands in a container that includes mono, dotnet, nuget and other tools for
building JC SDKs.

Parameters:

* `sbt` - The SBT command line to execute.
* `packageJson` - If present, should refer to a local `package.json` file. This file will be parsed
  and the properties of the files will be made available to subsequent steps as environment variables
  with the `PACKAGE_` prefix. Defaults to `target/package.json`.

Example:

```yaml
- name: Build
  uses: mindjolt/actions/sbt-unity@v2
  with:
    sbt: 'packageUnity packageDotnet'
    packageJson: 'target/package.json'
```

