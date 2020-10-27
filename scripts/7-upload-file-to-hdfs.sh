file=$1
if [ -z $file ]
then
   echo "Parameter file is required"
else
    file_path='../data/'$file
    echo $file_path
    if [ -f "$file_path" ]
    then
        extension="${file##*.}"
        filename="${file%.*}"
        kubectl exec -n hadoop --stdin --tty hadoop-hadoop-hdfs-nn-0 -- /bin/bash -c "hadoop fs -rm -r /$filename"
        kubectl exec -n hadoop --stdin --tty hadoop-hadoop-hdfs-nn-0 -- /bin/bash -c "hadoop fs -mkdir /$filename"
        kubectl exec -n hadoop --stdin --tty hadoop-hadoop-hdfs-nn-0 -- /bin/bash -c "hadoop fs -copyFromLocal /data/$file /$filename/$file"
        echo 'Copied file'
    else
        echo "File doesn't exist"
    fi
fi