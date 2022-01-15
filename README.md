# rutorrent-dock

Sample docker-compose project for running ruTorrent locally

Sample ruTorrent configurations can be found in `./config/`

Any environment variables that needs to be used inside the containers can be edited in `config/rutorrent/app.env`


Cloning project and setting permissions for rTorrent and ruTorrent data:
```bash
 git clone https://github.com/nelu/rutorrent-dock.git && cd rutorrent-dock \
 && chown 1000:1000 -R "./bt"
```

Host machine mount paths are configurable in the project `.env` file:
 ```
 LOGS_DIR - contents of container /var/log/rutorrent
 RUTORRENT_TEMP_DIR - contents of container /tmp
 RUTORRENT_DATA_DIR - contents of container /data/.session and /data/downloads
 RUTORRENT_SHARE_DIR - contents of container rutorrent/share directory
 RUTORRENT_SRC_DIR - path to local source code for rutorrent
 ```
See docker-compose.yml on how these variables and `./config/` files are being used 

Here is a config example where all container generated data is stored inside the project `./bt` directory :
```dotenv
LOGS_DIR=./bt/logs
RUTORRENT_TEMP_DIR=./bt/tmp
RUTORRENT_DATA_DIR=./bt/data

RUTORRENT_SRC_DIR=./src/rutorrent
```
Since they are bind volume mounts, all paths will be created empty by docker on the first run if they do not exist.
and might cause permission issues when running the project.

You can set permissions with:
```bash chown 1000:1000 -R "./bt" ```

Contents of `./src/rutorrent` are created automatically if the directory is empty from the 'web' container sources


Run using prebuilt image:

``` docker-compose pull && docker-compose up ```


Build image from src/Dockerfile:

``` docker-compose build && docker-compose up -V ```

You should have rutorrent running on http://172.200.23.2/ in the 172.200.23.0/24 subnet
