# HTTP server block for redirection to HTTPS
server {
listen 80;
server_name ${domain_name};

# Redirect all HTTP requests to HTTPS
return 301 https://$host$request_uri;
}

# HTTPS server block
server {
listen 443 ssl;
listen [::]:443 ssl;
server_name ${domain_name};

# SSL configuration
ssl_certificate /etc/nginx/ssl/${project_name}.crt;
ssl_certificate_key /etc/nginx/ssl/${project_name}.key;

root /var/www/html;
index index.html index.htm index.php;

location / {
try_files $uri $uri/ =404;
}
}