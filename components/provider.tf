# provider
output "provider" {
  value = {
    "aws" = {
      "region"  = "ap-northeast-1"
      "profile" = "default"
      "availability_zone" = [
        "ap-northeast-1a",
        "ap-northeast-1b"
      ]
    }
  }
}
