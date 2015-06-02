FROM openshift/jenkins-1-centos
MAINTAINER fabric8.io (http://fabric8.io/)

# Install package dependencies as root
USER root

RUN yum remove -y java-1.7.0-openjdk* && \
    yum install -y bzr mercurial java-1.8.0-openjdk-devel gcc

ENV JENKINS_UC https://updates.jenkins-ci.org
COPY plugins.sh /plugins.sh
COPY plugins.txt /plugins.txt
RUN /plugins.sh /plugins.txt

# lets configure and add default jobs
COPY jenkins/*.xml $JENKINS_HOME/
COPY jenkins/jobs $JENKINS_HOME/jobs

# configure maven settings and nexus mirroring and authentication
COPY mvnsettings.xml $JENKINS_HOME/.m2/settings.xml

# lets put a copy in the roots folder too for when running as root
COPY mvnsettings.xml /root/.m2/settings.xml
COPY jenkins.sh /usr/local/bin/jenkins.sh

RUN chown -R jenkins:jenkins $JENKINS_HOME/ /usr/local/bin/jenkins.sh

# TODO for socat we need to run as root unfortunately
#USER jenkins

ENV NEXUS_USERNAME admin
ENV NEXUS_PASSWORD admin123

ENV DOCKER_HOST tcp://localhost:2375
ENV SEED_GIT_URL https://github.com/fabric8io/default-jenkins-dsl.git

ENV KUBERNETES_MASTER https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}
ENV KUBERNETES_TRUST_CERT true
ENV SKIP_TLS_VERIFY true
ENV KUBERNETES_NAMESPACE default
ENV BUILD_NAMESPACE default
