provider "aws" {
  region = "us-east-1"
}

locals {
  domain_name = aws_eip.ec2_ip.public_ip
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = var.public_key
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_eip" "ec2_ip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.ec2_ip.id
}

# Create an EC2 instance for the web server
resource "aws_instance" "web" {
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_readonly.name
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.deployer.key_name

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/scripts/ec2_init.sh", {
    project_name   = var.project_name
    bucket_name    = aws_s3_bucket.bucket.bucket,
    cert_path      = aws_s3_bucket_object.cert.key,
    cert_key_path  = aws_s3_bucket_object.cert_key.key,
    html_file_path = aws_s3_bucket_object.html_file.key,
  })

  user_data_replace_on_change = true

  tags = {
    Name = "Web Server"
  }
}
