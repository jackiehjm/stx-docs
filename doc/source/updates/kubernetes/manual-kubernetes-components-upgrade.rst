
.. bfd1591638638205
.. _manual-kubernetes-components-upgrade:

=================================
Manual Kubernetes Version Upgrade
=================================

You can upgrade the Kubernetes version on a running system from one supported
version to another.


.. note::

    Each |prod| release supports two or more consecutive Kubernetes releases.
    The default version on a fresh install will always be the latest Kubernetes
    release supported by a |prod| release. Upgrades from previous releases will
    always start with the same Kubernetes version as the highest version from
    the release you are upgrading from.

    Kubernetes upgrades must be done sequentially without skipping any
    release(s).


.. rubric:: |context|

To complete this task, you will apply the following three updates (patches)
and upgrade various systems.

**Platform update**
    The platform update contains metadata for the new Kubernetes version and the
    Kubernetes networking pods templates for the new Kubernetes version.

**Kubeadm update**
    The kubeadm update upgrades the kubeadm RPM to the new Kubernetes version.

**Kubelet and Kubectl update**
    This Kubernetes update upgrades kubelet and kubectl RPMs to the new
    Kubernetes version.


.. rubric:: |prereq|


.. _manual-kubernetes-components-upgrade-ul-jbr-vcn-ylb:

-   The system must be clear of alarms.

-   All hosts must be unlocked, enabled and available.

-   All Kubernetes pods must be ready.

-   The installed applications must be compatible with the new Kubernetes
    version.

-   All updates required for the new Kubernetes version must be transferred to
    the active controller.

-   If you are using NetApp Trident in |prod| |prod-ver| and have upgraded from
    the |prod| previous version, ensure that your NetApp backend version is
    compatible with Trident 22.07 and follow the steps in :ref:`Upgrade the
    NetApp Trident Software <upgrade-the-netapp-trident-software-c5ec64d213d3>`
    to upgrade the Trident drivers to 21.04 before upgrading Kubernetes to
    version 1.19.

.. rubric:: |proc|

#.  Upload, apply and install the platform update.

    Use the standard :command:`sw-patch`, :command:`upload`, :command:`apply`
    and :command:`install` commands to perform these operations.

