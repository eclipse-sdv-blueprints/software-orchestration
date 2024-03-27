## Smart Trailer Scenario

This smart-trailer directory contains all of the source code associated with the smart trailer sample workloads.
This includes the interfaces needed to communicate with the in-vehicle stack (Eclipse Chariott, Ibeji, Agemo,
and Freyja).

### Interfaces

For simplicity for the first iteration, the files in the `interfaces` directory are copied from the main
repositories. These protobuf files enable communication with the services. You can find the
original files at the links below.
- [In-vehicle Digital Twin](https://github.com/eclipse-ibeji/ibeji/blob/0.1.1/interfaces/invehicle_digital_twin/v1)
- [Managed Subscribe Module](https://github.com/eclipse-ibeji/ibeji/tree/0.1.1/interfaces/module/managed_subscribe/v1)
for using Agemo
- [Service Discovery](https://github.com/eclipse-chariott/chariott/tree/0.2.1/service_discovery/proto/core/v1)

### Compiling the interfaces

The `proto_build` directory provides the necessary files to compile the protobuf with Rust. If you
would like to develop sample applications using Rust, you can use `cargo build -p interfaces`. If
you are not using Rust, use the [protobuf compiler](https://grpc.io/docs/protoc-installation/) with
the language of your choice to generate clients for interacting with the services.

### Building the sample workloads

>Note: Before running any of the following commands, replace all placeholders (wrapped with `<>`).

To containerize the sample workloads, follow the steps below for your container engine:

- Run the following command in this directory to build the docker container. If you run it from another
directory, adjust this command accordingly because the docker build context is the directory where this
README.md and the Dockerfile.sample_workloads files are located.

>Note: The dockerfile defaults to build the
[Trailer Properties Provider](./digital_twin_providers/trailer_properties_provider/) if a build
argument is not provided.

    ```shell
    docker build -t <image_name> -f Dockerfile.sample_workloads [--build-arg=APP_NAME=<workload_name>] .
    ```
    For example, to build an image for the `smart_trailer_application` workload:

    ```shell
    docker build -t ghcr.io/ladatz/sdvblueprint/smart_trailer_application:0.1.0 -f Dockerfile.sample_workloads --build-arg APP_NAME=smart_trailer_application .
    ```

- You can also use docker buildx build for cross-compilation, for example to build and push to a container registry:

    ```shell
    docker buildx build [--platform=<platform_name(s)>] -t <image_name> -f Dockerfile.sample_workloads [--build-arg=APP_NAME=<workload_name>] . --push
    ```
    For example, to build an image for the `smart_trailer_application` workload for linux/amd64 and linux/arm64:

    ```shell
    docker buildx build --platform=linux/amd64,linux/arm64 -t ghcr.io/ladatz/sdvblueprint/smart_trailer_application:0.1.0 -f Dockerfile.sample_workloads --build-arg APP_NAME=smart_trailer_application . --push
    ```

- You can also use podman:

    ```shell
    podman build -t <image_name> -f Dockerfile.sample_workloads [--build-arg=APP_NAME=<workload_name>] .
    ```
    For example, to build an image for the `smart_trailer_application` workload:

    ```shell
    podman build -t ghcr.io/ladatz/sdvblueprint/smart_trailer_application:0.1.0 -f Dockerfile.sample_workloads --build-arg APP_NAME=smart_trailer_application .
    ```
