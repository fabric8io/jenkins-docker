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
