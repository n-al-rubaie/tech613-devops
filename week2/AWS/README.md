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
