### NuGet Publish (docker)
Publishes nuget packages to github. Requires docker.

Parameters:

* `rootUrl` - The GitHub Packages NuGet URL (e.g., https://nuget.pkg.github.com/<owner>/index.json).
* `user` - The GitHub username.
* `password` - The personal access token (use ${{ secrets.GITHUB_TOKEN }} in GitHub Actions).
* `packagePath` - The path to the nupkg to publish.


```yaml
- name: Publish NuGet Package to Gihub
  uses: mindjolt/actions/nuget-publish-github@v2
  with:
    rootUrl: "https://nuget.pkg.github.com/${{ github.repository_owner }}/index.json"
    user: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
    packagePath: target/${{ env.PACKAGE_NAME }}.${{ env.PACKAGE_VERSION }}.nupkg
```
