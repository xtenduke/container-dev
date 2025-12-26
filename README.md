## Containerised Development Environment

A development environment inside Docker, running Fedora.

### Features
- **Host Docker Access**
- **Workspace mount** mount a dir from the host into the container

### Usage
1. **Configuration**:
   ```bash
   cp env.template .env
   # Edit .env to set your user/uid/gid preferences
   ```

2. **Run**:
   ```bash
   ./run.sh
   ```
   - You will be asked to enter a password. This password will be set for both `root` and your `DEV_USER`
   - The script will build (if needed), start the container, and attach you to a shell.

### Config
Variables in `.env`:

```bash
# Docker Compose service name
SERVICE_NAME=dev

# Name of the built image
IMAGE_NAME=dev-image

# Name of the container
CONTAINER_NAME=dev

# Directory to bind to /workspace
WORKSPACE_DIR=Workspace

# Your username inside the container
DEV_USER=user

# user fullname
DEV_FULL_NAME="Full Name"

# UID/GID mapping (should match your host user for file permissions)
DEV_UID=1000
DEV_GID=1000
DOCKER_GID=999
```
