
.. bfd1591638638205
.. _manual-kubernetes-components-upgrade:

=================================
Manual Kubernetes Version Upgrade
=================================

You can upgrade the Kubernetes version on a running system from one
supported version to another.

.. rubric:: |context|

To complete this task, you will apply the following three updates \(patches\)
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


.. rubric:: |proc|

#.  Upload, apply and install the platform update.

    Use the standard :command:`sw-patch`, :command:`upload`, :command:`apply`
    and :command:`install` commands to perform these operations.

#.  List the available Kubernetes versions.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-version-list
        +---------+--------+-----------+
        | Version | Target | State     |
        +---------+--------+-----------+
        | v1.16.1 | True   | active    |
        | v1.16.2 | False  | available |
        +---------+--------+-----------+

    The following meanings apply to the output shown:

    **Target**
        A value of True means that the target is currently selected for
        installation.

    **State**
        Can be one of:

        **active**
            The version is running everywhere.

        **partial**
            The version is running somewhere.

        **available**
            The version can be upgraded to.

#.  Upload, apply and install the kubeadm update.

    Use the standard :command:`sw-patch`, :command:`upload`, :command:`apply`
    and :command:`install` commands to perform these operations.

#.  Upload the kubelet update.

    .. note::
        Run the :command:`upload` command only:

        .. code-block:: none

            ~(keystone_admin)]$ sw-patch upload <kubelet-patch>


        The kubelet update cannot be applied before upgrading kubelet.

#.  Start the Kubernetes upgrade.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-start v1.16.2
        +-------------------+-------------------+
        | Property          | Value             |
        +-------------------+-------------------+
        | from_version      | v1.16.1           |
        | to_version        | v1.16.2           |
        | state             | upgrade-started   |
        +-------------------+-------------------+

    The upgrade process checks the applied/available updates, the upgrade path,
    the health of the system, the installed applications compatibility and
    validates the system is ready for an upgrade.

    .. warning::
        If you use the command :command:`system kube-upgrade-start --force` to
        cause the upgrades process to ignore management affecting alarms and
        start, first determine that these alarms will not compromise the
        upgrade process.

#.  Download the Kubernetes images.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-download-images
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | b5f7dada-2537-4416-9d2c-f9ca9fcd0e22 |
        | from_version | v1.16.1                              |
        | to_version   | v1.16.2                              |
        | state        | downloading-images                   |
        | created_at   | 2020-02-20T16:08:48.854869+00:00     |
        | updated_at   | None                                 |
        +--------------+--------------------------------------+

#.  Confirm that the download has completed.

    .. code-block:: none

        ~(keystone_admin)]$ system-kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | b5f7dada-2537-4416-9d2c-f9ca9fcd0e22 |
        | from_version | v1.16.1                              |
        | to_version   | v1.16.2                              |
        | state        | downloaded-images                    |
        | created_at   | 2020-02-20T16:08:48.854869+00:00     |
        | updated_at   | 2020-02-20T16:10:37.858661+00:00     |
        +--------------+--------------------------------------+


#.  Upgrade the control plane on the first controller.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade controller-1 control-plane
        +-----------------------+-------------------------+
        | Property              | Value                   |
        +-----------------------+-------------------------+
        | control_plane_version | v1.16.1                 |
        | hostname              | controller-1            |
        | id                    | 2                       |
        | kubelet_version       | v1.16.1                 |
        | personality           | controller              |
        | status                | upgrading-control-plane |
        | target_version        | v1.16.2                 |
        +-----------------------+-------------------------+


    You can upgrade either controller first.

    The state **upgraded-first-master** will be entered when the first control
    plane upgrade has completed.

#.  Upgrade Kubernetes networking.

    This step must be completed after the first control plane has been upgraded
    and before upgrading the second control plane.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-upgrade-networking
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | b5f7dada-2537-4416-9d2c-f9ca9fcd0e22 |
        | from_version | v1.16.1                              |
        | to_version   | v1.16.2                              |
        | state        | upgrading-networking                 |
        | created_at   | 2020-02-20T16:08:48.854869+00:00     |
        | updated_at   | 2020-02-20T16:18:11.459736+00:00     |
        +--------------+--------------------------------------+

    The state **upgraded-networking** will be entered when the networking
    upgrade has completed.

