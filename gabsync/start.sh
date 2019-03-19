#!/bin/bash

# define default value for serverhostname and serverport if not passed into container
KCCONF_SERVERHOSTNAME=${KCCONF_SERVERHOSTNAME:-127.0.0.1}
KCCONF_SERVERPORT=${KCCONF_SERVERPORT:-236}

set -eu # unset variables are errors & non-zero return values exit the whole script

#echo "Ensure directories"
#mkdir -p /run/sessions

if [ "$KCCONF_SERVERHOSTNAME" == "127.0.0.1" ]; then
	echo "Gabsync is using the default: connection"
else
	echo "Gabsync is using an ip connection"
	sed -e "s#define([\"']MAPI_SERVER[\"'],\s*[\"']default:[\"'])#define('MAPI_SERVER', 'https://${KCCONF_SERVERHOSTNAME}:${KCCONF_SERVERPORT}/kopano')#" \
	    -i /etc/z-push/kopano.conf.php
fi

echo "Starting Gabsync"
# cleaning up env variables
unset "${!KCCONF_@}"
while true; do
  set +e
  /usr/share/z-push/tools/gab-sync/gab-sync.php -a sync
  set -e
  echo "Automatically running GABSync in 24 hours - restart container to rerun it immediately"
  sleep 86400
done

