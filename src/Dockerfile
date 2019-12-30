############################################################
# Dockerfile to run a php fpm application#
#
############################################################

FROM php:7.1.33-apache

MAINTAINER hwk <user@somedomain.com>

ENV APP_HOME 	/usr/src/app
ENV STORAGE_DIR     /data
ENV PATH        $PATH:$APP_HOME


RUN apt-get update && apt-get install -y sudo gosu bash unzip g++ make file re2c autoconf openssl libssl-dev libevent-dev \
     rtorrent mediainfo gzip screen ffmpeg zip
     #ffmpeg-dev

RUN  docker-php-ext-install sockets \
	&& rm -rf /usr/local/etc/php/conf.d/*sockets.ini && docker-php-ext-enable --ini-name 20-sockets.ini sockets \
    && docker-php-ext-install  pcntl \
    && rm -rf /usr/local/etc/php/conf.d/*pcntl.ini && docker-php-ext-enable --ini-name 10-pcntl.ini pcntl

RUN curl https://www.rarlab.com/rar/rarlinux-x64-5.7.1.tar.gz | tar -xzvf - -C /tmp/ \
    && cp -rfp /tmp/rar/rar /usr/bin/rar && ln -s /usr/bin/rar /usr/bin/unrar \
    && rar -v

RUN apt-get remove -y g++ make re2c autoconf libssl-dev libevent-dev libstdc++-8-dev g++-8 \
    && docker-php-source delete
RUN groupadd -g 1000 runuser && useradd -u 1000 -g 1000 -m runuser && usermod -a -G www-data runuser

RUN mkdir -p "$APP_HOME" "$STORAGE_DIR/downloads" "$STORAGE_DIR/.session" \
     && chown -R www-data:www-data "$APP_HOME" "$STORAGE_DIR" /var/www

USER www-data

RUN curl https://codeload.github.com/Novik/ruTorrent/tar.gz/master | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME"

RUN mkdir "$APP_HOME/plugins/filemanager" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager/tar.gz/master \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager"

RUN mkdir "$APP_HOME/plugins/filemanager-share" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-share/tar.gz/master \
    | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-share"
RUN mkdir "$APP_HOME/plugins/filemanager-media" \
    && curl https://codeload.github.com/nelu/rutorrent-filemanager-media/tar.gz/master \
     | tar -xzf - --overwrite-dir --strip-components=1 -C "$APP_HOME/plugins/filemanager-media"

RUN chmod 755 -R "$APP_HOME"
USER root

RUN rm -rf /var/www/html \
    && ln -s $APP_HOME /var/www/html \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load \
    && ln -s /etc/apache2/mods-available/remoteip.load /etc/apache2/mods-enabled/remoteip.load
#    && rm -rf /etc/apache2/sites-enabled/000-default.conf \
#    && ln -s "$APP_HOME/entrypoints/vhost.conf" /etc/apache2/sites-enabled/000-default.conf

STOPSIGNAL TERM

VOLUME ["$STORAGE_DIR", "$APP_HOME/share"]

WORKDIR $APP_HOME

