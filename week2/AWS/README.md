# AWS Virtual Machine

## SSH Folder

* Store SSH keys in the `.ssh` folder.
* Store SSH keys securely.

## AWS Rules

* Select **EU West 1** region.
* Stop VMs when not using them or by COB.
* Use **Stop**, not **Terminate**, when shutting down a VM temporarily.

## Create SSH Key Pair

* Go to **EC2** in AWS.
* Click **Key Pairs**.
* Click **Create Key Pair**.
* Name: `tech613-nowres-aws-key`
* Key pair type: **ED25519**
* Private key file format: **.pem**
* Download the `.pem` file.
* Save the `.pem` file in the `.ssh` folder.

## Create the VM

* Go to **Instances**.
* Click **Launch instances**.
* VM name: `tech613-nowres-first-vm`
* OS: **Ubuntu**
* Ubuntu version: **24.04**
* Instance type: **t3.micro**
* Key pair: `tech613-nowres-aws-key`
* Firewall: **Create Security Group**
* Allow **SSH traffic from Anywhere**.
* Allow **HTTP traffic from the internet**.
* Click **Edit** under Network settings.
* Security group name: `tech613-nowres-allow-ssh-http`
* Launch the instance.

## Connect to the VM

* Open the VM in AWS.
* Click **Connect**.
* Select **In SSH client**.
* Go to **Option 3: Ensure your key is not publicly viewable**.
* Open Git Bash.
* Go to the SSH folder:

  * `cd ~/.ssh/`
* Make the key read-only:

  * `chmod 400 "tech613-nowres-aws-key.pem"`
* Check the file permissions:

  * `ls -l tech613-nowres-aws-key.pem`
* Confirm the key has read-only permissions. It should start with `-r--`

## SSH Into the VM

* Go to **Connect → SSH client** in AWS.
* Copy the SSH command from **Option 4: Connect to your instance using its Public DNS**.
* Paste it into Git Bash.
* Example:

  * `ssh -i "tech613-nowres-aws-key.pem" ubuntu@ec2-52-16-102-34.eu-west-1.compute.amazonaws.com`
* Type `yes` when prompted.
* You are now logged into the VM.

## Stop and Start the VM

* In AWS, select the instance.
* Click **Instance state**.
* Select **Stop** when finished using the VM.
* Select **Start** when you need to use it again.
* Do **not** select **Terminate** unless you want to delete the VM.

## Reconnect After Starting

* Starting the VM changes its public IP address.
* Go to the instance in AWS.
* Click **Connect**.
* Select **SSH client**.
* Copy the new SSH command from **Option 4**.
* Paste the command into Git Bash.
* Connect to the VM.


# Installing and running Nginx on an AWS Virtual Machine

## 1. Copy the Installation Script to the VM

Use `scp` (Secure Copy Protocol) to transfer `install-nginx.sh` from your local computer to your AWS VM.

Run this command in **Git Bash on your local computer**, not inside the SSH session.

```bash
scp -i ~/.ssh/tech613-nowres-aws-key.pem /c/Users/nalru/github/tech613-devops/week2/linux/scripts/install-nginx.sh ubuntu@YOUR_PUBLIC_IP:~
```

**Explanation:**

* `scp` - securely copies files between computers.
* `-i` - specifies the SSH private key to use.
* `~/.ssh/tech613-nowres-aws-key.pem` - the path to your private key.
* `/c/Users/nalru/github/tech613-devops/week2/linux/scripts/install-nginx.sh` - the location of the script on your local computer.
* `ubuntu@YOUR_PUBLIC_IP` - the Ubuntu user and public IP address of your AWS VM.
* `:~` - copies the file to the remote user's home directory.

Replace `YOUR_PUBLIC_IP` with your VM's actual public IP address.

## 2. Connect to the AWS VM

Run this command in Git Bash:

```bash
ssh -i ~/.ssh/tech613-nowres-aws-key.pem ubuntu@YOUR_PUBLIC_IP
```

**Explanation:**

* `ssh` - securely connects to a remote computer.
* `-i` - specifies the private key used for authentication.
* `ubuntu` - the default username for the Ubuntu EC2 image.
* `YOUR_PUBLIC_IP` - the public IP address of the VM.

## 3. Check That the Script Was Copied

Once connected to the VM, run:

```bash
ls -l install-nginx.sh
```

**Explanation:**

* `ls` - lists files and directories.
* `-l` - displays detailed file information, including permissions and ownership.
* `install-nginx.sh` - the file you want to check.

## 4. Make the Script Executable

Run:

```bash
chmod +x install-nginx.sh
```

**Explanation:**

* `chmod` - changes file permissions.
* `+x` - adds execute permission.
* `install-nginx.sh` - the script to which you are adding execute permission.

This allows you to run the script as a program.

## 5. Run the Nginx Installation Script

Run:

```bash
./install-nginx.sh
```

**Explanation:**

* `./` - tells Linux to run a file from the current directory.
* `install-nginx.sh` - the shell script that installs and configures Nginx.

The script should execute its commands, which may include updating package lists and installing Nginx.

## 6. Check That Nginx Is Running

Run:

```bash
sudo systemctl status nginx
```

**Explanation:**

* `sudo` - runs the command with administrator privileges.
* `systemctl` - manages system services.
* `status` - displays the current status of a service.
* `nginx` - the web server service.

Look for:

```text
Active: active (running)
```

Press `q` to exit the status screen.

## 7. Open the Nginx Welcome Page

Open a web browser and enter:

```text
http://YOUR_PUBLIC_IP
```

Replace `YOUR_PUBLIC_IP` with the public IP address of your AWS VM.

You should see the **Welcome to nginx!** page.

**Important:** Use `http://`, not `https://`.

The EC2 security group's inbound rules must allow HTTP traffic on port `80` from your browser.

## Summary of Commands

```bash
# Copy the script from your computer (local Git Bash)
scp -i ~/.ssh/tech613-nowres-aws-key.pem /c/Users/nalru/github/tech613-devops/week2/linux/scripts/install-nginx.sh ubuntu@YOUR_PUBLIC_IP:~

# Connect to the VM
ssh -i ~/.ssh/tech613-nowres-aws-key.pem ubuntu@YOUR_PUBLIC_IP

# Check that the script exists (inside the VM)
ls -l install-nginx.sh

# Make the script executable
chmod +x install-nginx.sh

# Run the script
./install-nginx.sh

# Check the Nginx service
sudo systemctl status nginx
```

**Expected result:** Nginx is running, and visiting `http://YOUR_PUBLIC_IP` displays the Nginx welcome page.
