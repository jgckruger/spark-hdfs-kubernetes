rm -rf ../hadoop/hadoop/templates ../hadoop/hadoop/values.yaml ../hadoop/hadoop/Chart.yaml ../hadoop/hadoop/README.md ../hadoop/hadoop/info.md ../hadoop/hadoop/hadoop-1.1.2.tgz
helm template hadoop stable/hadoop --version 1.1.2 --output-dir=../hadoop
helm show values stable/hadoop --version=1.1.2 > ../hadoop/hadoop/values.yaml
helm show chart stable/hadoop --version=1.1.2 > ../hadoop/hadoop/Chart.yaml
helm show readme stable/hadoop --version=1.1.2 > ../hadoop/hadoop/README.md
helm show all stable/hadoop --version 1.1.2 > ../hadoop/hadoop/info.md
awk '/volumes/{print;print "      - name: task-pv-storage\n        persistentVolumeClaim:\n          claimName: task-pv-claim";next}1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml | tee ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml > /dev/null
awk '/volumeMounts/ { print; print "        - name: task-pv-storage\n          mountPath: /data"; next }1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml | tee ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml > /dev/null
helm package ../hadoop/hadoop/ -d ../hadoop/