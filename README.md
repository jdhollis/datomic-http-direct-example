# datomic-http-direct-example

This is a starter template for integrating Datomic's HTTP Direct with a service using Terraform. You can read more about the approach on my site: [HTTP Direct with Datomic & Terraform](https://theconsultingcto.com/posts/http-direct-with-datomic-and-terraform/)

This also assumes you have a global Datomic service set up like [datomic-service](https://github.com/jdhollis/datomic-service).

You can read more about my approach to integrating Datomic here: [Datomic with Terraform](https://theconsultingcto.com/posts/datomic-with-terraform/)

## AWS

All Terraform and scripts assume you have the AWS CLI tools installed. On the Mac, you can install them via [Homebrew](https://brew.sh):

```bash
brew install awscli
```

### Credentials

All of the Terraform assumes that you have configured your AWS credentials the following way:

#### `~/.aws/credentials`

```ini
[ops]
aws_access_key_id = …
aws_secret_access_key = …
```

#### `~/.aws/config`

```ini
[profile ops]

[profile ops-dev]
source_profile = ops
role_arn = …

[profile ops-tools]
source_profile = ops
role_arn = …

[profile ops-stage]
source_profile = ops
role_arn = …

[profile ops-prod]
source_profile = ops
role_arn = …
```

You can configure using [`aws configure`](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) or edit the files directly.

## Deployment

Check out my [deployment-pipeline](https://github.com/jdhollis/deployment-pipeline) and [pipeline-example](https://github.com/jdhollis/pipeline-example) for examples of how to integrate with CodePipeline.
