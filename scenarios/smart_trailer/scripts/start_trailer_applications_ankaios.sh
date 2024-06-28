#!/bin/bash

# Copyright (c) Microsoft Corporation.
# Licensed under the Apache License, Version 2.0.
# SPDX-License-Identifier: Apache-2.0

set -eu

DEBUG_LOG_ENABLED=0
# optarg with enabling debug log output
while getopts ":d" opt; do
  case ${opt} in
    d )
      DEBUG_LOG_ENABLED=1
      ;;
    \? )
      echo "Usage: start_trailer_applications_ankaios.sh [-d]"
      echo "Options:"
      echo "  -d  Enable debug log output"
      exit 1
      ;;
  esac
done

# This script requires jq and grpcurl to be installed
# These are included in the ankaios devcontainer, but if you want to run it outside
# you could add the commands to install them here
# Check if grpcurl is installed
if !command -v grpcurl &> /dev/null
then
  echo "grpcurl could not be found; please install it and run again"
  exit 1
fi

# Check if jq is installed
if !command -v jq &> /dev/null
then
  echo "jq could not be found; please install it and run again"
  exit 1
fi

# Get the directory of where the script is located
# All relative paths will be in relation to this
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# The Ibeji gRPC server address
IBEJI_SERVER="0.0.0.0:5010"

# The Ibeji in-vehicle digitial twin FindById gRPC service and method
IBEJI_INVEHICLE_DT_SERVICE="invehicle_digital_twin.InvehicleDigitalTwin"
METHOD="FindById"

# The request body: The IsTrailerConnected signal
BODY='{"id":"dtmi:sdv:Trailer:IsTrailerConnected;1"}'

# Curl the proto file from the repository and save it locally
PROTO_URL="https://github.com/eclipse-ibeji/ibeji/releases/download/0.1.1/invehicle_digital_twin.proto"
PROTO_PATH="${SCRIPT_DIR}"
PROTO="invehicle_digital_twin.proto"
curl -sL "${PROTO_URL}" -o "${PROTO_PATH}/${PROTO}"

if [ $? -ne 0 ]; then
  echo "Failed to download the invehicle-digital twin proto file."
  exit 1
fi

EXPECTED_PROTOCOL="grpc"
EXPECTED_OPERATION="get"

trap 'cleanup_routine' EXIT SIGTERM SIGQUIT SIGKILL

cleanup_routine() {
  rm "${PROTO_PATH}/${PROTO}"
}

log_info() {
  echo -e "[$(date -u +"%Y-%m-%dT%H:%M:%SZ") INFO]    $1"
}

log_debug() {
  if [ $DEBUG_LOG_ENABLED = 1 ]; then
    echo -e "[$(date -u +"%Y-%m-%dT%H:%M:%SZ") DEBUG]    $1"
  fi
}


# Call FindById in a loop until something is returned
while true; do
  STATUS=0
  OUTPUT=$(grpcurl -import-path $PROTO_PATH -proto $PROTO -plaintext -d "$BODY" $IBEJI_SERVER $IBEJI_INVEHICLE_DT_SERVICE/$METHOD 2>&1) || STATUS=$?

  # Check if the output contains entityAccessInfo (the response from Ibeji when a provider is found)
  if echo "$OUTPUT" | grep -iq "EntityAccessInfo"
  then
    log_debug "The FindById call was successful. Output:\n$OUTPUT"
    log_info "Trailer successfully connected to the vehicle!"
    break
  else
    log_debug "Provider not found. Status Code '$STATUS' Error '$OUTPUT'\nThe trailer is not connected. Retrying..."
    log_info "Waiting for the trailer to connect. Connect the trailer by starting the following workload with the Ank CLI:\nank run workload trailer_connected_provider --runtime podman --config $'image: ghcr.io/eclipse-sdv-blueprints/software-orchestration/invehicle-stack/trailer-connected-provider:0.1.0\\\ncommandOptions: ["--network", "host", "--name", "trailer_connected_provider"]' --agent agent_A\n"
    sleep 5 
  fi
done

# Parse the output as a JSON object using jq and extract the endpoints
ENDPOINTS=$(echo $OUTPUT | jq -c '.entityAccessInfo.endpointInfoList[]')

# Loop through each endpoint
for ENDPOINT in $ENDPOINTS
do
  # Check if protocol is what we expect
  if [[ $(echo $ENDPOINT | jq -r '.protocol' | tr '[:upper:]' '[:lower:]') == $EXPECTED_PROTOCOL ]]
  then
    OPERATIONS=$(echo $ENDPOINT | jq -r '.operations[]')
    # Loop through each operation and check if this endpoint supports the expected operation
    for OPERATION in $OPERATIONS
    do
      if [[ $(echo $OPERATION | tr '[:upper:]' '[:lower:]') == $EXPECTED_OPERATION ]]
      then
        log_info "Starting trailer applications to manage the trailer!"

        # Start up the other workloads using podman
        CFG_PROVIDER=$'image: ghcr.io/eclipse-sdv-blueprints/software-orchestration/invehicle-stack/trailer-properties-provider:0.1.0\ncommandOptions: ["--network", "host", "--name", "trailer_properties_provider"]'
        CFG_APP=$'image: ghcr.io/eclipse-sdv-blueprints/software-orchestration/invehicle-stack/smart-trailer-application:0.1.0\ncommandOptions: ["--network", "host", "--name", "smart_trailer_application"]'

        ank run workload trailer_properties_provider --runtime podman --config "$CFG_PROVIDER" --agent agent_A
        ank run workload smart_trailer_application --runtime podman --config "$CFG_APP" --agent agent_A

        log_debug "Called Ankaios to start the Trailer Properties Digital Twin Provider and Smart Trailer Application"
        log_debug "Check Ankaios status with 'ank get workloads'"
        exit 0
      fi
    done
  fi
done
# We didn't find an endpoint which satisfied our conditions
exit 1