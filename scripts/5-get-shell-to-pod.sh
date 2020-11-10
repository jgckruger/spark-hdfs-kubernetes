service=$1

if [ -z $service ]
then
   echo "Parameter service is required"
else
    if [ $service = "jupyter" ]
    then
        kubectl exec --stdin --tty shell-demo -- /bin/bash
    fi

    if [ $service = "spark" ]
    then
        # TODO: properly set the name of the spark pod
        kubectl exec -n spark --stdin --tty my-notebook-deployment -- /bin/bash
    fi

    if [ $service = "hadoop" ]
    then
        echo "Getting shell to hadoop namenode"
        kubectl exec -n hadoop --stdin --tty hadoop-hadoop-hdfs-nn-0 -- /bin/bash
    fi

    if [ $service = "zeppelin" ]
    then
        kubectl exec --stdin --tty shell-demo -- /bin/bash
    fi
fi

