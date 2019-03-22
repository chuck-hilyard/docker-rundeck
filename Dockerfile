FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y openjdk-8-jdk \
    openssh-client \
    git \
    awscli \
    python3 python3-pip boto3 \
    uuid-runtime \
    wget && \
    wget https://dl.bintray.com/rundeck/rundeck-deb/3.0.17.20190311-1.201903111853_all.deb && \
    dpkg -i rundeck_3.0.7.20181008-1.201810082317_all.deb

RUN pip3 install requests consulate consul_kv

COPY init.py /tmp/init.py
COPY rundeck-config.properties /etc/rundeck/rundeck-config.properties
COPY jaas-ldap.conf /etc/rundeck/jaas-ldap.conf
RUN chown -R rundeck:rundeck /etc/rundeck

EXPOSE 4440

ENV ROLE_ID "somevaultstuff"

CMD ["python3", "-u", "tmp/init.py"]

#wget https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.0.7.20181008-1.201810082317_all.deb && \
