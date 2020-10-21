kubectl create namespace hadoop
kubectl create serviceaccount hadoop -n hadoop
kubectl create clusterrolebinding hadoop-role --clusterrole=edit --serviceaccount=hadoop:hadoop --namespace=hadoop
helm install hadoop stable/hadoop --version 1.1.2 --namespace hadoop # https://artifacthub.io/packages/helm/helm-stable/hadoop
#helm install hadoop $(stable/hadoop/tools/calc_resources.sh 70) stable/hadoop
helm install zeppelin --namespace hadoop --set hadoop.useConfigMap=true,hadoop.configMapName=hadoop-hadoop stable/zeppelin # https://artifacthub.io/packages/helm/helm-stable/zeppelin
kubectl get all -n hadoop