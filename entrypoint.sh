#!/bin/bash
## Entrypoint for the container
# restart ssh server

service ssh restart
echo "ssh server restarted"

echo "^C to stop"
for (( ; ; ))
do
   sleep 1
done
