#!/bin/bash

# auto populate volumes with code

sync_empty() {
    ! [[ -e "/var/www/html${1}" ]] \
    && ln -s "$APP_HOME${1}" "/var/www/html${1}" \
    || {
        ! [[ "$(ls -A /var/www/html${1})" ]] && ! [[ -L "/var/www/html${1}" ]] && {
                echo "sync_empty: mount is empty /var/www/html${1}"
                ls -A "/var/www/html${1}"
                cp -rfp "$APP_HOME${1}" "/var/www/html/"
        }
    }
}
sync_empty ""
sync_empty "/share"
apache2-foreground
