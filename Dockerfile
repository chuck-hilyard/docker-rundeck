FROM ubuntu:latest

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk \
    curl \
    openssh-client \
    git \
    awscli \
    python3 python3-pip python3-boto3 \
    uuid-runtime \
    supervisor \
    wget && \
    wget --no-check-certificate https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.1.3.20191204-1_all.deb && \
    dpkg -i rundeck_3.1.3.20191204-1_all.deb

RUN pip3 install requests consulate consul_kv

COPY init.py /tmp/init.py
COPY rundeck-config.properties /etc/rundeck/rundeck-config.properties
COPY jaas-ldap.conf /etc/rundeck/jaas-ldap.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown -R rundeck:rundeck /etc/rundeck

EXPOSE 4440

ENV ROLE_ID "somevaultstuff"

COPY entrypoint.sh /usr/local/bin/
#ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

#CMD ["python3", "-u", "tmp/init.py"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

#wget https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.0.7.20181008-1.201810082317_all.deb && \
#wget https://dl.bintray.com/rundeck/rundeck-deb/3.0.17.20190311-1.201903111853_all.deb && \
#wget https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.0.17.20190311-1.201903111853_all.deb && \
