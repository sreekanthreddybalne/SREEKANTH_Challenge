
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-bucket"
  # acl    = "public-read-write"
}

resource "aws_s3_bucket_object" "html_file" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "index.html"
  source = "${path.module}/nginx/index.html"

  tags = {
    md5 = "${md5(file("${path.module}/nginx/index.html"))}"
  }
}

resource "aws_s3_bucket_object" "nginx_conf" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "nginx.conf"
  content = templatefile("${path.module}/nginx/nginx.conf.tpl", {
    domain_name  = aws_instance.web.public_ip,
    project_name = var.project_name,
  })

  tags = {
    md5 = "${md5(file("${path.module}/nginx/nginx.conf.tpl"))}"
  }
}
