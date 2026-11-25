
#!/bin/bash

# Stop the script if any command fails
set -e

# ==================================================
# 1. Update packages and install required tools
# ==================================================

sudo apt-get update
sudo apt-get install -y curl gnupg


# ==================================================
# 2. Add MongoDB 8.0 signing key
# ==================================================

curl -fsSL https://pgp.mongodb.com/server-8.0.asc \
    | sudo gpg --dearmor --yes \
        -o /usr/share/keyrings/mongodb-server-8.0.gpg


# ==================================================
# 3. Add MongoDB 8.0 repository for Ubuntu 24.04
# ==================================================

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list


# ==================================================
# 4. Install MongoDB 8.0
# ==================================================

sudo apt-get update
sudo apt-get install -y mongodb-org


# ==================================================
# 5. Configure MongoDB network access
# ==================================================

# Allow MongoDB to listen on the VM's network interfaces.
# Azure NSG rules must restrict access to trusted private sources.
sudo sed -i 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf


# ==================================================
# 6. Start MongoDB and enable it on boot
# ==================================================

sudo systemctl enable mongod
sudo systemctl restart mongod


# ==================================================
# 7. Verify MongoDB is running
# ==================================================

sudo systemctl is-active --quiet mongod

echo "Azure MongoDB 8.0 installation and configuration complete."
