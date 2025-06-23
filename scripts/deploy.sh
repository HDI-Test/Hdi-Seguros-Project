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

# Generate a random trigger ID (portable, works in most CI environments)
if command -v openssl >/dev/null 2>&1; then
  TRIGGER_ID=$(openssl rand -hex 16)
else
  TRIGGER_ID=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c32)
fi
echo "TRIGGER_ID: $TRIGGER_ID"

JOB_TOKEN=${JENKINS_JOB_TOKEN}
echo "JOB_TOKEN: $JOB_TOKEN"

# Accept jobId as argument
if [ -z "$1" ]; then
  echo "Usage: $0 <jobId>"
  exit 1
fi

JOB_ID="$1"
echo "Using JOB_ID: $JOB_ID"

JSON_PAYLOAD=$(jq -n --arg trigger_id "${TRIGGER_ID}" --arg job_id "$JOB_ID" --arg token ${JOB_TOKEN} '{key: $trigger_id, jobId: $job_id, token: $token}')
echo "JSON_PAYLOAD: $JSON_PAYLOAD"

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
