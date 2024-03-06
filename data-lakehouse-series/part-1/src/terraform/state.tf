terraform {
  backend "s3" {
    bucket         = "bastion-tfstate-ap-southeast-2"
    key            = "lakehouse-pt1.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "bastion-tfstate-ap-southeast-2"
  }
}
