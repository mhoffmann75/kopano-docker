FROM osixia/openldap:1.2.4

COPY bootstrap /container/service/slapd/assets/config/bootstrap
RUN rm /container/service/slapd/assets/config/bootstrap/schema/mmc/mail.schema
RUN touch /etc/ldap/slapd.conf
