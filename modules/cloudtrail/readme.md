# How to deploy this code

## Precondetions

- The CloudTrail must not be valid.  
below configuration must be off.
  - How to know wether cloudtrail service is invalid?


## Code Structure

```
terraform
 |-modules
   |-cloudtrail
   |  |-main.tf
   |  |-variables.tf
   |-s3
   |  |-main.tf
   |  |-variables.tf
   |  |-output.tf
   |-kms
      |-main.tf
      |-variables.tf
      |-output.tf
```

## Main processing

## Variables

variables.tf

## Run terraform

- `$ cd cloudtrail`
- `$ terraform init`
- `$ terraform plan`
- `$ terraform apply` -> Type "yes" after "Enter a value:" is displayed.

## Parameters

Below parameter shows in case of used default variables.

### CloudTrail

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### S3 Bucket

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### KMS

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |