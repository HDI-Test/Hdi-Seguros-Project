#!/bin/bash

# Function to make POST request with JSON body
make_post_request() {
  local url="$1"
  local json_body="$2"
  local temp_file=$(mktemp)

  wget --method=POST \
    --header="Content-Type: application/json" \
    --header="Accept: application/json" \
    --body-data="$json_body" \
    --quiet \
    --output-document="$temp_file" \
    --server-response \
    "$url" 2>&1

  local exit_code=$?
  local response_body=$(cat "$temp_file")
  rm -f "$temp_file"

  echo "$response_body"
  return $exit_code
}

API_URL="https://console-to-kafka-test.console.gcp.mia-platform.eu/proxy/job/job-id/buildWithParameters"
TRIGGER_ID=$(cat /proc/sys/kernel/random/uuid)
JOB_ID=test-pipeline-kafka-integration
JOB_TOKEN=${JENKINS_JOB_TOKEN}
JSON_PAYLOAD=$(jq -n --arg trigger_id "${TRIGGER_ID}" --arg job_id ${JOB_ID} --arg token ${JOB_TOKEN} '{key: $trigger_id, jobId: $job_id, token: $token}')

# Execute the POST request
echo "Making POST request to: $API_URL"
response=$(make_post_request "$API_URL" "$JSON_PAYLOAD" 2>&1)
exit_code=$?

# Check if request was successful
if [ $exit_code -eq 0 ]; then
  echo "Request successful"
else
  echo "Request failed with exit code: $exit_code"
  echo "Response: $response"
  exit 1
fi
