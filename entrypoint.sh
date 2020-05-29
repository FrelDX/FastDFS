#!/bin/bash
# the env from k8s pod ip
HostIp=`ip addr|sed -nr 's#^.*inet (.*)/.*$#\1#gp'|grep -v 127.0.0.1`
sed -i "s#tracker_server=192.168.209.121:22122#tracker_server=$HostIp:22122#g" /etc/fdfs/storage.conf
sed -i "s#tracker_server=192.168.0.197:22122#tracker_server=$HostIp:22122#g" /etc/fdfs/client.conf
/etc/init.d/fdfs_trackerd start
/etc/init.d/fdfs_storaged start
/usr/local/nginx/sbin/nginx -g 'daemon off;'