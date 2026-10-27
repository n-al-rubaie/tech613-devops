# Deploy a Node.js App Using AWS User Data Without SSH

The purpose of this User Data script is to automatically set up an AWS EC2 machine and deploy the Tic-Tac-Toe application when the machine first starts, without needing to SSH into it and run commands manually.

Without User Data, you would normally connect to the EC2 instance using SSH and manually install the software, download the code, configure Nginx and start the application.

With User Data, these steps are automated and repeatable. You can launch a new EC2 instance and have it configure itself, reducing manual work and the chance of missing a step

## 1. Launch an EC2 Instance

- Go to **AWS Console → EC2 → Launch instances**.
- **Name:** `tech613-nowres-node20-app`
- **AMI:** Ubuntu Server 24.04 LTS
- **Security group inbound rules:**
  - HTTP: TCP port `80`
  - Custom TCP: port `3000` (for direct testing)
  - SSH: TCP port `22` (optional, restrict to your IP if enabled)
- Expand **Advanced details** and locate **User data**.

## 2. User Data Script

Paste the following script into the **User data** field before launching the instance.

```bash
#!/bin/bash
set -euxo pipefail

# Save the output so deployment errors can be investigated
exec > /var/log/user-data.log 2>&1

# Update packages and install required software
apt-get update -y
apt-get install -y curl unzip nginx

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh
bash /tmp/nodesource_setup.sh
apt-get install -y nodejs

# Download the application from GitHub
cd /home/ubuntu
curl -fL https://github.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1/archive/refs/heads/main.zip \
  -o /tmp/tictactoe.zip

# Extract the application
unzip -o /tmp/tictactoe.zip -d /tmp
rm -rf /home/ubuntu/app
mv /tmp/nodejs20-sparta-tictactoe-v1-main /home/ubuntu/app

# Give the ubuntu user ownership of the application
chown -R ubuntu:ubuntu /home/ubuntu/app

# Install application dependencies
cd /home/ubuntu/app
sudo -u ubuntu npm install

# Install PM2 to manage the application process
npm install -g pm2

# Configure Nginx to forward traffic from port 80 to port 3000
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

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

# Test and enable Nginx
nginx -t
systemctl enable nginx
systemctl restart nginx

# Start the Node.js application with PM2
sudo -u ubuntu -H pm2 start /home/ubuntu/app/index.js --name tic-tac-toe
sudo -u ubuntu -H pm2 save

echo "User Data deployment complete"
```

## 3. How the Script Works

| Command or tool | Purpose |
|---|---|
| `apt-get update` | Updates the package lists |
| `curl` | Downloads the application and Node.js setup script |
| `unzip` | Extracts the downloaded application |
| `npm install` | Installs the application dependencies |
| `pm2` | Manages the Node.js application process |
| `nginx` | Accepts HTTP requests on port 80 |
| `proxy_pass` | Forwards requests to the application on port 3000 |
| `systemctl enable nginx` | Enables Nginx to start on boot |

## 4. Test the Application

After launching the instance, wait for User Data to finish running.

1. Copy the instance's public IPv4 address from the EC2 console.
2. Open `http://YOUR-PUBLIC-IP:3000` to test the Node.js application directly.
3. Open `http://YOUR-PUBLIC-IP` to test access through Nginx. You may need to do this in incognito mode.
4. Confirm that the Tic-Tac-Toe application loads.

## 5. Troubleshooting

The script saves its output to:

```text
/var/log/user-data.log
```

If deployment fails, this log can help identify the command that caused the error. The EC2 console's system log may not include the complete contents of this file.

**Important:** User Data normally runs only during the instance's first boot. For another deployment test, launch a new EC2 instance with the updated script.

## Result

Successfully deployed the Node.js Tic-Tac-Toe application using AWS EC2 User Data, Node.js, PM2 and Nginx, without manually SSHing into the instance.