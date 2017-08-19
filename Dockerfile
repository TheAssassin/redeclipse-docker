FROM alpine:3.4

MAINTAINER "TheAssassin <theassassin@users.noreply.github.com>"

RUN apk update && \
    apk add gcc g++ sdl2-dev zlib-dev perl git wget ca-certificates coreutils make mesa-dev musl-dev glu-dev tini && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ sdl2_image-dev sdl2_mixer-dev && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ psmisc && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ dockerize

ARG BRANCH="stable"
ARG COMMIT=""

RUN mkdir /redeclipse
WORKDIR /redeclipse

RUN git clone --branch "$BRANCH" https://github.com/red-eclipse/base /redeclipse && \
    cd /redeclipse && \
    ([ "$COMMIT" != "" ] && git checkout "$COMMIT" || true) && \
    git submodule update --init -- data/maps && \
    make -C src -j"$(nproc)" redeclipse_server_linux install && \
    mkdir -p /redeclipse/.redeclipse/ && \
    adduser -S -D -h /redeclipse redeclipse && \
    chown redeclipse: -R /redeclipse && \
    rm -rf /redeclipse/.git

ADD ./servinit.tmpl /servinit.tmpl
ADD ./run.sh /run.sh

USER redeclipse

EXPOSE 28799/udp 28800/udp 28801/udp 28802/udp

ENTRYPOINT ["/sbin/tini", "--"]

CMD dockerize -template /servinit.tmpl:/redeclipse/.redeclipse/servinit.cfg /run.sh
