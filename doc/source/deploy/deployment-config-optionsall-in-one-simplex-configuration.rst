
.. egy1565201808746
.. _deployment-config-optionsall-in-one-simplex-configuration:

======================================
All-in-one (AIO) Simplex Configuration
======================================

The AIO Simplex deployment configuration provides a scaled-down |prod| that
combines controller, storage, and worker functionality on a single
non-redundant host.

.. image:: /deploy_install_guides/r5_release/figures/starlingx-deployment-options-simplex.png
   :width: 800

.. note::
    Physical L2 switches are not shown in the deployment diagram in subsequent
    chapters. Only the L2 networks they support are shown.

See :ref:`Common Components <common-components>` for a description of common
components of this deployment configuration.

This deployment configuration provides no protection against an overall server
hardware fault. However, there may be hardware component protection if, for
example, HW RAID or 2x Port |LAG| is used in the
deployment.

Typically, this solution is used where only a small amount of cloud processing
/ storage power is required, and protection against overall server hardware
faults is either not required or done at a higher level.

Ceph is deployed in this configuration using one or more disks for |OSDs|, and
provides the backend for Kubernetes' |PVCs|.

The solution requires two or more disks, one for system requirements and
container ephemeral storage, and one or more for Ceph |OSDs|.

.. xreflink .. note::
    A storage backend is not configured by default. You can use either
    internal Ceph or an external Netapp Trident backend. For more information,
    see the :ref:`|stor-doc| <storage-configuration-storage-resources>` guide.

The internal management network is not required in this scenario as it is
configured on the loopback interface. The cluster host network is internal by
default and also configured on the loopback interface with application
container external connectivity being achieved through either the external OAM
network or optional additional external networks. However, the cluster host
network can be re-configured on a physical interface depending on external
connectivity requirements.

.. _deployment-config-optionsall-in-one-simplex-configuration-section-N1004C-N1001C-N10001:

----------------------
Intel Xeon D Processor
----------------------

In addition to regular all-in-one deployments, |prod| Simplex and Duplex
provide support for small scale deployments on the Intel Xeon D family of
processors using a smaller memory and CPU footprint than the standard Simplex
configuration.

For low-cost or low-power applications with minimal performance demands \(40
Containers or fewer\), |prod| Simplex can be deployed on a server with a
single Intel Xeon D class processor. The platform-reserved memory and the
maximum number of worker threads are reduced by default, but can be
reconfigured as required.
