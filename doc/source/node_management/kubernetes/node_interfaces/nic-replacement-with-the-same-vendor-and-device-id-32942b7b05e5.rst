.. _nic-replacement-with-the-same-vendor-and-device-id-32942b7b05e5:

================================================
Replace a NIC with the same vendor and device-id
================================================

The following procedure allows the replacement of a NIC on a host, without
requiring a host or system (in case of |AIO-SX|) re-install and
re-configuration, in the case of the replaced NIC having the same vendor or
device ID information.

The normal approach to doing such a change would be to do a ``system
host-delete``, a ``system host-add`` (re-install) and a re-configure of the
host. In the case of an |AIO-SX| deployment, with only one host, this would
result in a full system re-install and full system re-configuration.

Since this procedure reuses same vendor and device ID information and
capabilities, the interface's new |MAC| will be updated internally and no
reconfiguration is required. Assuming that the replacement will occur on
the same |PCI| slot of the previous card, the procedure can be executed for all
types of NIC classes (``pci-sriov``, ``data``, ``pci-passthrough``, and
``platform``).

.. rubric:: |proc|

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <hostname>

    #. Wait for the host to be reported as locked.

#.  Power down the host manually and make the NIC card replacement.

#.  Power up the host.

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostname>

.. rubric:: |result|

The host is rebooted, and its Availability State is reported as ``In-Test``.
After a few minutes, it is reported as ``Unlocked``, ``Enabled``, and
``Available``.
