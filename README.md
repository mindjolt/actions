Github Actions
==============

This repo contains a collection of Jam City github actions for use in
[Github Action](https://docs.github.com/en/actions) workflows.

### [Confluence](confluence/action.yml)
The confluence action provide a mechanism for posting markdown and PDFs 
to a confluence page.

```yaml
- name: Confluence Documentation
  uses: mindjolt/actions/confluence@main
  with:
    user: ${{ secrets.CONFLUENCE_USER }}
    password: ${{ secrets.CONFLUENCE_PASSWORD }}
    page: 12345675
    title: 'My Documentation'
    files: doc/Unity.md,CHANGES.md
    toc: true
```

### [Config](config/action.yml)
The config action allows for simple set up of config service roots in 
a workflow.

```yaml
- name: Config Root Initialize
  uses: mindjolt/actions/config@main
  with:
    service: https://origin-prd-config-sdk-settings.jc-gs.com/v1
    root: JamCity.GemSdk
    json: '{ "key": {} }'
```



