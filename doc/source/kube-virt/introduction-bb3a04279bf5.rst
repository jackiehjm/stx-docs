.. _introduction-bb3a04279bf5:

============
Introduction
============

The KubeVirt system application in StarlingX includes: KubeVirt, Containerized
Data Importer (|CDI|), and the Virtctl client tool.

KubeVirt is an open source project that allows |VMs| to be run and managed as
pods inside a Kubernetes cluster. This is a particularly important innovation as
traditional |VM| workloads can be moved into Kubernetes alongside already
containerized workloads, thereby taking advantage of Kubernetes as an
orchestration engine. Specifically, KubeVirt |VM| workloads and containerized
workloads can exist on the same node/host; an advantage over the OpenStack
solution in |prod| where workloads can exist on same system/cluster but not on
the same node/host.

The |CDI| is an open source project that provides facilities for enabling |PVCs|
to be used as disks for KubeVirt |VMs| by way of DataVolumes.

The Virtctl client tool is an open source tool distributed with KubeVirt and
required to use advanced features such as serial and graphical console access.
It also provides convenience commands for starting/stopping |VMs|, live
migrating |VMs|, canceling live migrations and uploading |VM| disk images.

See https://kubevirt.io/user-guide for more details.


