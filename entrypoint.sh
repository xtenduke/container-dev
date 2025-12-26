#!/bin/bash
set -e

if [ -n "${ROOT_PASSWORD:-}" ]; then
    echo "root:${ROOT_PASSWORD}" | chpasswd
fi

if [ -n "${DEV_PASSWORD:-}" ] && [ -n "${DEV_USER:-}" ]; then
    echo "${DEV_USER}:${DEV_PASSWORD}" | chpasswd
fi

if [ -n "${DEV_USER:-}" ] && [ -d "/home/${DEV_USER}" ]; then
    chown -R ${DEV_USER}:${DEV_USER} /home/${DEV_USER}
fi

# fix socket perm
if [ -S "/var/run/docker.sock" ]; then
    chmod 666 /var/run/docker.sock
fi

if [ $# -eq 0 ]; then
    if [ -n "${DEV_USER:-}" ]; then
        exec gosu ${DEV_USER} /usr/bin/zsh
    else
        exec /usr/bin/zsh
    fi
else
    if [ -n "${DEV_USER:-}" ]; then
        exec gosu ${DEV_USER} "$@"
    else
        exec "$@"
    fi
fi

