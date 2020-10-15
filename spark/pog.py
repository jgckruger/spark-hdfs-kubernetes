import os
from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession

# Create Spark config for our Kubernetes based cluster manager
sparkConf = SparkConf()
sparkConf.setMaster("k8s://https://kubernetes.default.svc.cluster.local:443")
sparkConf.setAppName("spark")
sparkConf.set("spark.kubernetes.container.image", "jgckruger/spark-py:v3.0.1")
sparkConf.set("spark.kubernetes.namespace", "spark")
sparkConf.set("spark.executor.instances", "7")
sparkConf.set("spark.executor.cores", "2")
sparkConf.set("spark.driver.memory", "512m")
sparkConf.set("spark.executor.memory", "512m")
sparkConf.set("spark.kubernetes.pyspark.pythonVersion", "3")
sparkConf.set("spark.kubernetes.authenticate.driver.serviceAccountName", "spark")
sparkConf.set("spark.kubernetes.authenticate.serviceAccountName", "spark")
sparkConf.set("spark.driver.port", "29413")
sparkConf.set("spark.driver.host", "my-notebook-deployment.spark.svc.cluster.local")# Initialize our Spark cluster, this will actually
sparkConf.set("fs.defaultFS", "hdfs://hadoop-hadoop-hdfs-nn.spark.svc.cluster.local:9000/")

# generate the worker nodes.
spark = SparkSession.builder.config(conf=sparkConf).getOrCreate()
sc = spark.sparkContext

from pyspark.sql.functions import randn, round as roundNum

data = [(i, i) for i in range(10)] # random data

columns = ['id', 'txt']    # add your columns label here

df = spark.createDataFrame(data, columns)
df = df.drop('txt')
for i in range(10):
    df = df.withColumn('col'+str(i), roundNum(randn(), 3))
df.show()

URI           = sc._gateway.jvm.java.net.URI
Path          = sc._gateway.jvm.org.apache.hadoop.fs.Path
FileSystem    = sc._gateway.jvm.org.apache.hadoop.fs.FileSystem
Configuration = sc._gateway.jvm.org.apache.hadoop.conf.Configuration


fs = FileSystem.get(URI("hdfs://hadoop-hadoop-hdfs-nn.spark.svc.cluster.local:9000"), Configuration())

status = fs.listStatus(Path('/'))

for fileStatus in status:
    print(fileStatus.getPath())

# sc.stop()