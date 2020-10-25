apiVersion: v1
appVersion: 2.9.0
description: The Apache Hadoop software library is a framework that allows for the
  distributed processing of large data sets across clusters of computers using simple
  programming models.
home: https://hadoop.apache.org/
icon: http://hadoop.apache.org/images/hadoop-logo.jpg
maintainers:
- email: disla@google.com
  name: danisla
name: hadoop
sources:
- https://github.com/apache/hadoop
version: 1.1.2

---
# The base hadoop image to use for all components.
# See this repo for image build details: https://github.com/Comcast/kube-yarn/tree/master/image
image:
  repository: danisla/hadoop
  tag: 2.9.0
  pullPolicy: IfNotPresent

# The version of the hadoop libraries being used in the image.
hadoopVersion: 2.9.0

# Select antiAffinity as either hard or soft, default is soft
antiAffinity: "soft"

hdfs:
  nameNode:
    pdbMinAvailable: 1

    resources:
      requests:
        memory: "256Mi"
        cpu: "10m"
      limits:
        memory: "2048Mi"
        cpu: "1000m"

  dataNode:
    replicas: 1

    pdbMinAvailable: 1

    resources:
      requests:
        memory: "256Mi"
        cpu: "10m"
      limits:
        memory: "2048Mi"
        cpu: "1000m"

  webhdfs:
    enabled: false

yarn:
  resourceManager:
    pdbMinAvailable: 1

    resources:
      requests:
        memory: "256Mi"
        cpu: "10m"
      limits:
        memory: "2048Mi"
        cpu: "2000m"

  nodeManager:
    pdbMinAvailable: 1

    # The number of YARN NodeManager instances.
    replicas: 2

    # Create statefulsets in parallel (K8S 1.7+)
    parallelCreate: false

    # CPU and memory resources allocated to each node manager pod.
    # This should be tuned to fit your workload.
    resources:
      requests:
        memory: "2048Mi"
        cpu: "1000m"
      limits:
        memory: "2048Mi"
        cpu: "1000m"

persistence:
  nameNode:
    enabled: false
    storageClass: "-"
    accessMode: ReadWriteOnce
    size: 50Gi

  dataNode:
    enabled: false
    storageClass: "-"
    accessMode: ReadWriteOnce
    size: 200Gi

---
# Hadoop Chart

