#[PTPPF]: Operational Analytics using Cloud Logging’s Log Analytics powered by BigQuery

Task 1. Create a log bucket with linked dataset in BigQuery

Go to Cloud Log Storage and create a log bucket and also enable the upgrade log analytics and then create a linked bigquery.

Task 2. Create a log sink

Go to Cloud Log Router and create a log sink and add the previous log bucket and add input filter as resource.type="k8s_container"

Task 3. Use Log Analytics to identify the issue

Ignore.....!!


Task 4. Fix the issue and redeploy the app to the GKE cluster
go to environment_config config_map and update the /tmp-incorrect/ to /tmp/ and save it. Delete all the failed pods to create new pods.

Login to cluster using the connect cmd from the GKE Cluster Console,
get the configmap
kubectl edit cm <cm_name>
change the /tmp-incorrect/.ssh/... to /tmp/.ssh/...
save it
delete all the failing pods by giving kubectl delete pod <pod_name>  !! To see the failing pods: kubectl get pods and only focus on not running pods.


