#[PTPPF]: Hands-off Stateful Workloads at Scale on GKE Autopilot

Task-1:
gcloud container clusters create-auto cepf-autopilot-cluster \
    --region us-east1

Task-2:
gcloud sql instances create bank-of-anthos-db \
    --database-version=POSTGRES_14 \
    --region=us-east1 \
    --tier=db-f1-micro \
    --storage-size=10GB
Task-3:
Follow this steps in step by step manner:
https://github.com/GoogleCloudPlatform/bank-of-anthos/tree/main/extras/cloudsql

Task-4:
kubectl autoscale deployment frontend \
    --cpu-percent=50 \
    --min=1 \
    --max=10

kubectl autoscale deployment userservice \
    --cpu-percent=50 \
    --min=1 \
    --max=10

kubectl get hpa

Locate the kubernetes-manifests/loadgenerator.yaml file in your project directory. The file should define a deployment or pod for the load generator service.
Update the USERS Environment Variable 5 to 100.
Find the section of the YAML file that defines the environment variables. Update the USERS value to 100
kubectl apply -f kubernetes-manifests/loadgenerator.yaml
