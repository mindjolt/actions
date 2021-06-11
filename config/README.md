### Config
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
  uses: mindjolt/actions/config@v2
  with:
    service: https://origin-prd-config-sdk-settings.jc-gs.com/v1
    root: JamCity.GemSdk
    json: '{ "key": {} }'
```

