//[PTPPF]: Using Cloud Workstations to Manage Development Environments and Deploy Apps:

#Task 1. Create a Cloud Workstations configuration
Just follow the google Console  Cloud Workstations Configuration instructions

#Task 2. Create a Cloud Workstations instance
Just follow the google Console  Cloud Workstations Instance instructions

#Task 3. Use Cloud Build to build a container application
Login to the created Cloud Workstations instance and go to terminal and execute all the below  cmdlets.

gsutil cp gs://cloud-training/cepf/cepf023/cepf023-app-code.zip .

unzip cepf023-app-code.zip
cd cepf023-app-code

gcloud artifacts repositories create cepf-repo \
    --repository-format=docker \
    --location=<REGION> \
    --description="Repository for CEPF application images" \
    --project="<PROJET_ID>"

gcloud auth configure-docker <REGION>-docker.pkg.dev


gcloud builds submit . \
    --tag <REGION>-docker.pkg.dev/<PROJET_ID>/cepf-repo/cepf-app:latest \
    --region=<REGION>

gcloud artifacts docker images list \
    --repository=<REGION>-docker.pkg.dev/<PROJET_ID>/cepf-repo


#Task 4. Use Google Cloud Deploy to deploy an application to Cloud Run
Go to Cloud Deploy Console and create a new pipeline with given names and target names cepf-dev-service and cepf-prod-service and create new release with artifactory image generated as part of previous step.
gcloud run services add-iam-policy-binding cepf-prod-service \
    --member="allUsers" \
    --role="roles/run.invoker" \
    --region=<REGION>

#Task 5. Fix any issues and redeploy the app

Go to that dockerFile and change the index_v1 to index_v2.html

gcloud builds submit . \
    --tag <REGION>-docker.pkg.dev/<PROJECT_ID>/cepf-repo/cepf-app:latest \
    --region=<REGION>

Go to Cloud Deploy Console and create a new release with latest image generated as part of previous step.

gcloud run services describe cepf-prod-service \
    --region=<REGION> \
    --format="value(status.url)"

#Task 6. Promote the release to the production environment once the app passes verification
Go to Cloud Deploy Console and go to delivery pipeline and click on promote to prod servie 
gcloud run services add-iam-policy-binding cepf-prod-service \
    --member="allUsers" \
    --role="roles/run.invoker" \
    --region=<REGION>


gcloud run services describe cepf-prod-service \
    --region=us-west1 \
    --format="value(status.url)"

#Task 7. Configure the load balancer for the Cloud Run app
Step 1: Restrict Ingress for Cloud Run:

gcloud run services update cepf-dev-service \
    --ingress="internal-and-cloud-load-balancing" \
    --region=us-west1

gcloud run services update cepf-prod-service \
    --ingress="internal-and-cloud-load-balancing" \
    --region=us-west1


Step 2: Set Up a Global External HTTP Load Balancer:

gcloud compute network-endpoint-groups create cepf-prod-neg \
    --region=us-west1 \
    --network-endpoint-type=serverless \
    --cloud-run-service=cepf-prod-service


gcloud compute network-endpoint-groups create cepf-dev-neg \
    --region=us-west1 \
    --network-endpoint-type=serverless \
    --cloud-run-service=cepf-dev-service

gcloud compute backend-services create cepf-backend-service \
    --load-balancing-scheme=EXTERNAL_MANAGED \
    --global

gcloud compute backend-services add-backend cepf-backend-service \
    --global \
    --network-endpoint-group=cepf-prod-neg \
    --network-endpoint-group-region=us-west1

Create a URL Map:
gcloud compute url-maps create cepf-url-map \
    --default-service=cepf-backend-service

Create an HTTP Proxy:
gcloud compute target-http-proxies create cepf-http-proxy \
    --url-map=cepf-url-map

Create a Frontend Forwarding Rule:
gcloud compute forwarding-rules create cepf-frontend \
    --global \
    --target-http-proxy=cepf-http-proxy \
    --ports=80


Step 3: Verify the Load Balancer:

gcloud compute forwarding-rules describe cepf-frontend \
    --global \
    --format="value(IPAddress)"

