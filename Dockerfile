FROM openshift/jenkins-1-centos
MAINTAINER fabric8.io (http://fabric8.io/)

# Install package dependencies as root
USER root

RUN yum install -y bzr mercurial

ENV JENKINS_UC https://updates.jenkins-ci.org
COPY plugins.sh /plugins.sh
COPY plugins.txt /plugins.txt
RUN /plugins.sh /plugins.txt

# lets configure and add default jobs
COPY jenkins/*.xml $JENKINS_HOME/
COPY jenkins/jobs $JENKINS_HOME/jobs

RUN chown -R jenkins:jenkins $JENKINS_HOME/

USER jenkins
