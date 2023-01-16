# How to deploy this code

## Precondetions

Nothing.

## Code Structure

```
terraform
 |-modules
   |-vpc
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

### VPC

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### Subnet

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### Route table

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### Internet gateeway

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |

### NAT Gateway

| aaa | bbb | ccc |
| :--- | :--- | :--- |
| xxx | yyy | zzz |