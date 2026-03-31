# IAM Role for Jenkins

resource "aws_iam_role" "jenkins" {
  name               = "jenkins-ec2-role"
  assume_role_policy = jsonencode ({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Instance Profile for Jenkins EC2 instance
resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-ec2-instance-profile"
  role = aws_iam_role.jenkins.name
}


# Policy for S3 access
resource "aws_iam_policy" "jenkins_s3_access" {
  name        = "jenkins-s3-access-policy"
  description = "Policy to allow Jenkins EC2 instance to access S3 buckets for artifacts and logging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.jenkins-frontend.arn,
          "${aws_s3_bucket.jenkins-frontend.arn}/*",
          aws_s3_bucket.jenkins-artifacts.arn,
          "${aws_s3_bucket.jenkins-artifacts.arn}/*",
          aws_s3_bucket.jenkins-logging.arn,
          "${aws_s3_bucket.jenkins-logging.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:GetBucketLocation",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketPublicAccessBlock"
        ]
        Resource = [
          "arn:aws:s3:::taaops-*",
          "arn:aws:s3:::jenkins-bucket-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::taaops-*/*",
          "arn:aws:s3:::jenkins-bucket-*/*"
        ]
      }
    ]
  })
}

# Attach S3 policy to Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_s3_policy_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_s3_access.arn
}

# Policy for AWS Systems Manager Session Manager access
resource "aws_iam_policy" "jenkins_ssm_access" {
  name        = "jenkins-ssm-access-policy"
  description = "Policy to allow Jenkins EC2 instance to be managed via AWS Systems Manager Session Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach SSM policy to Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_ssm_policy_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_ssm_access.arn
}

# Policy for Route 53 access
resource "aws_iam_policy" "jenkins_route53_access" {
  name        = "jenkins-route53-access-policy"
  description = "Policy to allow Jenkins to read Route 53 hosted zones for Terraform deployments"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:GetHostedZone",
          "route53:ListResourceRecordSets",
          "route53:GetChange",
          "route53:ChangeResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Route53 policy to Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_route53_policy_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_route53_access.arn
}

# Terraform Deployment Policy 1: Compute & Networking
resource "aws_iam_policy" "jenkins_terraform_compute" {
  name        = "jenkins-terraform-compute-policy"
  description = "EC2, VPC, Transit Gateway, VPN, Auto Scaling permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:DeleteNatGateway",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateTransitGateway",
          "ec2:DeleteTransitGateway",
          "ec2:CreateTransitGatewayVpcAttachment",
          "ec2:DeleteTransitGatewayVpcAttachment",
          "ec2:ModifyTransitGatewayVpcAttachment",
          "ec2:CreateVpnGateway",
          "ec2:DeleteVpnGateway",
          "ec2:CreateCustomerGateway",
          "ec2:DeleteCustomerGateway",
          "ec2:CreateVpnConnection",
          "ec2:DeleteVpnConnection",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:CreateFlowLogs",
          "ec2:DeleteFlowLogs",
          "ec2:GetTransitGatewayRouteTableAssociations",
          "ec2:GetTransitGatewayRouteTablePropagations"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:Describe*",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:DeleteLaunchConfiguration"
        ]
        Resource = "*"
      }
    ]
  })
}

# Terraform Deployment Policy 2: Security & Secrets
resource "aws_iam_policy" "jenkins_terraform_security" {
  name        = "jenkins-terraform-security-policy"
  description = "IAM, KMS, Secrets Manager, ACM, WAF permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRoles",
          "iam:ListPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PassRole",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:TagPolicy",
          "iam:UntagPolicy",
          "iam:GetInstanceProfile",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:GetRolePolicy"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:DescribeKey",
          "kms:CreateKey",
          "kms:ListKeys",
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:UpdateAlias",
          "kms:ListAliases",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListResourceTags"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource",
          "secretsmanager:ListSecrets",
          "secretsmanager:RotateSecret",
          "secretsmanager:GetResourcePolicy"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:GetCertificate",
          "acm:RequestCertificate",
          "acm:DeleteCertificate",
          "acm:AddTagsToCertificate",
          "acm:ListTagsForCertificate"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "wafv2:GetIPSet",
          "wafv2:GetWebACL",
          "wafv2:GetRuleGroup",
          "wafv2:ListIPSets",
          "wafv2:ListWebACLs",
          "wafv2:ListRuleGroups",
          "wafv2:CreateIPSet",
          "wafv2:DeleteIPSet",
          "wafv2:UpdateIPSet",
          "wafv2:CreateWebACL",
          "wafv2:DeleteWebACL",
          "wafv2:UpdateWebACL",
          "wafv2:TagResource",
          "wafv2:UntagResource",
          "wafv2:ListTagsForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "wafv2:GetLoggingConfiguration"
        ]
        Resource = "*"
      }
    ]
  })
}

