# Node.js App Provisioning with Bash and PM2

## Objective

Create a Bash script called `provision-app.sh` to automate deploying a Node.js application on an Ubuntu AWS EC2 server.


## 1. Prerequisites

- An Ubuntu EC2 virtual machine on AWS.
- A Node.js application ZIP file copied to the server.
- Node.js and npm installed on the server.
- SSH access to the server.

## 2. Create the Bash Script

**Where:** On the Ubuntu EC2 server, using the SSH terminal.

Create the script:

```bash
nano /home/ubuntu/provision-app.sh
```

Add the following code:

```bash
#!/bin/bash
set -e

# Configuration
APP_ZIP="/home/ubuntu/app.zip"
APP_DIR="/home/ubuntu/app"
APP_NAME="tic-tac-toe"

# Check that the ZIP file exists
if [ ! -f "$APP_ZIP" ]; then
    echo "Error: ZIP file not found"
    exit 1
fi

# Install unzip
sudo apt-get update
sudo apt-get install -y unzip

# Extract the application
mkdir -p "$APP_DIR"
unzip -o "$APP_ZIP" -d /home/ubuntu

# Install dependencies
cd "$APP_DIR"
npm install

# Install PM2 if it is not installed
if ! command -v pm2 >/dev/null 2>&1; then
    sudo npm install -g pm2
fi

# Start or restart the application
if pm2 describe "$APP_NAME" >/dev/null 2>&1; then
    pm2 restart "$APP_NAME"
else
    pm2 start npm --name "$APP_NAME" -- start
fi

echo "Application deployment complete"
pm2 status
```

Save in Nano using `Ctrl + O`, press `Enter`, then `Ctrl + X`.

## 3. Run the Script

**Where:** Ubuntu EC2 SSH terminal.

Make the script executable:

```bash
chmod +x /home/ubuntu/provision-app.sh
```

Run it:

```bash
/home/ubuntu/provision-app.sh
```

The script extracts the ZIP, installs dependencies, installs PM2 if necessary, and starts or restarts the application.

## 4. Check the Application

**Where:** Ubuntu EC2 SSH terminal.

Check PM2 status:

```bash
pm2 status
```

View application logs:

```bash
pm2 logs tic-tac-toe
```

The application listens on port `3000`. If the EC2 security group permits access to that port, open the following URL in your browser, replacing the IP with your instance's public IP:

```text
http://YOUR_EC2_PUBLIC_IP:3000
```

## Start the Application with PM2

Where: Ubuntu EC2 SSH terminal.

Run the following command to start the application:

```bash
pm2 start tic-tac-toe
```

Check the application status:

```bash
pm2 status
```

Note: This command assumes tic-tac-toe is a valid script or application target for PM2. If it is already registered as a PM2 process name, use pm2 restart tic-tac-toe to restart it instead.

## 5. Copy the Script to the GitHub Repository

**Where:** Windows Git Bash, not the Ubuntu SSH terminal.

Navigate to your local repository:

```bash
cd ~/github/tech613-devops
```

Copy the script from the Ubuntu server:

```bash
scp -i ~/.ssh/tech613-nowres-aws-key.pem \
ubuntu@YOUR_EC2_PUBLIC_IP:/home/ubuntu/provision-app.sh \
week_4/scripts/provision-app.sh
```

Replace `YOUR_EC2_PUBLIC_IP` with your EC2 instance's public IP address.

## 6. Push the Script to GitHub

**Where:** Windows Git Bash, inside your local repository.

Stage the script:

```bash
git add .
```

Commit the changes:

```bash
git commit -m "Add Node.js app provisioning script"
```

Push to GitHub:

```bash
git push
```

Check the repository status:

```bash
git status
```

## 7. Key Terms

- **Bash:** A command-line shell used to run commands and scripts.
- **Provisioning:** Preparing and configuring a server to run an application.
- **npm:** Installs and manages Node.js packages and dependencies.
- **PM2:** Manages Node.js application processes and restarts applications if needed.
- **Idempotency:** Running a script repeatedly produces the intended result without creating duplicate processes.

## Important Notes

- The ZIP file must exist at `/home/ubuntu/app.zip` on the server.
- The script assumes the ZIP is already on the folder, it extracts the application into `/home/ubuntu/app` and that `package.json` defines a working `start` command.
- The script checks whether the PM2 process exists before starting it, helping prevent duplicate processes.
- The script should be committed and pushed to GitHub as part of the assignment.