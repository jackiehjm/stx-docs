==========================
Upgrade Kubernetes version
==========================

This section describes how to upgrade the components on a system running
StarlingX from one supported version of Kubernetes (K8s) to another supported
version.

.. contents::
   :local:
   :depth: 1


--------
Overview
--------

StarlingX only supports specific Kubernetes versions and upgrade paths. Each
supported Kubernetes version is tracked via metadata in the Sysinv component.
The patching mechanism is used to deliver metadata and software in platform
patches to enable upgrades for specific Kubernetes versions. Typically, three
structured patches must be uploaded, applied, and installed before starting
the upgrades:

*   Patch1

    *   platform patch for sysinv and playbookconfig components
    *   contains metadata for new Kubernetes version
    *   contains the templates of K8s networking pods for the new Kubernetes
        version

*   Patch2

    *   Kubernetes patch that patches kubeadm RPM to the new Kubernetes version

*   Patch3

    *   Kubernetes patch that patches kubelet and kubectl RPMs to the new
        Kubernetes version

For details on how to build the patches, refer to :ref:`Build_patches_manually`.

Here is a high-level summary of the Kubernetes upgrade process:

*   Download images for the new Kubernetes version.
*   Trigger the control plane upgrades on either of the controllers to upgrade
    kube-apiserver, kube-controller-manager, and kube-scheduler pods. Before
    upgrading the second control plane on the other controller, the Kubernetes
    networking upgrades for networking pods must be completed first.
*   Upgrade kubelet on controller nodes first, then on worker nodes. Before you
    upgrade each kubelet, you must lock the host, except for all-in-one simplex
    systems. Host-unlock is required after the kubelet is upgraded on the host.
    The kubelet can be upgraded in parallel on worker hosts as long as there is
    sufficient capacity remaining on other worker hosts. No upgrade actions are
    needed for storage hosts because they are not in the Kubernetes cluster.
*   The final step is to complete the upgrade.

If any of the upgrade steps fail, you can repeat the step to continue upgrading.

-------------
Prerequisites
-------------

*   The system must be free of alarms.
*   All hosts must be unlocked, enabled and available.
*   Kubernetes pods must be all ready.
*   The installed applications must be compatible with the new Kubernetes
    version.
*   All patches required for the new Kubernetes version must be transferred to
    the active controller.

**************
Patch commands
**************

The following list contains the supported patch commands:

::

    $ sudo sw-patch upload <platform-patch.1>.patch
    $ sudo sw-patch query
    $ sudo sw-patch apply K8S_UPG_1_18_PLATFORM_PATCH

    $ sudo sw-patch host-install controller-0
    $ sudo sw-patch host-install controller-1   # if present

    $ sudo sw-patch host-install storage-0      # if present
                                                # ... for all storage nodes

    $ sudo sw-patch host-install worker-0       # if present
                                                # ... for all worker nodes


--------------------------
Upgrade Kubernetes cluster
--------------------------

#.  Upload, apply, and install the platform patch. Use the ``sw-patch`` commands
    (for example, upload, apply, host-install) to install the patch. This is an
    in-service patch, it is NOT required to lock the host to install this patch.

#.  List available Kubernetes versions:

    ::

        $ system kube-version-list
        +---------+--------+-----------+
        | Version | Target | State     |
        +---------+--------+-----------+
        | v1.16.1 | True   | active    |
        | v1.16.2 | False  | available |
        +---------+--------+-----------+


    .. note::

        This list comes from metadata in the sysinv component.
        The fields include:

        *   Target: denotes currently selected for installation.
        *   State:

            *   active: version is running everywhere
            *   partial: version is running somewhere
            *   available: version that can be upgraded to

#.  Upload, apply, and install the kubeadm patch. Use the ``sw-patch`` commands
    (for example, upload, apply, host-install) to install the patch. This is an
    in-service patch, it is NOT required to lock the host to install this patch.

#.  Upload the kubelet patch. Use the ``sudo sw-patch upload <kubelet-patch>``
    command. **Do not** apply the kubelet patch because it cannot be applied
    before you start upgrading kubelet.

