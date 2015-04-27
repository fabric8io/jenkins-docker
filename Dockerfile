FROM openshift/jenkins-1-centos
MAINTAINER fabric8.io (http://fabric8.io/)

WORKDIR ~

# Install package dependencies as root
USER root

RUN yum install -y bzr mercurial

# Go
ENV PATH $PATH:/usr/local/go/bin
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

# Java JDK
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.rpm" -O jdk-8-linux-x64.rpm && \
	yum -y install jdk-8-linux-x64.rpm && \
	rm -rf jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000 && \
	alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 && \
	alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

# Switch to jenkibs user to set env vars and configure Jenkins
USER jenkins

ENV JAVA_HOME /usr/java/latest

ENV JENKINS_UC https://updates.jenkins-ci.org
COPY plugins.sh /plugins.sh
COPY plugins.txt /plugins.txt
RUN /plugins.sh /plugins.txt

# lets configure and add default jobs
ADD jenkins/*.xml $JENKINS_HOME/
ADD jenkins/jobs $JENKINS_HOME/jobs
