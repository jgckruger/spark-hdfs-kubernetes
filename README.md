# spark-hdfs-kubernetes
Spark + Jupyter + Zeppelin on a Kubernetes environment for development using the Apache stack for Big Data :)

# Why

# How does it work?
This repo contains a series of scripts at the folder /scripts that
- 0 - Builds a new Apache Spark Docker Image 
- 1 - Creates a Minikube kubernetes cluster
- 2 - Creates a HDFS cluster inside K8S
- 3 - Creates a Spark cluster inside K8S and serves a Jupyter Lab page for coding purposes
- 4 - Forwards the relevant ports to the host machine
- 5 - Gets a shell to a pod
- 6 - Gets a copy of Apache's version of the HDFS charts adds persistency to /data folder
- 7 - Uploads a file to the HDFS

# Prerequisites
I assume you have the following software installed before trying to run this:
- Linux (Windows is a WIP) with at least 16GB+ of RAM
- Docker
- Docker-compose
- Kubelet
- Minikube
- Helm 3 (with the default repos enabled)
- Apache Spark (needed only for building your own Spark container)

# How to run
Given that all the required software are installed, you can start everything with:
```
  $ cd ./scripts
  $ ./1-kubernetes-minikube.sh
  $ ./2-hadoop.sh
  $ ./3-hadoop.sh
```

After this, you need to wait for the pods to be in the running state. This takes a minute and depends on the computer specs. You can check the state of the pods with:
```
  $ kubectl get all -n spark
  $ kubectl get all -n hadoop
```

After the pods are up, you can either get a shell into a pod using the included script or access _http://localhost:8888_ and use the Jupyter UI (default password is _jupyter_)
