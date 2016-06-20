#!/bin/bash

KUBE_PIPELINE_DIR=../kubernetes-pipeline-plugin

cp $KUBE_PIPELINE_DIR/kubernetes-steps/target/kubernetes-pipeline-steps.hpi plugins
cp $KUBE_PIPELINE_DIR/devops-steps/target/kubernetes-pipeline-devops-steps.hpi plugins
