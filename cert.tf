

locals {
  certs_path    = "${path.module}/files/certs"
  cert_path     = "${local.certs_path}/${var.project_name}.crt"
  cert_key_path = "${local.certs_path}/${var.project_name}.key"
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  is_ca_certificate = true
  ip_addresses      = [aws_eip.ec2_ip.public_ip]

  subject {
    common_name  = var.project_name
    organization = var.project_name
  }

  validity_period_hours = 8760
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "cert" {
  content  = tls_self_signed_cert.cert.cert_pem
  filename = local.cert_path
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "local_file" "cert_key" {
  content  = tls_private_key.private_key.private_key_pem
  filename = local.cert_key_path
}

resource "aws_s3_bucket_object" "cert" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "${var.project_name}.crt"
  source = local.cert_path

  depends_on = [local_file.cert]
}

resource "aws_s3_bucket_object" "cert_key" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "${var.project_name}.key"
  source = local.cert_key_path

  depends_on = [local_file.cert_key]
}
