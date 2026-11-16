# Using SSH to Push Changes to GitHub

## Overview

1. Create SSH Key pair (RSA) (Consists of public/private key)
2. Register padlock with public key (setting: any repo can be accessed)
3. Add private key to SSH register
4. Create test repo
5. Push changes to test repo

---

# Step 1: Create RSA Key Pair

In Git Bash terminal, go to the `.ssh` folder:

```bash
ssh-keygen -t rsa -b 4096 -C "yourownpersonalemail"
```

Name for key:

```text
firstname-github-key
```

![RSA Key Generation](image.png)

---

# Step 2: Register Padlock with Public Key on GitHub

Get your public key via Bash:

```bash
cat nowres-github-key.pub
```

![Public Key](image-1.png)

Go to **GitHub → Settings → SSH and GPG keys**.

Create a new SSH key, paste the public key, then click **Add SSH key**.

![Add SSH Key](image-3.png)

---

# Step 3: Add Private Key to SSH Register

Start SSH Agent, add with backticks:

```bash
eval `ssh-agent -s`
```

**pid** = process ID

![SSH Agent Started](image-4.png)

Then run:

```bash
ssh-add nowres-github-key
```

![SSH Add](image-5.png)

Then run:

```bash
ssh -T git@github.com
```

![SSH Connection Test](image-6.png)

---

# Step 4: Create Test Repo

Create a new repository called:

```text
tech613-ssh-test
```

---

# Step 5: Push Changes to Repo

Make a new directory in Bash in your local GitHub folder:

```bash
mkdir tech613-ssh-test
```

Then run:

```bash
git init
```

Then run:

```bash
git remote add origin git@github.com:n-al-rubaie/tech613-ssh-test.git
```

![Git Remote](image-7.png)

Create a new `.md` file with the title:

```text
Hello
```

![Create README](image-8.png)

Then add, commit and push the project to GitHub.

![Push to GitHub](image-9.png)

---

# Result

The project has now successfully been pushed using SSH.