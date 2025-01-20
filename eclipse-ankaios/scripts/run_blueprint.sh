#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ANKAIOS_SERVER_SOCKET="0.0.0.0:25551"
ANKAIOS_SERVER_URL="http://${ANKAIOS_SERVER_SOCKET}"

trap 'cleanup_routine' EXIT SIGTERM SIGQUIT SIGKILL

cleanup_routine() {
  printf "\nStopping the blueprint\n"
  $SCRIPT_DIR/shutdown_blueprint.sh
}

run_ankaios() {
  ANKAIOS_LOG_DIR="/var/log/ankaios"
  mkdir -p ${ANKAIOS_LOG_DIR}

  # Start the Ankaios server
  echo "Starting Ankaios server"
  ank-server --insecure --startup-config ${SCRIPT_DIR}/../config/startupManifest.yaml --address ${ANKAIOS_SERVER_SOCKET} > ${ANKAIOS_LOG_DIR}/ankaios-server.log 2>&1 &

  sleep 2
  # Start an Ankaios agent
  echo "Starting Ankaios agent agent_A"
  ank-agent --insecure --name agent_A --server-url ${ANKAIOS_SERVER_URL} > ${ANKAIOS_LOG_DIR}/ankaios-agent_A.log 2>&1 &

  echo "Ankaios started in insecure mode (according to env variables in .bashrc). For mTLS setup see https://eclipse-ankaios.github.io/ankaios/0.5/usage/mtls-setup/"
  echo "For graceful shutdown press Ctrl+C. Never exit just the terminal. Otherwise execute 'shutdown_blueprint.sh' manually."

  # Wait for any process to exit
  wait -n

  # Exit with status of process that exited first
  exit $?
}

run_ankaios