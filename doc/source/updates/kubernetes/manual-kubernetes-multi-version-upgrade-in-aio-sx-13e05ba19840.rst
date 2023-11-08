.. _manual-kubernetes-multi-version-upgrade-in-aio-sx-13e05ba19840:

=================================================
Manual Kubernetes Multi-Version Upgrade in AIO-SX
=================================================

You can upgrade the Kubernetes version on a running system from one supported
version to another.

|AIO-SX| now supports multi-version Kubernetes upgrades. In this model,
Kubernetes is upgraded by two or more versions after disabling applications and
then applications are enabled again. This is faster than upgrading Kubernetes
one version at a time. Also, the upgrade can be aborted and reverted to the
original version. This feature is supported only for |AIO-SX|.

|AIO-SX| supports the Kubernetes multi-version upgrade. Thus, Kubernetes can be
upgraded from the lowest version to the highest version available in the
system. This feature is not supported in the system which is not |AIO-SX|.

.. note::

    Each |prod| release supports two or more consecutive Kubernetes releases.
    The default version on a fresh install will always be the latest Kubernetes
    release supported by a |prod| release. Upgrades from previous releases will
    always start with the same Kubernetes version as the highest version from
    the release you are upgrading from.

.. rubric:: |prereq|

-   The system must be clear of alarms.

-   All hosts must be unlocked, enabled, and available.

-   All Kubernetes pods must be ready.

-   The installed applications must be compatible with the new Kubernetes
    versions that the system will upgrade to.

-   If you are using NetApp Trident in |prod| |prod-ver| and if you have
    upgraded from the |prod| previous version, ensure that your NetApp backend
    version is compatible with Trident 22.07. Follow the steps in
    :ref:`upgrade-the-netapp-trident-software-c5ec64d213d3` to upgrade Trident
    to 22.07 before upgrading Kubernetes to version 1.24.

