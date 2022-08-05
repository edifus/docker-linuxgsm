FROM ubuntu:22.04

LABEL maintainer="edifus <edifus@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

ARG USERNAME=linuxgsm
ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install UTF-8 unicode
RUN \
  echo "**** apt upgrade ****" && \
    apt-get update && \
    apt-get upgrade -y && \
  echo "**** Install Base LinuxGSM Requirements ****" && \
    apt-get install -y \
      apt-utils \
      bc \
      binutils \
      bsdmainutils \
      bzip2 \
      ca-certificates \
      cpio \
      curl \
      debconf-utils \
      distro-info \
      file \
      gzip \
      hostname \
      jq \
      lib32gcc-s1 \
      lib32stdc++6 \
      locales \
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
  echo "**** Install NodeJS ****" && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
  echo "**** Install GameDig ****" && \
    npm install --global gamedig && \
  echo "**** Install SteamCMD ****" && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 steamcmd && \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd && \
  echo "**** Configure UTF-8 Locale ****" && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
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

