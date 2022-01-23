#!/bin/bash

# auto populate volumes with code

! [[ -e /var/www/html ]] \
&& ln -s "$APP_HOME" /var/www/html \
|| {
    ! [[ "$(ls -A /var/www/html)" ]] && ! [[ -L /var/www/html ]] && {
            echo "mount is empty"
            ls -A /var/www/html
            cp -rfp /usr/src/app/. /var/www/html/

    }


}

apache2-foreground
