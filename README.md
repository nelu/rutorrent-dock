# rutorrent-dock
[![Multiarch Build](https://github.com/nelu/rutorrent-dock/actions/workflows/docker-image.yml/badge.svg)](https://github.com/nelu/rutorrent-dock/actions/workflows/docker-image.yml)

Sample docker-compose project for running ruTorrent locally


Cloning project and setting permissions for rTorrent and ruTorrent data:
```bash
 git clone https://github.com/nelu/rutorrent-dock.git && cd rutorrent-dock \
 && chown 1000:1000 -R "./bt" && chown -R 775 "./bt"
```

### Configuration
Sample ruTorrent configurations can be found in `./config/`
Host machine mount paths are configurable in the project `.env` file:

PERSISTENT_DATA_DIR - Where to mount the persistent data volume (/data/.session /data/downloads /data/logs /data/share) locally in the project

Here is a config example where all container generated data is stored inside the project `./bt` directory :
 ```
# using ./bt as persistent data dir for this project
PERSISTENT_DATA_DIR=./bt
 ```
See how these variables are being used in docker-compose.yml for a better picture

Since they are bind volume mounts, all paths will be created empty by docker on the first run if they do not exist.
and might cause permission issues when running the project.

Contents of `./src/rutorrent` and `./bt/data/` are created automatically from the 'web' container contents if the directory is empty. Permissions can be set with:
```bash 
chown 1000:1000 -R "./bt" && chown -R 775 "./bt"
```
Any environment variables that needs to be used inside the containers can be edited in `config/rutorrent/app.env`. 


### Developer mode
You can enable development mode and mount the whole rutorrent source code from `./src/rutorrent` inside the containers, by uncommenting `- ./src/rutorrent:/var/www/html` volume mount for the `web` service inside `docker-compose.yml`, like so:
```
# development mounts
#      - ./src/build/entrypoint.sh:/usr/local/bin/entrypoint.sh
      - ./src/rutorrent:/var/www/html
```

### Running or building

#### ruTorrent Stock Image
https://hub.docker.com/r/unzel/rutorrent

Run using prebuilt image:

``` docker-compose pull && docker-compose up ```

Update to latest version version and run:

``` docker-compose pull && docker-compose up -V```



Build image from src/Dockerfile:

 ``` docker-compose build && docker-compose up -V ```

Build multi arch images from common.yml using buildx:

 ``` bash
 # build the local arch image 
 export $(grep -v '^#' .env | xargs) && \
 docker buildx bake -f common.yml --load \
 && docker-compose up -d -V
 
# build the x64 image only 
export $(grep -v '^#' .env | xargs) && \
docker buildx bake -f common.yml --load \
	--set *.platform=linux/amd64 \
	--load \
&& docker-compose up -d -V
	
# build all arch images and publish latest and 0.2 tags
export $(grep -v '^#' .env | xargs) && \
docker buildx bake -f common.yml \
	--set *.platform=linux/amd64,linux/arm64,linux/arm/v7,linux/386 \
	--set *.tags=unzel/rutorrent-filemanager:latest \
	--set *.tags=${SERVICE_IMAGE} \
	--push
	
 ```


You should have rutorrent running on ```http://localhost:80/``` inside the 172.200.23.0/24 docker subnet

#### Tutorials:
[Running ruTorrent on a Raspberry PI 4 - Guide](https://github.com/nelu/rutorrent-dock/wiki/Running-ruTorrent-on-a-Raspberry-PI---Guide)