.. rubric:: |proc|

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

    If |prod| was upgraded to |prod-ver|, the following output appears:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-version-list
        +---------+--------+-------------+
        | Version | Target | State       |
        +---------+--------+-------------+
        | v1.21.8 | True   | active      |
        | v1.22.5 | False  | available   |
        | v1.23.1 | False  | available   |
        | v1.24.4 | False  | available   |
        +---------+--------+-------------+

    The following meanings apply to the output shown:

    **Target**

    Target is either true or false. Target will be true only for the active
    Kubernetes version.

    **State**

    State can be one of the following:

    *active*: The version is running everywhere.

    *partial*: The version is running somewhere.

    *available*: The version can be upgraded.

    *unavailable*: The version is not available for upgrading.

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-kube-upgrade` command, and
    recheck the system health status to confirm that all the **System Health**
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
            All kubernetes applications are in a valid state: [OK]
            Active controller is controller-0: [OK]

#.  Start the Kubernetes multi-version upgrade.

    Specify the desired target version available to upgrade.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-start 1.24.4
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | upgrade-started                      |             
        +--------------+--------------------------------------+

    The upgrade process checks the applied/available updates, the upgrade
    path, the system health, the installed applications compatibility, and
    validates that the system is ready for an upgrade.

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
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | downloading-images                   |
        | created_at   | 2023-08-24T02:33:47.049826+00:00     |
        | updated_at   | None                                 |
        +--------------+--------------------------------------+

#.  Confirm that the download has completed.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | downloaded-images                    |
        | created_at   | 2023-08-24T02:33:47.049826+00:00     |
        | updated_at   | 2023-08-24T02:38:16.374677+00:00     |
        +--------------+--------------------------------------+

#.  Upgrade Kubernetes networking.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-networking
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | bf3f9c80-0cec-49a0-91ef-dd86c9bb8fe8 |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | upgrading-networking                 |
        | created_at   | 2023-08-24T02:33:47.049826+00:00     |
        | updated_at   | 2023-08-24T02:38:16.374677+00:00     |
        +--------------+--------------------------------------+

    The state **upgraded-networking** will be entered when the networking
    upgrade has completed.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | upgraded-networking                  |
        | created_at   | 2023-08-24T02:33:47.049826+00:00     |
        | updated_at   | 2023-08-24T02:42:40.543522+00:00     |
        +--------------+--------------------------------------+

#.  |optional| Cordon

    The :command:`kube-host-cordon` command will evict the regular pods from
    the host. This command will prevent the application from running on
    intermediate versions.

    .. note::

        This command will permanently evict the pods which are not in namespaces.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-cordon controller-0
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | cordon-started                       |
        | created_at   | 2023-08-24T02:45:32.257231+00:00     |
        | updated_at   | 2023-08-24T02:45:32.257231+00:00     |
        +--------------+--------------------------------------+

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | cordon-complete                      |
        | created_at   | 2023-08-24T02:45:32.257231+00:00     |
        | updated_at   | 2023-08-24T11:47:56.178266+00:00     |
        +--------------+--------------------------------------+

    The state **cordon-complete** will be entered when the host cordon has
    completed.

#.  Upgrade the control plane on controller-0.

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
        | target_version        | v1.24.4                 |
        +-----------------------+-------------------------+

    Check if the control plane version upgrade status is changed to *None*.
    This verifies that the control plane has been successfully upgraded to the next
    version.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade-list
        +----+---------------+------------+----------------+-----------------------+-----------------+--------------+
        | id | hostname      | personality| target_version | control_plane_version | kubelet_version | status       |                             
        +----+---------------+------------+----------------+-----------------------+-----------------+--------------+
        | 1  | controller-0  | controller | v1.22.5        | v1.22.5               | v1.21.8         | None         |
        +----+---------------+---+--------+----------------+-----------------------+-----------------+--------------+

#.  Upgrade kubelet on controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade controller-0 kubelet
        +-----------------------+-------------------------+
        | Property              | Value                   |
        +-----------------------+-------------------------+
        | control_plane_version | v1.22.5                 |
        | hostname              | controller-0            |
        | id                    | 1                       |
        | kubelet_version       | v1.21.8                 |
        | personality           | controller              |
        | status                | upgrading-kubelet       |
        | target_version        | v1.22.5                 |
        +-----------------------+-------------------------+

    Check the status of the kubelet upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade-list
        +----+---------------+------------+----------------+-----------------------+-----------------+------------------+
        | id | hostname      | personality| target_version | control_plane_version | kubelet_version | status           |                              
        +----+---------------+------------+----------------+-----------------------+-----------------+------------------+
        | 1  | controller-0  | controller | v1.22.5        | v1.22.5               | v1.22.5         | upgraded-kubelet |
        +----+---------------+---+--------+----------------+-----------------------+-----------------+------------------+

    The status **upgraded-kubelet** will be entered when the kubelet upgrade
    has completed.

    Repeat steps 9 and 10 to reach the target Kubernetes version. For example, in
    this case, we need to repeat steps 9 and 10 twice for the remaining
    versions v1.23.1 and v1.24.4.

#. |optional| Uncordon

   Skip this step if you did not perform step 8.

   The :command:`kube-host-uncordon` command will allow the regular pods on the
   host again.

   .. code-block:: none

       ~(keystone_admin)]$ system kube-host-uncordon controller-0
       +--------------+--------------------------------------+
       | Property     | Value                                |
       +--------------+--------------------------------------+
       | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
       | from_version | v1.21.8                              |
       | to_version   | v1.24.4                              |
       | state        | uncordon-started                     |
       | created_at   | 2023-08-24T11:56:56.178266+00:00     |
       | updated_at   | 2023-08-24T11:56:56.178266+00:00     |
       +--------------+--------------------------------------+

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | uncordon-complete                    |
        | created_at   | 2023-08-24T11:56:56.178266+00:00     |
        | updated_at   | 2023-08-24T11:58:35.136866+00:00     |
        +--------------+--------------------------------------+

    The state **uncordon-complete** will be entered when the host uncordon has
    completed.

#.  Complete the Kubernetes upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-complete
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | upgrade-complete                     |
        | created_at   | 2023-08-24T02:33:47.049826+00:00     |
        | updated_at   | 2023-08-24T02:55:18.122620+00:00     |
        +--------------+--------------------------------------+

#.  Remove the alarm 900.007 (Kubernetes upgrade in progress) if it is still
    running after the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-delete

------------------------
Kubernetes Upgrade Abort
------------------------

If you want to abort the Kubernetes upgrade after the upgrade has started, run
the following command:

.. code-block:: none

    ~(keystone_admin)]$ system kube-upgrade-abort
    +--------------+--------------------------------------+
    | Property     | Value                                |
    +--------------+--------------------------------------+
    | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
    | from_version | v1.21.8                              |
    | to_version   | v1.22.4                              |
    | state        | upgrade-aborting                     |
    | created_at   | 2023-06-26T18:44:46.854319+00:00     |
    | updated_at   | 2023-08-24T02:55:18.122620+00:00     |
    +--------------+--------------------------------------+

To check the status of the abort operation, run the following command:

.. code-block:: none

    ~(keystone_admin)]$ system kube-upgrade-show
    +--------------+--------------------------------------+
    | Property     | Value                                |
    +--------------+--------------------------------------+
    | uuid         | 065e683a-13a3-4229-b3c7-701f90216a3d |
    | from_version | v1.21.8                              |
    | to_version   | v1.24.4                              |
    | state        | upgrade-aborted                      |
    | created_at   | 2023-08-24T07:10:02.578787+00:00     |
    | updated_at   | 2023-08-24T07:24:00.429794+00:00     |
    +--------------+--------------------------------------+

.. note::

    - The upgrade abort operation reverts all the Kubernetes version upgrades and
      shows the same state the Kubernetes was in before the upgrade started.
    
    - Once the Kubernetes upgrade is completed, it cannot be aborted.
