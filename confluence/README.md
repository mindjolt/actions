
Drone Confluence Plugin
=======================

A drone plugin that can publish simple html and markdown documents to a confluence
page. The settings available in this plugin are:

* `user` - The confluence user to authenticate as. Required
* `password` - The confluence password/token to use. Tokens are created as described [here](https://confluence.atlassian.com/cloud/api-tokens-938839638.html). Required.
* `page` - The page number to update. You must create the page in confluence prior to using this.
   The page number is part of the URL of the page: `https://socialgamingnetwork.jira.com/wiki/spaces/GS/pages/6064046/Jam+City+COPPA+SDK`. In this URL, the page number is `6064046`. Required.
* `title` - The page title. Required.
* `files` - Path to the file(s) to publish. The files can be confluence-appropriate html, markdown or pdf.
   If more than one file is specified, they will be concatenated together on the page.
   Note that not all html/markdown works with confluence, so keep it simple! Required.
* `toc` - If present, a table of contents will be added automatically. Optional.
* `topdf` - If present, source markdown or html will be converted to PDF and pushed to confluence. Optional
   

For example:

```yaml
- name: Confluence Documentation
  image: sgn0/confluence
  settings:
    user:
      from_secret: confluence_user
    password:
      from_secret: confluence_password
    page: 6064046
    title: My Page Title
    toc: true
    files: doc/Unity.md
  when:
    branch:
      - master
```


```yaml
- name: Confluence Documentation
  image: sgn0/confluence
  settings:
    user:
      from_secret: confluence_user
    password:
      from_secret: confluence_password
    page: 6064046
    title: My Page Title
    toc: true
    files:
      - doc/Unity.md
      - CHANGES.md
  when:
    branch:
      - master
```




