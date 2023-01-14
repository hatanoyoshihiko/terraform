# Terraform
## What's terraform?
- Description
HashiCorp社によって作られたオープンソースのインフラ構成管理ツールです(IaC,Infrastracture as Codeと呼ぶ)
AWS、Azure、GCP等のプラットフォームに対して、ネットワークの定義や仮想マシンの展開を行えます。

- advantage
  - インフラの構築や変更を自動化出来、手動による操作ミスを防げる
  - 複数環境に同じインフラを構築する場合にコードを再利用することで作業を減らすことができる
  - インフラの状態をコードで表現、管理出来る

## Install terraform for macOS

- install tfenv and terraform

`$ brew install tfenv`  
`$ tfenv install latest`

- show version list and specify a version

`$ tfenv list`  
`$ tfenv use 1.0.0`

## Configure AWS Credential
事前にAWS CLIをインストールしておくこと。

- Linuxの場合

```bash
$ aws configure --profile default
AWS Access Key ID [****************FJHQ]:xxxxxxxxx
AWS Secret Access Key [****************8XVS]:yyyyyyyyyy
Default region name [us-east-2]:us-east-1
Default output format [json]: json
```

- Windowsの場合

```bash
>aws configure --profile default
AWS Access Key ID [****************FJHQ]:xxxxxxxxx
AWS Secret Access Key [****************8XVS]:yyyyyyyyyy
Default region name [us-east-2]:us-east-1
Default output format [json]: json
```

## File and Directory Layout
ファイル拡張子は.tf、基本的に同一ディレクトリ内に配置します。
全ての実装を単一ファイルで実装出来ます。
ファイル名は任意です。

サブディレクトリ配下にファイルを分けてモジュール化することも出来ます。

- 単一の場合

```bash
|-main.tf
```

- 複数の場合

```bash
|-ec2.tf
|-vpc.tf
|-s3.tf
```

- モジュール化

```bash
|-main.tf
|-ec2
|  |-main.tf
|  |-variables.tf
|-vpc
|  |-main.tf
|  |-variables.tf
```

---

## Coding
コーディングルール等のお作法を記載する。

---

## Run Terraform
### Deploy a instance

実行先はAWSとします。
実行の流れは、
1. terraformのコード(main.tf?)があるディレクトリで初期化を実行 `$ terraform init`
2. 変更内容を確認 `$ terraform plan`
3. 変更を実行 `$ terraform apply`
4. 環境の削除 `$ terraform destroy`

- 作業環境の初期化
最初の1回だけ行います。

```
$ cd terraform_dir
$ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Installing hashicorp/aws v3.12.0...
- Installed hashicorp/aws v3.12.0 (signed by HashiCorp)

Terraform has been successfully initialized!
```

- 実行内容の確認
```
$ terraform plan
terraform plan                                                                                           (git)-[main]
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_ami.example: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_default_subnet.example will be created
  + resource "aws_default_subnet" "example" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = (known after apply)
      + availability_zone               = "us-west-2d"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = (known after apply)
      + id                              = (known after apply)
      + ipv6_cidr_block                 = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = (known after apply)
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "example"
        }
      + vpc_id                          = (known after apply)
    }
```

- 実行
```
$ terraform apply
```

- 削除
```
$ terraform destroy
```

---

## 変数の定義

- 命名規則 
[システム名] - [環境] - [リソース名] - [用途] - [数字]
[システム名] - [環境] - [リソース名] - [用途] - [何でも] - [数字]

- 本番
Asystem-prd-ec2-web-01


- 実行時に指定
```
$ terraform plan
```

- 実行時の引数で指定
```
$ terraform plan -var 'foo=test-bucket'
```

- 環境変数で指定
```
TF_VAR_foo='env-test' terraform plan
```

- 変数用のファイルを指定
```
$ terraform plan -var-file = FILE_NAME
```
