Jenkins CI Server
-----------------

This is a [Jenkins CI](http://jenkins-ci.org/) server with build dependencies installed

-	[Maven](http://maven.apache.org/)
-	[JDK](http://www.oracle.com/technetwork/java/javase/overview/index.html)
-	[Golang](https://golang.org/) installed.

In addition this Jenkins comes pre configured to work with a local on premise Nexus service using the following environment variables (usually supplied via Kubernetes)

-	$NEXUS_SERVICE_HOST
-	$NEXUS_SERVICE_PORT
