# Docker build file for Missive/Logger
#
# Things like the custom cert were taken from
# https://github.com/sendgridlabs/loggly-docker/blob/master/rsyslog.conf with thanks.
#
# Alpine 3.5 has rsyslogd 8.20.0
#        3.6 has          8.26.0
#        3.7 has          8.31.0

FROM alpine:3.7

# Do a system update
RUN apk update

# Need openssl to fetch dumb-init
# Loggly file watcher use rsyslog
RUN apk add --update openssl ca-certificates rsyslog rsyslog-tls

# Add dumb init to improve sig handling
RUN wget -O /usr/local/bin/dumb-init \
    https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Here's the switcher script
COPY run.sh /root/run.sh

# Here's the Loggly and Papertrail certs
#COPY config/loggly/loggly.crt /etc/loggly.crt
COPY config/papertrail/papertrail-bundle.pem /etc/papertrail-bundle.pem

# Choose one of these config files
#COPY config/loggly/rsyslog.conf /etc/rsyslog.conf
COPY config/papertrail/rsyslog.conf /etc/rsyslog.d/papertrail.conf

RUN mkdir /var/spool/rsyslog

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["sh", "/root/run.sh"]
