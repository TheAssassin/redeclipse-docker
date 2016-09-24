FROM alpine:3.4

MAINTAINER "TheAssassin <theassassin@users.noreply.github.com>"

RUN apk update && \
    apk add gcc g++ sdl2-dev zlib-dev perl git wget ca-certificates coreutils make mesa-dev musl-dev glu-dev tini && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ dockerize psmisc && \

# Build SDL_mixer and SDL_image this way until there are packages for Alpine Linux
RUN wget -O- https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz | tar xz && \
    wget -O- https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz | tar xz && \
    cd /SDL2_image-2.0.1 && ./configure --prefix /usr && make -j $(cat /proc/cpuinfo  | grep -c processor) install && \
    cd /SDL2_mixer-2.0.1 && ./configure --prefix /usr && make -j $(cat /proc/cpuinfo  | grep -c processor) install

RUN git clone --recursive --branch stable https://github.com/red-eclipse/base /redeclipse && \
    cd /redeclipse && \
    rm -r .git && \
    cd src && \
    make clean && \
    make -j $(cat /proc/cpuinfo  | grep -c processor) redeclipse_server_linux && \
    make install && \
    mkdir -p /redeclipse/.redeclipse/ && \
    adduser -S -D -h /redeclipse redeclipse && \
    chown redeclipse: -R /redeclipse

ADD ./servinit.tmpl /servinit.tmpl

WORKDIR /redeclipse
USER redeclipse

EXPOSE 28799/udp 28800/udp 28801/udp 28802/udp

ENV REDECLIPSE_BRANCH inplace

ENTRYPOINT ["/sbin/tini", "--"]

CMD dockerize -template /servinit.tmpl:/redeclipse/.redeclipse/servinit.cfg /redeclipse/redeclipse_server.sh
