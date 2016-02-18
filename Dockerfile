FROM jenkins:1.642.1

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

#Copy plugins
COPY plugins/*.hpi /usr/share/jenkins/ref/plugins/

COPY config/jenkins.properties /usr/share/jenkins/

# remove executors in master
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# lets configure and add default jobs
COPY config/*.xml $JENKINS_HOME/

USER root
COPY start.sh /root/
COPY postStart.sh /root/
RUN chown -R jenkins:jenkins $JENKINS_HOME/

ENV JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties -Ddocker.host=unix:/var/run/docker.sock"

EXPOSE 8000

ENTRYPOINT ["/root/start.sh"]
