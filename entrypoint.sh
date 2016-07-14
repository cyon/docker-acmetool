#!/bin/sh
set -e

if [ "${1:0:1}" = '-' ]; then
    shift
    set -- acmetool "$@"
fi

if [ "$1" = 'acmetool' ]; then
    chown -R acmetool: /var/lib/acme
    shift
    if [ "$#" -gt 0 ]; then
        exec su-exec acmetool /usr/bin/acmetool "$@"
    else
        exec su-exec acmetool /usr/bin/acmetool --help
    fi
fi

exec "$@"
