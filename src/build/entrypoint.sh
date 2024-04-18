#!/bin/bash

# auto populate volumes with code

sync_empty() {
    ! [[ -e "${1}" ]] && [[ -e "${2}" ]] && { \
      echo "sync_empty: dir is empty ${1} - copy from ${2}";
      cp -rfp "${2}" "${1}"
      }

}

! [[ -e "/var/www/html" ]] && ln -s "$APP_HOME" "/var/www/html"

sync_empty "/data/share" "$APP_HOME/share"

exec apache2-foreground "$@"
