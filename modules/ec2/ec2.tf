# Ensure AWS region data is available
data "aws_region" "current" {}

# Cloud-init to render user_data
data "cloudinit_config" "userdata" {
  count         = var.user_data_template != "" ? 1 : 0
  gzip          = false
  base64_encode = true
  boundary      = "//"

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/${var.user_data_template}.sh.tpl", {})
  }
}

resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  availability_zone           = var.availability_zone
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = var.associate_public_ip
  vpc_security_group_ids      = var.security_group_ids

  iam_instance_profile = var.iam_instance_profile != "" ? var.iam_instance_profile : null

  dynamic "credit_specification" {
    for_each = var.credit_specification == null ? [] : [var.credit_specification]
    content {
      cpu_credits = credit_specification.value.cpu_credits
    }
  }

  root_block_device {
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    volume_size           = var.root_block_device.volume_size
    volume_type           = var.root_block_device.volume_type
    kms_key_id            = var.root_block_device.kms_key_id
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    }
  }

  user_data_base64 = length(data.cloudinit_config.userdata) > 0 ? data.cloudinit_config.userdata[0].rendered : null

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data_base64]
  }

  tags = merge(
    tomap({
      Name = "aws-ec2-${data.aws_region.current.name}-${var.availability_zone}-${var.app_type}-${var.stage}-${var.service_name}-${count.index}"
    }),
    var.tags
  )
}