
kubectl port-forward -n hadoop service/hadoop-hadoop-yarn-ui 8088:8088 &
kubectl port-forward -n hadoop service/hadoop-hadoop-hdfs-nn 50070:50070 &
kubectl port-forward -n spark deployment.apps/my-notebook-deployment 8888:8888 &
kubectl port-forward -n spark deployment.apps/my-notebook-deployment 8888:8888 &
kubectl port-forward -n hadoop $(kubectl get pod -n hadoop --selector=app=zeppelin -o jsonpath='{.items...metadata.name}') 8080:8080 &