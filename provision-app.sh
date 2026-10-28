
#!/bin/bash
set -e

# Configuration
REPO_URL="https://github.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1.git"
APP_DIR="/home/ubuntu/app"
APP_NAME="tic-tac-toe"
NGINX_CONFIG="/etc/nginx/sites-available/tic-tac-toe"
MONGODB_URI="mongodb://172.31.55.151:27017/tictactoe"

# 1. Install required packages
sudo apt-get update
sudo apt-get install -y git nginx

# 2. Get the application from GitHub
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

# 3. Install application dependencies and seed MongoDB
cd "$APP_DIR"
MONGODB_URI="$MONGODB_URI" npm install

# 4. Install PM2 if needed
if ! command -v pm2 >/dev/null 2>&1; then
    sudo npm install -g pm2
fi

# 5. Start or restart the application with MongoDB configured
if pm2 describe "$APP_NAME" >/dev/null 2>&1; then
    MONGODB_URI="$MONGODB_URI" pm2 restart "$APP_NAME" --update-env
else
    MONGODB_URI="$MONGODB_URI" pm2 start npm --name "$APP_NAME" -- start
fi

# Save the PM2 process list
pm2 save

# 6. Configure Nginx as a reverse proxy
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
# 8. Test Nginx before reloading it
sudo nginx -t
sudo systemctl enable nginx
sudo systemctl reload nginx

echo "Application and Nginx deployment complete."
pm2 status
    sudo rm /etc/nginx/sites-enabled/default
fi


# Disable the default welcome page if enabled
if [ -L /etc/nginx/sites-enabled/default ]; then
# 7. Enable the application site in Nginx
sudo ln -sfn "$NGINX_CONFIG" \
    /etc/nginx/sites-enabled/tic-tac-toe
}
EOF


