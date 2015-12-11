FROM jenkins:1.625.2

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

#Copy plugins
COPY kubernetes.hpi /usr/share/jenkins/ref/plugins/kubernetes.hpi
COPY fabric8-jenkins-workflow-steps-1.0.hpi /usr/share/jenkins/ref/plugins/
COPY jenkins.properties /usr/share/jenkins/

# remove executors in master
COPY *.groovy /usr/share/jenkins/ref/init.groovy.d/
# configure maven settings and nexus mirroring and authentication
# lets put a copy in the roots folder too for when running as root
COPY mvnsettings.xml /root/.m2/settings.xml

# lets configure and add default jobs
COPY jenkins/*.xml $JENKINS_HOME/

USER root
COPY start.sh /root/
COPY postStart.sh /root/
RUN chown -R jenkins:jenkins $JENKINS_HOME/

RUN cd /usr/local && \
  wget https://github.com/github/hub/releases/download/v2.2.1/hub-linux-amd64-2.2.1.tar.gz && \
  tar xf /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
  rm /usr/local/hub-linux-amd64-2.2.1.tar.gz && \
  ln -s /usr/local/hub-linux-amd64-2.2.1/hub /usr/bin/hub

ENV DOCKER_HOST unix:///var/run/docker.sock
ENV SEED_GIT_URL https://github.com/fabric8io/default-jenkins-dsl.git
ENV KUBERNETES_TRUST_CERTIFICATES true
ENV SKIP_TLS_VERIFY true
ENV JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties"

# use development version of openshift jenkins plugin
COPY openshift-pipeline.hpi /usr/share/jenkins/ref/plugins/
ENTRYPOINT ["/root/start.sh"]
