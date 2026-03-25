# Region Variables - Lab 2 + TGW Hub Configuration

variable "domain_name" {
  description = "domain name: jastek.click"
  type        = string
  default     = "jastek.click"
}

variable "app_subdomain" {
  description = "App hostname prefix (e.g., app.jastek.click)."
  type        = string
  default     = "app"
}

variable "alb_origin_subdomain" {
  description = "Dedicated ALB origin hostname prefix for CloudFront (e.g., origin.jastek.click)."
  type        = string
  default     = "origin"
}

variable "alb_origin_cert_arn" {
  description = "Optional ACM cert ARN for the ALB origin hostname."
  type        = string
  default     = ""
}

variable "taaops" {
  description = "taaops project identifier"
  type        = string
  default     = "taaops"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "taaops"
}

# JENKINS VPC CONFIGURATION
variable "jenkins_vpc_cidr" {
  description = "Jenkins VPC CIDR (use 10.x.x.x/xx as instructed)."
  type        = string
  default     = "10.231.0.0/16"
}


variable "certificate_validation_method" {
  description = "ACM validation method for origin cert."
  type        = string
  default     = "DNS"
}



variable "aws_region_tls" {
  description = "Region for ACM certificate (us-east-1 for CloudFront)"
  type        = string
  default     = "us-east-1"
}


# COMMON TAGS
variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Region      = "us-west-1"
    Purpose     = "Jenkins"
    Environment = "production"
  }
}

# Instance configuration variables
variable "ec2_ami_id" {
  description = "AMI ID for Jenkins EC2 instance (must be valid in the target region)."
  type        = string
  default     = "ami-038f4d4c8824bfed9" # Amazon Linux 2023 kernel-6.1 AMI in us-west-1
}

variable "ec2_instance_type" {
  description = "EC2 instance type for Jenkins (e.g., t3.medium)."
  type        = string
  default     = "t3.medium"
}

# SECURITY
variable "admin_ssh_cidr" {
  description = "CIDR allowed to SSH into EC2 instances."
  type        = string
  default     = "0.0.0.0/0"
}

variable "jenkins_iam_instance_profile" {
  description = "Optional IAM instance profile name for the Jenkins EC2 instance."
  type        = string
  default     = ""
}


/*
variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
*/

