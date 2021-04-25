 
Drone Config Service Plugin
===========================

A Drone plugin that can create or update Config Roots for any Config Microservice instance.
This can be used to initialize a config root at build time.

The settings available in this plugin are:

* `service` - The FQ URL of the config service. For example, for the sdk settings config service,
   the value would be `https://origin-prd-config-sdk-settings.jc-gs.com/v1`.
* `root` - The case-sensitive root name to create/update.
* `sandbox` - The config service sandbox to use. Defaults to `prod`.
* `json` - The JSON string to use for the root. Default to `{}`.
* `overwrite` - If present, the specified json string will overwrite any current value. 
   If absent (the default), then a pre-existing root will not be overwritten.

For example:

```yaml
- name: Config Root Update
  image: sgn0/drone-config-service
  depends_on: [ "${DRONE_BRANCH} build" ]
  settings:
    service: https://origin-prd-config-sdk-settings.jc-gs.com/v1
    root: JamCity.CommonSdk
    json: "{}"
```




