# ---------------------------------------
#   Log files
# ---------------------------------------
resource "aws_s3_bucket" "log_bucket" {
  bucket = "aws-s3-${var.stage}-${var.servicename}-log-bucket"

  ### add after create logging bucket
  #  logging {
  #    target_bucket = var.logging_bucket_id
  #    target_prefix = "${var.s3_access_logging_prefix}/smp-eks-node"
  #  }
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    tomap({
      Name = "aws-s3-${var.stage}-${var.servicename}-log-bucket"
    }),
    var.tags
  )
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [] # 추가 필요
  })
}

# ---------------------------------------
#   Images
# ---------------------------------------
resource "aws_s3_bucket" "image_bucket" {
  bucket = "aws-s3-${var.stage}-${var.servicename}-image-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    tomap({
      Name = "aws-s3-${var.stage}-${var.servicename}-image-bucket"
    }),
    var.tags
  )
}

resource "aws_s3_bucket_policy" "image_bucket_policy" {
  bucket = aws_s3_bucket.image_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [] # 추가 필요
  })
}

# ---------------------------------------
#   MySQL backup
# ---------------------------------------
resource "aws_s3_bucket" "mysql_backup_bucket" {
  bucket = "aws-s3-${var.stage}-${var.servicename}-mysql-backup-bucket"

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    tomap({
      Name = "aws-s3-${var.stage}-${var.servicename}-mysql-backup-bucket"
    }),
    var.tags
  )
}

resource "aws_s3_bucket_policy" "mysql_backup_bucket_policy" {
  bucket = aws_s3_bucket.mysql_backup_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [] # 추가 필요
  })
}