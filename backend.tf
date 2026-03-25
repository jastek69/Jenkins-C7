# Oregon Backend Configuration for Jenkins deployment


terraform {
  backend "s3" {
    bucket       = "jastekops-zion"
    key          = "jenkins/31426terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
