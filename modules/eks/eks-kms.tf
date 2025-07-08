resource "aws_kms_key" "eks_secrets" {
    description            = "KMS key for EKS secrets encryption"
    enable_key_rotation = true
    tags = merge(
        var.tags,
        {
            Name = "aws-eks-secrets-${var.stage}-${var.service_name}"
        }
    )
}

resource "aws_kms_alias" "eks_secrets_alias" {
    name          = "alias/aws-eks-secrets-${var.stage}-${var.service_name}"
    target_key_id = aws_kms_key.eks_secrets.key_id
}