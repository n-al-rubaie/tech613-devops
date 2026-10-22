# Linux: Managing File Ownership

## Question 1: Why is managing file ownership important?

* File ownership is important for security and access control.
* It determines who owns a file and who is allowed to read, write or execute it.
* This helps prevent unauthorised users from accessing or changing important files.

## Question 2: What command is used to view file ownership?

* Use **`ls -l`** to view file ownership.
* For a specific file, use **`ls -l filename`**.
* Example: **`ls -l chicken-joke.txt`**
* The output shows the owner and group of the file.

## Question 3: What permissions are set when a user creates a file or directory? Who does the file or directory belong to?

* A newly created file or directory belongs to the user who created it and their primary group.
* **`umask`** controls the default permissions of new files and directories.
* Files start with **`666`** permissions before the umask is applied.
* Directories start with **`777`** permissions before the umask is applied.
* The actual permissions depend on the user's umask.

With a typical umask of **`022`**:

* File: `666 - 022 = 644`
* Directory: `777 - 022 = 755`

### File Permissions Example

**`-rw-r--r-- file`**

* **`-`** = regular file, not a directory.
* Owner/User: **`rw-`** = read and write.
* Group: **`r--`** = read only.
* Others: **`r--`** = read only.

### Directory Permissions Example

**`drwxr-xr-x directory`**

* **`d`** = directory.
* Owner/User: **`rwx`** = read, write and execute.
* Group: **`r-x`** = read and execute.
* Others: **`r-x`** = read and execute.

## Question 4: Why does the owner, by default, not receive execute permission when they create a file?

* Execute permission is not automatically given to newly created files for security reasons.
* A normal text file, for example, should not automatically be executable.
* If a file needs to be executable, use **`chmod +x filename`**.
* **`chmod`** stands for Change Mode.
* Directories normally receive execute permission because it allows users to enter or traverse the directory.

## Question 5: What command is used to change the owner of a file or directory?

* Use **`chown`** to change the owner of a file or directory.
* Example: **`sudo chown john file.txt`**
* To change the owner of a directory and everything inside it, use **`sudo chown -R john directoryname`**.
* **`chown`** means “change owner”.
* **`-R`** means recursive, so ownership is changed for the directory and its contents.

---

# Linux: Managing File Permissions

## Question 1: Does being the owner of a file mean you have full permissions on that file? Explain.

* No. Being the owner does not automatically mean you have full permissions.
* The owner can have any combination of read, write and execute permissions depending on the permissions set on the file.
* Example: **`-r--r--r--`** means the owner is only allowed to read the file.

## Question 2: If you give permissions to the User entity, what does this mean?

* **User/Owner:** The owner of the file.
* Example: `rw-` means the owner can read and write.

## Question 3: If you give permissions to the Group entity, what does this mean?

* **Group:** Users who belong to the group that owns the file.
* Example: `r--` means members of that group can read the file.

## Question 4: If you give permissions to the Other entity, what does this mean?

* **Other:** Everyone who is not the owner and is not a member of the file's group.
* Example: `r--` means those users can read the file.

## Question 5: You give a file User read-only, Group read and write, and Other read, write and execute permissions. If you are the owner, what permissions will you have? Explain.

If a file has these permissions:

* User: **`r--`** = read only.
* Group: **`rw-`** = read and write.
* Other: **`rwx`** = read, write and execute.

If you are the owner, Linux uses the User permissions for you. It does not combine your User permissions with the Group or Other permissions.

Therefore, the owner can read the file but cannot write to or execute it.

## Question 6: What can you work out about the permissions and details from this `ls -l` output?

Example:

**`-rwxr-xr-- 1 tcboony staff 123 Nov 25 18:36 keeprunning.sh`**

### File Type

* **`-`** = regular file, not a directory.

### Permissions

The remaining nine characters are **`rwx r-x r--`**:

* User: **`rwx`** = read, write and execute.
* Group: **`r-x`** = read and execute.
* Other: **`r--`** = read only.

### Ownership and Other Information

* **`tcboony`** = file owner.
* **`staff`** = group that owns the file.
* **`1`** = number of hard links to the file.
* **`123`** = file size in bytes.
* **`Nov 25 18:36`** = last modification date and time.
* **`keeprunning.sh`** = filename.

A hard link is another name or directory entry that points to the same file data. If there are two hard links, they are two names pointing to the same data.

Because the filename ends in `.sh` and the owner has execute permission, the owner can execute the shell script.

---

# Linux: Managing File Permissions Using Numeric Values

## Question 1: What numeric values are assigned to each permission?

Linux permissions use numeric values called octal values.

| Permission    | Symbol | Numeric value |
| ------------- | ------ | ------------: |
| Read          | `r`    |             4 |
| Write         | `w`    |             2 |
| Execute       | `x`    |             1 |
| No permission | `-`    |             0 |

## Question 2: What numeric value represents read + write?

* Read + Write: **`4 + 2 = 6`**

## Question 3: What numeric value represents read + write + execute?

* Read + Write + Execute: **`4 + 2 + 1 = 7`**

## Question 4: What numeric value represents read + execute?

* Read + Execute: **`4 + 1 = 5`**

## Question 5: What does `644` mean?

The three numbers represent permissions for **User/Owner**, **Group** and **Other**.

* **`6`** = User/Owner: read + write (`rw-`).
* **`4`** = Group: read only (`r--`).
* **`4`** = Other: read only (`r--`).

Therefore, **`644` = `rw-r--r--`**. The owner can read and write, while the group and others can only read.

To test this on your VM:

* **`chmod 644 test.txt`**
* **`ls -l test.txt`**

