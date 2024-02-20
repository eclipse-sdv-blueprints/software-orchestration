# Blueprint with Ankaios orchestrator


**Architectural Overview**


![Smart trailer blueprint](../docs/diagrams/ankaios.png)

The container is designed to have an immediately running environment. Once triggered, all workloads are initially started and sample data is exchanged between them.

## Links

- [Ankaios docs](https://eclipse-ankaios.github.io/ankaios/0.2/)
- [Ankaios quickstart](https://eclipse-ankaios.github.io/ankaios/0.2/usage/quickstart/)
- [Podman](https://docs.podman.io/en/v4.6.1/)
- [What are devcontainers?](https://containers.dev/)

## Prerequisites

- Docker [Installation instructions](https://docs.docker.com/get-docker/)

## Development environment

The following is provided inside the devcontainer:

- Ankaios executables (`ank-server`, `ank-agent` and `ank`)

- Podman 4.6.2

- Pre-configured Ankaios startup config [startupState.yaml](./config/startupState.yaml)

- Automation scripts for starting and stopping all workloads of the challenge:
    - run_blueprint.sh
    - shutdown_blueprint.sh

- Exposed port:
    - 25551: for optionally using the Ankaios CLI outside of the devcontainer

- [Ankaios Control Interface dependencies](#ankaios-control-interface-dependencies)


All services are running in the host network meaning those can be accessed by `localhost:<port>`. We recommend that you set the network mode to host for all your developed workloads as well.

## Ankaios Control Interface dependencies

The devcontainer includes also dependencies for developing applications using the [Ankaios Control Interface](https://eclipse-ankaios.github.io/ankaios/0.2/reference/control-interface/):

- protobuf compiler
- grpcurl
- Ankaios protobuf file (under `/usr/local/lib/ankaios/ankaios.proto`)

Those dependencies are needed for use-cases in which your app needs to use the [Ankaios Control Interface](https://eclipse-ankaios.github.io/ankaios/0.2/reference/control-interface/) to be able to communicate with the Ankaios cluster via the API. An example use-case would be to write a workload that shall request Ankaios to dynamically start another workload. You can find example workload applications written in various programming languages inside the Eclipse Ankaios repository [here](https://github.com/eclipse-ankaios/ankaios/tree/v0.2.0/examples).

## Run devcontainer with VSCode

### Prerequisites
- [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension installed in VSCode

Open the subfolder containing this README file in VSCode:

```shell
code .
```

VSCode detects automatically that a `.devcontainer` folder exists inside this subfolder.
Please confirm the dialog to reopen VSCode inside the devcontainer.
Afterwards, open a new terminal inside the devcontainer in VSCode.

## Run devcontainer without VSCode

Navigate to the subfolder containing this README file and run the following command to build the devcontainer image:

```shell
docker build -t custom-ankaios-dev:0.1 --target dev -f .devcontainer/Dockerfile .
```

Todo! Fix mountpoints, when new folder structure of Microsoft is available..

Start the devcontainer with the required mount points:

```shell
docker run -it --privileged --name custom_ankaios_dev -v <absolute/path/to>/blueprint/eclipse-ankaios:/workspaces/app -v <absolute/path/to>/blueprint/in-vehicle-stack:/workspaces/app/in-vehicle-stack -p 25551:25551 --workdir /workspaces/app custom-ankaios-dev:0.1 /bin/bash
```

## Startup check before development

Before starting active development we recommend you start once Ankaios with the current startup config [startupState.yaml](./config/startupState.yaml) and sample applications.

1. Log in into the Microsoft container registry
```shell
podman login sdvblueprint.azurecr.io
```

2. Start Ankaios with all workloads inside the startup config:
```shell
run_blueprint.sh
```

3. Next, use the Ankaios CLI to verify that all initial workloads are up and running:

```shell
ank get workloads
```

4. Verify that all initial workloads inside the startup config have execution state "Running".

The output looks similar to the following:
```shell
 WORKLOAD NAME              AGENT     RUNTIME   EXECUTION STATE
 digital_twin_cloud_sync    agent_A   podman    Running
 digital_twin_vehicle       agent_A   podman    Running
 dynamic_topic_management   agent_A   podman    Running
 mqtt_broker                agent_A   podman    Running
 service_discovery          agent_A   podman    Running
```

5. Only for the **Smart Trailer scenario**, do the following extra steps:
    - Inside the devcontainer, run the script `start_trailer_applications_ankaios.sh`:
        ```shell
        start_trailer_applications_ankaios.sh
        ```
    - In another terminal window inside the devcontainer, add the following workload by using the Ankaios CLI to simulate the Smart Trailer connected signal:
        ```shell
        ank run workload trailer_connected_provider --runtime podman --config $'image: sdvblueprint.azurecr.io/sdvblueprint/in-vehicle-stack/trailer_connected_provider:0.1.0\ncommandOptions: ["--network", "host", "--name", "trailer_connected_provider"]' --agent agent_A
        ```
    - Verify the output of the terminal window of the `start_trailer_applications_ankaios.sh` script. The output should look like the following:
        ```shell
        Trailer is connected! Starting workloads to manage it
        Called Ankaios to start the Trailer Properties Digital Twin Provider and Smart Trailer Application
        Check Ankaios status with 'ank get workloads'
        ```
    - Check the execution states of the newly added workloads by using the Ankaios CLI.
        ```shell
        ank get workloads
        ```
    - Run `podman logs -f smart_trailer_application` to check the sample data output of the Smart Trailer App. Feel free to check the logs of the other workloads too.

6. Stop Ankaios and clean up all workloads by running:

```shell
shutdown_blueprint.sh
```

## Customizing Devcontainer

You can customize the devcontainer depending on your preferred programming language, tools and frameworks.

To customize the devcontainer add your specific dev dependencies to `.devcontainer/Dockerfile` (starting from line 7).

Rebuild the container image.

## Workload development

After customizing the devcontainer, start the development of your workload apps.

- Write your code
- Write a [Dockerfile](https://docs.docker.com/engine/reference/builder/) for each workload
- Build a container image for each workload with [podman build](https://docs.podman.io/en/v4.6.1/markdown/podman-build.1.html)
- For the Smart Trailer scenario, replace the image URIs within the script [start_trailer_applications_ankaios.sh](../in-vehicle-stack/scenarios/smart_trailer_use_case/scripts/start_trailer_applications_ankaios.sh)
- If required, extend the Ankaios startup config [startupState.yaml](./config/startupState.yaml) by adding config parts for your workloads

Start and stop all workloads according to the section [Startup check before development](#startup-check-before-development).
Use the Ankaios ClI to check the workload states. For more details display the help of Ankaios CLI by running:
```shell
ank --help
```

Use the [podman logs](https://docs.podman.io/en/v4.6.1/markdown/podman-logs.1.html) command to check the logs of your container applications for debugging purposes.

```shell
podman ps -a
podman logs -f <container_name|container_id>
```

## Ankaios logs

There are log files for debugging purposes of Ankaios server and agent.

The Ankaios server logs can be viewed by executing the following command:

```shell
tail -f /var/log/ankaios-server.log
```

The Ankaios agent logs can be viewed by executing the following command:

```shell
tail -f /var/log/ankaios-agent_A.log
```
