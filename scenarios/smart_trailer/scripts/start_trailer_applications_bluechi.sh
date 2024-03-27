#!/bin/bash

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.
# SPDX-License-Identifier: MIT

set -e

# This script requires jq and grpcurl to be installed
# These are included in the bluechi devcontainer, but if you want to run it outside
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
SERVER="0.0.0.0:5010"

# The Ibeji FindById gRPC service and method
SERVICE="invehicle_digital_twin.InvehicleDigitalTwin"
METHOD="FindById"

# The request body: The IsTrailerConnected signal
BODY='{"id":"dtmi:sdv:Trailer:IsTrailerConnected;1"}'

# Curl the proto file from the repository and save it locally
PROTO_URL="https://github.com/eclipse-ibeji/ibeji/releases/download/0.1.1/invehicle_digital_twin.proto"
PROTO_PATH="${SCRIPT_DIR}"
PROTO="invehicle_digital_twin.proto"
curl -L "${PROTO_URL}" -o "${PROTO_PATH}/${PROTO}"

EXPECTED_PROTOCOL="grpc"
EXPECTED_OPERATION="get"

# Call FindById in a loop until something is returned
while true; do
  STATUS=0
  OUTPUT=$(grpcurl -import-path $PROTO_PATH -proto $PROTO -plaintext -d "$BODY" $SERVER $SERVICE/$METHOD 2>&1) || STATUS=$?

  # Check if the output contains entityAccessInfo (the response from Ibeji when a provider is found)
  if echo "$OUTPUT" | grep -iq "EntityAccessInfo"
  then
    echo "The FindById call was successful. Output:"
    echo "$OUTPUT"
    break
  else
    echo "Provider not found. Status Code '$STATUS' Error '$OUTPUT'"
    echo "The trailer is not connected. Retrying..."
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
        echo "Trailer is connected! Starting workloads to manage it"

        # The service.kube and service.yml files for these two services are included in the BlueChi devcontainer
        # See /etc/containers/systemd for these files
        # Start up the other workloads using systemctl
        systemctl start trailer-properties
        systemctl start smart-trailer

        echo "Called systemctl to start the Trailer Properties Digital Twin Provider and Smart Trailer Application"
        echo "Check systemctl status with 'systemctl status trailer-properties' and 'systemctl status smart-trailer' for status"
        rm "${PROTO_PATH}/${PROTO}"
        exit 0
      fi
    done
  fi
done
# We didn't find an endpoint which satisfied our conditions
rm "${PROTO_PATH}/${PROTO}"
exit 1