### JCPM index builder

This action grabs every sdk on the jcpm repository and rebuilds a `index.json` with all the `package.json` with names and versions.


Parameters:

* `branchRef` - Branch where this changes will be pushed. Defaults to `main`.

```yaml
- name: 'Rebuild index json'
  uses: mindjolt/actions/jcpm-index-builder@v2
  with:
    branchRef: ${{ github.ref }}
```
