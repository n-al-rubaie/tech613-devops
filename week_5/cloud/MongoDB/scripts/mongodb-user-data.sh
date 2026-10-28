#!/bin/bash
set -e

# Log User Data output for troubleshooting
exec > >(tee -a /var/log/mongodb-user-data.log) 2>&1

# Update packages and install required tools
apt-get update -y
apt-get install -y curl gnupg

# Add MongoDB signing key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc \
  | gpg --dearmor --yes \
      -o /usr/share/keyrings/mongodb-server-7.0.gpg

# Add MongoDB repository for Ubuntu 24.04
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/7.0 multiverse" \
  > /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install MongoDB
apt-get update -y
apt-get install -y mongodb-org

# Configure MongoDB to listen on network interfaces
sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf

# Enable and start MongoDB
systemctl enable mongod
systemctl restart mongod

# Verify MongoDB is running
systemctl is-active --quiet mongod

echo "MongoDB User Data deployment completed successfully."