#.  Start the Kubernetes upgrade with the command:

    ::

        $ system kube-upgrade-start v1.16.2
        +-------------------+-------------------+
        | Property          | Value             |
        +-------------------+-------------------+
        | from_version      | v1.16.1           |
        | to_version        | v1.16.2           |
        | state             | upgrade-started   |
        +-------------------+-------------------+

    The upgrade process checks the applied/available patches, the upgrade path,
    the health of the system, the installed applications compatibility, and
    validates the system is ready for an upgrade.

    .. note::

            Use the command ``system kube-upgrade-start --force`` to force the
            upgrade process to start and to ignore management affecting alarms.
            This should ONLY be done if you feel these alarms will not be an
            issue during the upgrade process.


    The states of the Kubernetes upgrade process include the following:

    *   upgrade-started: semantic checks passed, upgrade started
    *   downloading-images: images downloading in progress
    *   downloaded-images: images downloading complete
    *   downloading-images-failed: images downloading fail
    *   upgrading-first-master: first master node control plane upgrade in
        progress
    *   upgraded-first-master: first master node control plane upgrade complete
    *   upgrading-first-master-failed: first master node control plane upgrade
        fail
    *   upgrading-networking: networking plugin upgrade in progress
    *   upgraded-networking: networking plugin upgrade complete
    *   upgrading-networking-failed: networking plugin upgrade fail
    *   upgrading-second-master: second master node control plane upgrade in
        progress
    *   upgraded-second-master: second master node control plane upgrade
        complete
    *   upgrading-second-master-failed: second master node control plane upgrade
        fail
    *   upgrading-kubelets: kubelet upgrades in progress
    *   upgrade-complete: all nodes upgraded

#.  Download Kubernetes images:

    ::

        $ system kube-upgrade-download-images
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

    The “downloaded-images” state is entered when the Kubernetes images
    download is complete.

    To verify the action is completed, use ``system kube-upgrade-show`` to check
    the upgrade state.

    ::

        $ system kube-upgrade-show
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


#.  Upgrade the control plane on the first controller:

    ::

        $ system kube-host-upgrade controller-1 control-plane
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

    Either controller can be upgraded first.

    The ``upgraded-first-master`` state is entered when the first control plane
    upgrade is done.

#.  Upgrade Kubernetes networking:

    ::

        $ system kube-upgrade-networking
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

    The networking upgrade must be done **after** you upgrade the first control
    plane and **before** you upgrade the second control plane.

    The ``upgraded-networking`` state is entered when the networking upgrade is
    done.

#.  Upgrade the control plane on the second controller:

    ::

        $ system kube-host-upgrade controller-0 control-plane
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

    The ``upgraded-second-master`` state is entered when the second control
    plane upgrade is done.

#.  Show the Kubernetes upgrade status for the hosts:

    ::

        $ system kube-host-upgrade-list
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | id | hostname     | personality | target_version | control_plane_version | kubelet_version | status |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+
        | 1  | controller-0 | controller  | v1.16.2        | v1.16.2               | v1.16.1         | None   |
        | 2  | controller-1 | controller  | v1.16.2        | v1.16.2               | v1.16.1         | None   |
        | 3  | storage-0    | storage     | v1.16.1        | N/A                   | N/A             | None   |
        | 4  | storage-1    | storage     | v1.16.1        | N/A                   | N/A             | None   |
        | 5  | worker-0     | worker      | v1.16.1        | N/A                   | v1.16.1         | None   |
        | 6  | worker-1     | worker      | v1.16.1        | N/A                   | v1.16.1         | None   |
        +----+--------------+-------------+----------------+-----------------------+-----------------+--------+

    The control planes of both controllers are upgraded to v1.16.2 now.

#.  Apply and install the kubelet/kubectl patch.

    Use the sw-patch commands (apply, host-install) to install the patch. This
    places the new version of the kubelet binary on each host, but will not
    restart kubelet.

    .. note::

        If a node restarts unexpectedly, the kubelet on the node that
        restarts will come up running the new K8s version, however, it will
        read the old format of the kubelet config file. This should be
        supported, because new values in the config file will be defaulted. You
        can still run the kube-host-upgrade command after this to upgrade
        the kubelet config file.

#.  Upgrade kubelet on each controller:

    ::

        $ system host-lock controller-1
        $ system kube-host-upgrade controller-1 kubelet
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
        $ system host-unlock controller-1

    Either controller can be done first.

    Upgrading kubelet requires host-lock/unlock.

    .. note::

            For All-in-one Simplex (AIO-SX) setups only, host lock/unlock is not
            required and **must not** be done.

    The kubelets on all controller hosts must be upgraded before upgrading
    kubelets on worker hosts.

#.  Show the Kubernetes upgrade status:

    ::

        $ system kube-upgrade-show
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

#.  Upgrade kubelet on all worker hosts:

    ::

        $ system host-lock worker-1
        $ system kube-host-upgrade worker-1 kubelet
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
        $ system host-unlock worker-1

    Multiple worker hosts can be upgraded at the same time, as long as there is
    sufficient capacity remaining on other worker hosts.

