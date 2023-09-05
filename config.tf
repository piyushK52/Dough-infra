terraform {
  backend s3 {
    bucket  = "banodoco-auto-backend-tf"
    key     = "infra/terraform.tfstate"
    region  = "ap-south-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

# terraform {
#   backend "local" {
#     path = "./terraform.tfstate"
#   }
# }

provider "aws" {
    alias   = "south-1"
    region  = "ap-south-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile = "personal"
}
