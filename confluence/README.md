### Confluence (docker)
The confluence action provide a mechanism for posting markdown and PDFs
to a confluence page. This action requires docker.

Parameters:

* `user` - The confluence user to use when posting the documents.
* `password` - The password/token for the `user`.
* `page` - The confluence page id to post documents to.
* `title` - Title for the page.
* `files` - Comma-separated list of local files to publish. These can be markdown or pdfs (identified by .md or .pdf extension).
* `space` - The Confluence space in which the page exists. Defaults to `GS`.
* `toc` - If true, a table of contents is included. Defaults to false.
* `toPdf` - If true, the files are combined into a PDF and published rather than publishing as confluence native. Defaults to false.

```yaml
- name: Confluence Documentation
  uses: mindjolt/actions/confluence@v2
  with:
    user: ${{ secrets.CONFLUENCE_USER }}
    password: ${{ secrets.CONFLUENCE_PASSWORD }}
    page: 12345675
    title: 'My Documentation'
    files: doc/Unity.md,CHANGES.md
    toc: true
```


