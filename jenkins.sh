#! /bin/bash

# lets define some env vars for easier kubernetes integration
export KUBERNETES_MASTER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}
export KUBERNETES_TRUST_CERT=true
export SKIP_TLS_VERIFY=true
export KUBERNETES_NAMESPACE=default
export BUILD_NAMESPACE=default

# lets startup socat so we can access the docker socket over http from Java code
socat tcp-listen:2375,fork unix:/var/run/docker.sock &

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   exec java $JAVA_OPTS -jar /usr/lib/jenkins/jenkins.war $JENKINS_OPTS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"