# Python & Git Notes for DevOps

## Virtual Environment in PyCharm

A virtual environment is an isolated Python environment for a project. It keeps each project's packages and dependencies separate, avoiding conflicts with other projects.

It lets you:

- Install packages for one project without affecting other projects.
- Use different package versions for different projects.
- Avoid conflicts between dependencies.

### Example

Suppose:

- Project A needs Django 4.2
- Project B needs Django 5.0

Without virtual environments, these versions could conflict. With separate virtual environments, each project gets its own Django version.

---

## Python Basics

### Find Python Version (Git Bash)

```bash
python --version
```

### Run Python Interpreter

```bash
python
```

### Exit Python Interpreter

```python
exit()
```

---

## Variables and Types

```python
hostname = "web-01"
port = 8801
disk_used_percent = 41.5
is_healthy = True

print(type(hostname))
print(type(port))
print(type(disk_used_percent))
print(type(is_healthy))
```

---

## Type Casting

```python
port_from_file = "8801"

if int(port_from_file) == 8801:
    print("match")
else:
    print("no match")
```

Common conversions:

```python
int("8801")      # 8801
float("41.5")   # 41.5
str(8801)       # "8801"
```

---

## Commenting Code

Highlight lines and press:

```text
Ctrl + /
```

---

## Arithmetic Operators

```python
total_checks = 8
failed_checks = 2

passed = total_checks - failed_checks
pass_rate = passed / total_checks

print(passed)
print(pass_rate)
```

---

## Comparison Operators

```python
disk_used = 94
threshold = 85

print(disk_used > threshold)    # True
print(disk_used == threshold)   # False
```

---

## F-Strings (Formatted Strings)

```python
hostname = "api-01"
status = "degraded"

print(f"{hostname} is {status}")
```

Output:

```text
api-01 is degraded
```

---

## String Concatenation

```python
print(hostname + " is " + status)
```

### F-String vs Concatenation

```python
hostname = "api-01"
port = 8801

print(f"{hostname} listening on {port}")     # Works

# print(hostname + " listening on " + port) # Error
```

---

## Formatting Numbers

```python
response_time = 2.8441562652587891

print(f"Responded in {response_time} seconds")
print(f"Responded in {response_time:.2f} seconds")
```

Output:

```text
Responded in 2.84 seconds
```

---

## Formatting Percentages

```python
used = 94
total = 100

print(f"Disk {used / total:.1%} full")
```

Output:

```text
Disk 94.0% full
```



# Collections for DevOps

## Lists

### Create a List

```python
hosts = ["web-01", "web-02", "api-01"]

print(hosts[0])     # web-01
print(hosts[-1])    # api-01
print(len(hosts))   # 3
```

---

### Add and Remove Items

```python
hosts = ["web-01", "web-02"]

hosts.append("api-01")
hosts.remove("web-01")

print(hosts)
```

Output:

```text
['web-02', 'api-01']
```

---

### Loop Through a List

```python
for host in ["web-01", "web-02", "api-01"]:
    print(f"Checking {host}")
```

Output:

```text
Checking web-01
Checking web-02
Checking api-01
```

---

## Tuples

Tuples are ordered collections that cannot be modified.

```python
server = ("web-01", 8801)

hostname, port = server

print(f"{hostname} on {port}")
```

Output:

```text
web-01 on 8801
```

---

## Dictionaries

### Create a Dictionary

```python
server = {
    "hostname": "web-01",
    "environment": "production",
    "port": 8801,
    "disk_used": 41,
}

print(server["hostname"])
print(server["port"])
```

Output:

```text
web-01
8801
```

---

### Using `.get()`

```python
server = {"hostname": "web-01"}

print(server.get("port"))         # None
print(server.get("port", 8801))   # 8801
```

Output:

```text
None
8801
```

---

### Loop Through a Dictionary

```python
server = {
    "hostname": "web-01",
    "port": 8801,
    "disk_used": 41
}

for key, value in server.items():
    print(f"{key}: {value}")
```

Output:

```text
hostname: web-01
port: 8801
disk_used: 41
```

---

## Nested Data Structures

### List of Dictionaries

```python
inventory = [
    {"hostname": "web-01", "environment": "production", "bytes": 8419203},
    {"hostname": "api-01", "environment": "production", "bytes": 15220477},
    {"hostname": "web-01-stg", "environment": "staging", "bytes": 402117},
]

print(inventory[0]["hostname"])
```

Output:

```text
web-01
```

---

### Dictionary Containing a List

```python
config = {
    "site": "eu-west",
    "servers": [
        {"hostname": "web-01", "port": 8801},
        {"hostname": "api-01", "port": 8802},
    ],
}

print(config["servers"][0]["port"])
```

Output:

```text
8801
```

---

## Summing Values

```python
inventory = [
    {"hostname": "web-01", "bytes": 8419203},
    {"hostname": "api-01", "bytes": 15220477},
    {"hostname": "db-01", "bytes": 2044118},
]

total_bytes = 0

for server in inventory:
    total_bytes += server["bytes"]

print(f"Bytes transferred {total_bytes}")
```

---

# Control Flow

## If / Elif / Else

```python
disk_used = 94

if disk_used >= 90:
    print("CRITICAL")
elif disk_used >= 80:
    print("WARNING")
else:
    print("OK")
```

Output:

```text
CRITICAL
```

---

## Checking for Empty Lists

```python
failed_checks = []

if not failed_checks:
    print("All checks passed")
else:
    print(f"{len(failed_checks)} 