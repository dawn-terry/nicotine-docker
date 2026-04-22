FROM debian

ARG DEBIAN_FRONTEND=noninteractive
ARG NICOTINE_VERSION=3.3.10
ARG NOVNC_VERSION=1.6.0
ARG WEBSOCKIFY_VERSION=0.13.0

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

#RUN mkdir /usr/share/novnc
#RUN chmod 777 /usr/share/novnc
#RUN curl -fL# https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz -o /tmp/novnc.tar.gz
#RUN tar -xf /tmp/novnc.tar.gz --strip-components=1 -C /usr/share/novnc

#RUN mkdir /usr/share/novnc/utils/websockify
#RUN curl -fL# https://github.com/novnc/websockify/archive/refs/tags/v${WEBSOCKIFY_VERSION}.tar.gz -o /tmp/websockify.tar.gz
#RUN tar -xf /tmp/websockify.tar.gz --strip-components=1 -C /usr/share/novnc/utils/websockify

RUN apt install -y --no-install-recommends \
  novnc \
  nicotine

RUN useradd -u 1000 -U -d /data -s /bin/false nicotine
RUN usermod -G users nicotine
RUN mkdir /downloads
RUN chown nicotine:nicotine /downloads

ENV PIPX_HOME=/app

RUN apt install -y \
  gir1.2-adw-1 \  
  gir1.2-gspell-1 \
  gir1.2-gtk-4.0 \
  libcairo2-dev \
  libgirepository-2.0-dev \
  libglib2.0-dev \
  libgtk-4-dev \
  python3 \
  python3-dev \
  python3-gdbm \
  python3-gi \
  meson \
  pipx

RUN pipx install PyGObject
RUN pipx install pycairo
RUN pipx install nicotine-plus==${NICOTINE_VERSION}

RUN chown -R nicotine:nicotine /app

RUN apt --purge remove -y \
  curl \
  libcairo2-dev \
  libglib2.0-dev \
  libgtk-4-dev \
  python3-dev \
  meson \
  pipx
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
