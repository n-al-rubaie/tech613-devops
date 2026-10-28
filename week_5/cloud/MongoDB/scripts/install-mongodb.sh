#!/bin/bash
set -e

# Install MongoDB 7.0 on Ubuntu 24.04
# Run on the MongoDB EC2 instance, not the app instance.

# 1. Update packages and install required tools
sudo apt-get update -y
sudo apt-get install -y curl gnupg

# 2. Add MongoDB's signing key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc \
  | sudo gpg --dearmor --yes \
      -o /usr/share/keyrings/mongodb-server-7.0.gpg

# 3. Add MongoDB's repository for Ubuntu 24.04 (Noble)
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/7.0 multiverse" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# 4. Install MongoDB
sudo apt-get update -y
sudo apt-get install -y mongodb-org

# 5. Configure MongoDB to accept network connections
sudo sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf

# 6. Start MongoDB and enable it on boot
sudo systemctl enable mongod
sudo systemctl restart mongod

# 7. Verify MongoDB is running
sudo systemctl is-active --quiet mongod
echo "MongoDB installation and configuration complete."
