# Deploys the Node.js application from a ZIP file on the EC2 instance.
# Checks that app.zip exists and extracts the application files.
# Installs application dependencies using npm install.
# Installs PM2 if it is not already installed.
# Starts the application or restarts it if it is already running.
# Does not configure Nginx.
# Requires Node.js, npm and the application ZIP file to be available.
# Purpose: Basic deployment using a ZIP file and PM2.

#!/bin/bash
set -e # Tells Bash to stop the script when a command fails.

APP_ZIP="/home/ubuntu/app.zip"
APP_DIR="/home/ubuntu/app"
APP_NAME="tic-tac-toe"

# Check required files and tools
if [ ! -f "$APP_ZIP" ]; then
    echo "Error: $APP_ZIP not found"
    exit 1
fi

sudo apt-get update
sudo apt-get install -y unzip

# Extract the application
mkdir -p "$APP_DIR"
unzip -o "$APP_ZIP" -d /home/ubuntu

# Install dependencies
cd "$APP_DIR"
npm install

# Install PM2 if needed
if ! command -v pm2 >/dev/null 2>&1; then
    sudo npm install -g pm2
fi

# Start or restart the application
if pm2 describe "$APP_NAME" >/dev/null 2>&1; then
    pm2 restart "$APP_NAME"
else
    pm2 start npm --name "$APP_NAME" -- start
fi

echo "Application deployed successfully"
pm2 status

