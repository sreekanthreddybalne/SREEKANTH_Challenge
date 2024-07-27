# These outputs are used by our tests

output "project_name" {
  value = var.project_name
}

output "self_signed_cert_path" {
  value = local.cert_path
}

output "web_server_ip" {
  value = aws_eip.ec2_ip.public_ip
}
