# vamOS Void Linux Build
# check=error=true

FROM scratch AS void-base

ARG VOID_ROOTFS
ADD ${VOID_ROOTFS} /

RUN mkdir -p /tmp/nabu

ARG USERNAME=nabu

COPY ./rootfs-tools/userspace/base_setup.sh /tmp/nabu/
RUN chmod +x /tmp/nabu/base_setup.sh && /tmp/nabu/base_setup.sh

FROM void-base

ARG USERNAME=nabu

COPY ./rootfs-tools/userspace/irsc_util/ /tmp/nabu/irsc_util/
RUN cd /tmp/nabu/irsc_util && \
    gcc -Wall -O2 -o /usr/bin/irsc_util irsc_util.c && \
    rm -rf /tmp/nabu/irsc_util

RUN yes | xbps-install -Sy mesa-dri

RUN xbps-install -y \
  bash-completion \
  btop \
  git \
  hyperfine \
  iperf \
  iperf3 \
  ripgrep \
  ncdu \
  nfs-utils \
  socat \
  stress-ng \
  tree \
  wavemon \
  android-tools \
  avahi-utils \
  usbutils \
  vim

ARG XDG_DATA_HOME="/usr/local"
ENV PATH="/root/.local/bin:$XDG_DATA_HOME/venv/bin:$PATH"
COPY ./rootfs-tools/userspace/uv /tmp/nabu/uv
RUN cd /tmp/nabu/uv && \
    MAKEFLAGS="-j$(nproc)" UV_CONCURRENT_BUILDS=4 UV_NO_CACHE=1 UV_PROJECT_ENVIRONMENT=$XDG_DATA_HOME/venv \
    uv sync --frozen --inexact

RUN wget -qO- https://github.com/0312birdzhang/ubuntu-xiaomi-nabu/archive/refs/heads/master.tar.gz | tar xz --strip-components=1 -C / && \
    cp -r firmware-xiaomi-nabu/usr/lib/firmware/qcom/sm8150 /lib/firmware/qcom/ && \
    cp -r firmware-xiaomi-nabu/usr/lib/firmware/ath10k /lib/firmware/ && \
    cp -r firmware-xiaomi-nabu/usr/lib/firmware/qca /lib/firmware/ && \
    cp -r firmware-xiaomi-nabu/usr/lib/firmware/cirrus /lib/firmware/ && \
    cp -r firmware-xiaomi-nabu/usr/lib/firmware/novatek /lib/firmware/ && \
    cp -p firmware-xiaomi-nabu/usr/lib/firmware/regulatory.db /lib/firmware/ && \
    cp -p firmware-xiaomi-nabu/usr/lib/firmware/regulatory.db.p7s /lib/firmware/ && \
    cp -r alsa-xiaomi-nabu/usr/share/alsa /usr/share/ && \
    ln -sf /lib/firmware/ath10k/WCN3990/hw1.0/wlanmdsp.mbn /lib/firmware/qcom/sm8150/wlanmdsp.mbn 2>/dev/null || true && \
    rm -rf firmware-xiaomi-nabu alsa-xiaomi-nabu

COPY ./rootfs-tools/userspace/root/ /

RUN chown -R nabu:nabu /home/nabu
RUN printf '\nif [ -f ~/.bash_aliases ]; then\n    . ~/.bash_aliases\nfi\n' >> /home/$USERNAME/.bashrc
RUN mkdir -p /root/.config

RUN for svc in \
  avahi-daemon \
  cronie \
  dbus \
  NetworkManager \
  sshd \
  agetty-ttyMSM0 \
  agetty-ttyAMA0; do \
    ln -sf /etc/sv/$svc /etc/runit/runsvdir/default/; \
  done

RUN rm -f /etc/runit/runsvdir/default/udevd

RUN sed -i 's/FileCreateMode 0640/FileCreateMode 0644/' /etc/rsyslog.conf

RUN chmod +x /usr/local/bin/rootfs-*.sh

COPY ./rootfs-tools/userspace/readonly_setup.sh /tmp/nabu/
RUN chmod +x /tmp/nabu/readonly_setup.sh && /tmp/nabu/readonly_setup.sh

RUN find /usr/share/locale -maxdepth 1 -mindepth 1 ! -name en_US ! -name en -exec rm -rf {} + && \
    rm -rf /usr/share/man /usr/share/doc /usr/share/info && \
    rm -rf /var/cache/xbps

RUN echo ttyS0 >> /etc/securetty
RUN echo ttyMSM0 >> /etc/securetty

RUN usermod -p '$6$nabudev$NmMcideymvdAilEr.m7OeTX.fnt3H4UmcgheKB39rkrmebVfvZIUE17zjgtOxi7K07uGicamzFFbkFLE3EjQj/' nabu && \
    usermod -p '$6$nabudev$NmMcideymvdAilEr.m7OeTX.fnt3H4UmcgheKB39rkrmebVfvZIUE17zjgtOxi7K07uGicamzFFbkFLE3EjQj/' root

RUN mkdir -p /var/chroot/ssh

RUN echo '#!/bin/sh' > /etc/sv/sshd/run && \
    echo 'exec 2>&1' >> /etc/sv/sshd/run && \
    echo 'mkdir -p /data/etc/ssh' >> /etc/sv/sshd/run && \
    echo 'if [ ! -f /data/etc/ssh/ssh_host_ed25519_key ]; then' >> /etc/sv/sshd/run && \
    echo '  ssh-keygen -t ed25519 -f /data/etc/ssh/ssh_host_ed25519_key -N ""' >> /etc/sv/sshd/run && \
    echo '  ssh-keygen -t rsa -b 4096 -f /data/etc/ssh/ssh_host_rsa_key -N ""' >> /etc/sv/sshd/run && \
    echo '  ssh-keygen -t ecdsa -f /data/etc/ssh/ssh_host_ecdsa_key -N ""' >> /etc/sv/sshd/run && \
    echo 'fi' >> /etc/sv/sshd/run && \
    echo 'exec /usr/bin/sshd -D' >> /etc/sv/sshd/run

RUN ldconfig