#.  List the available Kubernetes versions.

    On a fresh install of |prod| |prod-ver|, the following output appears:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-version-list
        +---------+--------+-------------+
        | Version | Target | State       |
        +---------+--------+-------------+
        | v1.21.8 | False  | unavailable |
        | v1.22.5 | False  | unavailable |
        | v1.23.1 | False  | unavailable |
        | v1.24.4 | True   | active      |
        +---------+--------+-------------+

    If |prod| was upgraded to |prod-ver|, the following appears:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-version-list
        +---------+--------+-------------+
        | Version | Target | State       |
        +---------+--------+-------------+
        | v1.21.8 | True   | active      |
        | v1.22.5 | False  | available   |
        | v1.23.1 | False  | unavailable |
        | v1.24.4 | False  | unavailable |
        +---------+--------+-------------+

    The following meanings apply to the output shown:

    **Target**
        A value of True means that the target is currently selected for
        installation.

    **State**
        Can be one of:

        *active*
            The version is running everywhere.

        *partial*
            The version is running somewhere.

        *available*
            The version can be upgraded to.

        *unavailable*
            The version is not available for upgrading. Either it is a
            downgrade or it requires an intermediate upgrade first. Kubernetes
            can be only upgraded one version at a time.

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-kube-upgrade` command then
    recheck the system health status to confirm that all **System Health**
    fields are set to *OK*.

    .. code-block:: none

        ~(keystone_admin)]$ system health-query-kube-upgrade
            System Health:
            All hosts are provisioned: [OK]
            All hosts are unlocked/enabled: [OK]
            All hosts have current configurations: [OK]
            All hosts are patch current: [OK]
            Ceph Storage Healthy: [OK]
            No alarms: [OK]
            All kubernetes nodes are ready: [OK]
            All kubernetes control plane pods are ready: [OK]
            Required patches are applied: [OK]
            License valid for upgrade: [OK]
            No instances running on controller-1: [OK]
            All kubernetes applications are in a valid state: [OK]
            Active controller is controller-0: [OK]

#.  Start the Kubernetes upgrade.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-start v1.22.5
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | upgrade-started                      |                            
        +--------------+--------------------------------------+
        

    The upgrade process checks the *applied*/*available* updates, the upgrade
    path, the health of the system, the installed applications compatibility and
    validates the system is ready for an upgrade.

    .. warning::
        The command :command:`system kube-upgrade-start --force` causes the
        upgrade process to ignore non-management-affecting alarms.
        Kubernetes cannot be upgraded if there are management-affecting alarms.

#.  Download the Kubernetes images.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-download-images
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | downloading-images                   |
        | created_at   | 2023-06-26T18:44:46.854319+00:00     |
        | updated_at   | None                                 |
        +--------------+--------------------------------------+

#.  Confirm that the download has completed.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | downloaded-images                    |
        | created_at   | 2023-06-26T18:44:46.854319+00:00     |
        | updated_at   | 2023-06-26T18:51:29.486448+00:00     |
        +--------------+--------------------------------------+

#.  Upgrade Kubernetes networking.

    This step must be completed after the first control plane has been upgraded
    and before upgrading the second control plane.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-networking
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | upgrading-networking                 |
        | created_at   | 2023-06-26T18:44:46.854319+00:00     |
        | updated_at   | 2023-06-26T18:51:29.486448+00:00     |
        +--------------+--------------------------------------+

    The state *upgraded-networking* will be entered when the networking
    upgrade has completed.

#.  Upgrade the control plane on the first controller.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade controller-1 control-plane
        +-----------------------+-------------------------+
        | Property              | Value                   |
        +-----------------------+-------------------------+
        | control_plane_version | v1.21.8                 |
        | hostname              | controller-1            |
        | id                    | 2                       |
        | kubelet_version       | v1.21.8                 |
        | personality           | controller              |
        | status                | upgrading-control-plane |
        | target_version        | v1.22.5                 |
        +-----------------------+-------------------------+
        
    You can upgrade either controller first.

    The state *upgraded-first-master* will be entered when the first control
    plane upgrade has completed.

#.  Upgrade the control plane on the second controller.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade controller-0 control-plane
        +-----------------------+-------------------------+
        | Property              | Value                   |
        +-----------------------+-------------------------+
        | control_plane_version | v1.21.8                 |
        | hostname              | controller-0            |
        | id                    | 1                       |
        | kubelet_version       | v1.21.8                 |
        | personality           | controller              |
        | status                | upgrading-control-plane |
        | target_version        | v1.22.5                 |
        +-----------------------+-------------------------+

    The state *upgraded-second-master* will be entered when the upgrade has
    completed.

#.  Show the Kubernetes upgrade status for all hosts.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade-list
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | id | hostname     | personality | target_version | control_plane_version | kubelet_version | status |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | 1  | controller-0 | controller  | v1.22.5        | v1.22.5               | v1.21.8         | None   |
        | 2  | controller-1 | controller  | v1.22.5        | v1.22.5               | v1.21.8         | None   |
        | 3  | worker-0     | worker      | v1.18.1        | N/A                   | v1.18.1         | None   |
        | 4  | worker- 1    | worker      | v1.18.1        | N/A                   | v1.18.1         | None   |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+

    The control planes of both controllers are now upgraded to v1.19.13.

#.  Upgrade kubelet on both controllers.

    Either controller can be upgraded first.

    The kubelets on all controller hosts must be upgraded before upgrading
    kubelets on worker hosts.

    For each controller, do the following.


    #.  For non |AIO-SX| systems, lock the controller.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-1

        .. warning::
            For All-In-One Simplex systems, the controller must **not** be
            locked.

    #.  Apply the upgrade.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system kube-host-upgrade controller-1 kubelet
            +-----------------------+-------------------+
            | Property              | Value             |
            +-----------------------+-------------------+
            | control_plane_version | v1.22.5           |
            | hostname              | controller-1      |
            | id                    | 2                 |
            | kubelet_version       | v1.21.8           |
            | personality           | controller        |
            | status                | upgrading-kubelet |
            | target_version        | v1.22.5           |
            +-----------------------+-------------------+

    #.  For non |AIO-SX| systems, unlock the controller.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-1


#.  Show the Kubernetes upgrade status.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | upgrading-kubelets                   |
        | created_at   | 2023-06-26T18:44:46.854319+00:00     |
        | updated_at   | 2023-06-26T19:41:57.936617+00:00     |
        +--------------+--------------------------------------+

#.  Upgrade kubelet on all worker hosts.

    Multiple worker hosts can be upgraded simultaneously provided there is
    sufficient capacity remaining on other worker hosts.

    For each worker host, do the following:


    #.  Lock the host.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock worker-1

    #.  Perform the upgrade.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system kube-host-upgrade worker-1 kubelet
            +-----------------------+-------------------+
            | Property              | Value             |
            +-----------------------+-------------------+
            | control_plane_version | v1.22.5           |
            | hostname              | worker-1          |
            | id                    | 3                 |
            | kubelet_version       | v1.21.8           |
            | personality           | worker            |
            | status                | upgrading-kubelet |
            | target_version        | v1.22.5           |
            +-----------------------+-------------------+

    #.  Unlock the host.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock worker-1


#.  Complete the Kubernetes upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-complete
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.22.5                              |
        | state        | upgrade-complete                     |
        | created_at   | 2023-06-26T18:44:46.854319+00:00     |
        | updated_at   | 2023-06-26T19:06:47.515747+00:00     |
        +--------------+--------------------------------------+

#.  Remove the alarm 900.007 (Kubernetes upgrade in progress) if it is still
    running after the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-delete

.. from step 1
.. For more
    information, see the :ref:`Managing Software Updates
    <managing-software-updates>`.
