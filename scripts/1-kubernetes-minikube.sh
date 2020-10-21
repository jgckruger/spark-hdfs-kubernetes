#!/bin/bash
cluster_not_running=$(minikube status | grep 'no local cluster' | wc -l)
if [[ cluster_not_running -eq "0" ]] # if cluster is running then
then
   minikube delete
fi

minikube start --cpus 8 --memory 8192 
ssh -oStrictHostKeyChecking=no -i $(minikube ssh-key) docker@$(minikube ip) <<-'ENDSSH'
   sudo mkdir /mnt/data
   sudo sh -c "echo 'Hello from Kubernetes storage' > /mnt/data/index.html" =y
ENDSSH
echo "Kubernetes is up"