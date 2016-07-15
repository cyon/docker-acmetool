FROM python:3.5-alpine

MAINTAINER Dominic Luechinger 'dol@cyon.ch'

# Fix user/group ID, no login, no home, no password
RUN adduser -u 1337 -s /sbin/nologin -H -D acmetool

RUN apk --no-cache add --virtual .install-deps \
        curl \
        dpkg \
        tar \
    && ACMETOOL_VERSION='0.0.54' \
    && CPU_ARCH=$(dpkg --print-architecture | awk -F'-' '{print $NF}') \
    && curl -N -L https://github.com/hlandau/acme/releases/download/v${ACMETOOL_VERSION}/acmetool-v${ACMETOOL_VERSION}-linux_${CPU_ARCH}.tar.gz \
    | tar xz \
        --strip-components=2 \
        acmetool-v${ACMETOOL_VERSION}-linux_${CPU_ARCH}/bin/acmetool \
    && install -m 0755 \
        -o root \
        -g root \
        acmetool /usr/bin \
    && apk del .install-deps \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache \
        ca-certificates \
        su-exec \
    && su-exec acmetool true

COPY entrypoint.sh /entrypoint.sh

VOLUME /var/lib/acme

ENTRYPOINT ["/entrypoint.sh"]

CMD ["acmetool"]
