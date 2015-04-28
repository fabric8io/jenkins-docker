FROM openshift/jenkins-1-centos
MAINTAINER fabric8.io (http://fabric8.io/)

# Install package dependencies as root
USER root

RUN yum install -y bzr mercurial java-1.8.0-openjdk-devel

ENV JENKINS_UC https://updates.jenkins-ci.org
COPY plugins.sh /plugins.sh
COPY plugins.txt /plugins.txt
RUN /plugins.sh /plugins.txt

# lets configure and add default jobs
COPY jenkins/*.xml $JENKINS_HOME/
COPY jenkins/jobs $JENKINS_HOME/jobs

# configure maven settings and nexus mirroring and authentication
ADD mvnsettings.xml $JENKINS_HOME/.m2/settings.xml

RUN chown -R jenkins:jenkins $JENKINS_HOME/

USER jenkins
