#
# LinuxGSM Base Dockerfile
#
# https://github.com/GameServerManagers/LinuxGSM-Docker
#

FROM ubuntu:20.04

LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm

ARG USERNAME=linuxgsm
ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install UTF-8 unicode
RUN \
  echo "**** Install UTF-8 ****" && \
    apt-get update && \
    apt-get install -y locales apt-utils debconf-utils && \ 
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  echo "**** apt upgrade ****" && \
    apt-get update && \
    apt-get upgrade -y && \
  echo "**** Install Base LinuxGSM Requirements ****" && \
    apt-get install -y software-properties-common && \
    add-apt-repository multiverse && \
    apt-get update && \
    apt-get install -y \
      bc \
      binutils \
      bsdmainutils \
      bzip2 \
      ca-certificates \
      cpio \
      curl \
      distro-info \
      file \
      gzip \
      hostname \
      jq \
      lib32gcc1 \
      lib32stdc++6 \
      netcat \
      python3 \
      tar \
      tmux \
      unzip \
      util-linux \
      wget \
      xz-utils \
      # Docker Extras
      cron \
      iproute2 \
      iputils-ping \
      nano \
      vim \
      sudo \
      tini && \
  echo "**** Install SteamCMD ****" && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 steamcmd && \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd && \
  echo "**** Install NodeJS ****" && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
  echo "**** Install GameDig ****" && \
    npm install --global gamedig && \
  echo "**** Add linuxgsm user ****" && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    chown $USERNAME:$USERNAME /home/$USERNAME && \
  echo "**** Download linuxgsm.sh ****" && \
    set -ex && \
    wget -O linuxgsm.sh https://linuxgsm.sh && \
    chmod +x /linuxgsm.sh && \
  echo "**** Cleanup ****"  && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR /home/linuxgsm
ENV PATH=$PATH:/home/linuxgsm
USER linuxgsm

COPY entrypoint.sh /home/linuxgsm/entrypoint.sh

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "bash","./entrypoint.sh" ]

