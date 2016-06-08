FROM alpine:3.3

MAINTAINER "TheAssassin <theassassin@users.noreply.github.com>"

ADD ./repatches/duelmaxqueued.patch /patches/duelmaxqueued.patch
ADD ./repatches/fix_ircfilter.patch /patches/fix_ircfilter.patch

RUN apk update && \
    apk add gcc g++ sdl-dev zlib-dev sdl_mixer-dev sdl_image-dev perl git wget ca-certificates coreutils make mesa-dev musl-dev glu-dev && \
    wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -O dockerize.tar.gz && \
    [[ "$(sha256sum dockerize.tar.gz | cut -d' ' -f1)" == "c0e2e33cfe066036941bf8f2598090bd8e01fdc05128490238b2a64cf988ecfb" ]] && echo "SHA256 checksum OK" || exit 1; \
    tar -C /usr/local/bin -xzvf dockerize.tar.gz && \
    git clone --recursive https://github.com/red-eclipse/base /redeclipse && \
    cd /redeclipse && \
    git checkout v1.5.3 && \
    git submodule update && \
    rm -r .git && \
    patch -p1 < /patches/duelmaxqueued.patch && \
    patch -p1 < /patches/fix_ircfilter.patch && \
    cd src && \
    make clean && \
    make -j $(cat /proc/cpuinfo  | grep processor | wc -l) && \
    make install && \
    mkdir -p /redeclipse/.redeclipse/ && \
    adduser -S -D -h /redeclipse redeclipse && \
    chown redeclipse: -R /redeclipse

ADD ./servinit.tmpl /servinit.tmpl

WORKDIR /redeclipse
USER redeclipse

EXPOSE 28799/udp 28800/udp 28801/udp 28802/udp

ENV REDECLIPSE_BRANCH inplace

CMD dockerize -template /servinit.tmpl:/redeclipse/.redeclipse/servinit.cfg /redeclipse/redeclipse_server.sh
