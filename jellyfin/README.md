# GPU

## AMD

### Deps
Install the neccessary deps
```sudo apt install -y vainfo mesa-va-drivers libva-drm2 libva-x11-2```
Check it works:
```vainfo```

### Edit compose
Uncomment the following lines:
```- LIBVA_DRIVER_NAME=radeonsi```
```
devices:
    - /dev/dri:/dev/dri
```

# Containers
https://hub.docker.com/r/linuxserver/jellyfin

# Deploy
If already running
```docker-compose down```
To start
```docker-compose up -d```

# Update
Pull images
```docker-compose pull```
Prune old images
```docker image prune```
