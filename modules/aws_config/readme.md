# How to deploy this code

## Precondetions

- The AWS Config must not be valid.
below configuration must be off.
 - How to know wether aws config service is invalid?
 - `$ aws configservice describe-configuration-recorders` -> `"ConfigurationRecorders": []`
 - `$ aws configservice describe-delivery-channel-status` -> `"DeliveryChannelsStatus": []`

## Code Structure

```
terraform
 |-modules
   |-aws_config
   |  |-main.tf
   |  |-variables.tf
   |-s3
      |-main.tf
      |-variables.tf
      |-output.tf
```
## Variables

variables.tf

## Run terraform

- `$ cd aws_config`
- `$ terraform init`
- `$ terraform plan`
- `$ terraform apply` -> Type "yes" after "Enter a value:" is displayed.

## Parameters

### AWS Config

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### S3 Bucket

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |