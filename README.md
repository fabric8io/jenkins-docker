Jenkins CI Server
-----------------

This is a [Jenkins CI](http://jenkins-ci.org/) server with build dependencies installed

-	[Maven](http://maven.apache.org/)
-	[JDK](http://www.oracle.com/technetwork/java/javase/overview/index.html)
-	[Golang](https://golang.org/) installed.

In addition this Jenkins comes pre configured to work with a local on premise Nexus service using the following environment variables (usually supplied via Kubernetes)

-	$NEXUS_SERVICE_HOST
-	$NEXUS_SERVICE_PORT

Running this container
----------------------

```
docker run -it -p 8080:8080 --name jenkins -e SEED_GIT_URL=https://github.com/fabric8io/default-jenkins-dsl.git -e NEXUS_SERVICE_HOST=dockerhost -e NEXUS_SERVICE_PORT=8081 fabric8/jenkins
```

Where `dockerhost` is the host running nexus. You may wish to [run nexus using these instructions](https://github.com/fabric8io/nexus-docker#running-this-container)

Environment variables
---------------------

* `NEXUS_SERVICE_HOST` host where nexus is running
* `NEXUS_SERVICE_PORT` port where nexus is running
* `SEED_GIT_URL` the git URL to clone for the seed job
