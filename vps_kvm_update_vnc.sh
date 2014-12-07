#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/root/bin"
myip="$(ifconfig $(ip route list | grep "^default" | sed s#"^default.*dev "#""#g | cut -d" " -f1)  |grep inet |grep -v inet6 | awk '{ print $2 }' | cut -d: -f2)"
name=$1
if [ $# -ne 1 ]; then
 echo "Open VNC To IP"
 echo " Setup xinetd to allow VNC access from an IP masq for a specific VPN"
 echo "Syntax $0 [vps]"
 echo " ie $0 windows1"
#check if vps exists
elif ! virsh dominfo $name >/dev/null 2>&1; then
 echo "Invalid VPS $name";
else
 port="$(virsh dumpxml $name | grep vnc |grep port= | cut -d\' -f4)"
 mv -f /etc/xinetd.d/${name} /etc/xinetd.d/${name}.backup
 cat /etc/xinetd.d/${name}.backup  | \
 sed s#"port.*=.*"#"port                    = $port"#g > /etc/xinetd.d/$name
 rm -f /etc/xinetd.d/${name}.backup
 echo "VNC Server $myip Port $port For VPS $name Opened To Previous IP"
 if [ -e /etc/init.d/xinetd ]; then
  /etc/init.d/xinetd reload >/dev/null 2>&1
 else
  service xinetd reload >/dev/null 2>&1
 fi;
fi