Expected permissions: **`-rw-r--r--`**

---

# Linux: Changing File Permissions

## Question 1: What command changes file permissions?

* Use **`chmod`** to change the permissions of files and directories.
* **`chmod`** means Change Mode.

## Question 2: To change permissions on a file, what must the end user be? (Two answers.)

The user must be either:

* The owner of the file.
* The root user, or a user using **`sudo`**.

## Question 3: How do you set User to read, Group to read + write + execute, and Other to read + write only?

Required permissions:

* User: **`r--`** = `4`
* Group: **`rwx`** = `7`
* Other: **`rw-`** = `6`

Using numeric notation:

* **`chmod 476 testfile.txt`**

Using symbolic notation:

* **`chmod u=r,g=rwx,o=rw testfile.txt`**

## Question 4: What command adds execute permissions to all entities?

* Use **`chmod a+x testfile.txt`**.
* **`a`** = all (User, Group and Other).
* **`+x`** = add execute permission.
* You can also use **`chmod +x testfile.txt`** to add execute permission for all three entities.

## Question 5: What command removes write permission from Group?

* Use **`chmod g-w testfile.txt`**.
* **`g`** = Group.
* **`-w`** = remove write permission.

## Question 6: How do you use numeric values to give read + write to User, read to Group, and no access to Other?

Required permissions:

* User: read + write = **`6`**
* Group: read = **`4`**
* Other: no permissions = **`0`**

Use:

* **`chmod 640 testfile.txt`**

This gives **`640 = rw-r-----`**:

* User: **`rw-`**
* Group: **`r--`**
* Other: **`---`**

---

# Linux: Streams

## Question 1: What is a stream in Linux?

* A stream is a flow of data between a command and somewhere it can be sent, such as the terminal or a file.
* Linux commands use streams to receive input and produce output.

## Question 2: What are the three data streams?

| Stream                     | Number | Simple meaning                | Example                             |
| -------------------------- | -----: | ----------------------------- | ----------------------------------- |
| Standard input (`stdin`)   |      0 | Data going into a command     | Typing input for a command          |
| Standard output (`stdout`) |      1 | Normal results from a command | A list of files                     |
| Standard error (`stderr`)  |      2 | Error messages from a command | A file or directory cannot be found |

## Question 3: Create a new file called `new.txt` and run `ls missing_directory new.txt`. How does this produce output to two different streams?

Create a new file called `new.txt`, then run:

* **`ls missing_directory new.txt`**

This should produce output to two different streams:

* The error message about `missing_directory` is sent to **stderr**.
* The listing for `new.txt` is sent to **stdout**.

ubuntu@ip-172-31-49-33:~$ ls missing_directory new.txt

ls: cannot access 'missing_directory': No such file or directory

new.txt


## Question 4: How can you direct each stream to a file, one at a time?

Use the redirection operator **`>`**.

### Redirect Standard Output

* **`ls missing_directory new.txt > output.txt`**
* This sends normal output to `output.txt`.
* The error message still appears in the terminal.

### Redirect Standard Error

* **`ls missing_directory new.txt 2> errors.txt`**
* This sends the error message to `errors.txt`.
* Normal output still appears in the terminal.

## Question 5: How can you direct both output streams to separate files in one command?

* **`ls missing_directory new.txt > output.txt 2> errors.txt`**
* Normal output goes to `output.txt`.
* Error output goes to `errors.txt`.

## Question 6: Which stream is directed to a file by default?

* Standard output (**`stdout`**, stream 1) is the default stream for the **`>`** redirection operator.
* Example: **`ls > files.txt`**
* This sends the normal output of `ls` to `files.txt`.

## Question 7: How can you direct both output streams to one file in one command?

Use:

* **`ls missing_directory new.txt > all_output.txt 2>&1`**

This means:

* **`> all_output.txt`** redirects standard output (1) to the file.
* **`2>&1`** redirects standard error (2) to wherever standard output is currently going.
* Both normal output and error messages go into `all_output.txt`, replacing its previous contents.

An alternative, shorter syntax in Bash is:

* **`ls missing_directory new.txt &> all_output.txt`**

Both forms redirect standard output and standard error to the same file, overwriting its previous contents.

---

# Linux: Redirection and Appending

## Question 1: What does `>` do?

* The **`>`** operator redirects output to a file, replacing the file's existing contents if it already exists.
* If the file does not exist, Linux creates it.
* Example: **`ls > msg.txt`**
* This sends the output of `ls` to `msg.txt`, replacing its previous contents.

## Question 2: How is appending different from overwriting?

* Appending adds new output to the end of a file without deleting its existing contents.
* **`>`** = overwrite the file's contents.
* **`>>`** = append to the end of the file.

## Question 3: Give an example of a command that appends to a file.

* **`ls >> msg.txt`**
* This adds the output of `ls` to the end of `msg.txt`, preserving anything already in the file.

Try it on your AWS Linux VM:

1. Run **`echo "First line" > msg.txt`**.
2. Run **`echo "Second line" >> msg.txt`**.
3. Run **`cat msg.txt`**.

Expected output:

```
First line
Second line
```

* The first command creates or overwrites the file.
* The second appends a new line to it.
* **`echo`** displays text or the value of a variable.

## Practice: How can you demonstrate that `>` overwrites and `>>` appends?

Run these three commands in your AWS Linux terminal:

* **`ls > msg.txt`** — writes your file listing to `msg.txt`.
* **`ls >> msg.txt`** — appends another file listing to the same file.
* **`cat msg.txt`** — displays the contents so you can check the result.

If you can see the file listing repeated twice, you have demonstrated that **`>`** overwrites and **`>>`** appends.