# Terraform Deployment Policy 3: Application Services
resource "aws_iam_policy" "jenkins_terraform_application" {
  name        = "jenkins-terraform-application-policy"
  description = "Lambda, ALB, CloudFront, RDS, S3, SNS, CloudWatch, SSM, Bedrock permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketLogging",
          "s3:PutBucketLogging",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetBucketNotification",
          "s3:PutBucketNotification",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:GetBucketWebsite",
          "s3:GetAccelerateConfiguration",
          "s3:PutAccelerateConfiguration",
          "s3:GetBucketRequestPayment",
          "s3:PutBucketRequestPayment",
          "s3:GetReplicationConfiguration",
          "s3:PutReplicationConfiguration",
          "s3:GetBucketObjectLockConfiguration",
          "s3:PutBucketObjectLockConfiguration"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds:Describe*",
          "rds:CreateDBCluster",
          "rds:DeleteDBCluster",
          "rds:ModifyDBCluster",
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:CreateDBParameterGroup",
          "rds:DeleteDBParameterGroup",
          "rds:ModifyDBParameterGroup",
          "rds:AddTagsToResource",
          "rds:RemoveTagsFromResource",
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:GetFunction",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:ListFunctions",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:ListTags",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:CreateEventSourceMapping",
          "lambda:DeleteEventSourceMapping",
          "lambda:ListVersionsByFunction",
          "lambda:GetFunctionCodeSigningConfig"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:GetDistribution",
          "cloudfront:CreateDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:DeleteDistribution",
          "cloudfront:ListDistributions",
          "cloudfront:TagResource",
          "cloudfront:UntagResource",
          "cloudfront:ListTagsForResource",
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:DeleteOriginAccessControl",
          "cloudfront:GetOriginAccessControl"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListTopics",
          "sns:ListSubscriptionsByTopic",
          "sns:TagResource",
          "sns:UntagResource",
          "sns:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:TagLogGroup",
          "logs:UntagLogGroup",
          "logs:ListTagsLogGroup",
          "logs:ListTagsForResource",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:DeleteLogStream"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:TagResource",
          "cloudwatch:UntagResource",
          "cloudwatch:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:DescribeDocument",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:PutParameter",
          "ssm:DeleteParameter",
          "ssm:DescribeParameters",
          "ssm:AddTagsToResource",
          "ssm:RemoveTagsFromResource",
          "ssm:ListTagsForResource",
          "ssm:DescribeAssociation",
          "ssm:CreateAssociation",
          "ssm:DeleteAssociation",
          "ssm:UpdateAssociation",
          "ssm:CreateDocument",
          "ssm:DeleteDocument",
          "ssm:GetDocument",
          "ssm:DescribeDocumentPermission"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:ListFoundationModels",
          "bedrock:GetFoundationModel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach all three policies to Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_terraform_compute_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_terraform_compute.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_terraform_security_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_terraform_security.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_terraform_application_attachment" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_terraform_application.arn
}

# ========================================
# ASSUMABLE ROLES FOR JENKINS USER
# ========================================
# These roles can be assumed by jenkins-programmatic-user
# for specific deployment operations (least privilege)

# Assumable Role: Compute Operations
resource "aws_iam_role" "jenkins_assume_compute" {
  name        = "jenkins-assume-compute-role"
  description = "Assumable role for EC2, VPC, Transit Gateway, VPN, Auto Scaling operations"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_iam_user.jenkins_user.arn
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "jenkins-compute-deployment"
        }
      }
    }]
  })

  tags = {
    Name        = "Jenkins Assume Compute Role"
    Purpose     = "Jenkins AssumeRole Pattern"
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_assume_compute_policy" {
  role       = aws_iam_role.jenkins_assume_compute.name
  policy_arn = aws_iam_policy.jenkins_terraform_compute.arn
}

# Assumable Role: Security Operations
resource "aws_iam_role" "jenkins_assume_security" {
  name        = "jenkins-assume-security-role"
  description = "Assumable role for IAM, KMS, Secrets Manager, ACM, WAF operations"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_iam_user.jenkins_user.arn
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "jenkins-security-deployment"
        }
      }
    }]
  })

  tags = {
    Name        = "Jenkins Assume Security Role"
    Purpose     = "Jenkins AssumeRole Pattern"
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_assume_security_policy" {
  role       = aws_iam_role.jenkins_assume_security.name
  policy_arn = aws_iam_policy.jenkins_terraform_security.arn
}

# Assumable Role: Application Services
resource "aws_iam_role" "jenkins_assume_application" {
  name        = "jenkins-assume-application-role"
  description = "Assumable role for Lambda, ALB, CloudFront, RDS, S3, SNS, CloudWatch, SSM, Bedrock"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_iam_user.jenkins_user.arn
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "jenkins-application-deployment"
        }
      }
    }]
  })

  tags = {
    Name        = "Jenkins Assume Application Role"
    Purpose     = "Jenkins AssumeRole Pattern"
    Environment = "production"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_assume_application_policy" {
  role       = aws_iam_role.jenkins_assume_application.name
  policy_arn = aws_iam_policy.jenkins_terraform_application.arn
}

# ========================================
# BASE POLICY FOR JENKINS USER
# ========================================
# Minimal permissions for jenkins-programmatic-user base user
# User assumes roles above for actual deployment operations

resource "aws_iam_policy" "jenkins_user_base" {
  name        = "jenkins-user-base-policy"
  description = "Minimal base permissions for Jenkins user (AssumeRole + basic operations)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow assuming the deployment roles
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [
          aws_iam_role.jenkins_assume_compute.arn,
          aws_iam_role.jenkins_assume_security.arn,
          aws_iam_role.jenkins_assume_application.arn
        ]
      },
      # Allow getting caller identity (for validation)
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
          "sts:GetAccessKeyInfo"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "Jenkins User Base Policy"
    Purpose     = "Jenkins AssumeRole Pattern"
    Environment = "production"
  }
}
