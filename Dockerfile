FROM debian

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y --no-install-recommends \
  curl \
  gettext \
  net-tools \
  openbox \
  supervisor \
  tigervnc-scraping-server \
  xvfb \
  ca-certificates

RUN apt install -y --no-install-recommends \
  novnc \
  nicotine

RUN useradd -u 1000 -U -d /data -s /bin/false nicotine
RUN usermod -G users nicotine
RUN mkdir /downloads
RUN chown nicotine:nicotine /downloads

#RUN chown -R nicotine:nicotine /app

RUN apt-get clean
RUN rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

COPY ./etc /etc
COPY ./usr /usr
COPY ./scripts/init.sh /tmp/init.sh

EXPOSE 6080/tcp
VOLUME ["/data","/downloads"]

CMD ["/bin/bash", "-c", "/tmp/init.sh;/usr/bin/supervisord -c /etc/supervisord.conf"]
