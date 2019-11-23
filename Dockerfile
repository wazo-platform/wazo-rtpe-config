FROM debian:buster
RUN apt-get update \
  && apt-get -y --quiet --force-yes upgrade curl iproute2 \
  && apt-get install -y --no-install-recommends ca-certificates gcc g++ make build-essential git iptables-dev libavfilter-dev \
  libevent-dev libpcap-dev libxmlrpc-core-c3-dev markdown \
  libjson-glib-dev default-libmysqlclient-dev libhiredis-dev libssl-dev \
  libcurl4-openssl-dev libavcodec-extra gperf libspandsp-dev \
  && cd /usr/local/src \
  && git clone https://github.com/sipwise/rtpengine.git \
  && cd rtpengine/daemon \
  && make && make install


FROM debian:buster-slim
LABEL maintainer="Wazo Authors <dev@wazo.community>"
ENV VERSION 1.0.0
RUN true && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends iproute2 curl bash netcat
RUN apt-get install -y --no-install-recommends libc6 libglib2.0-0 zlib1g libpcre3 libssl1.1 \
libevent-pthreads-2.1-6 libevent-2.1-6 libpcap0.8 libxmlrpc-core-c3 libcurl4 libhiredis0.14 \
libjson-glib-1.0-0 libglib2.0-0 libip4tc0 libip6tc0 libavcodec58 libavutil56 libswresample3 \
libc6 libnghttp2-14 libidn2-0 librtmp1 libssh2-1 libpsl5 libgssapi-krb5-2 libkrb5-3 libk5crypto3 \
libcom-err2 libldap-2.4-2 libglib2.0-0 libmount1 libselinux1 libc6 libffi6 libvpx5 libwebpmux3 \
libwebp6 liblzma5 libcrystalhd3 librsvg2-2 libcairo2 libzvbi0 libsnappy1v5 libaom0 libcodec2-0.8.1 \
libgsm1 libmp3lame0 libopenjp2-7 libopus0 libshine3 libspeex1 libtheora0 libtwolame0 libvorbis0a \
libvorbisenc2 libwavpack1 libx264-155 libx265-165 libxvidcore4 libva2 libva-drm2 libva-x11-2 libvdpau1 \
libx11-6 libdrm2 libsoxr0 libunistring2 libgnutls30 libhogweed4 libnettle6 libgmp10 libgcrypt20 \
libkrb5support0 libkeyutils1 libsasl2-2 libblkid1 libc6 libstdc++6 libgcc1 libgdk-pixbuf2.0-0 \
libpangocairo-1.0-0 libpangoft2-1.0-0 libpango-1.0-0 libfontconfig1 libcroco3 libxml2 libpixman-1-0 \
libfreetype6 libpng16-16 libxcb-shm0 libxcb1 libxcb-render0 libxrender1 libxext6 libogg0 \
libnuma1 libxfixes3 libgomp1 libp11-kit0 libtasn1-6 libgpg-error0 libuuid1 libharfbuzz0b \
libthai0 libfribidi0 libexpat1 libicu63 libxau6 libxdmcp6 libgraphite2-3 libdatrie1 libbsd0 \
libavformat58 libc6 libavfilter7 libspandsp2 libmariadb3
RUN rm -rf /var/lib/apt/lists/*
COPY --from=0 /usr/local/src/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine
COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
RUN mkdir -p /etc/rtpengine
COPY ./rtpengine.sample.conf /etc/rtpengine/rtpengine.sample.conf
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
