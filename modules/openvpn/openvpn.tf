locals {
    common_tags = {
        Stage = var.stage
        ServiceName = var.service_name
    }
}

resource "aws_security_group" "openvpn_sg" {
  name        = "aws-sg-openvpn-${var.stage}-${var.service_name}"
  description = "Security group for the OpenVPN server"
  vpc_id      = var.vpc_id
  tags = local.common_tags

  ingress {
    description = "Allow OpenVPN UDP traffic (default port 1194)"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN 943 port"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN 945 port"
    from_port   = 945
    to_port     = 945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN TCP traffic (default port 443)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH access to OpenVPN server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################
# OpenVPN EC2 Instance
#####################################
resource "aws_instance" "openvpn" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.openvpn_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    # 업데이트 및 OpenVPN, Easy-RSA 설치
    yum update -y
    yum install -y openvpn easy-rsa

    # 간단한 OpenVPN 서버 설정 (예제용, 실제 프로덕션에서는 더 정교한 설정 필요)
    mkdir -p /etc/openvpn/easy-rsa
    cp -r /usr/share/easy-rsa/3/* /etc/openvpn/easy-rsa/
    cd /etc/openvpn/easy-rsa
    ./easyrsa init-pki
    # CA 생성 (nopass 옵션, 실제 환경에서는 비밀번호를 고려)
    echo -ne "\n" | ./easyrsa build-ca nopass
    ./easyrsa gen-req server nopass
    # 자동 서명을 위해 'yes' 입력 (실제 환경에서는 주의 필요)
    ./easyrsa sign-req server server <<EOF2
yes
EOF2
    ./easyrsa gen-dh
    openvpn --genkey --secret /etc/openvpn/ta.key

    # 샘플 서버 구성 파일 복사 및 기본 설정 적용
    cp /usr/share/doc/openvpn*/sample/sample-config-files/server.conf /etc/openvpn/server.conf
    sed -i 's/;tls-auth ta.key 0/tls-auth ta.key 0/' /etc/openvpn/server.conf
    sed -i 's/;cipher AES-128-CBC/cipher AES-128-CBC/' /etc/openvpn/server.conf
    sed -i 's/;user nobody/user nobody/' /etc/openvpn/server.conf
    sed -i 's/;group nobody/group nobody/' /etc/openvpn/server.conf

    # OpenVPN 서비스 활성화 및 시작
    systemctl enable openvpn@server
    systemctl start openvpn@server
    sudo /usr/local/openvpn_as/scripts/sacli --user openvpnas --new_pass "rlagudwls" SetLocalPassword
  EOF

  tags = local.common_tags
}

resource "aws_eip" "openvpn_eip" {
  associate_with_private_ip = aws_instance.openvpn.private_ip
  tags = local.common_tags
}
resource "aws_eip_association" "openvpn_association" {
  instance_id   = aws_instance.openvpn.id
  allocation_id = aws_eip.openvpn_eip.id
}

