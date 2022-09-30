### snapshot-bump
This action bumps a gradle project's package version to the next SNAPSHOT version.

Nothing will happen if the version is already a snapshot version.

Parameters:

* `file` - A properties file where the version is stored. default: `gradle.properties`
* `property` - The property in the file where the version is stored. default: `packageVersion`

```yaml
- name: Snapshot Bump
  uses: mindjolt/actions/snapshot-bump
```

```yaml
- name: Snapshot Bump
  uses: mindjolt/actions/snapshot-bump
  with:
    file: my-properties.properties
    property: version 
```
