
.. nuo1612792731113
.. _configuring-vf-interfaces-rate-limiting-using-cli:

=====================================================
Configure VF Interfaces Rate Limiting Using the CLI
=====================================================

You can apply rate-limiting on |VFs| used for Data networks.

.. rubric:: |context|

This feature is available on the Intel X710/XL710 (Fortville) 10G and Intel
E810-CQDA2 (Columbiaville). It can be used on sub-interfaces of vf type
interfaces.

Be aware of the following guidance when using this feature:


.. _configuring-vf-interfaces-rate-limiting-using-cli-ul-c3p-yrz-44b:

-   Rate limiting is applicable to the maximum transmission rate.

-   Rate limiting is disabled by default.

-   If all |VFs| are in contention then each will get an equal share of the
    bandwidth.

-   The total sum of the maximum transmission rates of all rate limited |VFs|
    cannot exceed 90% of the port link speed.

-   The units are Mbps, and value of 0 means turn off the rate limiting.

-   |VFs| with different limited rate are supposed to be attached to separate
    data networks and managed by Kubernetes |SRIOV| device plugin as different
    ResourcePools. You can then use the |VFs| by specifying the corresponding
    <resourceName>.


This task must be performed from the CLI.

.. rubric:: |prereq|

You must create an |SRIOV| interface before you can provision VF interface. For
more information, see :ref:`Provisioning SR-IOV Interfaces using the CLI
<provisioning-sr-iov-interfaces-using-the-cli>`.

Data networks should be created for VF sub-interfaces attachment.

.. code-block:: none

    PHYSNET1='physnet_kernel_400m'
    PHYSNET2='physnet_dpdk_600m'
    system datanetwork-add ${PHYSNET1} vlan
    system datanetwork-add ${PHYSNET2} vlan


.. rubric:: |proc|

#.  Lock the host.

    .. note::
       AIO-SX hosts do not need to be locked to provision an |SRIOV|
       interface and assign it to a data network.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Create a sub-interface with rate limiting configuration.

    The parameters are all the same as shown in the procedure for |node-doc|:
    :ref:`Provisioning SR-IOV VF Interfaces using the CLI
    <provisioning-sr-iov-vf-interfaces-using-the-cli>`, plus one newly added
    rate limiting related parameter: ``--max-tx-rate``.

    .. note::
        The units for ``max-tx-rate`` are Mbps.
        The configured sriov_numvfs with
        max_tx_rate\(max_tx_rate\*sriov_numvfs) should not exceed 90% of
        the link bandwidth.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add -c pci-sriov controller-0 sriov00 vf sriov0 -N 2 --vf-driver=netdevice --max-tx-rate=400
        ~(keystone_admin)$ system host-if-add -c pci-sriov controller-0 sriov01 vf sriov0 -N 2 --vf-driver=vfio --max-tx-rate=600

#.  The rate limit configuration can be modified by specifying other values.

    .. note::
        The units for ``max-tx-rate`` are Mbps.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify controller-0 sriov00 --max-tx-rate=200

#.  The rate limit configuration can be modified by specifying a value of zero.

    .. note::
        Setting ``max-tx-rate`` to 0 disables any rate limiting.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify controller-0 sriov00 --max-tx-rate=0

#.  Attach the vf interfaces to the data.

    .. code-block:: none

        ~(keystone_admin)$ system interface-datanetwork-assign controller-0 sriov00 $PHYSNET1
        ~(keystone_admin)$ system interface-datanetwork-assign controller-0 sriov01 $PHYSNET2

#.  Unlock the host.

    .. note::
       AIO-SX hosts do not need to be locked to provision an |SRIOV|
       interface and assign it to a data network.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0
