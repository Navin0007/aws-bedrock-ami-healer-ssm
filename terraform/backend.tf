terraform {
  backend "s3" {
    bucket         = ""
    key            = "ami-healer-ssm/terraform.tfstate"
    region         = ""
    dynamodb_table = ""
    encrypt        = true
  }
}
