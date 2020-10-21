#!/bin/bash
cluster_not_running=$(minikube status | grep 'no local cluster' | wc -l)
if [[ cluster_not_running -eq "0" ]] # if cluster is running then
then
   minikube delete
fi

data_dir=$(echo $(cd .. && pwd)/data:/data)
minikube start --cpus 8 --memory 8192
echo "Mounting folder" $data_dir " to cluster"
minikube mount $data_dir &
echo "Mounted"
ssh -oStrictHostKeyChecking=no -i $(minikube ssh-key) docker@$(minikube ip) <<-'ENDSSH'
   sudo sh -c "echo 'Test file to kubernetes' > /data/index.html" =y
ENDSSH
echo "Kubernetes is up"