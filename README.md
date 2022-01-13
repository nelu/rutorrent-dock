# rutorrent-dock

Sample docker-compose project for running ruTorrent locally

Cloning repositories and setting permissions for dev env:
```bash
 git clone https://github.com/nelu/rutorrent-dock.git && cd rutorrent-dock/src \
 && git clone https://github.com/Novik/ruTorrent.git rutorrent \
 && cd "rutorrent/plugins" \
 && git clone https://github.com/nelu/rutorrent-filemanager.git "filemanager" \
 && git clone https://github.com/nelu/rutorrent-filemanager-media.git "filemanager-media" \
 && git clone https://github.com/nelu/rutorrent-filemanager-share.git "filemanager-share" \
 && cd ../../../ \
 && chmod 755 -R "./src/rutorrent" \
 && chown 1000:1000 -R "./bt"
```


Any environment variables that needs to be used inside the containers can be edited in `config/rutorrent/app.env`

Host machine mount paths are configurable in the project `.env` file:
 ```
 LOGS_DIR - contents of container /var/log/rutorrent
 RUTORRENT_TEMP_DIR - contents of container /tmp
 RUTORRENT_DATA_DIR - contents of container /data/.session and /data/downloads
 RUTORRENT_SHARE_DIR - contents of container rutorrent/share directory
 RUTORRENT_SRC_DIR - path to local source code for rutorrent
 ```
See docker-compose.yml on how these variables and `./config/` files are being used 
${RUTORRENT_SRC_DIR} mount must be uncommented in docker-compose.yml to make use of ./src/rutorrent. Take note that it will use configurations from ./config

Here is a config example where all container generated data is stored inside the project `./bt` directory :
```dotenv
LOGS_DIR=./bt/logs
RUTORRENT_TEMP_DIR=./bt/tmp
RUTORRENT_DATA_DIR=./bt/data
RUTORRENT_SHARE_DIR=./bt/rutorrent-share

RUTORRENT_SRC_DIR=./src/rutorrent
```
Since they are bind volume mounts, all paths will be created empty by docker on the first run if they do not exist.
and might cause permission issues when running the project.

You can set permissions with:
```bash chown 1000:1000 -R "./bt" ```


Run using prebuilt image:

``` docker-compose pull && docker-compose up ```


Build image from src/Dockerfile:

``` docker-compose build && docker-compose up -V ```

You should have rutorrent running on http://172.200.23.2/ in the 172.200.23.0/24 subnet