[Hadoop](https://hadoop.apache.org/) is a framework for running large scale distributed applications.

This chart is primarily intended to be used for YARN and MapReduce job execution where HDFS is just used as a means to transport small artifacts within the framework and not for a distributed filesystem. Data should be read from cloud based datastores such as Google Cloud Storage, S3 or Swift.

## Chart Details

## Installing the Chart

To install the chart with the release name `hadoop` that utilizes 50% of the available node resources:

```
$ helm install --name hadoop $(stable/hadoop/tools/calc_resources.sh 50) stable/hadoop
```

> Note that you need at least 2GB of free memory per NodeManager pod, if your cluster isn't large enough, not all pods will be scheduled.

The optional [`calc_resources.sh`](./tools/calc_resources.sh) script is used as a convenience helper to set the `yarn.numNodes`, and `yarn.nodeManager.resources` appropriately to utilize all nodes in the Kubernetes cluster and a given percentage of their resources. For example, with a 3 node `n1-standard-4` GKE cluster and an argument of `50`, this would create 3 NodeManager pods claiming 2 cores and 7.5Gi of memory.

### Persistence

To install the chart with persistent volumes:

```
$ helm install --name hadoop $(stable/hadoop/tools/calc_resources.sh 50) \
  --set persistence.nameNode.enabled=true \
  --set persistence.nameNode.storageClass=standard \
  --set persistence.dataNode.enabled=true \
  --set persistence.dataNode.storageClass=standard \
  stable/hadoop
```

> Change the value of `storageClass` to match your volume driver. `standard` works for Google Container Engine clusters.

## Configuration

The following table lists the configurable parameters of the Hadoop chart and their default values.

| Parameter                                         | Description                                                                        | Default                                                          |
| ------------------------------------------------- | -------------------------------                                                    | ---------------------------------------------------------------- |
| `image.repository`                                | Hadoop image ([source](https://github.com/Comcast/kube-yarn/tree/master/image))    | `danisla/hadoop`                                                 |
| `image.tag`                                       | Hadoop image tag                                                                   | `2.9.0`                                                          |
| `imagee.pullPolicy`                               | Pull policy for the images                                                         | `IfNotPresent`                                                   |
| `hadoopVersion`                                   | Version of hadoop libraries being used                                             | `2.9.0`                                                          |
| `antiAffinity`                                    | Pod antiaffinity, `hard` or `soft`                                                 | `hard`                                                           |
| `hdfs.nameNode.pdbMinAvailable`                   | PDB for HDFS NameNode                                                              | `1`                                                              |
| `hdfs.nameNode.resources`                         | resources for the HDFS NameNode                                                    | `requests:memory=256Mi,cpu=10m,limits:memory=2048Mi,cpu=1000m`   |
| `hdfs.dataNode.replicas`                          | Number of HDFS DataNode replicas                                                   | `1`                                                              |
| `hdfs.dataNode.pdbMinAvailable`                   | PDB for HDFS DataNode                                                              | `1`                                                              |
| `hdfs.dataNode.resources`                         | resources for the HDFS DataNode                                                    | `requests:memory=256Mi,cpu=10m,limits:memory=2048Mi,cpu=1000m`   |
| `hdfs.webhdfs.enabled`                            | Enable WebHDFS REST API                                                            | `false`
| `yarn.resourceManager.pdbMinAvailable`            | PDB for the YARN ResourceManager                                                   | `1`                                                              |
| `yarn.resourceManager.resources`                  | resources for the YARN ResourceManager                                             | `requests:memory=256Mi,cpu=10m,limits:memory=2048Mi,cpu=1000m`   |
| `yarn.nodeManager.pdbMinAvailable`                | PDB for the YARN NodeManager                                                       | `1`                                                              |
| `yarn.nodeManager.replicas`                       | Number of YARN NodeManager replicas                                                | `2`                                                              |
| `yarn.nodeManager.parallelCreate`                 | Create all nodeManager statefulset pods in parallel (K8S 1.7+)                     | `false`                                                          |
| `yarn.nodeManager.resources`                      | Resource limits and requests for YARN NodeManager pods                             | `requests:memory=2048Mi,cpu=1000m,limits:memory=2048Mi,cpu=1000m`|
| `persistence.nameNode.enabled`                    | Enable/disable persistent volume                                                   | `false`                                                          | 
| `persistence.nameNode.storageClass`               | Name of the StorageClass to use per your volume provider                           | `-`                                                              |
| `persistence.nameNode.accessMode`                 | Access mode for the volume                                                         | `ReadWriteOnce`                                                  |
| `persistence.nameNode.size`                       | Size of the volume                                                                 | `50Gi`                                                           |
| `persistence.dataNode.enabled`                    | Enable/disable persistent volume                                                   | `false`                                                          | 
| `persistence.dataNode.storageClass`               | Name of the StorageClass to use per your volume provider                           | `-`                                                              |
| `persistence.dataNode.accessMode`                 | Access mode for the volume                                                         | `ReadWriteOnce`                                                  |
| `persistence.dataNode.size`                       | Size of the volume                                                                 | `200Gi`                                                          |

## Related charts

The [Zeppelin Notebook](https://github.com/kubernetes/charts/tree/master/stable/zeppelin) chart can use the hadoop config for the hadoop cluster and use the YARN executor:

```
helm install --set hadoop.useConfigMap=true stable/zeppelin
```

# References

- Original K8S Hadoop adaptation this chart was derived from: https://github.com/Comcast/kube-yarn

