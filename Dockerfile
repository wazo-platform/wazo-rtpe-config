FROM debian:buster

RUN apt-get update \
  && apt-get -y --quiet --force-yes upgrade curl iproute2 \
  && apt-get install -y --no-install-recommends ca-certificates gcc g++ make build-essential git iptables-dev libavfilter-dev \
  libevent-dev libpcap-dev libxmlrpc-core-c3-dev markdown netcat \
  libjson-glib-dev default-libmysqlclient-dev libhiredis-dev libssl-dev \
  libcurl4-openssl-dev libavcodec-extra gperf libspandsp-dev \
  && cd /usr/local/src \
  && git clone https://github.com/sipwise/rtpengine.git \
  && cd rtpengine/daemon \
  && make && make install \
  && cp /usr/local/src/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine \
  && rm -Rf /usr/local/src/rtpengine \
  && apt-get purge -y --quiet --force-yes --auto-remove \
  ca-certificates gcc g++ make build-essential git markdown \
  && rm -rf /var/lib/apt/* \
  && rm -rf /var/lib/dpkg/* \
  && rm -rf /var/lib/cache/* \
  && rm -Rf /var/log/* \
  && rm -Rf /usr/local/src/* \
  && rm -Rf /var/lib/apt/lists/*

COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for

EXPOSE 23000-32768/udp 22222/udp

RUN mkdir -p /etc/rtpengine
COPY ./rtpengine.sample.conf /etc/rtpengine/rtpengine.sample.conf

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
