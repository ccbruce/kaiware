#!/bin/bash
echo fs.inotify.max_user_watches=4096 | tee -a /etc/sysctl.conf && sudo sysctl -p
service ssh restart
echo "***************************************************"
echo "Call Command"
exec "$@"
echo "***************************************************"

## //node.js docker-entry.sh
#!/bin/sh
set -e

# Run command with node if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

#exec "$@"
##


rm -f /opt/startup/monitor.log
touch /opt/startup/monitor.log
tail /opt/startup/monitor.log

