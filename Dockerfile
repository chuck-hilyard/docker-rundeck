FROM ubuntu:16.04

#COPY rundeck_2.11.3-1-GA_all.deb /

RUN apt-get update -y && \
    apt-get install -y openjdk-8-jdk \
    openssh-client \
    uuid-runtime \
    wget && \
    wget https://dl.bintray.com/rundeck/rundeck-deb/rundeck_3.0.7.20181008-1.201810082317_all.deb && \
		dpkg -i rundeck_3.0.7.20181008-1.201810082317_all.deb


CMD ["service", "rundeckd", "start"]
