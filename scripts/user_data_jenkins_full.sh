#!/bin/bash
set -euxo pipefail

# Update and install Jenkins + dependencies
dnf -y update --allowerasing
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install -y --allowerasing java-21-amazon-corretto-devel jenkins nginx git unzip curl wget nodejs npm

# Healthcheck for ALB (port 8081)
mkdir -p /var/www/healthcheck
echo "<html><body>Healthy</body></html>" > /var/www/healthcheck/index.html
cat >/etc/nginx/conf.d/healthcheck.conf <<'EOF'
server {
    listen 8081;
    location / { root /var/www/healthcheck; index index.html; }
}
EOF

systemctl enable --now jenkins nginx
systemctl reload nginx

# Log the initial admin password for convenience
cat /var/lib/jenkins/secrets/initialAdminPassword || true

echo "user-data completed"
