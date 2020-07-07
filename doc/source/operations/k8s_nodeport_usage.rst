=========================
Kubernetes NodePort Usage
=========================

The following usage restrictions apply when using NodePorts:

*   NodePorts 30,000 to 31,499 are **reserved** for the StarlingX
    Platform and additional StarlingX applications that are supported on top of
    the StarlingX Platform (for example, StarlingX OpenStack).

*   NodePorts 31,500 to 32,767 are available for applications that use the
    Kubernetes NodePort service to expose the application externally.