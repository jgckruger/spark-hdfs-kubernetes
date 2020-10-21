#!/bin/bash
# TODO: get args to build up on
# TODO: check if spark is installed
$SPARK_HOME/bin/docker-image-tool.sh -p $SPARK_HOME/kubernetes/dockerfiles/spark/bindings/python/Dockerfile -r jgckruger -t v3.0.1 build
docker push jgckruger/spark:v3.0.1
docker push jgckruger/spark-py:v3.0.1
docker build --pull --rm -f "../spark/driver-pod/Dockerfile" -t jgckruger/my-notebook:latest "driver-pod"
docker push jgckruger/spark-py:v3.0.1