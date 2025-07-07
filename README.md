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

## Running Docker Image with All Example Files and Environment Variables

To run the application with Docker, you need to mount each file from the `examples` directory into the container's `/config` directory. Below is an explicit example using all the files currently present in the `examples` directory:

```sh
git clone git@github.com:HDI-Test/Hdi-Seguros-Project.git
cd Hdi-Seguros-Project/examples
docker login nexus.mia-platform.eu
docker run --name kafka2rest --env-file local.env -v $(pwd)/bodyGenerators.js:/configs/bodyGenerators.js:ro -v $(pwd)/headerGenerators.js:/configs/headerGenerator.js:ro -v $(pwd)/kafka2rest-config.json:/configs/kafka2rest-config.json:ro -v $(pwd)/pathGenerators.js:/configs/pathGenerators.js:ro nexus.mia-platform.eu/plugins/kafka2rest:feat-support-non-json-body
```

- `--env-file local.env` loads all environment variables defined in your `local.env` file.
- Each `-v` flag mounts a specific file from the `examples` directory into `/config` inside the container as read-only.
- Adjust the paths as needed if your files are located elsewhere.

This setup allows the container to use all configuration and generator files from the `examples` directory, and environment variables from `local.env`, at runtime.

You need to update the values on the [local.env](./examples/local.env) file:
- KAFKA_BROKERS_LIST
- KAFKA_SASL_USERNAME
- KAFKA_SASL_PASSWORD


## Running kafka2rest Docker Image with a Mounted File

To run the `nexus.mia-platform.eu/plugins/kafka2rest:feat-support-non-json-body` Docker image locally and mount a configuration file, use the following command:

```sh
docker run \
  --name kafka2rest \
  -v /path/to/your/config.yaml:/app/config/config.yaml:ro \
  nexus.mia-platform.eu/plugins/kafka2rest:feat-support-non-json-body
```

- Replace `/path/to/your/config.yaml` with the path to your local configuration file.
- The file will be mounted as read-only (`:ro`) inside the container at `/app/config/config.yaml` (adjust the path as required by the application).

This allows the container to use your custom configuration file at runtime.


