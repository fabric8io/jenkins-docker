#!/bin/bash

#Env variable interpollation functions
value_of() {
	eval echo \${$1}
}

interpolate_env() {
	FILE=$1
	for env_var in `cat ${FILE} | grep {| awk -F "{" '{print $2}' | awk -F "}" '{print $1}'`; do
		SUBST=`value_of ${env_var}`
		if [ -n "$SUBST" ]; then
			sed -ie 's|${'"$env_var"'}|'"$SUBST"'|g' $FILE
		fi
	done
}


if [ -z "$PROJECT_VERSION" ]; then
	PROJECT_VERSION="latest"
fi
interpolate_env /var/jenkins_home/config.xml
/bin/tini -- /usr/local/bin/jenkins.sh $*


# We need those for supporting arbitrary user id:
# https://docs.openshift.org/latest/creating_images/guidelines.html#use-uid
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < root/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

