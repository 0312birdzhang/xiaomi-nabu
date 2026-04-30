#!/bin/bash
set -e

rm -rf /etc/timezone /etc/localtime
ln -s /data/etc/timezone /etc/timezone
ln -s /data/etc/localtime /etc/localtime

rm -f /etc/ssh/ssh_host*

rm -rf /etc/NetworkManager/system-connections
ln -s /data/etc/NetworkManager/system-connections /etc/NetworkManager/system-connections
rm -rf /etc/netplan/
ln -s /data/etc/netplan/ /etc/netplan

mkdir -p /usr/default/

rm -rf /var/cache/*
cp -a /var/db/xbps /usr/lib/xbps-db
mv /var /usr/default && mkdir /var

mv /home /usr/default && mkdir /home

rm -rf /tmp && mkdir /tmp
rm -rf /cache && mkdir /cache
rm -rf /systemrw && mkdir /systemrw
mkdir -p /rwtmp