# How to deploy this code

## Precondetions

Nothing.

## Code Structure

```
terraform
 |-modules
   |-security_group
   |  |-main.tf
   |  |-variables.tf
   |  |-output.tf
```

## Main processing

## Variables

variables.tf

## Run terraform

- `$ cd vpc`
- `$ terraform init`
- `$ terraform plan`
- `$ terraform apply` -> Type "yes" after "Enter a value:" is displayed.

## Parameters

Below parameter shows in case of used default variables.

### Security group

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### Ingress rule

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### Egress rule

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |
