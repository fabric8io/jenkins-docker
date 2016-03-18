#!/bin/bash

KUBE_PIPELINE_DIR=../kubernetes-workflow

cp $KUBE_PIPELINE_DIR/kubernetes-steps/target/kubernetes-steps.hpi plugins
cp $KUBE_PIPELINE_DIR/devops-steps/target/devops-steps.hpi plugins
