resource "aws_instance" "ec2" {
  for_each = var.instance_config

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = lookup(var.subnet_mapping, each.key)
  associate_public_ip_address = lookup(var.public_ip_mapping, each.key, false)
  iam_instance_profile        = var.ec2_iam_role_profile_name
  vpc_security_group_ids      = var.sg_ec2_ids
  user_data                   = lookup(var.user_data_mapping, each.key, "")
  key_name                    = var.key_name

  tags = merge(
    {
      Name = "${var.name_prefix}-${lookup(var.instance_names, each.key)}"
    },
    var.tags
  )

  # root_block_device {
  #   delete_on_termination = false
  #   # encrypted             = false
  #   # kms_key_id            = var.kms_key_id
  # }

  # dynamic "ebs_block_device" {
  #   for_each = var.ebs_volume != "" ? [var.ebs_volume] : []
  #   content {
  #     delete_on_termination = false
  #     device_name           = "/dev/xvdb"
  #     encrypted             = true
  #     kms_key_id            = var.kms_key_id
  #     volume_size           = var.ebs_volume
  #   }
  # }


  # lifecycle {
  #   create_before_destroy = true
  #   ignore_changes        = [user_data_base64, user_data]
  # }
}

data "cloudinit_config" "ec2_userdata" {
  gzip          = false
  base64_encode = true
  boundary      = "//"

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/templates/${var.userdata}.sh.tpl",
      var.userdata_vars
    )
  }
}

# ---------------------------------------
#   EIP
#   - OpenVPN, Grafana (O)
#   - Frontend, Backend, Database (X)
# ---------------------------------------
resource "aws_eip" "ec2_eip" {
  for_each = {
    for index, public_ip in var.public_ip_mapping : index => public_ip
    if public_ip == true
  }

  instance = aws_instance.ec2[each.key].id

  tags = merge(
    {
      Name = "eip-${var.region}-${var.zone}-${var.stage}-${var.servicename}-${each.key}"
    },
    var.tags
  )
}

resource "aws_eip_association" "ec2_eip" {
  for_each = aws_eip.ec2_eip

  instance_id   = aws_instance.ec2[each.key].id
  allocation_id = aws_eip.ec2_eip[each.key].id
}