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



from pathlib import Path

content = r'''# Python Functions, Files, JSON, Exceptions, Testing, YAML and CSV

## 1. Functions in Python

A function is a reusable block of code that performs a task.

```python
def greet_operator():
    print("Health check starting")


greet_operator()
```

Output:

```text
Health check starting
```

## 2. Functions with `return`

`return` sends a result back to the code that called the function.

```python
def is_healthy(status_code):
    return status_code == 200


print(is_healthy(200))  # True
print(is_healthy(500))  # False
```

Output:

```text
True
False
```

The expression `status_code == 200` checks whether the status code equals `200`. It returns either `True` or `False`.

## 3. Default Arguments

A default argument is used when a value is not supplied when calling the function.

```python
def check_disk(hostname, disk_used, threshold=85):
    return disk_used >= threshold


print(check_disk("build-01", 94))       # Uses threshold 85
print(check_disk("build-01", 94, 95))   # Uses threshold 95
```

Output:

```text
True
False
```

- The first call uses the default threshold of `85`.
- The second call supplies `95` as the threshold.
- `>=` means greater than or equal to.

## 4. The Problem with Using `[]` as a Default Argument

```python
def add_host(host, inventory=[]):
    inventory.append(host)
    return inventory


print(add_host("web-01"))
print(add_host("web-02"))
```

Output:

```text
['web-01']
['web-01', 'web-02']
```

**Problem:** Python creates the default list once when the function is defined. Calls that omit `inventory` reuse the same list, so entries from earlier calls remain.

### Safer Approach: Use `None`

```python
def add_host(host, inventory=None):
    if inventory is None:
        inventory = []
    inventory.append(host)
    return inventory


print(add_host("web-01"))
print(add_host("web-02"))
```

Output:

```text
['web-01']
['web-02']
```

When `inventory` is `None`, the function creates a new list for that call.

## 5. Docstrings

A **docstring** (documentation string) describes what a module, class or function does. It is written in triple quotes immediately after the definition.

```python
def is_healthy(status_code, healthy_codes=(200, 204)):
    """Return True if a status code counts as healthy.

    Args:
        status_code: the HTTP status code returned by the service
        healthy_codes: codes to treat as healthy

    Returns:
        bool
    """
    return status_code in healthy_codes


help(is_healthy)
# Alternatively:
# print(is_healthy.__doc__)
```

Example of the relevant help output:

```text
Help on function is_healthy in module __main__:

is_healthy(status_code, healthy_codes=(200, 204))
    Return True if a status code counts as healthy.

    Args:
        status_code: the HTTP status code returned by the service
        healthy_codes: codes to treat as healthy

    Returns:
        bool
```

The default tuple `(200, 204)` means that both status codes are treated as healthy.

## 6. Scope of a Function

Variables created inside a function are normally local to that function.

```python
def count_failures(results):
    total = 0
    for result in results:
        if not result:
            total += 1
    return total


print(count_failures([True, False, False]))
```

Output:

```text
2
```

- `total` is a local variable.
- `for result in results` checks each item.
- `if not result` is true when `result` is false.
- `total += 1` increases the count by one.
- `return total` returns the number of failures.

---

# Reading and Writing Files

## 7. `pathlib`

`pathlib` provides tools for working with file paths across operating systems.

```python
from pathlib import Path


log_file = Path("app.log")  # .log is the suffix
print(log_file.exists())
print(log_file.name)
print(log_file.suffix)
```

Example output when `app.log` does not exist in the current working directory:

```text
False
app.log
.log
```

- `.exists()` checks whether the path exists.
- `.name` returns the file name.
- `.suffix` returns the file extension, including the dot.

## 8. Putting Paths Together

```python
from pathlib import Path


config = Path("configs") / "targets.yaml"
print(config)
```

On Windows, the output may be:

```text
configs\targets.yaml
```

On Linux or macOS, it may be:

```text
configs/targets.yaml
```

Using `/` with a `Path` object joins path components using the correct path format for the operating system.

## 9. Reading a File with `read_text()`

UTF-8 is a character encoding that allows text to be stored as bytes and decoded correctly when read.

```python
from pathlib import Path


text = Path("app.log").read_text(encoding="utf-8")
print(len(text))
```

Example output for the supplied file:

```text
1857
```

`read_text()` reads the entire file and returns its contents as a string. `len(text)` returns the number of characters in that string.

The file must exist at the specified path, or Python raises an error.

## 10. Reading a File with `open()`

```python
file = open("app.log", encoding="utf-8")
text = file.read()
file.close()
```

- `open()` opens the file.
- `.read()` reads its contents.
- `.close()` closes the file.

If an error occurs before `.close()` runs, the file might not be closed properly.

## 11. Using `with open()`

Prefer `with open()` when working with files because it closes the file automatically when the block exits, including when an exception occurs.

```python
with open("app.log", encoding="utf-8") as file:
    text = file.read()


print(len(text))
```

Example output:

```text
1857
```

## 12. Reading a File Line by Line

```python
with open("app.log", encoding="utf-8") as file:
    for line in file:
        if "ERROR" in line:
            print(line.rstrip())
```

Example output:

```text
2026-09-14 06:02:44,158 ERROR [api-01] upstream timeout contacting db-01:5432
2026-09-14 06:04:00,556 ERROR [api-01-stg] worker did not exit within 10s, terminating
2026-09-14 06:07:41,209 ERROR [api-01] upstream timeout contacting db-01:5432
```

- `for line in file` reads the file one line at a time.
- `"ERROR" in line` checks whether the line contains the text `ERROR`.
- `.rstrip()` removes whitespace from the right-hand end, including the newline character `\n`.

## 13. String Methods for Working with Log Lines

```python
line = "2026-09-14 06:02:44,158 ERROR [api-01] upstream timeout"


print(line.strip())             # Removes whitespace at both ends
print(line.split())             # Splits on whitespace into a list
print(line.startswith("2026"))  # True
print("ERROR" in line)          # True
print(line.lower())             # Converts to lowercase
```

Output:

```text
2026-09-14 06:02:44,158 ERROR [api-01] upstream timeout
['2026-09-14', '06:02:44,158', 'ERROR', '[api-01]', 'upstream', 'timeout']
True
True
2026-09-14 06:02:44,158 error [api-01] upstream timeout
```

### `.strip()` vs `.rstrip()`

- `.strip()` removes whitespace from both the beginning and the end of a string.
- `.rstrip()` removes whitespace from the end (right-hand side) only.

## 14. File Modes

| Mode | Meaning |
|---|---|
| `"r"` | Read a file. This is the default mode. |
| `"w"` | Write to a file. Truncates an existing file to zero length first, or creates the file if it does not exist. |
| `"a"` | Append to the end of a file, creating it if necessary. |
| `"x"` | Create a new file. Raises an error if the file already exists. |

## 15. Writing to a File

```python
from pathlib import Path


lines = ["web-01 OK", "api-01 DEGRADED"]


with open("report.txt", "w", encoding="utf-8") as file:
    for line in lines:
        file.write(f"{line}\n")


print(Path("report.txt").read_text(encoding="utf-8"))
```

Output:

```text
web-01 OK
api-01 DEGRADED
```

- `"w"` opens the file for writing and replaces existing contents.
- `file.write()` writes text to the file.
- `\n` adds a newline after each item.
- `Path("report.txt").read_text()` reads the written file.

---

# JSON

## 16. What Is JSON?

JSON stands for **JavaScript Object Notation**. It is a text format used to store and exchange structured data between applications and machines.

JSON is similar to a Python dictionary, but their syntax differs.

| JSON | Python equivalent |
|---|---|
| Object `{}` | Dictionary (`dict`) |
| Array `[]` | List (`list`) |
| String | `str` |
| Number | `int` or `float` |
| `true` / `false` | `True` / `False` |
| `null` | `None` |

JSON uses double quotes around strings and object keys. Boolean values are lowercase in JSON.

JSON is commonly used in APIs, configuration files, web applications and logs.

## 17. `json.loads()`: Convert a JSON String into Python Data

```python
import json


# JSON stored inside a string
text = '{"hostname": "web-01", "port": 8801}'
server = json.loads(text)  # Converts the JSON string into a Python dictionary

print(server["hostname"])
print(type(server))
```

Output:

```text
web-01
<class 'dict'>
```

`json.loads()` parses a JSON string and converts it into the corresponding Python object.

## 18. `json.dumps()`: Convert Python Data into a JSON String

`json.dumps()` serialises a Python object, such as a dictionary, into a JSON-formatted string.

```python
import json


server = {"hostname": "web-01", "port": 8801}
print(json.dumps(server))
print(json.dumps(server, indent=2))
```

Output:

```json
{"hostname": "web-01", "port": 8801}
{
  "hostname": "web-01",
  "port": 8801
}
```

- `json.dumps(server)` returns a JSON string on one line.
- `indent=2` formats the JSON with two spaces of indentation to make it easier to read.

## 19. `json.load()` vs `json.loads()`

The main difference is where the JSON data comes from:

- `json.load()` reads JSON data from a file-like object.
- `json.loads()` reads JSON data from a string.

### Read JSON Using `Path.read_text()` and `json.loads()`

```python
import json
from pathlib import Path


data = json.loads(Path("inventory.json").read_text(encoding="utf-8"))
print(data["site"])
print(len(data["servers"]))
```

Example output:

```text
eu-west
8
```

Here, `read_text()` reads the file and returns a string. `json.loads()` then parses that string into a Python object.

### Read JSON Directly from a File Using `json.load()`

```python
import json


with open("inventory.json", encoding="utf-8") as file:
    data = json.load(file)


print(data["site"])
print(data["servers"][0]["hostname"])
```

Example output:

```text
eu-west
web-01
```

`json.load(file)` reads and parses the JSON directly from the open file.

## 20. Handling Invalid JSON

`try` tells Python to attempt to run the code in the block. `except` handles a matching error if one occurs.

The following JSON is invalid because it contains a trailing comma after `"web-01"`.

```python
import json


try:
    json.loads('{"hostname": "web-01",}')
except json.JSONDecodeError as error:
    print(f"Could not parse: {error}")
```

Example output (the exact wording can vary by Python version):

```text
Could not parse: Illegal trailing comma before end of object: line 1 column 22 (char 21)
```

### Another Invalid JSON Example

This JSON is missing a comma between the `"hostname"` and `"port"` values.

```python
import json


try:
    json.loads('{"hostname": "web-01" "port": 8801}')
except json.JSONDecodeError as error:
    print(f"line {error.lineno}, column {error.colno}: {error.msg}")
```

Example output:

```text
line 1, column 23: Expecting ',' delimiter
```

`JSONDecodeError` provides details about where parsing failed.

## 21. Write a JSON Report Using `json.dump()`

`json.dump()` writes JSON data to a file, whereas `json.dumps()` converts Python data into a JSON string.

```python
import json
from pathlib import Path


report = {
    "checked": 8,
    "healthy": 6,
    "problems": ["api-01", "api-01-stg"],
}


with open("report.json", "w", encoding="utf-8") as file:
    json.dump(report, file, indent=2)


print(Path("report.json").read_text(encoding="utf-8"))
```

Output:

```json
{
  "checked": 8,
  "healthy": 6,
  "problems": [
    "api-01",
    "api-01-stg"
  ]
}
```

- `json.dump(report, file, indent=2)` writes the report to the file.
- `"w"` creates the file if needed and replaces existing contents.
- `Path(...).read_text()` reads the saved JSON as text for printing.

---

# Exception Handling

## 22. What Is Exception Handling?

Exception handling lets a program handle errors instead of stopping unexpectedly.

- `try`: attempts to run the code.
- `except`: handles a matching exception.
- `ValueError`: an error often raised when a value has the correct general type but cannot be used for the requested conversion.

```python
try:
    port = int("not-a-port")
except ValueError:
    print("That is not a number")
```

Output:

```text
That is not a number
```

## 23. Display More Detail About an Error

Use `as error` to store the exception in a variable and display its message.

```python
try:
    port = int("not-a-port")
except ValueError as error:
    print(f"Could not read the port: {error}")
```

Output:

```text
Could not read the port: invalid literal for int() with base 10: 'not-a-port'
```

## 24. JSON String Exception Handling

```python
import json


try:
    config = json.loads("{broken")
except json.JSONDecodeError as error:
    print(f"Config is not valid JSON: {error}")
```

Example output:

```text
Config is not valid JSON: Expecting property name enclosed in double quotes: line 1 column 2 (char 1)
```

## 25. Using `except` to Set a Value to `None`

This code attempts to convert `"8801"` into an integer. If a matching exception occurs, it sets `value` to `None`.

```python
try:
    value = int("8801")
except Exception:
    value = None
```

Output:

```text
```

There is no output because the code contains no `print()` statement. The conversion succeeds, so `value` becomes the integer `8801`; the `except` block does not run.

**Note:** Catch a specific exception, such as `ValueError`, where possible instead of using `except Exception` unnecessarily.

## 26. Common Exceptions

| Exception | Common cause |
|---|---|
| `FileNotFoundError` | The file or directory cannot be found. |
| `PermissionError` | The operation is not permitted, often because of file permissions. |
| `json.JSONDecodeError` | The text is not valid JSON. |
| `KeyError` | A dictionary does not contain the requested key. |
| `ValueError` | The value is unsuitable for an operation, such as `int("abc")`. |
| `TypeError` | An operation or function receives an inappropriate type, such as `"8801" + 1`. |

## 27. Catch More Than One Exception Type

```python
try:
    raise PermissionError("denied")
except (FileNotFoundError, PermissionError) as error:
    print(f"Cannot read the config: {error}")
```

Output:

```text
Cannot read the config: denied
```

- `raise` deliberately raises an exception.
- The `except` block catches either `FileNotFoundError` or `PermissionError`.
- `as error` makes the exception available as a variable.

## 28. `else` and `finally`

- `else` runs if the `try` block finishes without an exception.
- `finally` runs whether an exception occurred or not, provided execution reaches the `try` statement.

```python
try:
    port = int("8801")
except ValueError:
    print("bad port")
else:
    print(f"port is {port}")
finally:
    print("checked the port")
```

Output:

```text
port is 8801
checked the port
```

## 29. Using `finally` to Close a File

```python
def read_config():
    file = open("app.log", encoding="utf-8")
    try:
        return file.read()
    finally:
        file.close()
        print("file closed")


print(len(read_config()))
```

If `app.log` cannot be found, this raises `FileNotFoundError`.

The error occurs because `open()` is executed **before** the `try` block. Python never enters the `try` block, so its `finally` block does not run.

To handle a missing file, place the `open()` call inside the `try` block, or use `with open()`.

## 30. Validate a Port Number

```python
def check_port(port):
    if not 1 <= port <= 65535:
        raise ValueError(f"port {port} is out of range")
    return port


print(check_port(8801))
```

Output:

```text
8801
```

The function accepts port numbers from `1` to `65535`, inclusive. Otherwise, it raises a `ValueError`.

## 31. Create a Custom Exception

A custom exception lets you define an error type for your application.

```python
class ConfigError(Exception):
    """The configuration file is missing or wrong."""


try:
    raise ConfigError("deploy.yaml not found")
except ConfigError as error:
    print(f"Config problem: {error}")
```

Output:

```text
Config problem: deploy.yaml not found
```

`ConfigError` inherits from Python's built-in `Exception` class.

## 32. Custom Exception Containing Multiple Problems

```python
class ConfigError(Exception):
    """Raised when the config is unusable. Carries every problem found."""

    def __init__(self, problems):
        self.problems = problems
        super().__init__("; ".join(problems))


def validate(config):
    problems = []
    for key in ("app_name", "release_version", "app_port"):
        if key not in config:
            problems.append(f"missing key: {key}")
    if problems:
        raise ConfigError(problems)


try:
    validate({"app_name": "flask-demo"})
except ConfigError as error:
    print(f"{len(error.problems)} problems found")
    for problem in error.problems:
        print(f"  - {problem}")
```

Output:

```text
2 problems found
  - missing key: release_version
  - missing key: app_port
```

Explanation:

- `ConfigError` creates a custom exception.
- `validate()` checks whether the three required keys exist.
- `problems.append()` records each missing key.
- `raise ConfigError(problems)` raises an error if any keys are missing.
- `except ConfigError as error` catches that error.
- `len(error.problems)` counts the problems.
- The `for` loop prints each problem.

---

# Unit Testing with pytest

## 33. What Is Unit Testing?

Unit testing checks whether small parts of a program behave as expected.

**Test-driven development (TDD)** is an approach in which tests are written before the implementation.

Install `pytest` in the terminal:

```bash
python -m pip install pytest
```

`assert` checks whether a condition is true. If the assertion fails, the test fails.

### pytest Naming Rules

| Item | Naming convention |
|---|---|
| Test file | `test_*.py` or `*_test.py` |
| Test function | `test_*` |

## 34. Basic pytest Tests

```python
def is_healthy(status_code):
    """Return True if a status code counts as healthy."""
    return status_code in (200, 204)


def test_200_is_healthy():
    assert is_healthy(200) is True


def test_500_is_unhealthy():
    assert is_healthy(500) is False
```

The tests pass if the function returns the expected values. `pytest` normally reports the number of tests passed rather than printing `All tests passed` by default.

Run the tests from the directory containing the test file:

```bash
python -m pytest
```

To display each test name:

```bash
python -m pytest -v
```

## 35. The Three Stages of Testing: Arrange, Act, Assert

```python
def classify_disk(used):
    return "CRITICAL" if used >= 90 else "OK"


def test_disk_at_threshold_is_critical():
    # Arrange
    disk_used = 90

    # Act
    result = classify_disk(disk_used)

    # Assert
    assert result == "CRITICAL"
```

Example verbose output:

```text
test_practice.py::test_disk_at_threshold_is_critical PASSED
```

- **Arrange:** Prepare the input.
- **Act:** Run the function being tested.
- **Assert:** Check that the result is correct.

## 36. Parametrised Tests

Parametrisation runs the same test function with several sets of inputs.

```python
import pytest


def classify_disk(used):
    if used >= 90:
        return "CRITICAL"
    if used >= 80:
        return "WARNING"
    return "OK"


@pytest.mark.parametrize("used, expected", [
    (94, "CRITICAL"),
    (90, "CRITICAL"),
    (89, "WARNING"),
    (80, "WARNING"),
    (79, "OK"),
    (0, "OK"),
])
def test_classify_disk(used, expected):
    assert classify_disk(used) == expected
```

Example verbose output:

```text
unit_testing/test_practice.py::test_classify_disk[94-CRITICAL] PASSED
unit_testing/test_practice.py::test_classify_disk[90-CRITICAL] PASSED
unit_testing/test_practice.py::test_classify_disk[89-WARNING] PASSED
unit_testing/test_practice.py::test_classify_disk[80-WARNING] PASSED
unit_testing/test_practice.py::test_classify_disk[79-OK] PASSED
unit_testing/test_practice.py::test_classify_disk[0-OK] PASSED
```

Each input and expected result becomes a separate test case.

## 37. Parametrised Tests for Health Checks

```python
import pytest


def is_healthy(status_code):
    """Return True if a status code counts as healthy."""
    return status_code in (200, 204)


@pytest.mark.parametrize("status_code, expected", [
    (200, True),
    (204, True),
    (404, False),
    (500, False),
    (301, False),
])
def test_is_healthy(status_code, expected):
    assert is_healthy(status_code) == expected
```

Example verbose output:

```text
unit_testing/test_practice.py::test_is_healthy[200-True] PASSED
unit_testing/test_practice.py::test_is_healthy[204-True] PASSED
unit_testing/test_practice.py::test_is_healthy[404-False] PASSED
unit_testing/test_practice.py::test_is_healthy[500-False] PASSED
unit_testing/test_practice.py::test_is_healthy[301-False] PASSED
```

---

# YAML and CSV

## 38. YAML vs JSON

YAML and JSON are formats for storing and exchanging structured data.

- YAML is often easier for humans to read and edit.
- JSON is widely used by APIs and applications.
- Both can represent objects, lists, strings, numbers and Boolean values.

To work with YAML in Python, install PyYAML:

```bash
python -m pip install pyyaml
```

Then import it:

```python
import yaml
```

CSV (Comma-Separated Values) is another data format, commonly used for tables of rows and columns.

## 39. JSON and Equivalent YAML

### JSON

```json
{
  "site": "eu-west",
  "servers": [
    {
      "hostname": "web-01",
      "port": 8801
    }
  ]
}
```

### Equivalent YAML

```yaml
site: eu-west
servers:
  - hostname: web-01
    port: 8801
```

The `hostname` and `port` fields belong to the same server object.

## 40. Parse YAML Using `yaml.safe_load()`

Parsing means reading data and interpreting its structure so a program can understand it.

```python
import yaml


text = """
site: eu-west
servers:
  - hostname: web-01
    port: 8801
"""


config = yaml.safe_load(text)
print(config["site"])
print(config["servers"][0]["port"])
print(type(config))
```

Output:

```text
eu-west
8801
<class 'dict'>
```

- `yaml.safe_load(text)` parses the YAML string into Python data.
- `config["site"]` accesses the site value.
- `config["servers"][0]["port"]` accesses the port of the first server.
- `type(config)` shows that the top-level object is a dictionary.

Use `safe_load()` when loading YAML from sources you do not fully trust. It avoids constructing arbitrary Python objects in the way the unrestricted loader can.

## 41. Create and Read a YAML File

```python
import yaml


text = "site: eu-west\nport: 8801\n"

with open("config.yaml", "w", encoding="utf-8") as file:
    file.write(text)


with open("config.yaml", encoding="utf-8") as file:
    config = yaml.safe_load(file)


print(config)
```

Output:

```text
{'site': 'eu-west', 'port': 8801}
```

Explanation:

- `with open(..., "w")` opens the file for writing and creates it if necessary.
- `file.write(text)` writes the YAML text.
- The second `with open(...)` opens the file for reading.
- `yaml.safe_load(file)` parses the file into Python data.
- Each `with` block closes its file automatically when the block exits.

## 42. Convert a Python Dictionary to YAML Using `yaml.dump()`

```python
import yaml


config = {"site": "eu-west", "port": 8801}
print(yaml.dump(config))
```

Example output:

```yaml
port: 8801
site: eu-west
```

The key order and formatting can vary. `yaml.dump()` converts Python data into YAML text and returns it as a string when no output stream is supplied.

## 43. The YAML Norway Problem

The **Norway problem** occurs with YAML 1.1-style Boolean parsing when values such as `NO` are interpreted as Boolean values rather than strings.

For example, with PyYAML's default resolver:

```python
import yaml

print(yaml.safe_load("country: NO"))
```

Output:

```text
{'country': False}
```

This is a problem if `NO` is intended to be a country code. The value is interpreted as the Boolean `False` instead of the string `"NO"`.

### Solution: Quote the Value

```yaml
country: "NO"
```

Quoting the value makes it a string.

Other words such as `yes`, `no`, `on` and `off` may also be interpreted as Boolean values by YAML 1.1-style parsers.

```python
import yaml


print(yaml.safe_load("a: yes\nb: no\nc: true\nd: on\ne: off"))
```

Output with PyYAML's default YAML 1.1-style resolution:

```text
{'a': True, 'b': False, 'c': True, 'd': True, 'e': False}
```

### Solution to the Norway Problem

```python
import yaml


print(yaml.safe_load("a: yes\nb: 'NO'\nc: true\nd: on\ne: off"))
```

Output:

```text
{'a': True, 'b': 'NO', 'c': True, 'd': True, 'e': False}
```

**Remember:** Quote values such as country codes when they could be interpreted as Boolean values.

## 44. Other YAML Parsing Surprises

With PyYAML's default YAML 1.1-style resolver, some unquoted values can be interpreted unexpectedly.

```python
import yaml


print(yaml.safe_load("mode: 0755"))     # 493: interpreted as octal
print(yaml.safe_load("time: 12:30"))    # 750: interpreted as base 60
print(yaml.safe_load("version: 1.20"))  # 1.2: interpreted as a float
```

Output:

```text
{'mode': 493}
{'time': 750}
{'version': 1.2}
```

These behaviours are specific to the parser's YAML 1.1-style resolution rules and may differ in other YAML implementations or versions.

### Example: Unquoted Values

```yaml
app: flask-demo
version: 1.10
debug: off
region: NO
```

Possible results with PyYAML's default YAML 1.1-style resolver:

- `app` becomes the string `"flask-demo"`.
- `version` becomes the float `1.1`, so the trailing zero is lost.
- `debug` becomes the Boolean `False`.
- `region` becomes the Boolean `False`.

```python
import yaml


print(yaml.safe_load("app: flask-demo"))
print(yaml.safe_load("version: 1.10"))
print(yaml.safe_load("debug: off"))
print(yaml.safe_load("region: NO"))
```

### Fixed Version: Quote Values Intended to Be Strings

```python
import yaml


print(yaml.safe_load('app: "flask-demo"'))
print(yaml.safe_load('version: "1.10"'))
print(yaml.safe_load('debug: "off"'))
print(yaml.safe_load('region: "NO"'))
```

Output:

```text
{'app': 'flask-demo'}
{'version': '1.10'}
{'debug': 'off'}
{'region': 'NO'}
```

Quoting values preserves them as strings, which is especially important for version numbers, country codes, identifiers and settings that look like Boolean values.

---


