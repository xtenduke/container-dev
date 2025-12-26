FROM fedora:43

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID
ARG DOCKER_GID

RUN dnf -y update \
    && curl -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo \
    && dnf clean all

RUN dnf -y install \
    sudo \
    util-linux \
    shadow-utils \
    passwd \
    procps-ng \
    bash-completion \
    zsh \
    less \
    which \
    tree \
    file \
    jq \
    ripgrep \
    fd-find \
    fzf \
    bat \
    neovim \
    tmux \
    git \
    git-lfs \
    openssh-clients \
    curl \
    wget \
    rsync \
    iproute \
    iputils \
    bind-utils \
    net-tools \
    tcpdump \
    traceroute \
    gcc \
    gcc-c++ \
    make \
    cmake \
    pkgconf-pkg-config \
    clang \
    lldb \
    tar \
    unzip \
    zip \
    xz \
    bzip2 \
    zstd \
    ca-certificates \
    openssl \
    iptables \
    slirp4netns \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    docker-ce-rootless-extras \
    fastfetch \
    && dnf clean all

RUN groupadd -g ${DOCKER_GID} docker || true

RUN groupadd -g ${DEV_GID} ${DEV_USER} \
    && useradd -m -u ${DEV_UID} -g ${DEV_GID} -G docker -s /usr/bin/zsh ${DEV_USER} \
    && echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${DEV_USER} \
    && chmod 0440 /etc/sudoers.d/${DEV_USER} \
    # gosu for easy step-down from root
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && echo "${DEV_USER}:100000:65536" >> /etc/subuid \
    && echo "${DEV_USER}:100000:65536" >> /etc/subgid \
    && echo "${DEV_USER}:100000:65536" >> /etc/subgid

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


