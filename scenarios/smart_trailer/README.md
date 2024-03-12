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

If you would like to containerize the sample workloads, you can do so by running:

1. Run the following command in this directory to build the docker container. Or adjust this
command depending on where you are running it from, but the build context is the directory where
this README.md and the Dockerfile.sample_workloads file are located.

    ```shell
    docker build -t <image_name> -f <Dockerfile.sample_workloads> [--build-arg=APP_NAME=<workload name>] .
    ```

    For example, to build an image for the `smart_trailer_application` workload:

    ```shell
    docker build -t ibeji_integration -f Dockerfile.freyja_apps.amd64 --build-arg APP_NAME=smart_trailer_application .
    ```

You can also use docker builx build, for example:

Or podman:


The dockerfile defaults to build the
[Trailer Properties Provider](./digital_twin_providers/trailer_properties_provider/) if a build
argument is not provided.
