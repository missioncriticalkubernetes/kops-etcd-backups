FROM ubuntu:xenial

WORKDIR /opt

RUN echo "deb http://ppa.launchpad.net/alestic/ppa/ubuntu xenial main" > /etc/apt/sources.list.d/alestic.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EC3735E12A0C5C1B98F0CF350EC7E508BE09C571 \
 && apt-get update \
 && apt-get install -y cron curl ec2-expire-snapshots awscli jq \
 && apt-get clean all \
 && rm -rf /var/lib/apt/lists/*

COPY crontab /etc/crontab
RUN chmod 0600 /etc/crontab

COPY snapshot-util docker-entrypoint /opt/

CMD exec /opt/docker-entrypoint
