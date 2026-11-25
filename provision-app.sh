
#!/bin/bash

# Stop the script immediately if any command fails
set -e

# ==================================================
# Configuration
# ==================================================

# GitHub repository containing the Tic-Tac-Toe application
REPO_URL="https://github.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1.git"

# Directory where the application will be stored
APP_DIR="/home/ubuntu/app"

# Name used to identify the application in PM2
APP_NAME="tic-tac-toe"

# Location of the Nginx configuration file
NGINX_CONFIG="/etc/nginx/sites-available/tic-tac-toe"

# MongoDB connection string, including the database name
MONGODB_URI="mongodb://172.31.55.151:27017/tictactoe"


# ==================================================
# 1. Install required packages
# ==================================================

# Update the Ubuntu package list
sudo apt-get update

# Install Git to clone the repository and Nginx as a web server
sudo apt-get install -y git nginx


# ==================================================
# 2. Get the application from GitHub
# ==================================================

# Check whether the application directory is already a Git repository
if [ -d "$APP_DIR/.git" ]; then

    # Navigate into the existing application directory
    cd "$APP_DIR"

    # Download the latest changes from the main branch
    git pull origin main

else

    # Check whether the directory exists and contains files
    if [ -d "$APP_DIR" ] && [ -n "$(ls -A "$APP_DIR")" ]; then

        # Stop deployment if the directory contains files but is not a Git repository
        echo "Error: App directory exists but is not a Git repository."
        exit 1
    fi

    # Clone the application repository from GitHub
    git clone "$REPO_URL" "$APP_DIR"

fi


# ==================================================
# 3. Install application dependencies and seed MongoDB
# ==================================================

# Navigate into the application directory
cd "$APP_DIR"

# Pass the MongoDB connection string to npm install
# This allows the application to connect to MongoDB during installation
MONGODB_URI="$MONGODB_URI" npm install


# ==================================================
# 4. Install PM2 if needed
# ==================================================

# Check whether PM2 is already installed
if ! command -v pm2 >/dev/null 2>&1; then

    # Install PM2 globally if it is not installed
    sudo npm install -g pm2

fi


# ==================================================
# 5. Start or restart the application with MongoDB configured
# ==================================================

# Check whether the application is already running in PM2
if pm2 describe "$APP_NAME" >/dev/null 2>&1; then

    # Restart the existing application and update its environment variables
    MONGODB_URI="$MONGODB_URI" pm2 restart "$APP_NAME" --update-env

else

    # Start the application using its npm start command
    # Give the PM2 process the name specified in APP_NAME
    MONGODB_URI="$MONGODB_URI" pm2 start npm --name "$APP_NAME" -- start

fi

# Save the current PM2 process list
# This allows PM2 to restore the application processes later
pm2 save


# ==================================================
# 6. Configure Nginx as a reverse proxy
# ==================================================

# Create the Nginx configuration file
# Nginx will receive HTTP requests on port 80
sudo tee "$NGINX_CONFIG" > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    # Forward incoming requests to the Node.js application
    location / {
        proxy_pass http://127.0.0.1:3000;

        # Use HTTP version 1.1 for communication with the application
        proxy_http_version 1.1;

        # Forward the original request information to the application
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF


# ==================================================
# 7. Enable the application site in Nginx
# ==================================================

# Create a symbolic link to enable the application configuration
# Nginx reads enabled configurations from sites-enabled
sudo ln -sfn "$NGINX_CONFIG" \
    /etc/nginx/sites-enabled/tic-tac-toe


# ==================================================
# 8. Disable the default Nginx welcome page
# ==================================================

# Check whether the default Nginx configuration is enabled
if [ -L /etc/nginx/sites-enabled/default ]; then

    # Remove the symbolic link to the default welcome page
    sudo rm /etc/nginx/sites-enabled/default

fi


# ==================================================
# 9. Test and reload Nginx
# ==================================================

# Check the Nginx configuration for syntax errors
sudo nginx -t

# Enable Nginx to start automatically when the VM reboots
sudo systemctl enable nginx

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx


# ==================================================
# 10. Display deployment status
# ==================================================

# Confirm that the deployment script has completed
echo "Application and Nginx deployment complete."

# Display the status of PM2 processes
pm2 status
