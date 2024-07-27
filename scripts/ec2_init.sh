#!/bin/bash
apt update -y
apt install awscli nginx -y
aws s3 cp s3://${bucket_name}/${cert_path} /etc/nginx/ssl/${project_name}.crt
aws s3 cp s3://${bucket_name}/${cert_key_path} /etc/nginx/ssl/${project_name}.key
aws s3 cp s3://${bucket_name}/nginx.conf /etc/nginx/sites-available/default
aws s3 cp s3://${bucket_name}/${html_file_path} /var/www/html/index.html
systemctl start nginx
systemctl enable nginx
systemctl restart nginx