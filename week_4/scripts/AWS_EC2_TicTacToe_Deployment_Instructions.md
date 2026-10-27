# Deploying the Tic-Tac-Toe Node.js Application on AWS EC2

These instructions cover launching an Ubuntu EC2 instance, installing Node.js using EC2 User data, deploying the Tic-Tac-Toe application from GitHub, and opening it in a browser. The point of this workflow is to automate the process of setting up a server and deploying your application, rather than manually installing and configuring everything each time.

## Overview

The process has two parts:

1. **EC2 User data** installs the basic prerequisites when the instance first launches.
2. **`provision-app.sh`** deploys the application, starts it with PM2, and configures Nginx as a reverse proxy.

Repository: `https://github.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1`

## 1. Launch an EC2 instance

1. Open **AWS Console → EC2 → Instances → Launch instances**.
2. Give the instance a name, such as `tech613-nowres-tictactoe`.
3. Select **Ubuntu Server 24.04 LTS** and the instance type required by your course.
4. Select or create an EC2 key pair. Keep the private key secure.
5. Configure these inbound security group rules:

| Type | Port | Source | Purpose |
|---|---:|---|---|
| SSH | 22 | My IP | Connect to the instance |
| HTTP | 80 | `0.0.0.0/0` | Allow website traffic |

You generally do not need to expose port 3000 publicly because Nginx receives traffic on port 80 and forwards it to the Node.js application on port 3000. Avoid opening SSH to everyone (`0.0.0.0/0`) unless your course specifically requires it.

## 2. Add the EC2 User data script

During instance setup, expand **Advanced details**, find **User data**, and paste:

```bash
#!/bin/bash
set -e

# Update Ubuntu packages
apt-get update -y

# Install Git and prerequisites
apt-get install -y git curl

# Install Node.js 20 and npm
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Verify installations in the cloud-init log
node --version
npm --version
git --version

# Indicate setup completion
echo "Server prerequisites installed successfully"
```

Launch the instance.

**Important:** EC2 User data normally runs during the instance's first boot. This script installs Git, curl, Node.js 20 and npm. It does **not** deploy the application or install/configure Nginx and PM2.

## 3. Wait for the instance to initialise

In **EC2 → Instances**, wait until the instance state is `Running` and status checks show `2/2 checks passed`. Copy its **Public IPv4 address**.

## 4. Connect using SSH

Open Git Bash on your Windows computer. Change to the folder containing your EC2 private key. For example:

```bash
cd ~/Downloads
```

Connect using your key filename and the instance's public IP address:

```bash
ssh -i "tech613-nowres-aws-key.pem" ubuntu@YOUR_PUBLIC_IP
```

Replace `YOUR_PUBLIC_IP` with the instance's actual public IPv4 address. Adjust the key filename/path if yours differs. If SSH asks whether to continue connecting, verify the host details and type `yes`.

## 5. Start the application
Run the command below in the Ubuntu terminal:
```bash
pm2 start npm --name "tic-tac-toe" -- start
```

If an error appears, go step step 6.

If no errors appear after running, then view the program by running in your url:

```text
http://YOUR_PUBLIC_IP
```



## 6. Verify the prerequisites

Run on the EC2 instance:

```bash
node --version
npm --version
git --version
```

You should see version numbers; Node.js should begin with `v20`.

If Node.js or npm is missing, inspect the User data log:

```bash
sudo tail -n 80 /var/log/cloud-init-output.log
```

You can retry installation with:

```bash
sudo apt-get update
sudo apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Verify the versions again afterwards.

## 7. Download the deployment script from GitHub

Run on the EC2 instance:

```bash
curl -fL https://raw.githubusercontent.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1/main/provision-app.sh -o /tmp/provision-app.sh
```

This saves the script to `/tmp/provision-app.sh`. The repository must be public, and the script must exist at that path in the `main` branch.

## 8. Run the deployment script

```bash
bash /tmp/provision-app.sh
```

The script is intended to:

1. Install Git and Nginx if needed.
2. Clone the Tic-Tac-Toe repository into `/home/ubuntu/app`, or pull the latest code if it is already a Git repository.
3. Install application dependencies with `npm install`.
4. Install PM2 if needed.
5. Start or restart the app using PM2.
6. Configure Nginx to forward HTTP requests from port 80 to `http://127.0.0.1:3000`.
7. Test the Nginx configuration and reload Nginx.

Wait for the command to finish. If it reports an error, inspect the error before continuing.

## 9. Check the application and services

Check PM2:

```bash
pm2 status
```

The `tic-tac-toe` process should show as `online`.

Check Nginx:

```bash
sudo systemctl status nginx
```

Nginx should show as `active (running)`. Press `q` to exit the status screen.

Test the site from the EC2 instance:

```bash
curl -I http://localhost
```

A response such as `HTTP/1.1 200 OK` indicates that the web server is responding. Other valid responses can occur depending on the app.

## 10. Open the website

Copy the instance's current **Public IPv4 address** from the EC2 console and visit:

```text
http://YOUR_PUBLIC_IP
```

Replace `YOUR_PUBLIC_IP` with the actual address. Use `http://` unless you have separately configured HTTPS.

If the site does not load, check:
- The instance is running and passed its status checks.
- The security group allows inbound HTTP on port 80.
- Nginx is active: `sudo systemctl status nginx`.
- PM2 shows the app online: `pm2 status`.
- The application is listening on port 3000.

Useful diagnostics:

```bash
pm2 logs tic-tac-toe
sudo tail -n 80 /var/log/nginx/error.log
sudo tail -n 80 /var/log/cloud-init-output.log
```

## 11. Important notes

- **User data and deployment are separate in this setup.** User data installs Git, curl, Node.js and npm. You then SSH into the instance and run `provision-app.sh` manually.
- **User data does not automatically copy your deployment script.** The `curl` command in Step 6 downloads it from GitHub.
- **User data usually runs on first boot only.** Changing User data later does not mean it will automatically run again on an existing instance.
- **PM2 after reboot:** `pm2 save` saves the process list, but by itself does not configure PM2 to start after reboot. If required, configure PM2 startup for the `ubuntu` user and follow the command PM2 prints.
- **Security:** Keep your private key secure. Restrict SSH to your own IP where possible, and avoid exposing port 3000 publicly when Nginx serves the app on port 80.

## Quick command summary

Run these commands on the EC2 instance after connecting by SSH:

```bash
# Check installed tools
node --version
npm --version
git --version

# Download deployment script
curl -fL https://raw.githubusercontent.com/n-al-rubaie/nodejs20-sparta-tictactoe-v1/main/provision-app.sh -o /tmp/provision-app.sh

# Deploy the application
bash /tmp/provision-app.sh

# Check services
pm2 status
sudo systemctl status nginx

# Test Nginx locally
curl -I http://localhost
```
