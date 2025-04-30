# ☁️ Left 4 Dead 2 Dedicated Server – Docker Image

> Powered by Debian Slim + SteamCMD  + RCON 🌈🫧

¡Bienvenido! Esta es una imagen de Docker optimizada para correr un servidor dedicado de **Left 4 Dead 2**, pensada para integrarse con [Pterodactyl](https://pterodactyl.io) y mantenerse ligera, estable y bonita ✨.

---

## 🛠️ Características

- 📦 Basada en `debian:bookworm-slim`
- 🎮 Compatible con SteamCMD y 100% funcional para L4D2 (`app_id: 222860`)
- 🔐 Compatible con Steam Guard
- 🪄 EntryPoint limpio y personalizable
- 🐣 Perfecta para Pterodactyl Eggs

---

## 🗃️ Variables de Entorno
> Esto es necesario ya que se removió Left 4 Dead 2 del repositorio anónimo, lo que dificulta la instalación
> del servidor sin cuenta.

1. STEAM_USER     | Default: anonymous
2. STEAM_PASSWORD | Default: [blank]

---

## 🚀 Manual de Configuiración
1. Ve a la sección "Nests" del panel de Pterodactyl
2. Selecciona "Source Engine" y agrega un nuevo egg llamado "Left 4 Dead 2"
3. En la sección de imágenes agrega:
```
Optimized Debian bookworm|ghcr.io/vstyler96/l4d2-bookworm:latest
```
4. En el "Startup Command" coloca:
```
./srcds_run -strictportbind -norestart +ip :IP -port :PORT
```
5. En "Start configuration":
```json
{
    "done": "Connection to Steam servers successful.",
    "userInteraction": []
}
```
6. En "Stop Command": `^C`
7. En "Configuration Files": `{}`
8. Y en "Log Configuration"
```json
{
    "custom": true,
    "location": "logs/latest.log"
}
```
9. Finalmente en install Script agrega
```bash
#!/bin/bash
set -e

# Instalar Left4Dead 2 Server
./Steam/steamcmd.sh +force_install_dir /mnt/server +login $STEAM_USER $STEAM_PASSWORD +app_update 222860 validate +quit
```