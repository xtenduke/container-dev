if [ -z "$1" ]
then
  echo "Config file argument must be specified i.e. ./run.sh .config"
  exit 1;
fi

export $(cat $1 | xargs)

if [ -z "$IMAGE_NAME" ] ||
[ -z "$CONTAINER_NAME" ] ||
[ -z "$SSH_KEY_FILE" ] ||
[ -z "$USERNAME" ] ||
[ -z "$SSH_HOST_PORT" ] ||
[ -z "$BIND_LOCAL_DIRECTORY" ] ||
[ -z "$BIND_CONTAINER_DIRECTORY" ]; then
echo "Missing env var.\nRequired env vars"
cat config.template
exit 1; fi

if [ -z "$IMAGE_NAME" ]
then
  echo "IMAGE_NAME env var missing"
  exit 1;
fi

SSH_KEY=$(< $SSH_KEY_FILE)
if [ -z "$SSH_KEY" ]
then 
  echo "Missing ssh key"
  exit 1;
fi

IMAGE_EXISTS=$(docker image ls | grep \"$IMAGE_NAME\")
CONTAINER_ID=$(docker ps -a --format "table {{.ID}}\t{{.Names}}" | grep $CONTAINER_NAME | cut -d ' ' -f1)

build () {
  set -e
  docker build -t $IMAGE_NAME --build-arg SSH_KEY="$SSH_KEY" --build-arg USERNAME=$USERNAME --build-arg PASSWORD=$PASSWORD . --no-cache
  set +e
}

# Stop and delete container
remove_container() {
  docker stop $CONTAINER_ID
  docker rm $CONTAINER_ID
}

# Create a new cotnainer
create_container() {
  set -e
  docker run -p 127.0.0.1:$SSH_HOST_PORT:22/tcp --name $CONTAINER_NAME -v $BIND_LOCAL_DIRECTORY:$BIND_CONTAINER_DIRECTORY -it $IMAGE_NAME
  set +e
}

# Start the existing container
start_container() {
  docker start $CONTAINER_ID
}

if [ $IMAGE_EXISTS ]; then
  echo "Image exists";
  echo $IMAGE_EXISTS;
  exit 1;
  if [ "$2" = "clean" ]; then
    echo "Building clean $IMAGE_NAME"
    build
  else
    echo "Image $IMAGE_NAME exists - Skip build"
  fi
else
  echo "Image doesnt exist"
  build
fi

# Get container id if it already exists
if [ $CONTAINER_ID ]; then
  if [ "$2" = "clean" ]; then
    echo "Removing container $CONTAINER_NAME"
    remove_container
    echo "Creating container $CONTAINER_NAME"
    create_container
  else
    echo "Container exists - starting"
    start_container
  fi
else
  echo "Creating container $CONTAINER_NAME"
  create_container
fi
