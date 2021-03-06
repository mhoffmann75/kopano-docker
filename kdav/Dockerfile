ARG docker_repo=zokradonh
FROM composer:1.8.4 as composer

RUN git clone --depth 1 https://stash.kopano.io/scm/kc/kdav.git /usr/share/kdav
WORKDIR /usr/share/kdav
RUN composer install

FROM ${docker_repo}/kopano_base

ARG DEBIAN_FRONTEND=noninteractive

ARG ADDITIONAL_KOPANO_PACKAGES=""
ARG DOWNLOAD_COMMUNITY_PACKAGES=1
ARG KOPANO_CORE_REPOSITORY_URL="file:/kopano/repo/core"
ARG KOPANO_REPOSITORY_FLAGS="trusted=yes"
ARG KOPANO_CORE_VERSION=newest
ARG RELEASE_KEY_DOWNLOAD=0

# install Kopano WebApp and refresh ca-certificates
RUN \
    # community download and package as apt source repository
    . /kopano/helper/create-kopano-repo.sh && \
    if [ ${DOWNLOAD_COMMUNITY_PACKAGES} -eq 1 ]; then \
        dl_and_package_community "core"; \
    fi; \
    echo "deb [${KOPANO_REPOSITORY_FLAGS}] ${KOPANO_CORE_REPOSITORY_URL} ./" > /etc/apt/sources.list.d/kopano.list; \
    # save kopano version
    echo "core-${KOPANO_CORE_VERSION}" > /kopano/buildversion; \
    set -x && \
    apt-get update && apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-php7.0 \
        crudini \
        php7-mapi \
        php-xml \
        php-mbstring \
	php-zip \
        sqlite \
        php-sqlite3 \
        ca-certificates \
        git \
        unzip \
        ${ADDITIONAL_KOPANO_PACKAGES} \
    && rm -rf /var/cache/apt /var/lib/apt/lists/*

COPY apache2-kopano-kdav.conf /etc/apache2/sites-available/kopano-kdav.conf

# configure basics
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    # configure apache
    rm /etc/apache2/sites-enabled/* && \
    sed -e 's,^ErrorLog.*,ErrorLog "|/bin/cat",' -i /etc/apache2/apache2.conf && \
    sed -e "s,MaxSpareServers[^:].*,MaxSpareServers 5," -i /etc/apache2/mods-available/mpm_prefork.conf && \
    a2disconf other-vhosts-access-log && \
    a2ensite kopano-kdav && \
    echo "Listen 80" > /etc/apache2/ports.conf && \
    # configure mod_php
    a2enmod rewrite && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP upload_max_filesize 500M && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP post_max_size 500M && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP max_input_vars 1800 && \
    crudini --set /etc/php/7.0/apache2/php.ini Session session.save_path /run/sessions && \
    mkdir -p /var/lib/kopano/kdav && \
    chown www-data:www-data /var/lib/kopano/kdav && \
    mkdir -p /var/log/kdav && \
    chown www-data:www-data /var/log/kdav

COPY --from=composer /usr/share/kdav /usr/share/kdav

EXPOSE 80/tcp

COPY start.sh /kopano/start.sh

ENV LANG en_US.UTF-8

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/kopano/start.sh" ]
