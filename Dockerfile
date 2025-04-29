FROM debian:bookworm-slim

LABEL author="Vincent GS" \
      description="Left 4 Dead 2 Dedicated Server"

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME_PATH=/home/container
ENV SERVER_PATH=/home/container/serverfiles

# Instalar dependencias del sistema
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        git \
        tini \
        unzip \
        lib32gcc-s1 \
        lib32stdc++6 \
        lib32z1 \
        libc6:i386 \
        libcurl4 \
        libcurl4:i386 \
        libsdl2-2.0-0:i386 \
        libssl3 \
        libssl3:i386 \
        libtinfo6 \
        libtinfo6:i386 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Definir carpeta de trabajo
WORKDIR ${HOME_PATH}

# Instalar SteamCMD
RUN mkdir -p Steam && \
    curl -fsSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xvzf - -C Steam && \
    chmod -R 0755 Steam && \
    Steam/steamcmd.sh +quit

# Configurar SteamCMD para compatibilidad
RUN for arch in 32 64; do \
    mkdir -p .steam/sdk${arch} && \
    cp Steam/linux${arch}/steamerrorreporter .steam/sdk${arch}/ || true && \
    cp Steam/linux${arch}/steamclient.so .steam/sdk${arch}/ || true && \
    cp Steam/linux${arch}/steamcmd .steam/sdk${arch}/ || true && \
    cp Steam/linux${arch}/steamcmd Steam/linux${arch}/steam || true; \
    done

# Copiar steamcmd.sh para compatibilidad
RUN cp Steam/steamcmd.sh Steam/steam.sh

# Instalar cliente RCON
RUN curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz | tar -xz -C /tmp && \
    mv /tmp/rcon-0.10.3-amd64_linux/rcon /usr/local/bin/ && \
    chmod +x /usr/local/bin/rcon

RUN echo "HOME: ${HOME_PATH}"

# Copiar el script de entrada
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

RUN echo "Files:"
RUN ls $HOME_PATH

# Inicializar con tini
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["./entrypoint.sh"]
