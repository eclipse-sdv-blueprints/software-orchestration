#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ANKAIOS_SERVER_SOCKET="0.0.0.0:25551"
ANKAIOS_SERVER_URL="http://${ANKAIOS_SERVER_SOCKET}"

cleanup_routine() {
  rm -f /tmp/currentState.yaml
  ank --server-url ${ANKAIOS_SERVER_URL} delete workload hello
}

trap cleanup_routine EXIT

run_ankaios() {
  ANKAIOS_LOG_DIR="/var/log"
  mkdir -p ${ANKAIOS_LOG_DIR}

  # Start the Ankaios server
  echo "Starting Ankaios server"
  ank-server --startup-config ${SCRIPT_DIR}/../config/default.yaml --address ${ANKAIOS_SERVER_SOCKET} > ${ANKAIOS_LOG_DIR}/ankaios-server.log 2>&1 &

  sleep 2
  # Start an Ankaios agent
  echo "Starting Ankaios agent agent_A"
  ank-agent --name agent_A --server-url ${ANKAIOS_SERVER_URL} > ${ANKAIOS_LOG_DIR}/ankaios-agent_A.log 2>&1 &

  echo "For graceful shutdown execute 'shutdown_blueprint.sh'. This prevents dangling services."

  # Wait for any process to exit
  wait -n

  # Exit with status of process that exited first
  exit $?
}

echo '[Starting Ankaios cluster ...]'
run_ankaios &

sleep 3;
while [ `ank -s $ANKAIOS_SERVER_URL get state workloadStates |  yq '.workloadStates.[] | select(.workloadName == "hello") | .executionState' | grep -c ExecSucceeded` = 0 ]; do 
  echo "Waiting..."
  sleep 3; 
done

echo '[Ankaios cluster started.]'

cat $SCRIPT_DIR/../config/startupState.yaml | yq '.workloads.* | path | .[-1]' | while read p; 
do
  yq ".workloads.$p | {\"currentState\": {\"workloads\": {\"$p\": .}}}"< $SCRIPT_DIR/../config/startupState.yaml > /tmp/currentState.yaml
  echo "Starting workload '$p' ..."
  ank -s $ANKAIOS_SERVER_URL set state -f /tmp/currentState.yaml currentState.workloads.$p
  while true; do
    if [ $(ank -s $ANKAIOS_SERVER_URL get state workloadStates |  yq ".workloadStates.[] | select(.workloadName == \"$p\") | .executionState" | grep -Ec '(ExecRunning|ExecFailed|ExecSucceeded)') = 1 ]
    then
        break
    fi
    sleep 3; 
  done
  echo "Workload '$p' started."
done 

