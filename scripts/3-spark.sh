kubectl create namespace spark
kubectl create serviceaccount spark -n spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=spark:spark --namespace=spark
kubectl apply -f ../spark/k8s/pv-volume.yaml
kubectl apply -f ../spark/k8s/pv-claim.yaml
kubectl apply -f ../spark/k8s/deploy.yaml
kubectl get all -n spark
