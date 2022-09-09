FROM ubuntu:20.04
ARG SSH_KEY
ARG USERNAME
ARG PASSWORD

VOLUME development

COPY entrypoint.sh /
RUN chmod 755 entrypoint.sh

# create user
RUN adduser --gecos "" --disabled-password $USERNAME
RUN echo "$PASSWORD\n$PASSWORD" | passwd $USERNAME

# Create ssh dir
RUN mkdir -p /home/$USERNAME/.ssh
# Create authorized_keys file
RUN touch /home/$USERNAME/.ssh/authorized_keys

# copy ssh key to authorized_keys
RUN echo "$SSH_KEY" > /home/$USERNAME/.ssh/authorized_keys

# fixup perms
RUN chmod 0700 /home/$USERNAME/.ssh
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Update repos
RUN apt update

# Install ssh server
RUN apt-get install -y openssh-server

# Enable ssh server
RUN service ssh start

# Disable password authentication
RUN sed -E -i 's|^#?(PasswordAuthentication)\s.*|\1 no|' /etc/ssh/sshd_config

RUN service ssh restart

# Add sudo
RUN apt install -y sudo
RUN adduser $USERNAME sudo

# Add vi
RUN apt install -y neovim

# Add nano
RUN apt install -y nano

EXPOSE 22

CMD ["./entrypoint.sh"]
