# HDI Seguros - Project Kustomize Configuration

This project provides the configuration required to deploy HDI Seguros services using the Mia-Platform Operator installed on the client side.

## What the Pipeline Does

The pipeline automates the deployment process by applying the Kustomize configurations to the target Kubernetes cluster. It ensures that all manifests and overlays are correctly applied for each environment (e.g., DEV, PROD). The pipeline is triggered by changes in the repository and uses secrets stored in GitHub to authenticate and interact with the cluster.

## Required GitHub Secrets

To make the pipeline work, you must update the following secrets in your GitHub repository:

- `JENKINS_JOB_TOKEN`: Token to authenticate with jenkins.

## How to Deploy

- You can use this project to deploy directly from the Mia-Platform Console:  
  [Project Console Link](https://console.cloud.mia-platform.eu/projects/68555d8048e364cdce509d68/homepage)

- Alternatively, you can use the deploy element from the Software Catalog, which you can also customize as needed:  
  [Software Catalog Deploy Item](https://console.cloud.mia-platform.eu/tenants/7898bbc0-aded-4fd1-8c5d-775cbf39427c/software-catalog/urn%3A7898bbc0-aded-4fd1-8c5d-775cbf39427c%3Amktp%3Adeploy-item)

## Network and Image Requirements

- The client must allow outbound connections to the following endpoints:
  - `pkc-z1o60.europe-west1.gcp.confluent.cloud:9092`
  - `https://pkc-z1o60.europe-west1.gcp.confluent.cloud:443`

- The client must also allow pulling the following Docker image (ensure network access to this registry):
  - `nexus.mia-platform.eu/plugins/kafka2rest:feat-support-non-json-body`


