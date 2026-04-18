# Application Environments
This is a repository where I will keep some templates for deploying resources I can use to deploy applications or other experiments.

## Overview
For starters, I am adding some templates to deploy Kubernetes clusters to both AWS and GCP, which can then be used to host other applications I develop. I may add some other applications or common utilities here for later reference and reuse.

## Organisation
The repository is generally organised as follows:
- `{cloud provider}`: Contains templates related to a particular Cloud provider. Currently AWS and GCP.
- `{cloud provider}/{template}/template`: Contains the Terraform template to deploy the resources to the provider.
- `{cloud provider}/{template}/values`: This is where you (if you want to use this nonsense) should put your terraform backend config files and `.tfvars` files for the resources.

There are a couple other small utilities in here:
- `db-shutdown`: This is a small Go AWS lambda function to periodically shut down RDS instances I mark with the `status=inactive` tag. THis is because AWS automatically restarts stopped RDS instances after a while.

## Taskfile
The repository contains a `Taskfile.yml` to help out with various tasks. Some useful tasks are:
- `task init-group GROUP={template} PROVIDER={provider}`: Runs Terraform init on the `{provider}/{template}` resource group / template.
- `task validate-group GROUP={template} PROVIDER={provider}`: As above, but also runs terraform validation.
- `task deploy-group GROUP={template} PROVIDER={provider}`: As above, but also runs terraform apply to deploy the resources.
- `task remove-group GROUP={template} PROVIDER={provider}`: Deletes the resources of the group with terraform destroy. To run when you are done with them.
- `task format`: Runs Terraform formatting on all files.

More provider-specific tasks include:
- `task kubeconfig-aws`: Updates your kubeconfig to use the AWS cluster (you must deploy it with `task deploy-group PROVIDER=aws GROUP=cluster` first).

## Applications
Here are some applications I have added in here that can be deployed together with the given templates.

### VLLM Deployment
There is a Helm chart and some templates to deploy a VLLM instance to host a large language model on your clusters. In order to use it, you must first deploy your cluster using the provided templates, and then you can deploy VLLM there. The chart is in the `vllm-deployment` directory. This is currently supported for AWS.

