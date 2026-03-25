# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.

# California
# reference this as `aws.california`.
provider "aws" {
  region = "us-west-1"
}


#If adding other regions and changing default provider, uncomment the following code:

# California - additional provider configuration for Asia Pacific region
# reference this as `aws.california`.
provider "aws" {
  alias  = "california"
  region = "us-west-1"
}



# Providers - terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0" 
    }
  }
 } 

