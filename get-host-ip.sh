#!/bin/bash
KUBERNETES=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
POD=`hostname`
curl -s -k -H "Authorization: Bearer $TOKEN" $KUBERNETES/api/v1/namespaces/$KUBERNETES_NAMESPACE/pods/$POD | grep -i hostIp | cut -d "\"" -f 4
