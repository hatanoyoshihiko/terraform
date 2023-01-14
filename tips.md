# How to use terraform

## Initial settings

### Create IAM user on aws enabled access key and secret access key  
Note: Policies granted to groups must be given appropriate permissions.

### Install awscli  
- [How to use AWS CLI](./../Tips/aws/aws_cli.md)  

- credential test  
`$ aws sts get-caller-identity --query Account --output text`

### Install terraform  
  
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- `$ terraform --version`

### Specify terrafrom version

`$ mkdir terrafrom_dir`  
`$ echo 1.0.0 > .terraform-version`

### Install git-secrets

Prevent leakage of aws confidential information.

`$ brew install git-secrets `  
`$ git secrets --register-aws --global`  
`$ git secrets --install ~/.git-templates/git-secrets`  
`$ git config --global init.templatedir '~/.git-templates/git-secrets'`

## Try Terraform




---

## Other tips

### Increase parallels

Increase speed by increasing the number of parallel executions.  
Note: default parallelism is 10

`$ terraform plan --parallelism=20`

### Enable debug log

`$ TF_LOG=debug`  
`$ TF_LOG_PATH=/tmp/terraform.log`  
`$ terraform apply`
