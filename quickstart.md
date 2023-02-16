# Extreme ZTNA: GCP Integration

To restart this tutorial, run this command in the Cloud Shell terminal:

```sh
teachme ~/cloudshell_open/ztmesh-support/quickstart.md
```


## Introduction

In this quickstart, you use Deployment Manager to deploy a Service Account that Extreme ZTNA will use to authenticate againts the specified GCP Project.


## Setting up

1. Select or create a Google Cloud Platform project:

    <walkthrough-project-setup></walkthrough-project-setup>

2. Create the deployment in your specified project:

    ```sh
	./create-integration-sa.sh <project-id> <env>
    ```
