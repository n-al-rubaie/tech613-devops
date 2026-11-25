
#!/bin/bash

# Stop the script if any command fails
set -e

# ==================================================
# Configuration
# ==================================================

REPO_URL="https://github.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1.git"
APP_DIR="/home/adminuser/app"
APP_NAME="tic-tac-toe"
NGINX_CONFIG="/etc/nginx/sites-available/tic-tac-toe"

# Azure MongoDB VM private IP
MONGODB_URI="mongodb://10.0.3.4:27017/tictactoe"


# ==================================================
# 1. Update Ubuntu and install required packages
# ==================================================

sudo apt-get update
sudo apt-get install -y git nginx curl

# Install Node.js 20 and npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs


# ==================================================
# 2. Get the application from GitHub
# ==================================================

if [ -d "$APP_DIR/.git" ]; then

    cd "$APP_DIR"
    git pull origin main

else

    if [ -d "$APP_DIR" ] && [ -n "$(ls -A "$APP_DIR")" ]; then
        echo "Error: App directory exists but is not a Git repository."
        exit 1
    fi

    git clone "$REPO_URL" "$APP_DIR"

fi


# ==================================================
# 3. Install application dependencies
# ==================================================

cd "$APP_DIR"

MONGODB_URI="$MONGODB_URI" npm install


# ==================================================
# 4. Install PM2 if needed
# ==================================================

if ! command -v pm2 >/dev/null 2>&1; then
    sudo npm install -g pm2
fi


# ==================================================
# 5. Start or restart the application
# ==================================================

if pm2 describe "$APP_NAME" >/dev/null 2>&1; then

    MONGODB_URI="$MONGODB_URI" pm2 restart "$APP_NAME" --update-env

else

    MONGODB_URI="$MONGODB_URI" pm2 start npm --name "$APP_NAME" -- start

fi

pm2 save


# ==================================================
# 6. Configure Nginx as a reverse proxy
# ==================================================

sudo tee "$NGINX_CONFIG" > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;

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

sudo ln -sfn "$NGINX_CONFIG" \
    /etc/nginx/sites-enabled/tic-tac-toe


# ==================================================
# 8. Disable the default Nginx welcome page
# ==================================================

if [ -L /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi


# ==================================================
# 9. Test and reload Nginx
# ==================================================

sudo nginx -t
sudo systemctl enable nginx
sudo systemctl reload nginx


# ==================================================
# 10. Display deployment status
# ==================================================

echo "Azure application deployment complete."

pm2 status

