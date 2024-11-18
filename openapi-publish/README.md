### Publish OpenAPI Documentation

Action to perform the release of the OpenAPI (Swagger) documentation
to the internally hosted SwaggerUI site.


Parameters:

* `openapi_file` - The name of the openapi file to publish
* `service_repo` - The name of the service github repo
* `token` - Github access token with sufficient persmission to checkout and push.

Example:

```yaml
name: Publish

jobs:
  publish-swagger:
    runs-on: ubuntu-latest
    steps:
      - name: Publish OpenAPI
        uses: mindjolt/actions/openapi-publish@v2
        with:
          openapi_file: "src/resources/openapi.yml"
          service_repo: "state-service"
          token: "${{ secrets.MJ_GITHUB_TOKEN }}"
```
