FROM ubuntu:xenial

WORKDIR /opt

RUN apt-get update \
 && apt-get -y install software-properties-common \
 && add-apt-repository -y ppa:alestic \
 && apt-get update \
 && apt-get install -y cron curl ec2-expire-snapshots awscli jq \
 && apt-get purge --autoremove -y software-properties-common \
 && apt-get clean all \
 && rm -rf /var/lib/apt/lists/*

COPY crontab /etc/cron.d/
COPY *.sh /opt/

CMD ["cron", "-f"]
