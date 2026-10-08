# Initial Git Setup

## View Git Configuration

* View all configurations:

  * `git config --list`

## Add Git Name

* Set username globally:

  * `git config --global user.name "Nowres"`

## Add Git Email

* Set email globally:

  * `git config --global user.email "email@outlook.com"`

## Git Configuration Levels

* **System** – applies to all users on the computer.
* **Global** – applies to the current user.
* **Local** – applies only to the current repository.

### Set Default Branch to Main

* Global:

  * `git config --global init.defaultBranch main`

* System:

  * `git config --system init.defaultBranch main`

* Local:

  * `git config --local init.defaultBranch main`

* Local overrides Global and System.

* Global overrides System.

---

# Creating a Git Repository

## Create a Directory

* Print working directory:

  * `pwd`
* Create a directory:

  * `mkdir GitExample`
* Change directory:

  * `cd GitExample`
* List files:

  * `ls`
* List all files, including hidden files:

  * `ls -al`

## Initialise Git

* Create a new Git repository:

  * `git init`
* Git creates a hidden `.git` directory.
* `.git` contains Git history, branches and version-control information.

## Create a .gitignore File

* Create `.gitignore`:

  * `notepad .gitignore`
* `.gitignore` specifies files Git should ignore.

Example:

```text
# Exclude all properties files from my repo
*.properties
```

---

# Staging and Committing Files

## Create README

* Create the README file:

  * `notepad README.md`

Example content:

```text
# My repository README file

This is just a sentence so we can see what happens with changes.
```

## Check Repository Status

* Check the current status:

  * `git status`

## Add Files to Staging

* Add a specific file:

  * `git add README.md`
* Add all files:

  * `git add .`

## Commit Changes

* Create a commit:

  * `git commit -m "First Commit"`

* A commit saves a version of the files in the repository.

## View Differences

* Compare changes between the working directory and the repository:

  * `git diff`

* If `git diff` opens in a pager, press:

  * `q`

## Commit Tracked Changes

* Automatically stage modified/deleted tracked files and commit:

  * `git commit -a -m "Update files x and y"`

* `-a` does not bypass the staging area.

* Git automatically stages tracked changes before committing.

---

# Git History and Branches

## View Git History

* Show commit history:

  * `git log`

## View Branches

* Show branches:

  * `git branch`

## Rename Branch to Main

* Rename the current branch:

  * `git branch -M main`

## View an Earlier Commit

* Use the first few characters of the commit ID from `git log`:

  * `git checkout nfi3h4`

## Return to Main

* Return to the main branch:

  * `git checkout main`

## Git Reset

### Soft Reset

* Move the current branch back to an earlier commit while keeping changes:

  * `git reset --soft <commit>`

### Hard Reset

* Move the current branch back to an earlier commit and remove the changes from that commit:

  * `git reset --hard <commit>`

---

# Copying a Local Repository to GitHub

## HTTPS

### View Tracked Files

* Show files currently tracked by Git:

  * `git ls-files`

### Add GitHub Remote

* Connect the local repository to GitHub:

  * `git remote add origin https://github.com/n-al-rubaie/GitExample.git`

### Push to GitHub

* Push the main branch to GitHub:

  * `git push origin main`

---

# SSH Connection to GitHub

## Remove Existing Remote

* Remove the existing GitHub remote:

  * `git remote remove origin`

## Add SSH Remote

* Add the GitHub repository using SSH:

  * `git remote add origin git@github.com:n-al-rubaie/GitExample.git`

## Generate SSH Key

* Generate an RSA SSH key:

  * `ssh-keygen -t rsa -b 4096 -C "n.alrubaie@outlook.com"`

## View Public SSH Key

* Open the public key:

  * `notepad ~/.ssh/id_rsa.pub`

* Copy the key.

* Go to GitHub → Settings → SSH Keys.

* Click **Add new SSH key**.

* Paste the public key into the **Key** box.

## Push to GitHub

* Push the main branch:

  * `git push origin main`

---

# Git Cloning

## Clone a GitHub Repository

* Go to the root directory:

  * `cd ..`
* Check the current directory:

  * `pwd`
* Clone the repository:

  * `git clone https://github.com/n-al-rubaie/GitHubExample.git`
* Enter the project directory:

  * `cd GitHubExample/`

## Pull Changes

* Download and merge changes from the remote repository:

  * `git pull`

---

# Rename Files

* Rename `file1` to `file2`:

  * `mv file1 file2`

---

# Synchronising Local and Remote Repositories

## Fetch

* Download information about changes from the remote repository without merging:

  * `git fetch`

## Check Status

* Check whether the local repository is up to date:

  * `git status`

## Check Remote URLs

* View the URLs used for fetch and push:

  * `git remote -v`

---

# Git Bash

* `~` = home directory.
* The home directory is the default location when Git Bash opens.

---

# Visual Studio Code

* Open the current folder in VS Code:

  * `code .`





