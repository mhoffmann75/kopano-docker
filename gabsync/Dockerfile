ARG docker_repo=zokradonh
FROM ${docker_repo}/kopano_zpush
RUN apt-get update && apt-get install --no-install-recommends -y \
	z-push-kopano-gabsync \
	&& rm -rf /var/cache/apt /var/lib/apt/lists

# Patch Gabsync to make it work
# See https://jira.z-hub.io/browse/ZP-1463
# https://forum.kopano.io/topic/1928/8-7-80-missing-php-files-in-php-mapi-deb-package-ubuntu-16-04
# can be removed once gabsync is fixed - should not hurt
RUN sed -i -e "s/set_include_path(get_include_path() . PATH_SEPARATOR . BASE_PATH_CLI);/define('PATH_TO_ZPUSH', '..\/..\/backend\/kopano\/');\n    set_include_path(get_include_path() . PATH_SEPARATOR . BASE_PATH_CLI . PATH_SEPARATOR . BASE_PATH_CLI . PATH_TO_ZPUSH);/" /usr/share/z-push/tools/gab-sync/gab-sync.php

# adapt config for gabsync
RUN sed -i -e "s/define('USERNAME', '');/define('USERNAME', 'SYSTEM');/" /usr/share/z-push/tools/gab-sync/config.php

COPY start.sh /kopano/start.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/kopano/start.sh" ]

