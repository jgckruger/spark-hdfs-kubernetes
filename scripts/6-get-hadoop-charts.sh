helm template hadoop stable/hadoop --version 1.1.2 --output-dir=../hadoop
helm show values stable/hadoop --version=1.1.2 >> ../hadoop/hadoop/values.yaml
helm show chart stable/hadoop --version=1.1.2 >> ../hadoop/hadoop/Chart.yaml
helm show readme stable/hadoop --version=1.1.2 >> ../hadoop/hadoop/README.md
helm show all stable/hadoop --version 1.1.2 >> ../hadoop/hadoop/info.md
# awk '/volumes/ { print; print "      - name: data\n        emptyDir: {}"; next }1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml  >> ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml
# awk '/volumeMounts/ { print; print "        - name: data\n          mountPath: /data"; next }1' ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml  >> ../hadoop/hadoop/templates/hdfs-nn-statefulset.yaml
helm package ../hadoop/hadoop/ -d ../hadoop/