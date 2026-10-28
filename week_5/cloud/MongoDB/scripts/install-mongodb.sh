
#!/bin/bash
set -e

# Install MongoDB 7.0 on Ubuntu
# Run on the MongoDB EC2 instance, not the app instance.

sudo apt-get update -y
sudo apt-get install -y curl gnupg

# Add MongoDB's signing key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc \
  | sudo gpg --dearmor --yes \
      -o /usr/share/keyrings/mongodb-server-7.0.gpg

# Add MongoDB's repository
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install MongoDB
sudo apt-get update -y
sudo apt-get install -y mongodb-org

# Configure MongoDB to accept network connections
sudo sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf

# Start MongoDB and enable it on boot
sudo systemctl enable mongod
sudo systemctl restart mongod

# Verify the service
sudo systemctl status mongod --no-pager

echo "MongoDB installation and configuration complete."
