#! /bin/bash

# Parse a support-core plugin -style txt file as specification for jenkins plugins to be installed
# in the reference directory, so user can define a derived Docker image with just :
# 
# FROM jenkins
# COPY plugins.txt /plugins.txt
# RUN /usr/local/bin/plugins.sh /plugins.txt
# 

REF=$JENKINS_HOME/plugins/
mkdir -p $REF

while read spec; do
    plugin=(${spec//:/ }); 
    [[ ${plugin[0]} =~ ^# ]] && continue
    [[ ${plugin[0]} =~ ^\s*$ ]] && continue
    echo "Installing ${plugin[0]}:${plugin[1]}"
    curl -f --retry 5 -sSL ${JENKINS_UC}/download/plugins/${plugin[0]}/${plugin[1]}/${plugin[0]}.hpi -o $REF/${plugin[0]}.hpi
    touch $REF/${plugin[0]}.hpi.pinned
done  < $1
