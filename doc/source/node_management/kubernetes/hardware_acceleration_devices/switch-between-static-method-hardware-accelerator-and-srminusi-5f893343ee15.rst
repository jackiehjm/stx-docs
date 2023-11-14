.. _switch-between-static-method-hardware-accelerator-and-srminusi-5f893343ee15:

=========================================================================
Switch between Static Method Hardware Accelerator and SR-IOV FEC Operator
=========================================================================

.. rubric:: |context|

The removal of the static device configuration requires a lock and unlock,
which is service impacting due to host reset. In addition, the |vRAN| Pods must
be reconfigured and recreated for this process, so the end-to-end service
impact will also be dependent on the application specific steps and recovery
process.

.. rubric:: |proc|

The following procedure allows to switch from the manual static method
configuration of a hardware accelerator device to the |SRIOV| |FEC| operator
method. This is necessary as it is not possible to use both methods at the same
time.

Taking in consideration that an accelerator card has been configured as in the
example in
:ref:`enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads`
to switch from Static to |SRIOV| |FEC| operator, follow the steps below.

.. note::

    As the device will be reconfigured in Kubernetes, it may be required to
    restart the app after switching methods.

#.  Lock the node containing the accelerator card.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$ system host-lock <hostname>

#.  Remove the past configuration from the accelerator card with
    :command:`host-device-modify` command.

    .. code-block:: none

        ~(keystone_admin)]$ system host-device-modify <hostname> <pci_address> --vf-driver none -N 0

        ~(keystone_admin)]$ system host-device-modify <hostname> <pci_address> --driver none

#.  Unlock the node containing the accelerator card.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostname>

#.  After the node finishes the unlocking process, find the |SRIOV| |FEC|
    operator along with other applications at
    ``/usr/local/share/applications/helm/sriov-fec-operator-<version>.tgz``.


Follow the steps in
:ref:`configure-sriov-fec-operator-to-enable-hw-accelerators-for-hosted-vran-containarized-workloads`
to upload and apply |SRIOV| |FEC| operator, and to create the pods for the
suitable accelerator card.

.. note::

    For compatibility between Static and |SRIOV| |FEC| operator, it is
    recommended to keep the same resource name for the accelerator (ACC100 in
    the example) while configuring |SRIOV| |FEC| operator using the following
    command before apply the application:

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-update sriov-fec-operator sriov-fec-operator sriov-fec-system --set env.SRIOV_FEC_ACC100_RESOURCE_NAME=intel_acc100_fec
