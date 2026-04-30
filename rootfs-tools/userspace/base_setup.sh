#!/bin/bash
set -e

USERNAME=nabu
PASSWD=nabu

touch /TICI
touch /AGNOS

mkdir -p /etc/xbps.d
cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
sed -i 's|https://repo-default.voidlinux.org|https://mirrors.cicku.me/voidlinux|g' /etc/xbps.d/*-repository-*.conf

xbps-install -Syu xbps -y
xbps-install -Syu

xbps-install -y \
  base-minimal \
  runit-void \
  bash \
  coreutils \
  glibc-locales \
  sudo \
  shadow \
  curl \
  wget \
  alsa-utils \
  avahi \
  base-devel \
  bc \
  busybox \
  bluez \
  clang \
  cmake \
  czmq-devel \
  dbus-devel \
  dfu-util \
  dhcpcd \
  dnsmasq \
  evtest \
  freetype-devel \
  fuse-sshfs \
  gdb \
  gdbm-devel \
  git \
  git-lfs \
  glib-devel \
  hostapd \
  htop \
  i2c-tools \
  inotify-tools \
  iproute2 \
  iputils \
  jq \
  kmod \
  libarchive-devel \
  libcurl-devel \
  libffi-devel \
  libgpiod \
  liblzma-devel \
  libomp-devel \
  libtool \
  libusb-devel \
  libuv-devel \
  llvm \
  logrotate \
  lz4 \
  nano \
  ncurses-devel \
  net-tools \
  NetworkManager \
  nload \
  opencl-headers \
  ppp \
  pv \
  rsync \
  rsyslog \
  SDL2-devel \
  smartmontools \
  sqlite-devel \
  squashfs-tools \
  tmux \
  traceroute \
  iw \
  zlib-devel \
  libqmi \
  libqmi-devel \
  ModemManager \
  ModemManager-devel \
  cronie \
  alacritty-terminfo \
  vim

useradd -m -s /usr/bin/bash $USERNAME
echo "$USERNAME:$PASSWD" | chpasswd
groupadd -f gpio
groupadd -f gpu
usermod -aG wheel,video,audio,disk,dialout,gpio,gpu $USERNAME
if getent group bluetooth >/dev/null; then
  usermod -aG bluetooth $USERNAME
fi

echo "net.ipv4.conf.all.rp_filter = 2" >> /etc/sysctl.conf
echo "vm.dirty_expire_centisecs = 200" >> /etc/sysctl.conf

echo "nabu - rtprio 100" >> /etc/security/limits.conf
echo "nabu - nice -10" >> /etc/security/limits.conf

echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales

mkdir -p /data /persist /config /system
chown $USERNAME:$USERNAME /data
chown $USERNAME:$USERNAME /persist
chown root:root /config

echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
echo "nabu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nabu

ln -sf /usr/bin/bash /bin/sh

ln -sf /etc/sv/dbus /etc/runit/runsvdir/default/
ln -sf /etc/sv/NetworkManager /etc/runit/runsvdir/default/
ln -sf /etc/sv/sshd /etc/runit/runsvdir/default/
ln -sf /etc/sv/avahi-daemon /etc/runit/runsvdir/default/
ln -sf /etc/sv/cronie /etc/runit/runsvdir/default/

rm -f /etc/runit/runsvdir/default/agetty-tty1
rm -f /etc/runit/runsvdir/default/agetty-tty2
rm -f /etc/runit/runsvdir/default/agetty-tty3
rm -f /etc/runit/runsvdir/default/agetty-tty4
rm -f /etc/runit/runsvdir/default/agetty-tty5
rm -f /etc/runit/runsvdir/default/agetty-tty6

ln -sf /etc/sv/agetty-ttyMSM0 /etc/runit/runsvdir/default/ 2>/dev/null
ln -sf /etc/sv/agetty-ttyAMA0 /etc/runit/runsvdir/default/ 2>/dev/null

export XDG_DATA_HOME="/usr/local"
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

uv python install 3.12

uv venv $XDG_DATA_HOME/venv --seed --python 3.12

echo "base_setup.sh complete"