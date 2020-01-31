ARG NGINX_VERSION=1.17.4
ARG NGINX_RTMP_VERSION=1.1.7.10
ARG NGINX_RTMP_BRANCH=dev
ARG NGINX_RTMP_COMMIT="3bf75232676da7eeff85dcd0fc831533a5eafe6b"
ARG FFMPEG_VERSION=4.2.2

##############################
# Build the NGINX-build image.
#FROM alpine:3.8 as build-nginx
#ARG NGINX_VERSION
#ARG NGINX_RTMP_VERSION
#ARG NGINX_RTMP_COMMIT

# Build dependencies.
#RUN apk add --update \
#  build-base \
#  ca-certificates \
#  curl \
#  gcc \
#  libc-dev \
#  libgcc \
#  linux-headers \
#  make \
#  musl-dev \
#  openssl \
#  openssl-dev \
#  pcre \
#  pcre-dev \
#  pkgconf \
#  pkgconfig \
#  zlib-dev
 

# Get nginx source.
#RUN cd /tmp && \
#  wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
#  tar zxf nginx-${NGINX_VERSION}.tar.gz && \
#  rm nginx-${NGINX_VERSION}.tar.gz

# Get nginx-rtmp module.
#RUN cd /tmp && \
#  echo https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/${NGINX_RTMP_COMMIT}.tar.gz && wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/3bf75232676da7eeff85dcd0fc831533a5eafe6b.tar.gz && \
#  tar zxf 3bf75232676da7eeff85dcd0fc831533a5eafe6b.tar.gz && rm 3bf75232676da7eeff85dcd0fc831533a5eafe6b.tar.gz

# Compile nginx with nginx-rtmp module.
#RUN cd /tmp/nginx-${NGINX_VERSION} && \
#	./configure \
#		--with-compat \
#		--add-dynamic-module=/tmp/nginx-rtmp-module-3bf75232676da7eeff85dcd0fc831533a5eafe6b \
#		&& \
#	cd /tmp/nginx-${NGINX_VERSION} && mkdir -p /etc/nginx/modules && make modules && cp -r objs/* /etc/nginx/modules/

###############################
# Build the FFmpeg-build image.
FROM alpine:3.8 as build-ffmpeg
ARG FFMPEG_VERSION
ARG PREFIX=/usr/local
ARG MAKEFLAGS="-j4"

# FFmpeg build dependencies.
RUN apk add --update \
  build-base \
  freetype-dev \
  lame-dev \
  libogg-dev \
  libass \
  libass-dev \
  libvpx-dev \
  libvorbis-dev \
  libwebp-dev \
  libtheora-dev \
  opus-dev \
  pkgconf \
  pkgconfig \
  rtmpdump-dev \
  wget \
  x264-dev \
  x265-dev \
  yasm

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --update fdk-aac-dev

# Get FFmpeg source.
RUN cd /tmp/ && \
  wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Compile ffmpeg.
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  ./configure \
  --prefix=${PREFIX} \
  --enable-version3 \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
  --enable-libmp3lame \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libopus \
  --enable-libfdk-aac \
  --enable-libass \
  --enable-libwebp \
  --enable-librtmp \
  --enable-postproc \
  --enable-avresample \
  --enable-libfreetype \
  --enable-openssl \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --extra-libs="-lpthread -lm" && \
  make && make install && make distclean

# Cleanup.
RUN rm -rf /var/cache/* /tmp/*

##########################
# Build the release image.
FROM linuxserver/letsencrypt

# copy rtmp prebuilts
#COPY --from=build-nginx /etc/nginx/modules /usr/lib/nginx/modules
COPY --from=build-ffmpeg /usr/local /usr/local
COPY --from=build-ffmpeg /usr/lib/libfdk-aac.so.2 /usr/lib/libfdk-aac.so.2

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
        ffmpeg \
	php7-cli php7-cgi php7-fpm

# add local files
COPY root/ /
