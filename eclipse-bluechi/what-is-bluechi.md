# What is Eclipse Bluechi?

BlueChi is a systemd controller that adds a thin layer to enable multi-node
workload management and cross-node dependencies to Systemd.

It can handle various workloads such as containers, virtual machines or
applications running on bare metal. To run containers under systemd in an
optimal way it uses Podman's Quadlet implementation. This also enables the usage
of Kubernetes resource definitions to define your automotive workloads.

## Links

* [Bluechi documentation](https://bluechi.readthedocs.io/en/latest/)
* [Bluechi CLI
  documentation](<https://github.com/eclipse-bluechi/bluechi/blob/main/doc/man/bluechictl.1.md>)
* [Podman](https://docs.podman.io/en/latest/)
* [Podman and Quadlet](https://www.redhat.com/sysadmin/quadlet-podman)
