#[PTPPF]: Building and Deploying a Globally Available and Scalable Application on GKE

https://cloud.google.com/kubernetes-engine/docs/how-to/enabling-multi-cluster-gateways


Task-1:

git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples.git 
cd kubernetes-engine-samples/quickstarts/whereami/

# create artifact reg:
    gcloud artifacts repositories create cepf-app-mod-repo --location us-east1 --repository-format docker
    gcloud artifacts repositories list
    gcloud builds submit --tag us-east1-docker.pkg.dev/qwiklabs-gcp-00-d554fd93315a/cepf-app-mod-repo/whereami:latest
    gcloud artifacts docker images list us-east1-docker.pkg.dev/qwiklabs-gcp-00-d554fd93315a/cepf-app-mod-repo
   
TASK 2:

gcloud deploy apply --file=appdeployment.yaml --region=us-east1 --project=qwiklabs-gcp-00-d554fd93315a
gcloud deploy releases create cepf-gke-release --delivery-pipeline=cepf-gke-pipeline   --region=us-west1   --project=qwiklabs-gcp-00-f63afccc6693   --from-k8s-manifest=deployment.yml


#Promote the release to the second target.
gcloud deploy releases promote \
  --release=cepf-gke-release \
  --delivery-pipeline=cepf-gke-pipeline \
  --region=us-west1 \
  --project=qwiklabs-gcp-00-f63afccc6693 \
  --to-target=target2


TASK 3: Enable multi-cluster gateways(https://cloud.google.com/kubernetes-engine/docs/how-to/enabling-multi-cluster-gateways)

gcloud services enable \
  trafficdirector.googleapis.com \
  multiclusterservicediscovery.googleapis.com \
  multiclusteringress.googleapis.com \
  --project=qwiklabs-gcp-00-d554fd93315a

  gcloud container clusters update cepf-gke-cluster-1 \
  --location=CLUSTER_LOCATION\
  --gateway-api=standard

  gcloud container clusters update cepf-gke-cluster-2 \
  --location=CLUSTER_LOCATION\
  --gateway-api=standard  


#Enable Workload Identity on the GKE Cluster 1
gcloud container clusters update cepf-gke-cluster-1 \
  --workload-pool=qwiklabs-gcp-00-d554fd93315a.svc.id.goog \
  --region=us-west1-a \
  --project=qwiklabs-gcp-00-d554fd93315a

#  Enable Workload Identity on the GKE Cluster 2
gcloud container clusters update cepf-gke-cluster-2 \
  --workload-pool=qwiklabs-gcp-00-d554fd93315a.svc.id.goog \
  --region=europe-west1-c \
  --project=qwiklabs-gcp-00-d554fd93315a



  gcloud services enable \
  trafficdirector.googleapis.com \
  multiclusterservicediscovery.googleapis.com \
  multiclusteringress.googleapis.com \
  --project=qwiklabs-gcp-00-d554fd93315a

  gcloud container clusters update cepf-gke-cluster-1 \
  --location=us-east1-b\
  --gateway-api=standard

  gcloud container clusters update cepf-gke-cluster-2 \
  --location=europe-west1-c\
  --gateway-api=standard    


#Register cepf-gke-cluster-1 in the us-west1-c region:
gcloud container hub memberships register cepf-gke-cluster-1 \
  --gke-cluster=us-east1-b/cepf-gke-cluster-1 \
  --enable-workload-identity \
  --project=qwiklabs-gcp-00-d554fd93315a

#Register cepf-gke-cluster-2 in the us-west1-a region:
gcloud container hub memberships register cepf-gke-cluster-2 \
  --gke-cluster=europe-west1-c/cepf-gke-cluster-2 \
  --enable-workload-identity \
  --project=qwiklabs-gcp-00-d554fd93315a

  gcloud container fleet multi-cluster-services enable \
  --project qwiklabs-gcp-00-d554fd93315a

  gcloud projects add-iam-policy-binding qwiklabs-gcp-00-d554fd93315a \
    --member "serviceAccount:qwiklabs-gcp-00-d554fd93315a.svc.id.goog[gke-mcs/gke-mcs-importer]" \
    --role "roles/compute.networkViewer" \
    --project=qwiklabs-gcp-00-d554fd93315a

    gcloud container fleet multi-cluster-services describe --project=qwiklabs-gcp-00-d554fd93315a

    gcloud container fleet ingress enable \
    --config-membership=projects/qwiklabs-gcp-00-d554fd93315a/locations/us-east1/memberships/cepf-gke-cluster-1 \
    --project=qwiklabs-gcp-00-d554fd93315a

Task-4(https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-multi-cluster-gateways)