# datomic/ions

## Development

Since we rely on CodePipeline for our `stage` and `prod` deployments, instead of the Datomic standard `push`/`deploy`, we've got a single `release` command for `dev`.

```bash
./bin/release.sh
``` 

This will only make ion code updates, so you're likely better off with the top-level `./bin/plan.sh`/`./bin/apply.sh` approach to make certain all of the AWS resources are wired up properly.

Before you can connect to the cluster locally, you'll need to run `./bin/socks-proxy.sh -p ops-dev -r us-east-1 [system-name]`.
