locals {
  # Prefix used for naming resources like ALB target groups, SGs, etc.
  # Uses project_name variable so it stays consistent across files.
  name_prefix = var.project_name
}
