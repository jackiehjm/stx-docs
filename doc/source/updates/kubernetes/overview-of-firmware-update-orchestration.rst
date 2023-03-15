
.. xkr159015711692
.. _overview-of-firmware-update-orchestration:

========
Overview
========

Firmware update orchestration allows the firmware on the hosts of an entire
|prod-long| system to be updated with a single operation.

You can configure and run firmware update orchestration using the |CLI|, or the
``stx-nfv`` VIM REST API.

.. note::
    Firmware update is currently not supported on the Horizon Web interface.
    Only host device |FPGA| firmware update is currently supported.

------------------------------------------
Firmware update orchestration requirements
------------------------------------------

Firmware update orchestration can only be done on a system that meets the
following conditions:

-   The system is clear of alarms (with the exception of alarms for locked
    hosts, stopped instances, and firmware updates in progress).

    .. note::
        When configuring firmware update orchestration, you have the option to
        ignore alarms that are not of management-affecting severity. For more
        information, see :ref:`Kubernetes Version Upgrade Cloud Orchestration
        <configuring-kubernetes-update-orchestration>`.

-   There are unlocked-enabled worker function hosts in the system that
    requires firmware update. The *Firmware Update Orchestration Strategy*
    creation step will fail if there are no qualified hosts detected.

-   Firmware update is a reboot-required operation. Therefore, in systems that
    have the |prefix|-openstack application applied with running instances, if
    the migrate option is selected there must be spare openstack-compute \
    (worker) capacity to move instances off the openstack-compute \
    (worker) host\(s) being updated.

    .. note::
        Administrative controller Swacts should be avoided during firmware
        update orchestration.

For more information, refer to the following:

.. toctree::
    :maxdepth: 1

    the-firmware-update-orchestration-process
    firmware-update-operations-requiring-manual-migration
