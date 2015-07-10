FROM jenkins
MAINTAINER fabric8.io (http://fabric8.io/)

# Install package dependencies as root
USER root

RUN apt-get update -y && apt-get install -y socat bzr

ENV JENKINS_UC https://updates.jenkins-ci.org
COPY plugins.txt /usr/share/jenkins/ref/
COPY plugins.sh /usr/local/bin/plugins.sh
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# lets configure and add default jobs
COPY jenkins/*.xml $JENKINS_HOME/
COPY jenkins/jobs $JENKINS_HOME/jobs

# configure maven settings and nexus mirroring and authentication
COPY mvnsettings.xml $JENKINS_HOME/.m2/settings.xml

# lets put a copy in the roots folder too for when running as root
COPY mvnsettings.xml /root/.m2/settings.xml
COPY get-host-ip.sh /usr/local/bin/get-host-ip.sh
COPY jenkins.sh /usr/local/bin/jenkins.sh

RUN chown -R jenkins:jenkins $JENKINS_HOME/ /usr/local/bin/jenkins.sh

#Install some additional python libraries to handle jenkins encrypt decrypt.
RUN apt-get install -y python-dev python-pip vim-common
RUN pip install pycrypto
COPY jenkins-encrypt.py /usr/local/bin/jenkins-encrypt.py

# TODO for socat we need to run as root unfortunately
#USER jenkins

# these env vars should be replaced by kubernetes configuration in the OpenShift templates:
ENV NEXUS_USERNAME admin
ENV NEXUS_PASSWORD admin123

ENV JENKINS_GOGS_USER gogsadmin
ENV JENKINS_GOGS_PASSWORD RedHat$1
ENV JENKINS_GOGS_EMAIL gogsadmin@fabric8.local

#ENV JENKINS_SLAVE_IMAGE fabric8/jenkins-slave
ENV JENKINS_SLAVE_IMAGE fabric8/jenkins-slave-dind

# disable GCC requirement by default
ENV CGO_ENABLED 0

ENV DOCKER_HOST tcp://localhost:2375
ENV SEED_GIT_URL https://github.com/fabric8io/default-jenkins-dsl.git

ENV KUBERNETES_MASTER https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}
ENV KUBERNETES_TRUST_CERT true
ENV SKIP_TLS_VERIFY true
ENV KUBERNETES_NAMESPACE default
