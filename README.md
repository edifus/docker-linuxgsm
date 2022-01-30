<h1 align="center">
  <br>
  <a href="https://linuxgsm.com"><img src="https://i.imgur.com/Eoh1jsi.jpg" alt="LinuxGSM"></a>
</h1>

# LinuxGSM Docker Container
[LinuxGSM](https://linuxgsm.com) is the command-line tool for quick, simple deployment and management of Linux dedicated game servers.

> This docker container is under development is subject to significant change and not considured stable.

A dockerised version of LinuxGSM https://linuxgsm.com

Github Container Repo: https://github.com/edifus/docker-linuxgsm/pkgs/container/linuxgsm

## Usage

### docker-compose
Below is an example `docker-compose` for [`sdtdserver`](https://linuxgsm.com/servers/sdtdserver/). Ports and data volume will vary depending upon game server.

``` yaml
version: '3.8'

services:
  linuxgsm:
    image: ghcr.io/edifus/linuxgsm
    container_name: sdtdserver
    environment:
      - GAMESERVER=sdtdserver
      - LGSM_GITHUBUSER=GameServerManagers
      - LGSM_GITHUBREPO=LinuxGSM
      - LGSM_GITHUBBRANCH=master
    volumes:
      - /path/to/game-config/serverfiles:/home/linuxgsm/serverfiles
      - /path/to/game-config/logs:/home/linuxgsm/log
      - /path/to/game-config/lgsm:/home/linuxgsm/lgsm
      - /path/to/game-config/data:/home/linuxgsm/.local/share/7DaysToDie # varies depending on game server
    ports: # varies depending on game server
      - "26900:26900/tcp"
      - "26900:26900/udp"
      - "26901:26901/udp"
      - "26902:26902/udp"
      - "8020:8080/tcp"   # WEB CONTROL PANEL
      - "8021:8081/tcp"   # TELNET
    restart: unless-stopped
```

## First Run
Change environment variable `GAMESERVER` to the game server of choice. On first run linuxgsm will install your selected server and will start running. Once completed the game server details will be output.

### Game Server Ports
Each game server has its own port requirements. Becuase of this you will need to configure the correct ports in your `docker-compose` after first run. The required ports are output once installation is completed and everytime the docker container is started.

### Volumes
Volumes are required to save persistant data for your game server. The example above covers a basic `sdtdserver` however some game servers save files in other places. Please check all the correct locations are mounted to remove the risk of loosing save data.

## Run LinuxGSM commands
Commands can be run just like standard LinuxGSM using the docker exec command.

``` shell
# linux game server manager commands
docker exec -it sdtdserver ./sdtdserver <command>

# connect to game server console (tmux session)
# normal tmux keybinds (disconnect - ctrl+b, d)
docker exec -it sdtdserver tmux a
```

