### k6 Performance Test
Runs a performance test using [k6](https://k6.io/docs/).

This Action is similar to the official [k6 action](https://github.com/grafana/k6-action)
except that it's a `composite` action instead of a Docker-based action, which
makes it easier for tests to target a service running as a container within the
same GitHub Action because there's no need to setup Docker networking required for
communicating between containers.

Parameters:

* `version` - the version of `k6` to install
* `script` - the full path to the script `k6` will run
* `archiveUrl` - the URL of .tar.gz archive to use for installing k6 binary
* `flags` - command line flags to pass to `k6`

Example:

```yaml
  - name: Run performance test
    id: perf_test
    uses: mindjolt/actions/k6-perf-test
    with:
      script: "${{ github.workspace }}/.github/workflows/perf-test.js"
```

