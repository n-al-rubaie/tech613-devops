# Explore Using Nginx as a Reverse Proxy

## Objective

Understand how Nginx can sit in front of a Node.js application and forward incoming web requests to the application running on port `3000`.

## What is a reverse proxy?

A reverse proxy is a web server that receives requests from clients and forwards those requests to another server behind it.

In this deployment:

- **Nginx** receives public HTTP requests on port `80`.
- **Node.js** runs the Tic-Tac-Toe application on port `3000`.
- **PM2** manages the Node.js application process.
- Nginx forwards requests to Node.js and returns the application's responses to the client.

## Request flow

```text
User's browser
      |
      | HTTP request to http://EC2-PUBLIC-IP
      v
Nginx (port 80)
      |
      | forwards request to http://127.0.0.1:3000
      v
Node.js application (port 3000)
      |
      | sends response back
      v
Nginx
      |
      v
User's browser
```

Without Nginx, a user may need to visit `http://EC2-PUBLIC-IP:3000` directly, provided the application listens on a publicly reachable interface and the EC2 security group permits port `3000`.

With Nginx configured as a reverse proxy, the user can visit `http://EC2-PUBLIC-IP` using the default HTTP port `80`.

## Why use Nginx?

- **Simpler URL:** Users do not need to specify port `3000`.
- **Traffic routing:** Nginx forwards requests to the application.
- **Extra control:** Nginx can handle TLS/HTTPS, request limits, headers, and other web-server tasks when configured.
- **Separation of responsibilities:** Nginx handles incoming web traffic, while Node.js runs the application.

Nginx does not replace Node.js or PM2. It works in front of the application.

## Nginx configuration used for the application

The deployment script creates this configuration at `/etc/nginx/sites-available/tic-tac-toe`:

```nginx
server {
    listen 80;
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
```

### Explanation of the main directives

- `listen 80;` — Nginx listens for HTTP traffic on port `80`.
- `server_name _;` — acts as a catch-all server name in this simple configuration.
- `location / { ... }` — applies the rules to requests whose URL path begins with `/`.
- `proxy_pass http://127.0.0.1:3000;` — forwards requests to the Node.js app on the same EC2 instance.
- `proxy_http_version 1.1;` — uses HTTP/1.1 for the connection to the application.
- `proxy_set_header Host $host;` — passes the requested host name to the application.
- `proxy_set_header X-Real-IP $remote_addr;` — passes the client's IP address in a header.
- `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` — preserves the forwarding chain of client IP addresses.
- `proxy_set_header X-Forwarded-Proto $scheme;` — tells the application whether the original request used HTTP or HTTPS.

## How the deployment script enables Nginx

The script uses commands like these:

```bash
sudo ln -sfn /etc/nginx/sites-available/tic-tac-toe /etc/nginx/sites-enabled/tic-tac-toe
```

This creates or updates a symbolic link so Nginx enables the Tic-Tac-Toe site configuration.

```bash
sudo nginx -t
```

This checks the Nginx configuration for syntax errors.

```bash
sudo systemctl enable nginx
sudo systemctl reload nginx
```

- `systemctl enable nginx` configures Nginx to start automatically when the server boots.
- `systemctl reload nginx` asks Nginx to load the updated configuration without a full service restart, if the configuration is valid.

The script tests the configuration before reloading it, which helps avoid applying an invalid configuration.

## AWS security group requirements

For this setup, the EC2 security group normally needs these inbound rules:

| Port | Purpose | Suggested source |
|---|---|---|
| `22` TCP | SSH administration | Your IP address where practical |
| `80` TCP | Public HTTP traffic through Nginx | `0.0.0.0/0` for a publicly accessible website |
| `3000` TCP | Direct access to Node.js | Usually not needed publicly once Nginx works |

After confirming that the application works through Nginx on port `80`, you can usually remove public inbound access to port `3000`. Nginx can still reach Node.js through `127.0.0.1:3000` on the EC2 instance. Keep SSH access restricted to trusted IP addresses where possible.

## How to test the setup

Run these commands on the EC2 instance.

### 1. Check the Node.js app in PM2

```bash
pm2 status
```

Confirm that `tic-tac-toe` is online.

### 2. Test the application directly from the EC2 instance

```bash
curl -I http://127.0.0.1:3000
```

This tests whether the application responds locally. The exact HTTP status can depend on the application.

### 3. Test the Nginx configuration

```bash
sudo nginx -t
```

Look for a successful syntax check and configuration test.

### 4. Check Nginx is running

```bash
sudo systemctl status nginx
```

### 5. Test through Nginx locally

```bash
curl -I http://127.0.0.1
```

### 6. Test from your browser

Open:

```text
http://YOUR-EC2-PUBLIC-IP
```

Replace `YOUR-EC2-PUBLIC-IP` with the instance's actual public IPv4 address.

If the local Node.js test works but the public URL does not, check that Nginx is running, port `80` is allowed in the EC2 security group, and the enabled Nginx configuration is correct.

## Troubleshooting commands

```bash
# Check the application process
pm2 status

# View recent application logs
pm2 logs tic-tac-toe --lines 50

# Test the Nginx configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# View recent Nginx error logs
sudo tail -n 50 /var/log/nginx/error.log

# View recent Nginx access logs
sudo tail -n 50 /var/log/nginx/access.log
```

## Key takeaway

Nginx is the public-facing web server on port `80`. It forwards incoming requests to the Node.js application on port `3000`, then sends the application's responses back to the user. PM2 manages the Node.js process; Nginx manages incoming web traffic.
