rm -rf ../hadoop/hadoop/templates ../hadoop/hadoop/values.yaml ../hadoop/hadoop/Chart.yaml ../hadoop/hadoop/README.md ../hadoop/hadoop/info.md ../hadoop/hadoop/hadoop-1.1.2.tgz
helm template hadoop stable/hadoop  \
        --version 1.1.2 \
        --output-dir=../hadoop \
        --set hdfs.dataNode.replicas=3
helm show values stable/hadoop --version=1.1.2 > ../hadoop/hadoop/values.yaml
helm show chart stable/hadoop --version=1.1.2 > ../hadoop/hadoop/Chart.yaml
helm show readme stable/hadoop --version=1.1.2 > ../hadoop/hadoop/README.md
helm show all stable/hadoop --version 1.1.2 > ../hadoop/hadoop/info.md
awk -i inplace '/volumes/{print;print "      - name: task-pv-storage\n        persistentVolumeClaim:\n          claimName: task-pv-claim";next}1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml
awk -i inplace '/volumeMounts/ { print; print "        - name: task-pv-storage\n          mountPath: /data"; next }1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml
helm package ../hadoop/hadoop/ -d ../hadoop/