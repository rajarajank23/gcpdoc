[PTPPF]: Multicluster Management with Anthos Hybrid and Multi Cloud Solutions

Task 1. Create GKE and bare metal cluster
# Set variables for project and zone
PROJECT_ID="qwiklabs-gcp-04-daf3e4a5c577"
ZONE="us-east1-d"
CLUSTER_NAME="cepf-gke-cluster"

# Create GKE cluster with Enterprise tier and Workload Identity enabled
gcloud container clusters create $CLUSTER_NAME \
  --zone $ZONE \
  --release-channel "regular" \
  --workload-pool="$PROJECT_ID.svc.id.goog" \
  --tier="enterprise" \
  --machine-type "e2-standard-4" \
  --num-nodes "3"

gcloud container clusters get-credentials $CLUSTER_NAME --region $ZONE --project $PROJECT_ID

# Register the GKE cluster in the Fleet
gcloud container fleet memberships register $CLUSTER_NAME \
  --gke-cluster $ZONE/$CLUSTER_NAME \
  --enable-workload-identity \
  --project=$PROJECT_ID

Task 2. Configure Policy Controller and Config Sync, and test Anthos Config Management capabilities

Go to the GKE cluster and go to Config Sync and enable for two clusters and the deploy a package with git as source. Then reconcile it for two clusters.