/*
# REGIONAL CONFIGURATION
variable "aws_region" {
  description = "Tokyo AWS region"
  type        = string
  default     = "ap-northeast-1"
}

# TOKYO VPC CONFIGURATION
variable "tokyo_vpc_cidr" {
  description = "Tokyo VPC CIDR (use 10.x.x.x/xx as instructed)."
  type        = string
  default     = "10.233.0.0/16"
}



# SÃO PAULO VPC CONFIGURATION (for cross-region reference)
variable "saopaulo_vpc_cidr" {
  description = "São Paulo VPC CIDR for cross-region access rules"
  type        = string
  default     = "10.234.0.0/16"
}

variable "tokyo_subnet_public_cidrs" {
  description = "Tokyo public subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.233.1.0/24", "10.233.2.0/24", "10.233.3.0/24"]
}

variable "tokyo_subnet_private_cidrs" {
  description = "Tokyo private subnet CIDRs (use 10.x.x.x/xx)."
  type        = list(string)
  default     = ["10.233.10.0/24", "10.233.11.0/24", "10.233.12.0/24"]
}

variable "tokyo_azs" {
  description = "Tokyo Availability Zones list (match count with subnets)."
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}




# SNS AND NOTIFICATIONS
variable "sns_email_endpoint" {
  description = "Email endpoint for SNS notifications"
  type        = string
  default     = "jastek.sweeney@gmail.com"
}

# ALARM CONFIGURATION
variable "alarm_reports_bucket_name" {
  description = "S3 bucket name for alarm reports"
  type        = string
  default     = "taaops-tokyo-alarm-reports"
}

variable "rds_cluster_identifier" {
  description = "Aurora cluster identifier (override if a previous name is reserved)"
  type        = string
  default     = "taaops-aurora-cluster-02"
}

variable "rds_kms_key_arn" {
  description = "Override KMS key ARN for RDS encryption and master user secret."
  type        = string
  default     = ""
}

variable "rds_security_group_id" {
  description = "Override security group ID for the RDS cluster."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Allow S3 buckets to be destroyed even when they contain objects."
  type        = bool
  default     = false
}

variable "enable_saopaulo_remote_state" {
  description = "Enable Sao Paulo remote state lookups for TGW peering."
  type        = bool
  default     = true
}

# SECRETS ROTATION
variable "secrets_rotation_days" {
  description = "Number of days between Secrets Manager rotations"
  type        = number
  default     = 30
}

# AUTOMATION CONFIGURATION
variable "automation_parameters_json" {
  description = "JSON parameters for automation document"
  type        = string
  default     = "{\"Param1\":[\"value1\"],\"Param2\":[\"value2\"]}"
}

# WAF LOGGING CONFIGURATION
variable "waf_log_destination" {
  description = "WAF log destination type: cloudwatch or firehose"
  type        = string
  default     = "cloudwatch"
  validation {
    condition     = contains(["cloudwatch", "firehose"], var.waf_log_destination)
    error_message = "WAF log destination must be either 'cloudwatch' or 'firehose'."
  }
}

variable "waf_log_retention_days" {
  description = "WAF log retention in days"
  type        = number
  default     = 14
}

variable "enable_waf" {
  description = "Enable WAF logging"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logging" {
  description = "Enable CloudWatch logging for WAF"
  type        = bool
  default     = true
}

variable "enable_firehose_logging" {
  description = "Enable Firehose logging for WAF"
  type        = bool
  default     = false
}

# INCIDENT REPORTING CONFIGURATION
variable "bedrock_model_id" {
  description = "Bedrock model ID for incident report generation"
  type        = string
  default     = "mistral.mistral-large-3-675b-instruct"
}

variable "incident_report_retention_days" {
  description = "Retention days for incident reports in S3"
  type        = number
  default     = 2555 # 7 years
}

variable "enable_bedrock" {
  description = "Enable Bedrock for AI-generated incident reports"
  type        = bool
  default     = true
}

variable "enable_translation" {
  description = "Enable automatic translation of incident reports"
  type        = bool
  default     = true
}


# AUTOMATION AND MONITORING CONFIGURATION
variable "alarm_asg_name" {
  description = "Auto Scaling Group name for alarm monitoring"
  type        = string
  default     = "tokyo-app-asg"
}

variable "automation_document_name" {
  description = "SSM automation document name for incident response"
  type        = string
  default     = "taaops-tokyo-incident-report"
}


# TRANSIT GATEWAY VARS
# AWS VPN Setup = Transit Gateway (TGW) + Customer Gateways


variable "tgw_id" {
  description = "Tokyo Transit Gateway ID"
  type        = string
  default     = ""
}

variable "tokyo_state_bucket" {
  description = "S3 bucket holding Tokyo Terraform remote state."
  type        = string
  default     = "taaops-terraform-state-tokyo"
}

variable "tokyo_state_key" {
  description = "S3 key for Tokyo Terraform state file."
  type        = string
  default     = "tokyo/terraform.tfstate"
}

variable "tokyo_state_region" {
  description = "AWS region for the Tokyo remote state bucket."
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_side_asn" {
  description = "AWS-side ASN (TGW BGP ASN)"
  type        = number
  default     = 65501
}

variable "gcp_peer_asn" {
  description = "GCP Cloud Router ASN"
  type        = number
  default     = 65515
}


variable "tunnel1_inside_cidr" { type = string }
variable "tunnel2_inside_cidr" { type = string }
variable "tunnel3_inside_cidr" { type = string }
variable "tunnel4_inside_cidr" { type = string }

variable "psk_tunnel_1" { type = string }
variable "psk_tunnel_2" { type = string }
variable "psk_tunnel_3" { type = string }
variable "psk_tunnel_4" { type = string }

variable "gcp_advertised_cidr" {
  description = "CIDR advertised from GCP Cloud Router toward AWS."
  type        = string
  default     = "10.240.0.0/16"
}


# Break Glass Invalidation
variable "break_glass_invalidation" {
  description = "Trigger a CloudFront invalidation (for testing or emergency use)."
  type        = bool
  default     = false
}

variable "break_glass_paths" {
  description = "List of paths to invalidate when break_glass_invalidation is true."
  type        = list(string)
  default     = [
      "/images/*",
      "/css/*",
      "/js/app.js",
      "/index.html"
    ]

}
*/
