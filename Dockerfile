FROM alpine:3

MAINTAINER "TheAssassin <theassassin@users.noreply.github.com>"

RUN apk update && \
    apk add gcc g++ sdl2-dev zlib-dev perl git wget ca-certificates coreutils make mesa-dev musl-dev glu-dev tini sdl2_image-dev sdl2_mixer-dev psmisc python3 && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ dockerize


ARG BRANCH="v1.6.0"
ARG COMMIT=""

RUN mkdir /redeclipse
WORKDIR /redeclipse

ADD serverip.patch /serverip.patch
RUN git clone --branch "$BRANCH" https://github.com/redeclipse-legacy/base /redeclipse && \
    cd /redeclipse && \
    git apply < /serverip.patch && \
    ([ "$COMMIT" != "" ] && git checkout "$COMMIT" || true) && \
    git submodule update --init -- data/maps && \
    make -C src -j"$(nproc)" redeclipse_server_linux install && \
    mkdir -p /redeclipse/.redeclipse/ && \
    adduser -S -D -h /redeclipse redeclipse && \
    chown redeclipse: -R /redeclipse && \
    rm -rf /redeclipse/.git

ADD ./run.sh /run.sh

EXPOSE 28799/udp 28800/udp 28801/udp 28802/udp

ENTRYPOINT ["/sbin/tini", "--"]

ADD ./generate-servinit-template.py /generate-servinit-template.py
RUN python3 /generate-servinit-template.py /redeclipse/doc/examples/servinit.cfg > /servinit.tmpl

CMD dockerize -template /servinit.tmpl:/redeclipse/.redeclipse/servinit.cfg /run.sh

USER redeclipse

