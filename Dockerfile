FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y openjdk-8-jdk \
    openssh-client \
    python3 python3-pip \
    uuid-runtime \
    wget && \
    wget https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.0.7.20181008-1.201810082317_all.deb && \
		dpkg -i rundeck_3.0.7.20181008-1.201810082317_all.deb

RUN pip3 install requests consulate consul_kv

COPY init.py /tmp/init.py

EXPOSE 4440

CMD ["python3", "-u", "tmp/init.py"]
