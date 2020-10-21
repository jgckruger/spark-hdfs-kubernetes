is_hadoop_environment=$(kubectl get namespaces | grep 'hadoop' | wc -l)
is_spark_environment=$(kubectl get namespaces | grep 'spark' | wc -l)

#TODO: wait for container creation
if [[ is_hadoop_environment -eq "1" ]] # if hdfs is running
then
    kubectl port-forward -n hadoop service/hadoop-hadoop-yarn-ui 8088:8088 &
    kubectl port-forward -n hadoop service/hadoop-hadoop-hdfs-nn 50070:50070 &
    kubectl port-forward -n hadoop $(kubectl get pod -n hadoop --selector=app=zeppelin -o jsonpath='{.items...metadata.name}') 8080:8080 &
fi

#TODO: wait for container creation
if [[ is_spark_environment -eq "1" ]] # if spark is running
then
    kubectl port-forward -n spark deployment.apps/my-notebook-deployment 8888:8888 &
fi