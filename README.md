## Containerised development environment
A development environment inside docker, running Ubuntu

Create multiple Containers with separate configs, install whatever packages you need 

### Usage
- Create a config file for a development 'environment' / project
- Run `run.sh` with the config file (optional clean argument to ensure a clean image build `./run.sh .config clean`
- SSH into the container to develop, or use Jetbrains Gateway / VS Code remote plugin

### Config
```
  # What directory on the host to bind to the container, i.e. a code 'workspace'
  BIND_LOCAL_DIRECTORY= 
  
  # where in the container to bind the directory
  BIND_CONTAINER_DIRECTORY=
  
  # name of the image to build
  IMAGE_NAME= 
  
  # name of the container this will create
  CONTAINER_NAME= 
  
  # port to bind the SSH port to (container SSH port hardcoded to 22)
  SSH_HOST_PORT= 
  
  # user name for the container user
  USERNAME=
  
  # password for the user
  PASSWORD= 
  
  # path to SSH pubkey, this will be copied to the container
  SSH_KEY_FILE=
                                           
```

### Example config
```
BIND_LOCAL_DIRECTORY=/mnt/c/Users/Jake/development/dotfiles
BIND_CONTAINER_DIRECTORY=/home/jake/development
IMAGE_NAME=dotfiles-container
CONTAINER_NAME=dotfiles
SSH_HOST_PORT=22
USERNAME=jake
PASSWORD=someSecretPassword
SSH_KEY_FILE=/home/jake/.ssh/id_rsa.pub
```

### Running
```
./run.sh <config-file> <clean>
```
