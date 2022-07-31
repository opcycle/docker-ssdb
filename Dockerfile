FROM alpine

ARG VERSION=${VERSION:-master}

RUN apk add --no-cache --virtual .build-deps \
      curl gcc g++ make autoconf libc-dev libevent-dev linux-headers perl tar \
    && mkdir -p /ssdb/tmp \
    && curl -Lk "https://github.com/ideawu/ssdb/archive/${VERSION}.tar.gz" | \
       tar -xz -C /ssdb/tmp --strip-components=1 \
    && cd /ssdb/tmp \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install PREFIX=/opt/ssdb \
    && rm -rf /ssdb/tmp \
    && apk add --virtual .rundeps libstdc++ \
    && apk del .build-deps

EXPOSE 16379
VOLUME /var/ssdb

CMD ["/opt/ssdb/ssdb-server", "/opt/ssdb/ssdb.conf"]