#.  Upgrade the control plane on the second controller.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade controller-0 control-plane
        +-----------------------+-------------------------+
        | Property              | Value                   |
        +-----------------------+-------------------------+
        | control_plane_version | v1.16.1                 |
        | hostname              | controller-0            |
        | id                    | 1                       |
        | kubelet_version       | v1.16.1                 |
        | personality           | controller              |
        | status                | upgrading-control-plane |
        | target_version        | v1.16.2                 |
        +-----------------------+-------------------------+

    The state **upgraded-second-master** will be entered when the upgrade has
    completed.

#.  Show the Kubernetes upgrade status for all hosts.

    .. code-block:: none

        ~(keystone_admin)]$ system kube-host-upgrade-list
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | id | hostname     | personality | target_version | control_plane_version | kubelet_version | status |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | 1  | controller-0 | controller  | v1.16.2        | v1.16.2               | v1.16.1         | None   |
        | 2  | controller-1 | controller  | v1.16.2        | v1.16.2               | v1.16.1         | None   |
        | 3  | storage-0    | storage     | v1.16.1        | N/A                   | N/A             | None   |
        | 4  | storage-1    | storage     | v1.16.1        | N/A                   | N/A             | None   |
        | 5  | worker-0     | worker      | v1.16.1        | N/A                   | v1.16.1         | None   |
        | 6  | worker- 1    | worker      | v1.16.1        | N/A                   | v1.16.1         | None   |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+

    The control planes of both controllers are now upgraded to v1.16.2.

#.  Apply and install the kubectl update.

    Use the standard :command:`sw-patch`, :command:`apply` and
    :command:`install` commands to perform these operations.

    This places the new version of kubelet binary on each host, but will not
    restart kubelet.

#.  Upgrade kubelet on both controllers.

    Either controller can be upgraded first.

    The kubelets on all controller hosts must be upgraded before upgrading
    kubelets on worker hosts.

    For each controller, do the following.


    #.  For non |AIO-SX| systems, lock the controller.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-1

        .. note::
            For All-In-One Simplex systems, the controller must **not** be
            locked.

    #.  Apply the upgrade.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ system kube-host-upgrade controller-1 kubelet
            +-----------------------+-------------------+
            | Property              | Value             |
            +-----------------------+-------------------+
            | control_plane_version | v1.16.2           |
            | hostname              | controller-1      |
            | id                    | 2                 |
            | kubelet_version       | v1.16.1           |
            | personality           | controller        |
            | status                | upgrading-kubelet |
            | target_version        | v1.16.2           |
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
        | uuid         | b5f7dada-2537-4416-9d2c-f9ca9fcd0e22 |
        | from_version | v1.16.1                              |
        | to_version   | v1.16.2                              |
        | state        | upgrading-kubelets                   |
        | created_at   | 2020-02-20T16:08:48.854869+00:00     |
        | updated_at   | 2020-02-20T21:53:16.347406+00:00     |
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
            | control_plane_version | v1.16.2           |
            | hostname              | worker-1          |
            | id                    | 3                 |
            | kubelet_version       | v1.16.1           |
            | personality           | worker            |
            | status                | upgrading-kubelet |
            | target_version        | v1.16.2           |
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
        | uuid         | 4e942297-465e-47d4-9e1b-9fb1630be33c |
        | from_version | v1.16.1                              |
        | to_version   | v1.16.2                              |
        | state        | upgrade-complete                     |
        | created_at   | 2020-02-19T20:59:51.079966+00:00     |
        | updated_at   | 2020-02-24T15:03:34.572199+00:00     |
        +--------------+--------------------------------------+

.. from step 1
.. For more
    information, see the :ref:`Managing Software Updates
    <managing-software-updates>`.
