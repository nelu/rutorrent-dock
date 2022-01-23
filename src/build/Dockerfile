############################################################
# Dockerfile to run a php fpm application#
#
############################################################

ARG ARCH

FROM ${ARCH}php:7.4.27-apache as osbuild
ARG UID=1000
ARG GID=1000
RUN apt update && apt install -y sudo gosu bash unzip g++ make file re2c autoconf openssl libssl-dev libevent-dev \
     rtorrent mediainfo gzip screen p7zip-full ffmpeg zip unrar-free \
    && docker-php-ext-install sockets \
	&& rm -rf /usr/local/etc/php/conf.d/*sockets.ini && docker-php-ext-enable --ini-name 20-sockets.ini sockets \
    && docker-php-ext-install  pcntl \
    && rm -rf /usr/local/etc/php/conf.d/*pcntl.ini && docker-php-ext-enable --ini-name 10-pcntl.ini pcntl \
    && apt remove -y g++ make re2c autoconf libssl-dev libevent-dev \
    && apt autoremove -y --purge \
    && docker-php-source delete \
    && groupadd -g ${GID} runuser && useradd -u ${UID} -g ${GID} -m runuser \
    && usermod -a -G www-data runuser && usermod -a -G ${GID} www-data \
    && rm -rf /var/www/html \
#    && ln -s $APP_HOME /var/www/html \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load \
    && ln -s /etc/apache2/mods-available/remoteip.load /etc/apache2/mods-enabled/remoteip.load \
    && apt-get clean -y \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/src/php.tar.xz


COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY --chown=${UID}:${GID} rtorrent.conf /home/runuser/.rtorrent.rc
COPY entrypoint.sh  /usr/local/bin/entrypoint.sh


FROM osbuild as srcbuild
ARG TARGETPLATFORM

ARG STORAGE_DIR=/data
ARG UID=1000
ARG GID=1000

ARG RUTORRENT_VER=master
ARG FILEMANAGER_VER=master
ARG FILEMANAGER_MEDIA_VER=master
ARG FILEMANAGER_SHARE_VER=master

ENV APP_HOME 	/usr/src/app

RUN  echo "${TARGETPLATFORM}" | grep -q "arm" \
           || { BUILDPLATFORM_SHORT=$(echo "${TARGETPLATFORM}" | grep -q "64" && echo "x64" || echo "x32"); \
               curl https://www.rarlab.com/rar/rarlinux-${BUILDPLATFORM_SHORT}-610b3.tar.gz | tar -xzvf - -C /tmp/ \
               && cp -rfp /tmp/rar/rar /usr/bin/rar ; } && exit 0;

RUN mkdir -p "$APP_HOME" "$STORAGE_DIR/downloads" "$STORAGE_DIR/.session" \
    && curl https://codeload.github.com/Novik/ruTorrent/tar.gz/${RUTORRENT_VER} | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME" \
    && mkdir "$APP_HOME/plugins/filemanager" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager/tar.gz/${FILEMANAGER_VER} \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager" \
    && mkdir "$APP_HOME/plugins/filemanager-share" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-share/tar.gz/${FILEMANAGER_SHARE_VER} \
    | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-share" \
    && mkdir "$APP_HOME/plugins/filemanager-media" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-media/tar.gz/${FILEMANAGER_MEDIA_VER} \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-media" \
    && chmod 775 -R "$APP_HOME" \
    && chown -R ${UID}:${GID} "$STORAGE_DIR"

COPY config.php "$APP_HOME/conf/"


FROM srcbuild as appbuild
MAINTAINER hwk <nelu@github.com>
ARG STORAGE_DIR=/data

ENV APP_HOME 	/usr/src/app
ENV PATH        $PATH:$APP_HOME


RUN chown -R www-data:www-data "$APP_HOME"

STOPSIGNAL TERM

VOLUME ["$STORAGE_DIR", "/var/www/html"]

CMD entrypoint.sh

WORKDIR $APP_HOME


