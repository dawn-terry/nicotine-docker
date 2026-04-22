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

RUN useradd -u 1000 -U -m -d /home/nicotine -s /bin/false nicotine
RUN usermod -G users nicotine

RUN apt-get clean
RUN rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

COPY ./etc /etc

RUN mkdir /home/nicotine/.config/nicotine
COPY ./config /home/nicotine/.config/nicotine

COPY ./usr /usr
COPY ./scripts/init.sh /tmp/init.sh

EXPOSE 6080/tcp

CMD ["/bin/bash", "-c", "/tmp/init.sh;/usr/bin/supervisord -c /etc/supervisord.conf"]
