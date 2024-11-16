############################################################
# Dockerfile to build ruTorrent and plugins
#
############################################################

ARG ARCH

FROM ${ARCH}php:7.4.27-apache AS osbuild
ENV APP_HOME=/usr/src/app
ARG STORAGE_DIR=/data
ARG TARGETPLATFORM
ARG UID=1000
ARG GID=1000
RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list \
    && apt update && apt install --no-install-recommends -y sudo gosu bash unzip g++ make file re2c autoconf openssl libssl-dev libevent-dev \
        rtorrent mediainfo gzip screen p7zip-full p7zip-rar ffmpeg python3 python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && python3 -m pip install cloudscraper \
    && docker-php-ext-install sockets pcntl \
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

COPY rar /usr/src/rarsrc
COPY vhost.conf /etc/apache2/sites-enabled/000-default.conf

RUN mkdir -p "$APP_HOME" "$STORAGE_DIR/downloads" "$STORAGE_DIR/.session" \
      && chmod 775 -R "$APP_HOME" \
      && chown -R ${UID}:${GID} "$STORAGE_DIR" \
    && echo "${TARGETPLATFORM}" | grep -q "arm" \
           || {  \
            BUILDPLATFORM_SHORT=$(echo "${TARGETPLATFORM}" | grep -q "64" && echo "x64" || echo "x32"); \
            RAR_DISTRO="/usr/src/rarsrc/rarlinux-${BUILDPLATFORM_SHORT}.tar.gz";  \
             tar -xzvf "${RAR_DISTRO}" -C /tmp/ \
              && cp -rfp /tmp/rar/rar /usr/bin/rar  \
              && ln -s /usr/bin/rar /usr/bin/unrar; \
            rm -rf /usr/src/rarsrc; \
     } && exit 0

FROM osbuild AS srcbuild

ARG UID=1000
ARG GID=1000

ARG RUTORRENT_VER=master
ARG FILEMANAGER_VER=master
ARG FILEMANAGER_MEDIA_VER=master
ARG FILEMANAGER_SHARE_VER=master



RUN mkdir -p "$APP_HOME" \
    && curl https://codeload.github.com/Novik/ruTorrent/tar.gz/${RUTORRENT_VER} | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME" \
    && mkdir "$APP_HOME/plugins/filemanager" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager/tar.gz/${FILEMANAGER_VER} \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager" \
    && mkdir "$APP_HOME/plugins/filemanager-share" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-share/tar.gz/${FILEMANAGER_SHARE_VER} \
    | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-share" \
    && mkdir "$APP_HOME/plugins/filemanager-media" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-media/tar.gz/${FILEMANAGER_MEDIA_VER} \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-media"


COPY --chown=${UID}:${GID} rtorrent.conf /home/runuser/.rtorrent.rc
COPY entrypoint.sh  "$APP_HOME/entrypoint.sh"
RUN chmod 775 "$APP_HOME/entrypoint.sh"

COPY config.php "$APP_HOME/conf/"
RUN chown -R www-data:www-data "$APP_HOME" && rm -rf /var/www/html && ln -s "$APP_HOME"  "/var/www/html"


FROM ${ARCH}osbuild AS appbuild
MAINTAINER hwk <nelu@github.com>
ARG STORAGE_DIR=/data

ENV PATH="$PATH:$APP_HOME"

COPY --from=srcbuild "$APP_HOME" "$APP_HOME"
STOPSIGNAL TERM

VOLUME ["$STORAGE_DIR", "/var/www/html"]

CMD ["entrypoint.sh"]

WORKDIR $APP_HOME


