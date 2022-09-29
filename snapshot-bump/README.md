### snapshot-bump
This action bumps a gradle project's package version to the next SNAPSHOT version.
This is helpful for automating release processes, including preparing for new incoming work to be published as a snapshot version.

Nothing will happen if the version is already a snapshot version.

Parameters:

* `file` - The properties file where the version is stored. default: `gradle.properties`
* `property` - The property in the file where the version is stored. default: `packageVersion`

```yaml
- name: Snapshot Bump
  uses: mindjolt/actions/snapshot-bump@v1
```

```yaml
- name: Snapshot Bump
  uses: mindjolt/actions/snapshot-bump@v1
  with:
    file: some-other-property-file.properties
    property: version 
```