FROM debian
ARG S6_OVERLAY_VERSION=3.2.0.0

# Install the necessary packages
# cron: to run the cron job
# xz-utils: to extract the s6-overlay
RUN apt-get update && \
    apt-get install -y cron xz-utils

# Copy the app source files
COPY src/main.sh /app/main.sh

# Copy the cron job file
ADD docker/crontab.txt /etc/cron.d/main
RUN chmod 0600 /etc/cron.d/main

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Copy the s6-overlay files
COPY docker/etc/s6-overlay /etc/s6-overlay

ENTRYPOINT ["/init"]