#.  Complete the K8s upgrade:

    This command does a final check to verify that all the K8s components are
    now running the new release and then updates the state to upgrade-complete.

    ::

        $ system kube-upgrade-complete
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


--------------------------------
Build Kubernetes upgrade patches
--------------------------------

To build Kubernetes upgrade patches, you can use the patch building script
(``$MY_REPO/stx/update/cgcs-patch/bin/patch_build.sh``) and the following
command:

::

    $MY_REPO/stx/update/patch-scripts/kube-upgrade/make_kube_patch.sh

To build the upgrade patches manually, follow the steps in the next section.

.. _Build_patches_manually:

**********************
Build patches manually
**********************

This section describes how to build a set of patches for a new version of
Kubernetes.

**Retrieve tarball for new Kubernetes version**

You must have the tarball for the new K8s version in the downloads
directory for your workspace. For example: ``$MY_REPO/stx/downloads``

#.  Download the tarball for the new Kubernetes version from: https://github.com/kubernetes/kubernetes/releases

#.  Copy the tarball to your workspace and rename it. In this example, the new
    version is v1.16.3.

    ::

        mv <source file> $MY_REPO/stx/downloads/kubernetes-v1.16.3.tar.gz

**Create patch for project: config (``$MY_REPO/stx/config``)**

#.  Update the file: ``sysinv/sysinv/sysinv/sysinv/common/kubernetes.py`` and
    change the ``get_kube_versions()`` function to specify both the old and new
    version and the patches that will be used for the upgrade. If the previous
    version was v1.16.2 and the new version is v1.16.3, it would look like this:

    ::

      def get_kube_versions():
         return [
             {'version': 'v1.16.2',
              'upgrade_from': [],
              'downgrade_to': [],
              'applied_patches': [],
              'available_patches': [],
             },
             {'version': 'v1.16.3',
              'upgrade_from': ['v1.16.2'],
              'downgrade_to': [],
              'applied_patches': ['KUBE.1'],
              'available_patches': ['KUBE.2'],
             },
         ]

#.  Update the ``sysinv/sysinv/centos/build_srpm.data`` file and increment the
    ``TIS_PATCH_VER`` value.

**Create patch for project: ansible-playbooks (``$MY_REPO/stx/ansible-playbooks``)**

#.  Create the necessary repositories for the new Kubernetes version.
    Create system images dir and k8s networking pods’ templates dir for the new
    K8s version by copying over from the old one. Make any necessary updates in
    the new version if networking pods require upgrades.

    If the previous version was v1.16.2 and the new version is v1.16.3, it would
    look like this:

    ::

        cp -R playbookconfig/src/playbooks/roles/common/push-docker-images/vars/k8s-v1.16.2 playbookconfig/src/playbooks/roles/common/push-docker-images/vars/k8s-v1.16.3
        cp -R playbookconfig/src/playbooks/roles/bootstrap/bringup-essential-services/templates/k8s-v1.16.2 playbookconfig/src/playbooks/roles/bootstrap/bringup-essential-services/templates/k8s-v1.16.3

#.  Update the ``playbookconfig/centos/build_srpm.data`` file and increment the
    ``TIS_PATCH_VER`` value.

**Create patch for project: integ (``$MY_REPO/stx/integ``)**

#.  Update the ``kubernetes/kubernetes/centos/build_srpm.data`` file. Change
    ``VERSION`` to the new version and increment the ``TIS_PATCH_VER`` value.

#.  Update the ``kubernetes/kubernetes/centos/kubernetes.spec`` file. Change
    ``%global commit`` to the new version and change ``%global kube_version`` to
    the new version.

**Build the patches**

#.  First build the updated RPMs:

    ::

        # Build packages
        cd $MY_WORKSPACE
        build-pkgs --no-build-info --no-descendants sysinv
        build-pkgs --no-build-info --no-descendants playbookconfig
        build-pkgs --no-build-info --no-descendants kubernetes

    Several scripts can be found in
    ``$MY_REPO/stx/update/patch-scripts/kube-upgrade/`` to build patches.

    ::

        ls $MY_REPO/stx/update/patch-scripts/kube-upgrade/KUBE.1.preapply
        KUBE.1.preremove  KUBE.2.preapply  KUBE.2.preremove  make_kube_patch.sh

#.  Make any necessary edits.

    #.  If you want Patch2 and Patch3 names to be different from KUBE.1 and
        KUBE.2, make sure you have “pre” scripts updated with the names as well
        as the names in ``make_kube_patch.sh``.
    #.  Update RPMs to the new increased versions in the ``make_kube_patch.sh``
        file.

#.  Run ``$MY_REPO/stx/update/patch-scripts/kube-upgrade/make_kube_patch.sh`` to
    generate patches.
