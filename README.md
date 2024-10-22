# Bitbucket Pipelines Pipe: Google Cloud Function Deploy

Pipe to deploy a function to [Google Cloud Function][gcf].

## Packages

Packages are deployed to both Dockerhub and GitHub Packages:

- [GitHub Packages](https://github.com/gyzo/google-cloud-functions-deploy/pkgs/container/google-cloud-functions-deploy)
- [Dockerhub](https://hub.docker.com/r/gyzo/google-cloud-functions-deploy)

## YAML Definition

Add the following snippet to the script section of your `bitbucket-pipelines.yml` file:

```yaml
- pipe: docker://artemrys/google-cloud-functions-deploy:latest
  variables:
    KEY_FILE: "<string>"
    PROJECT: "<string>"
    FUNCTION_NAME: "Array<<string>>"
    ENTRY_POINT: "Array<string>"
    RUNTIME: "<string>"
    REGION: "<string>"
    # MEMORY: '<string>'  [Optional]
    # TIMEOUT: '<string>'  [Optional]
    # EXTRA_ARGS: '<string>' [Optional]
    # DEBUG: '<string>'  [Optional]
    # SOURCE: '<string>' [Optional]
    # TRIGGER: '<string>' [Optional]
    # ALLOW_UNAUTHENTICATED: '<string>' [Optional]
```

## Variables

| Variable              | Usage                                                                                                                                                                                                                        |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| KEY_FILE (\*)         | Key file for a [Google service account](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).                                                                                                           |
| PROJECT (\*)          | The Project ID of the project that owns the app to deploy.                                                                                                                                                                   |
| FUNCTION_NAME (\*)    | The array of names of the function in Google Cloud Function.                                                                                                                                                                 |
| ENTRY_POINT (\*)      | Array of entry points for the functions. The order in the ENTRY_POINT array must correspond to the order in the FUNCTION_NAME array. The deployed Cloud Function will use a function named `ENTRY_POINT` in the source file. |
| RUNTIME (\*)          | The runtime of the Cloud Function.                                                                                                                                                                                           |
| REGION (\*)           | The region of the Cloud Function.                                                                                                                                                                                            |
| MEMORY                | The memory limit of the Cloud Function.                                                                                                                                                                                      |
| TIMEOUT               | The timeout of the Cloud Function.                                                                                                                                                                                           |
| EXTRA_ARGS            | Extra arguments to be passed to the CLI.                                                                                                                                                                                     |
| DEBUG                 | Turn on extra debug information. Default `false`.                                                                                                                                                                            |
| SOURCE                | Path to the source of the Google Cloud Function. Default '.'                                                                                                                                                                 |
| TRIGGER               | Trigger command-line flag. [More details](https://cloud.google.com/functions/docs/concepts/events-triggers) Default '--trigger-http'.                                                                                        |
| ALLOW_UNAUTHENTICATED | allow unauthenticated command-line flag.                                                                                                                                                                                     |

_(\*) = required variable._

## Prerequisites

- An IAM user is configured with sufficient permissions to perform a deployment of your application using gcloud.
- You have [enabled APIs and services](https://cloud.google.com/service-usage/docs/enable-disable) needed for your application.

## Examples

### Basic example:

```yaml
- pipe: docker://artemrys/google-cloud-functions-deploy:latest
  variables:
    KEY_FILE: $KEY_FILE
    PROJECT: "my-project"
    FUNCTION_NAME: ["fun1", "fun2"]
    ENTRY_POINT: ["hello_world_for_fun1", "hello_world_for_fun2"]
    RUNTIME: "nodejs20"
    REGION: "europe-central2"
```

### Advanced example:

```yaml
- pipe: docker://artemrys/google-cloud-functions-deploy:latest
  variables:
    KEY_FILE: $KEY_FILE
    PROJECT: "my-project"
    FUNCTION_NAME: ["fun1", "fun2"]
    ENTRY_POINT: ["hello_world_for_fun1", "hello_world_for_fun2"]
    RUNTIME: "nodejs20"
    MEMORY: "256MB"
    TIMEOUT: "60"
    EXTRA_ARGS: "--logging=debug"
```

## Testing

Test repository in Github is located [here](https://github.com/gyzo/google-cloud-functions-deploy).

## Releasing

To release a new version of the image to both GitHub Packages and Dockerhub, you just need to tag a specific commit and push it to the repository. GitHub Actions job will do the rest.

## License

Copyright (c) 2022 Artem Rys.
Apache 2.0 licensed, see [LICENSE.txt](LICENSE.txt) file.

[gcf]: https://cloud.google.com/functions
[github_repo]: https://github.org/gyzo/google-cloud-functions-deploy
