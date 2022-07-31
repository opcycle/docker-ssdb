FROM alpine

ARG VERSION=${VERSION:-master}

RUN apk add --no-cache --virtual .build-deps \
      curl gcc g++ make autoconf libc-dev libevent-dev linux-headers perl tar \
    && mkdir -p /ssdb/tmp \
    && mkdir -p /opt/ssdb \
    && mkdir -p /var/ssdb \
    && curl -Lk "https://github.com/ideawu/ssdb/archive/${VERSION}.tar.gz" | \
       tar -xz -C /ssdb/tmp --strip-components=1 \
    && cd /ssdb/tmp \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && cp ssdb-server /opt/ssdb \
    && cp ssdb-repair /opt/ssdb \
    && cp ssdb-dump /opt/ssdb \
    && apk add --virtual .rundeps libstdc++ \
    && apk del .build-deps \
    && rm -rf /ssdb

ADD ssdb.conf /opt/ssdb/ssdb.conf

EXPOSE 16379
VOLUME /var/ssdb

CMD ["/opt/ssdb/ssdb-server", "/opt/ssdb/ssdb.conf"]