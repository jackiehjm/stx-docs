.. _r8-0-release-notes-6a6ef57f4d99:

.. This release note was created to address review https://review.opendev.org/c/starlingx/docs/+/862596
.. The Release Notes will be updated and a separate gerrit review will be sent out
.. Ignore the contents in this RN except for the updates stated in the comment above

==================
R8.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO (Debian) for StarlingX Release 8.0 are located at the
``StarlingX mirror`` repo:

https://mirror.starlingx.windriver.com/mirror/starlingx/release/8.0.0/debian/monolithic/outputs/iso/

-------------------------------------
Source Code for StarlingX Release 8.0
-------------------------------------

The source code for StarlingX Release 8.0 is available on the r/stx.8.0
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

To deploy StarlingX Release 8.0, see `Consuming StarlingX <https://docs.starlingx.io/introduction/consuming.html>`_.

For detailed installation instructions, see `StarlingX 8.0 Installation Guides <https://docs.starlingx.io/deploy_install_guides/index-install-e083ca818006.html>`_.

-----------------------------
New Features and Enhancements
-----------------------------

.. start-new-features-r8

The sections below provides a detailed list of new features and links to the
associated user guides (if applicable).

.. https://storyboard.openstack.org/#!/story/2010452

*********
Debian OS
*********

StarlingX Release 8.0 (and onwards) will only support a Debian-based Solution;
full StarlingX functionality is supported. StarlingX R8 release runs Debian
Bullseye (11.3) with the 5.10 kernel version from the Yocto project.

Debian is a well-established Linux Distribution supported by a large and mature
open-source community and used by hundreds of commercial organizations,
including Google. |deb-prev-prods| has full functional equivalence to the
earlier CentOS-based versions of |deb-prev-prods|. From |prod-long| Release 8.0
Debian OS is the only supported OS in |prod-long|.

Major features of Debian-based |prod| 8.0 include:

*  Linux 5.10 Yocto-based kernel ( https://www.yoctoproject.org/ )

   The Yocto Project Kernel:

   * tracks stable kernel updates very closely; staying very current with the
     stable kernel,

   * provides a reliable implementation of the preempt-rt patchset (see:
     https://archive.kernel.org/oldwiki/rt.wiki.kernel.org/), and

   * provides predictable and searchable |CVE| handling.

|org| leverages its existing relationships with the Yocto Project to
enhance development, bug fixes and other activities in the Yocto Project kernel
to drive |prod| quality and feature content.

*   Debian Bullseye (11.3)

    Debian is a well-established Linux Distribution supported by a large and
    mature open-source community.

*   OSTree ( https://ostree.readthedocs.io/en/stable/manual/introduction/ )

    OSTree provides for robust and efficient versioning, packaging and
    upgrading of Linux-based systems.

*   An updated Installer to seamlessly adapt to Debian and OSTree

*   Updated software patching and upgrades for Debian and OSTree.

*****************************
Operational Impacts of Debian
*****************************

The operational impacts of Debian-based |prod| are:

*  Functional equivalence with CentOS-based |prod|

*  Use of the |prod| CLIs and APIs will remain the same:

   *  |prod| on Debian will provide the same CLIs and APIs as |prod| on CentOS.

   *  |prod| on Debian will run on a 5.10 based kernel.

   *  |prod| on Debian will support the same set of Kubernetes APIs used in
      |prod| on CentOS.

   *  The procedure to install hosts will be unchanged by the migration from
      CentOS to Debian. Only the ``grub`` menu has been modified.

   *  The CLIs used for software updates (patching) will be unchanged by
      the migration from CentOS to Debian.

*  User applications running in containers on CentOS should run on Debian
   without modification. Re-validation of containers on Debian is encouraged to
   identify any exceptions.

*  A small subset of operating system-specific commands will differ. Some of
   these changes result from the switch in distributions while others are
   generic changes that have accumulated since the release of the CentOS
   distribution currently used. For example:

   *  The Debian installation requires new pxeboot grub menus. See
      :ref:`PXE Boot Controller-0 <deb-grub-deltas>`.

   *  Some prompt strings will be slightly different (for example: ssh login,
      passwd command, and others).

   *  Many 3rd-party software packages are running a newer version in Debian
      and this may lead to minor changes in syntax, output, config files, and
      logs.

   *  The URL to expose keystone service does not have the version appended.

   *  On Debian, interface and static routes need to be handled using system-API
      (host-route-\*, host-if-\* and host-addr-\*).

      *  Do not edit configuration files in ``/etc/network/`` as they are
         regenerated from sysinv database after a system reboot. Any changes
         directly done there will be lost.

      *  The static routes configuration file is ``/etc/network/routes``

      *  Interface configuration files are located in
         ``/etc/network/interfaces.d/``

   *   Debian stores network information in ``/etc/network`` instead of
       ``/etc/sysconfig/network-scripts`` location used in CentOS. However, the
       |prod| ``system`` commands are unchanged. |deb-update-iso|

   *   Patching on Debian is done using ostree commits rather than individual
       RPMs.

       You can see which packages are updated by ostree using the :command:`dpkg
       -l` instead of :command:`rpm -qa` used on CentOS.

   *   The patching CLI commands and Horizon interactions are the same as for
       CentOS.

       *   The supported patching CLI commands for |deb-release-ver| are:

           * ``sw-patch upload``
           * ``sw-patch upload-dir``
           * ``sw-patch apply``
           * ``sw-patch remove``
           * ``sw-patch delete``

********************************************************
Change in Login for Systems installed from Prestaged ISO
********************************************************

In |prod-long| Systems installed using prestaging ISO has a
sysadmin account, and the default initial password is ``sysadmin``
(default login / password combination is ``sysadmin/sysadmin``). The initial
password must be changed immediately after logging in to the host for the
first time. Follow the steps below:

1. login: sysadmin

2. password: sysadmin

3. Current password: sysadmin

4. New Password:

5. Re-enter New Password:

****************
CVSS v3 Adoption
****************

|prod-long| is now using CVSS v3 instead of CVSS v2 as a fix criteria to evaluate
CVEs that need to be fixed.

On a monthly basis, the |prod| is scanned for |CVE|'s and the reports that are
generated are reviewed by the Security team.

**See**: :ref:`cve-maintenance-723cd9dd54b3` for details.


********************************************************************
Single Physical Core for Platform Function in All-In-One Deployments
********************************************************************

The platform core usage is optimized to operate on a single physical core (with
two logical cores with Hyper-Threading enabled) for |AIO| deployments.

.. note::

   The use of single physical core for platform function is only suitable for
   Intel® 4th Generation Xeon® Scalable Processors or above and should not be
   configured for previous Intel® Xeon® CPU families. For All-In-One systems
   with older generation processors, two physical cores (or more) must be
   configured.

**See**:

-  :ref:`single-physical-core-for-platform-function-in-all-in-one-deployments-bec61d5a13f4`


**************************************************
AIO memory reserved for the platform has increased
**************************************************

The amount of memory reserved for the platform for |prod| Release 8.0 on
an |AIO| controller has increased to 11 GB for hosts with 2 numa nodes.

*************************************************
Resizing platform-backup partition during install
*************************************************

During Installation: If a platform-backup partition exists, it will no
longer be wiped in normal installation operations. The platform-backup
partition can be resized during the install; although it can only be increased
in size, not reduced in size.

.. caution::

    Attempts to install using a smaller partition size than the existing
    partition will result in installation failures.

During Installation and Provisioning of a Subcloud: For subcloud install operations,
the ``persistent-size`` install value in the subcloud ``install-values.yaml`` file
used during subcloud installation, controls platform-backup partition sizing.
Since the platform-backup partition is non-destructive, this value can only be
increased from previous installs. In this case, the partition size is extended
and the filesystem is resized.

.. caution::

   Any "persistent-size" values smaller than the existing partition
   will cause installation failures, with the partition remaining in place.

**Recommended**: For new installations where a complete reinstall is being
performed it may be preferable to wipe the disks before the fresh install.

****************************
Optimized Backup and Restore
****************************

.. note::

    The backup in earlier |prod-long| releases are not compatible with the
    Optimized Restore functionality introduced in |prod| Release 8.0.

Backup from one release to another release is not supported, except for an
|AIO-SX| upgrade.


Optimized Backup
****************

The extra var `backup_registry_filesystem` can now be used to backup users images
in the registry backup (mainly for backup for reinstall usage scenario).

Optimized Restore
*****************

The new optimized restore method will support restore with registry backup only.
It will obtain from the prestaged images the required platform images. If no
prestaged images are available, it would need to resort to pulling from the
registry.

**See**: :ref:`node-replacement-for-aiominussx-using-optimized-backup-and-restore-6603c650c80d` for details.

*****************************************************************
Enhancements for Generic Error Tolerance in Redfish Virtual Media
*****************************************************************

Redfish virtual media operations have been observed to fail with transient
errors. While the conditions for those failures are not always known
(network, BMC timeouts, etc), it has been observed that if the Subcloud
install operation is retried, the operation is successful.

To alleviate the transient conditions, the robustness of the Redfish media
operations are improved by introducing automatic retries.

***************************************
Centralized Subcloud Backup and Restore
***************************************

The |prod-long| Backup and Restore feature allows for essential system data
(and optionally some additional information, such as container registry images,
and OpenStack application data) to be backed up, so that it can be used to
restore the platform to a previously working state.

The user may backup system data, or restore previously backed up data into it,
by running a set of ansible playbooks. They may be run either locally within
the system, or from a remote location. The backups are saved as a set of
compressed files, which can then be used  to restore the system to the same
state as it was when backed up.

The subcloud's system backup data can either be stored locally on the subcloud
or on the System Controller. The subcloud's container image backup
(from registry.local) can only be stored locally on the subcloud to avoid
overloading the central storage and the network with large amount of data
transfer.

**See**:

-  :ref:`Backup and Restore <index-backup-kub-699e0d16c076>` for details.

********************************************************
Improved Subcloud Deployment / Upgrading Error Reporting
********************************************************

In |prod-long| Release 8.0 provides enhanced support for subcloud deployments
and upgrading error reporting.

Key error messages from subcloud deployment or upgrade failures can now be
accessed via RESTAPIs, the CLI or the GUI (Horizon).

Full logs for subcloud deployments and upgrades are still accessible by
using SSH to the System Controller; however, this should no longer be required
in most error scenarios.

**See**: :ref:`Distributed Cloud Guide <index-dist-cloud-kub-95bef233eef0>` for details.

*******************************
Kubernetes Pod Coredump Handler
*******************************

A new Kubernetes aware core dump handler has been added in |prod| Release 8.0.

Individual pods can control the core dump handling by specifying Kubernetes Pod
annotations that will instruct the core dump handler for specific applications.

**See**: :ref:`kubernetes-pod-coredump-handler-54d27a0fd2ec` for details.

************************************************************
Enhancements for Subcloud Rehoming without controller reboot
************************************************************

|prod-long| Release 8.0 supports rehoming a subcloud to a new system controller
without requiring a lock and unlock of the subcloud controller(s).

When the System Controller needs to be reinstalled, or when the subclouds from
multiple System Controllers are being consolidated into a single System
Controller, you can rehome an already deployed subcloud to a different System
Controller.

**See**: :ref:`rehoming-a-subcloud` for details.

********
KubeVirt
********

The KubeVirt system application in |prod-long| includes; KubeVirt, Containerized
Data Importer (CDI) and the ``Virtctl`` client tool.

KubeVirt is an open source project that allows |VMs| to be run
and managed as pods inside a Kubernetes cluster. This is a particularly
important innovation as traditional VM workloads can be moved into Kubernetes
alongside already containerized workloads, thereby taking advantage of
Kubernetes as an orchestration engine.

The |CDI| is an open source project that provides facilities for enabling |PVCs|
to be used as disks for KubeVirt |VMs| by way of DataVolumes.

The Virtctl client tool is an open source tool distributed with
KubeVirt and required to use advanced features such as serialand graphical
console access.  It also provides convenience commands for starting/stopping |VMs|,
live migrating |VMs|, cancelling live migrations and uploading |VM| disk images.

.. note::

    Limited testing of KubeVirt on |prod-long| has been performed, along with
    some simple examples on creating a Linux |VM| and a Windows |VM|. In future
    releases, high performance capabilities of KubeVirt will be validated on
    |prod-long|.

**See**:

-  :ref:`introduction-bb3a04279bf5`

-  :ref:`create-a-windows-vm-82957181df02`

-  :ref:`create-an-ubuntu-vm-fafb82ec424b`

-  `https://kubevirt.io/user-guide <https://kubevirt.io/user-guide>`_


*********************************************************************
Support for Intel Wireless FEC Accelerators using SR-IOV FEC operator
*********************************************************************

The |SRIOV| |FEC| Operator for Intel Wireless |FEC| Accelerators supports the
following |vRAN| |FEC| accelerators:

-   Intel® vRAN Dedicated Accelerator ACC100.

-   Intel® |FPGA| Programmable Acceleration Card N3000.

-   Intel® vRAN Dedicated Accelerator ACC200.

You can enable and configure detailed FEC parameters for an ACC100/ACC200 eASIC
card so that it can be used as a hardware accelerator by hosted |vRAN|
containerized workloads on |prod-long|.

**See**:

-  :ref:`enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads`

-  :ref:`configure-sriov-fec-operator-to-enable-hw-accelerators-for-hosted-vran-containarized-workloads`

*******************************
Multiple Driver Version Support
*******************************

|prod-long| supports multiple driver versions for the ice, i40e,
and iavf drivers.

**See**: :ref:`intel-multi-driver-version-5e23e989daf5` for details.


****************************************************************************************
Intel 4th Generation Intel(R) Xeon(R) Scalable Processor Kernel Feature Support (5G ISA)
****************************************************************************************

Introduction of the 5G ISA (Instruction Set Architecture) will facilitate an
acceleration for |vRAN| workloads to improve performance and capacity for |RAN|
solutions specifically compiled for the 4th Generation Intel(R) Xeon(R) Scalable
Processor target with the 5G instruction set (AVX512-FP16) enabled.

**************************
vRAN Intel Tools Container
**************************

|prod-long| Release 8.0 supports OpenSource |vRAN| tools that are being
delivered in the ``docker.io/starlingx/stx-debian-tools-dev:stx.8.0-v1.0.3``
container.

**See**: :ref:`vran-tools-2c3ee49f4b0b` for details.

***********************************
Quartzville iqvlinux driver support
***********************************

This OpenSource Quartzville driver is included in |prod-long| in support of a
user building a container with the Quartzville tools from Intel, using
``docker.io/starlingx/stx-debian-tools-dev:stx.8.0-v1.0.3`` as a base container,
as described in :ref:`vran-tools-2c3ee49f4b0b` .

**See**: :ref:`vran-tools-2c3ee49f4b0b` for details.

*********************************
Pod Security Admission Controller
*********************************

The |PSA| Controller is the |PSP| replacement which is supported in Kubernetes
v1.24 in StarlingX Release 8.0. It replaces the deprecated |PSP|; |PSP| will be
REMOVED in StarlingX Release 9.0 with Kubernetes v1.25.

The |PSA| controller acts on creation and modification of the pod and
determines if it should be admitted based on the requested security context and
the policies defined by Pod Security Standards. It provides a more usable
k8s-native solution to enforce Pod Security Standards.

.. note::

    StarlingX users should migrate their security policy configurations from |PSP|
    to |PSA| in StarlingX Release 8.0 .

**See**:

-  :ref:`pod-security-admission-controller-8e9e6994100f`

-  `https://kubernetes.io/docs/concepts/security/pod-security-admission/ <https://kubernetes.io/docs/concepts/security/pod-security-admission/>`__


****************************************************
SSH integration with remote Windows Active Directory
****************************************************

By default, |SSH| to |prod| hosts supports authentication using the 'sysadmin'
Local Linux Account and |prod| Local |LDAP| Linux User Accounts. |SSH| can
also be optionally configured to support authentication with one or more remote
|LDAP| identity providers (such as Windows Active Directory (WAD)). Internally,
|SSH| uses |SSSD| service to provide NSS and PAM interfaces and a backend
system able to remotely connect to multiple different |LDAP| domains.

|SSSD| provides a secure solution by using data encryption for |LDAP| user
authentication. |SSSD| supports authentication only over an encrypted channel.

**See**: :ref:`sssd-support-5fb6c4b0320b` for details.

**********************
Keystone Account Roles
**********************

``reader`` role support has been added for |prod| commands: system, fm,
swmanager and dcmanager.

Roles:

-  ``admin`` role in the admin projet can execute any action in the system

-  ``reader`` role in the admin project has access to only read-only type commands;
   i.e. list, query, show, summary type commands

-  ``member`` role is currently equivalent to reader role; this may change in the
   future.

**See**: :ref:`keystone-account-roles-64098d1abdc1` for details.


*******************
O-RAN O2 Compliance
*******************

In the context of hosting a |RAN| Application on |prod|, the |O-RAN| O2
Application provides and exposes the |IMS| and |DMS| service APIs of the O2
interface between the O-Cloud (|prod|) and the Service Management and
Orchestration (SMO), in the |O-RAN| Architecture.

The O2 interfaces enable the management of the O-Cloud (|prod|) infrastructure
and the deployment life-cycle management of |O-RAN| cloudified |NFs| that run on
O-Cloud (|prod|).  See `O-RAN O2 General Aspects and Principles 2.0
<https://orandownloadsweb.azurewebsites.net/specifications>`__, and `INF O2
documentation <https://docs.o-ran-sc.org/projects/o-ran-sc-pti-o2/en/latest/>`__.

The |O-RAN| O2 application is integrated into |prod| as a system application.
The |O-RAN| O2 application package is saved in |prod| during system
installation, but it is not applied by default.

.. note::

   |prod-long| Release 8.0 O2 IMS and O2 DMS with Kubernetes profiles are
   compliant with the October 2022 version of the O-RAN standards.

**See**: :ref:`oran-o2-application-b50a0c899e66` for details.

********************************************
O-RAN Spec Compliant Timing API Notification
********************************************

|prod-long| provides ``ptp-notification`` to support applications that rely on
|PTP| for time synchronization and require the ability to determine if the system
time is out of sync. ``ptp-notification`` provides the ability for user applications
to query the sync state of hosts as well as subscribe to push notifications for
changes in the sync status.

PTP-notification consists of two main components:

-  The ``ptp-notification`` system application can be installed on nodes
   using |PTP| clock synchronization. This monitors the various time services
   and provides the v1 and v2 REST API for clients to query and subscribe to.

-  The ``ptp-notification`` sidecar. This is a container image which can be
   configured as a sidecar and deployed alongside user applications that wish
   to use the ``ptp-notification`` API. User applications only need to be
   aware of the sidecar, making queries and subscriptions via its API.
   The sidecar handles locating the appropriate ``ptp-notification`` endpoints,
   executing the query and returning the results to the user application.

**See**: :ref:`ptp-notifications-overview` for details.

.. end-new-features-r8

----------------
Hardware Updates
----------------

The following hardware is now supported in |prod-long| 8.0:

4th Generation Intel® Xeon® Scalable Processor with and without built-in
accelerator.

**See**:

-  :ref:`Kubernetes Verified Commercial Hardware <verified-commercial-hardware>`

----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for a number of defects. Refer to the StarlingX bug
database to review the R8.0 `Fixed Bugs <https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&field.status%3Alist=FIXRELEASED&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=stx.8.0&field.tags_combinator=ANY&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search>`_.

.. All please confirm if any Limitations need to be removed / added for Stx 8.0

---------------------------------
Known Limitations and Workarounds
---------------------------------

The following are known limitations you may encounter with your |prod| Release
8.0 and earlier releases. Workarounds are suggested where applicable.

.. note::

    These limitations are considered temporary and will likely be resolved in
    a future release.

*****************************************
Subcloud Upgrade with Kubernetes Versions
*****************************************

Subcloud Kubernetes versions are upgraded along with the System Controller.
You can add a new subcloud while the System Controller is on intermediate
versions of Kubernetes as long as the needed k8s images are available at the
configured sources.

**Workaround**: In a Distributed Cloud configuration, when upgrading from
|prod-long| Release 7.0 the Kubernetes version is v1.23.1. The default
version of the new install for Kubernetes is v1.24.4. Kubernetes must be
upgraded one version at a time on the System Controller.

.. note::
    New subclouds should not be added until the System Controller has been
    upgraded to Kubernetes v1.24.4.

****************************************************
AIO-SX Restore Fails during puppet-manifest-apply.sh
****************************************************

Restore fails using a backup file created after a fresh install.

**Workaround**: During the restore process, after reinstalling the controllers,
the |OAM| interface must be configured with the same IP address protocol version
used during installation.


**************************************************************************
Subcloud Controller-0 is in a degraded state after upgrade and host unlock
**************************************************************************

During an upgrade orchestration of the subcloud from |prod-long| Release 7.0
to |prod-long| Release 8.0, and after host unlock, the subcloud is in a
``degraded`` state, and alarm 200.004 is raised, displaying
"controller-0 experienced a service-affecting failure. Auto-recovery in progress".

**Workaround**: You can recover the subcloud to the ``available`` state by
locking and unlocking controller-0 .

***********************************************************************
Limitations when using Multiple Driver Versions for the same NIC Family
***********************************************************************

The capability to support multiple NIC driver versions has the following
limitations:

-  Intel NIC family supports only: ice, i40e and iavf drivers

-  Driver versions must respect the compatibility matrix between drivers

-  Multiple driver versions cannot be loaded simultaneously and applies to the
   entire system.

-  Latest driver version will be loaded by default, unless specifically
   configured to use a legacy driver version.

-  Drivers used by the installer will always use the latest version,
   therefore firmware compatibility must support basic NIC operations for each
   version to facilitate installation

-  Host reboot is required to activate the configured driver versions

-  For Backup and Restore, the host must be rebooted a second time for
   in order to activate the drivers versions.

**Workaround**: NA

*****************
Quartzville Tools
*****************

The following :command:`celo64e` and :command:`nvmupdate64e` commands are not
supported in |prod-long|, Release 8.0 due to a known issue in Quartzville
tools that crashes the host.

**Workaround**: Reboot the host using the boot screen menu.

*************************************************
Controller SWACT unavailable after System Restore
*************************************************

After performing a restore of the system, the user is unable to swact the
controller.

**Workaround**: NA

*************************************************************
Intermittent Kubernetes Upgrade failure due to missing Images
*************************************************************

During a Kubernetes upgrade, the upgrade may intermittently fail when you run
:command:`system kube-host-upgrade <host> control-plane` due to the
containerd cache being cleared.

**Workaround**: If the above failure is encountered, run the following commands
on the host encountering the failure:

.. rubric:: |proc|

#.  Ensure the failure is due to missing images by running ``crictl images`` and
    confirming the following are not present:

    .. code-block::

        registry.local:9001/k8s.gcr.io/kube-apiserver:v1.24.4
        registry.local:9001/k8s.gcr.io/kube-controller-manager:v1.24.4
        registry.local:9001/k8s.gcr.io/kube-scheduler:v1.24.4
        registry.local:9001/k8s.gcr.io/kube-proxy:v1.24.4

#.  Manually pull the image into containerd cache by running the following
    commands, replacing ``<admin_password>`` with your password for the admin
    user.

    .. code-block::

        ~(keystone_admin)]$ crictl pull --creds admin:<admin_password> registry.local:9001/k8s.gcr.io/kube-apiserver:v1.24.4
        ~(keystone_admin)]$ crictl pull --creds admin:<admin_password> registry.local:9001/k8s.gcr.io/kube-controller-manager:v1.24.4
        ~(keystone_admin)]$ crictl pull --creds admin:<admin_password> registry.local:9001/k8s.gcr.io/kube-scheduler:v1.24.4
        ~(keystone_admin)]$ crictl pull --creds admin:<admin_password> registry.local:9001/k8s.gcr.io/kube-proxy:v1.24.4

#.  Ensure the images are present when running ``crictl images``. Rerun the
    :command:`system kube-host-upgrade <host> control-plane`` command.

***********************************
Docker Network Bridge Not Supported
***********************************

The Docker Network Bridge, previously created by default, is removed and no
longer supported in |prod-long| Release 8.0 as the default bridge IP address
collides with addresses already in use.

As a result, docker can no longer be used for running containers. This impacts
building docker images directly on the host.

**Workaround**: Create a Kubernetes pod that has network access, log in
to the container, and build the docker images.


************************************
Impact of Kubenetes Upgrade to v1.24
************************************

In Kubernetes v1.24 support for the ``RemoveSelfLink`` feature gate was removed.
In previous releases of |prod-long| this has been set to "false" for backward
compatibility, but this is no longer an option and it is now hardcoded to "true".

**Workaround**: Any application that relies on this feature gate being disabled
(i.e. assumes the existance of the "self link") must be updated before
upgrading to Kubernetes v1.24.


*******************************************************************
Password Expiry Warning Message is not shown for LDAP user on login
*******************************************************************

In |prod-long| Release 8.0, the password expiry warning message is not shown
for LDAP users on login when the password is nearing expiry. This is due to
the ``pam-sssd`` integration.

**Workaround**: It is highly recommend that LDAP users maintain independent
notifications and update their passwords every 3 months.

The expired password can be reset by a user with root privileges using
the following command:

.. code-block::none

    ~(keystone_admin)]$ sudo ldapsetpasswd ldap-username
    Password:
    Changing password for user uid=ldap-username,ou=People,dc=cgcs,dc=local
    New Password:
    Retype New Password:
    Successfully set password for user uid=ldap-username,ou=People,dc=cgcs,dc=local

******************************************
Console Session Issues during Installation
******************************************

After bootstrap and before unlocking the controller, if the console session times
out (or the user logs out), ``systemd`` does not work properly. ``fm, sysinv and
mtcAgent`` do not initialize.

**Workaround**: If the console times out or the user logs out between bootstrap
and unlock of controller-0, then, to recover from this issue, you must
re-install the ISO.

************************************************
PTP O-RAN Spec Compliant Timing API Notification
************************************************

.. Need the version for the .tgz tarball....Please confirm if this is applicable to stx 8.0?

-  The ptp-notification <minor_version>.tgz application tarball and the corresponding
   notificationservice-base:stx8.0-v2.0.2 image are not backwards compatible
   with applications using the ``v1 ptp-notification`` API and the corresponding
   notificationclient-base:stx.8.0-v2.0.2 image.

   Backward compatibility will be provided in StarlingX Release 9.0.

   .. note::

       For |O-RAN| Notification support (v2 API), deploy and use the
       ``ptp-notification-<minor_version>.tgz`` application tarball. Instructions for this
       can be found in the |prod-long| Release 8.0 documentation.

   **See**:

   -  :ref:`install-ptp-notifications`

   -  :ref:`integrate-the-application-with-notification-client-sidecar`

-  The ``v1 API`` only supports monitoring a single ptp4l + phc2sys instance.

   **Workaround**: Ensure the system is not configured with multiple instances
   when using the v1 API.

-  The O-RAN Cloud Notification defines a /././sync API v2 endpoint intended to
   allow a client to subscribe to all notifications from a node. This endpoint
   is not supported |prod-long| Release 8.0.

   **Workaround**: A specific subscription for each resource type must be
   created instead.

-  ``v1 / v2``

   -  v1: Support for monitoring a single ptp4l instance per host - no other
      services can be queried/subscribed to.

   -  v2: The API conforms to O-RAN.WG6.O-Cloud Notification API-v02.01
      with the following exceptions, that are not supported in |prod-long|
      Release 8.0.

      -  O-RAN SyncE Lock-Status-Extended notifications

      -  O-RAN SyncE Clock Quality Change notifications

      -  O-RAN Custom cluster names

      -  /././sync endpoint

   **Workaround**: See the respective PTP-notification v1 and v2 document
   subsections for further details.

   v1: https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v1.html

   v2: https://docs.starlingx.io/api-ref/ptp-notification-armada-app/api_ptp_notifications_definition_v2.html


**************************************************************************
Upper case characters in host names cause issues with kubernetes labelling
**************************************************************************

Upper case characters in host names cause issues with kubernetes labelling.

**Workaround**: Host names should be lower case.

****************
Debian Bootstrap
****************

On CentOS bootstrap worked even if **dns_servers** were not present in the
localhost.yml. This does not work for Debian bootstrap.

**Workaround**: You need to configure the **dns_servers** parameter in the
localhost.yml, as long as no |FQDNs| were used in the bootstrap overrides in
the localhost.yml file for Debian bootstrap.

***********************
Installing a Debian ISO
***********************

The disks and disk partitions need to be wiped before the install.
Installing a Debian ISO may fail with a message that the system is
in emergency mode if the disks and disk partitions are not
completely wiped before the install, especially if the server was
previously running a CentOS ISO.

**Workaround**: When installing a lab for any Debian install, the disks must
first be completely wiped using the following procedure before starting
an install.

Use the following wipedisk commands to run before any Debian install for
each disk (eg: sda, sdb, etc):

.. code-block:: none

    sudo wipedisk
    # Show
    sudo sgdisk -p /dev/sda
    # Clear part table
    sudo sgdisk -o /dev/sda

.. note::

    The above commands must be run before any Debian install. The above
    commands must also be run if the same lab is used for CentOS installs after
    the lab was previously running a Debian ISO.

**********************************
Security Audit Logging for K8s API
**********************************

A custom policy file can only be created at bootstrap in ``apiserver_extra_volumes``.
If a custom policy file was configured at bootstrap, then after bootstrap the
user has the option to configure the parameter ``audit-policy-file`` to either
this custom policy file (``/etc/kubernetes/my-audit-policy-file.yml``) or the
default policy file ``/etc/kubernetes/default-audit-policy.yaml``. If no
custom policy file was configured at bootstrap, then the user can only
configure the parameter ``audit-policy-file`` to the default policy file.

Only the parameter ``audit-policy-file`` is configurable after bootstrap, so
the other parameters (``audit-log-path``, ``audit-log-maxsize``,
``audit-log-maxage`` and ``audit-log-maxbackup``) cannot be changed at
runtime.

**Workaround**: NA

**See**: :ref:`kubernetes-operator-command-logging-663fce5d74e7`.

******************************************************************
Installing subcloud with patches in Partial-Apply is not supported
******************************************************************

When a patch has been uploaded and applied, but not installed, it is in
a ``Partial-Apply`` state. If a remote subcloud is installed via Redfish
(miniboot) at this point, it will run the patched software. Any patches in this
state will be applied on the subcloud as it is installed. However, this is not
reflected in the output from the :command:`sw-patch query` command on the
subcloud.

**Workaround**: For remote subcloud install operations using the Redfish
protocol, you should avoid installing any subclouds if there are System
Controller patches in the ``Partial-Apply`` state.

******************************************
PTP is not supported on Broadcom 57504 NIC
******************************************

|PTP| is not supported on the Broadcom 57504 NIC.

**Workaround**: None. Do not configure |PTP| instances on the Broadcom 57504
NIC.

*************************************
Metrics Server Update across Upgrades
*************************************

After a platform upgrade, the Metrics Server will NOT be automatically updated.

**Workaround**: To update the Metrics Server,
**See**: :ref:`Install Metrics Server <kubernetes-admin-tutorials-metrics-server>`

***********************************************************************************
Horizon Drop-Down lists in Chrome and Firefox causes issues due to the new branding
***********************************************************************************

Drop-down menus in Horizon do not work due to the 'select' HTML element on Chrome
and Firefox.

It is considered a 'replaced element' as it is generated by the browser and/or
operating system. This element has a limited range of customizable CSS
properties.

**Workaround**: The system should be 100% usable even with this limitation.
Changing browser's and/or operating system's theme could solve display issues
in case they limit the legibility of the elements (i.e. white text and
white background).

************************************************************************************************
Deploying an App using nginx controller fails with internal error after controller.name override
************************************************************************************************

An Helm override of controller.name to the nginx-ingress-controller app may
result in errors when creating ingress resources later on.

Example of Helm override:

.. code-block::none

    cat <<EOF> values.yml
    controller:
      name: notcontroller

    EOF

    ~(keystone_admin)$ system helm-override-update nginx-ingress-controller ingress-nginx kube-system --values values.yml
    +----------------+-----------------------+
    | Property       | Value                 |
    +----------------+-----------------------+
    | name           | ingress-nginx         |
    | namespace      | kube-system           |
    | user_overrides | controller:           |
    |                |   name: notcontroller |
    |                |                       |
    +----------------+-----------------------+

    ~(keystone_admin)$ system application-apply nginx-ingress-controller

**Workaround**: NA

************************************************
Kata Container is not supported on StarlingX 8.0
************************************************

Kata Containers that were supported on CentOS in earlier releases of |prod-long|
will not be supported on |prod-long| Release 8.0.

***********************************************
Vault is not supported on StarlingX Release 8.0
***********************************************

The Vault application is not supported on |prod-long| Release 8.0.

**Workaround**: NA

***************************************************
Portieris is not supported on StarlingX Release 8.0
***************************************************

The Portieris application is not supported on |prod-long| Release 8.0.

**Workaround**: NA

*****************************
DCManager Patch Orchestration
*****************************

.. warning::
    Patches must be applied or removed on the System Controller prior to using
    the :command:`dcmanager patch-strategy` command to propagate changes to the
    subclouds.

****************************************
Optimization with a Large number of OSDs
****************************************

As Storage nodes are not optimized, you may need to optimize your Ceph
configuration for balanced operation across deployments with a high number of
|OSDs|. This results in an alarm being generated even if the installation
succeeds.

800.001 - Storage Alarm Condition: HEALTH_WARN. Please check 'ceph -s'

**Workaround**: To optimize your storage nodes with a large number of |OSDs|, it
is recommended to use the following commands:

.. code-block:: none

    $ ceph osd pool set kube-rbd pg_num 256
    $ ceph osd pool set kube-rbd pgp_num 256

******************************************************************
PTP tx_timestamp_timeout causes ptp4l port to transition to FAULTY
******************************************************************

NICs using the Intel Ice NIC driver may report the following in the `ptp4l``
logs, which might coincide with a |PTP| port switching to ``FAULTY`` before
re-initializing.

.. code-block:: none

    ptp4l[80330.489]: timed out while polling for tx timestamp
    ptp4l[80330.CGTS-30543489]: increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug

This is due to a limitation of the Intel ICE driver.

**Workaround**: The recommended workaround is to set the ``tx_timestamp_timeout``
parameter to 700 (ms) in the ``ptp4l`` config using the following command.

.. code-block:: none

    ~(keystone_admin)]$ system ptp-instance-parameter-add ptp-inst1 tx_timestamp_timeout=700

***************
BPF is disabled
***************

|BPF| cannot be used in the PREEMPT_RT/low latency kernel, due to the inherent
incompatibility between PREEMPT_RT and |BPF|, see, https://lwn.net/Articles/802884/.

Some packages might be affected when PREEMPT_RT and BPF are used together. This
includes the following, but not limited to these packages.

-   libpcap
-   libnet
-   dnsmasq
-   qemu
-   nmap-ncat
-   libv4l
-   elfutils
-   iptables
-   tcpdump
-   iproute
-   gdb
-   valgrind
-   kubernetes
-   cni
-   strace
-   mariadb
-   libvirt
-   dpdk
-   libteam
-   libseccomp
-   binutils
-   libbpf
-   dhcp
-   lldpd
-   containernetworking-plugins
-   golang
-   i40e
-   ice

**Workaround**: Wind River recommends not to use BPF with real time kernel.
If required it can still be used, for example, debugging only.

*****************
crashkernel Value
*****************

**crashkernel=auto** is no longer supported by newer kernels, and hence the
v5.10 kernel will not support the "auto" value.

**Workaround**: |prod-long| uses **crashkernel=2048m** instead of
**crashkernel=auto**.

.. note::

    |prod-long| Release 8.0 has increased the amount of reserved memory for
    the crash/kdump kernel from 512 MiB to 2048 MiB.

***********************
Control Group parameter
***********************

The control group (cgroup) parameter **kmem.limit_in_bytes** has been
deprecated, and results in the following message in the kernel's log buffer
(dmesg) during boot-up and/or during the Ansible bootstrap procedure:
"kmem.limit_in_bytes is deprecated and will be removed. Please report your
use case to linux-mm@kvack.org if you depend on this functionality." This
parameter is used by a number of software packages in |prod-long|, including,
but not limited to, **systemd, docker, containerd, libvirt** etc.

**Workaround**: NA. This is only a warning message about the future deprecation
of an interface.

****************************************************
Kubernetes Taint on Controllers for Standard Systems
****************************************************

In Standard systems, a Kubernetes taint is applied to controller nodes in order
to prevent application pods from being scheduled on those nodes; since
controllers in Standard systems are intended ONLY for platform services.
If application pods MUST run on controllers, a Kubernetes toleration of the
taint can be specified in the application's pod specifications.

**Workaround**: Customer applications that need to run on controllers on
Standard systems will need to be enabled/configured for Kubernetes toleration
in order to ensure the applications continue working after an upgrade from
|prod-long| Release 6.0 to |prod-long| future Releases. It is suggested to add
the Kubernetes toleration to your application prior to upgrading to |prod-long|
Release 8.0.

You can specify toleration for a pod through the pod specification (PodSpec).
For example:

.. code-block:: none

    spec:
    ....
    template:
    ....
        spec
          tolerations:
            - key: "node-role.kubernetes.io/control-plane"
            operator: "Exists"
            effect: "NoSchedule"
            - key: "node-role.kubernetes.io/control-plane"
            operator: "Exists"
            effect: "NoSchedule"

**See**: `Taints and Tolerations <https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/>`__.

********************************************************
New Kubernetes Taint on Controllers for Standard Systems
********************************************************

A new Kubernetes taint will be applied to controllers for Standard systems in
order to prevent application pods from being scheduled on controllers; since
controllers in Standard systems are intended ONLY for platform services. If
application pods MUST run on controllers, a Kubernetes toleration of the taint
can be specified in the application's pod specifications. You will also need to
change the nodeSelector / nodeAffinity to use the new label.

**Workaround**: Customer applications that need to run on controllers on
Standard systems will need to be enabled/configured for Kubernetes toleration
in order to ensure the applications continue working after an upgrade to
|prod-long| Release 8.0 and |prod-long| future Releases.

You can specify toleration for a pod through the pod specification (PodSpec).
For example:

.. code-block:: none

    spec:
    ....
    template:
    ....
        spec
          tolerations:
            - key: "node-role.kubernetes.io/control-plane"
            operator: "Exists"
            effect: "NoSchedule"

**See**: `Taints and Tolerations <https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/>`__.

**************************************************************
Ceph alarm 800.001 interrupts the AIO-DX upgrade orchestration
**************************************************************

Upgrade orchestration fails on |AIO-DX| systems that have Ceph enabled.

**Workaround**: Clear the Ceph alarm 800.001 by manually upgrading both
controllers and using the following command:

.. code-block:: none

    ~(keystone_admin)]$ ceph mon enable-msgr2

Ceph alarm 800.001 is cleared.

***************************************************************
Storage Nodes are not considered part of the Kubernetes cluster
***************************************************************

When running the :command:`system kube-host-upgrade-list` command the output
must only display controller and worker hosts that have control-plane and kubelet
components. Storage nodes do not have any of those components and so are not
considered a part of the Kubernetes cluster.

**Workaround**: Do not include Storage nodes.

***************************************************************************************
Backup and Restore of ACC100 (Mount Bryce) configuration requires double unlock attempt
***************************************************************************************

After restoring from a previous backup with an Intel ACC100 processing
accelerator device, the first unlock attempt will be refused since this
specific kind of device will be updated in the same context.

**Workaround**: A second attempt after few minutes will accept and unlock the
host.

**************************************
Application Pods with SRIOV Interfaces
**************************************

Application Pods with |SRIOV| Interfaces require a **restart-on-reboot: "true"**
label in their pod spec template.

Pods with |SRIOV| interfaces may fail to start after a platform restore or
Simplex upgrade and persist in the **Container Creating** state due to missing
PCI address information in the |CNI| configuration.

**Workaround**: Application pods that require|SRIOV| should add the label
**restart-on-reboot: "true"** to their pod spec template metadata. All pods with
this label will be deleted and recreated after system initialization, therefore
all pods must be restartable and managed by a Kubernetes controller
\(i.e. DaemonSet, Deployment or StatefulSet) for auto recovery.

Pod Spec template example:

.. code-block:: none

    template:
        metadata:
          labels:
            tier: node
            app: sriovdp
            restart-on-reboot: "true"


***********************
Management VLAN Failure
***********************

If the Management VLAN fails on the active System Controller, communication
failure 400.005 is detected, and alarm 280.001 is raised indicating
subclouds are offline.

**Workaround**: System Controller will recover and subclouds are manageable
when the Management VLAN is restored.

********************************
Host Unlock During Orchestration
********************************

If a host unlock during orchestration takes longer than 30 minutes to complete,
a second reboot may occur. This is due to the delays, VIM tries to abort. The
abort operation triggers the second reboot.

**Workaround**: NA

**************************************
Storage Nodes Recovery on Power Outage
**************************************

Storage nodes take 10-15 minutes longer to recover in the event of a full
power outage.

**Workaround**: NA

*************************************
Ceph OSD Recovery on an AIO-DX System
*************************************

In certain instances a Ceph OSD may not recover on an |AIO-DX| system
\(for example, if an OSD comes up after a controller reboot and a swact
occurs), and remains in the down state when viewed using the :command:`ceph -s`
command.

**Workaround**: Manual recovery of the OSD may be required.

********************************************************
Using Helm with Container-Backed Remote CLIs and Clients
********************************************************

If **Helm** is used within Container-backed Remote CLIs and Clients:

-   You will NOT see any helm installs from |prod| Platform's system
    Armada applications.

    **Workaround**: Do not directly use **Helm** to manage |prod| Platform's
    system Armada applications. Manage these applications using
    :command:`system application` commands.

-   You will NOT see any helm installs from end user applications, installed
    using **Helm** on the controller's local CLI.

    **Workaround**: It is recommended that you manage your **Helm**
    applications only remotely; the controller's local CLI should only be used
    for management of the |prod| Platform infrastructure.

*********************************************************************
Remote CLI Containers Limitation for StarlingX Platform HTTPS Systems
*********************************************************************

The python2 SSL lib has limitations with reference to how certificates are
validated. If you are using Remote CLI containers, due to a limitation in
the python2 SSL certificate validation, the certificate used for the 'ssl'
certificate should either have:

#.  CN=IPADDRESS and SAN=empty or,

#.  CN=FQDN and SAN=FQDN

**Workaround**: Use CN=FQDN and SAN=FQDN as CN is a deprecated field in
the certificate.

*******************************************************************
Cert-manager does not work with uppercase letters in IPv6 addresses
*******************************************************************

Cert-manager does not work with uppercase letters in IPv6 addresses.

**Workaround**: Replace the uppercase letters in IPv6 addresses with lowercase
letters.

.. code-block:: none

    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
        name: oidc-auth-apps-certificate
        namespace: test
    spec:
        secretName: oidc-auth-apps-certificate
        dnsNames:
        - ahost.com
        ipAddresses:
        - fe80::903a:1c1a:e802::11e4
        issuerRef:
            name: cloudplatform-interca-issuer
            kind: Issuer

*******************************
Kubernetes Root CA Certificates
*******************************

Kubernetes does not properly support **k8s_root_ca_cert** and **k8s_root_ca_key**
being an Intermediate CA.

**Workaround**: Accept internally generated **k8s_root_ca_cert/key** or
customize only with a Root CA certificate and key.

************************
Windows Active Directory
************************

-   **Limitation**: The Kubernetes API does not support uppercase IPv6 addresses.

    **Workaround**: The issuer_url IPv6 address must be specified as lowercase.

-   **Limitation**: The refresh token does not work.

    **Workaround**: If the token expires, manually replace the ID token. For
    more information, see, :ref:`Obtain the Authentication Token Using the Browser <obtain-the-authentication-token-using-the-browser>`.

-   **Limitation**: TLS error logs are reported in the **oidc-dex** container
    on subclouds. These logs should not have any system impact.

    **Workaround**: NA

-   **Limitation**: **stx-oidc-client** liveness probe sometimes reports
    failures. These errors may not have system impact.

    **Workaround**: NA

.. Stx LP Bug: https://bugs.launchpad.net/starlingx/+bug/1846418

************
BMC Password
************

The BMC password cannot be updated.

**Workaround**: In order to update the BMC password, de-provision the BMC,
and then re-provision it again with the new password.

****************************************
Application Fails After Host Lock/Unlock
****************************************

In some situations, application may fail to apply after host lock/unlock due to
previously evicted pods.

**Workaround**: Use the :command:`kubectl delete` command to delete the evicted
pods and reapply the application.

***************************************
Application Apply Failure if Host Reset
***************************************

If an application apply is in progress and a host is reset it will likely fail.
A re-apply attempt may be required once the host recovers and the system is
stable.

**Workaround**: Once the host recovers and the system is stable, a re-apply
may be required.

********************************
Pod Recovery after a Host Reboot
********************************

On occasions some pods may remain in an unknown state after a host is rebooted.

**Workaround**: To recover these pods kill the pod. Also based on `https://github.com/kubernetes/kubernetes/issues/68211 <https://github.com/kubernetes/kubernetes/issues/68211>`__
it is recommended that applications avoid using a subPath volume configuration.

****************************
Rare Node Not Ready Scenario
****************************

In rare cases, an instantaneous loss of communication with the active
**kube-apiserver** may result in kubernetes reporting node\(s) as stuck in the
"Not Ready" state after communication has recovered and the node is otherwise
healthy.

**Workaround**: A restart of the **kublet** process on the affected node\(s)
will resolve the issue.

*************************
Platform CPU Usage Alarms
*************************

Alarms may occur indicating platform cpu usage is \>90% if a large number of
pods are configured using liveness probes that run every second.

**Workaround**: To mitigate either reduce the frequency for the liveness
probes or increase the number of platform cores.

*******************
Pods Using isolcpus
*******************

The isolcpus feature currently does not support allocation of thread siblings
for cpu requests (i.e. physical thread +HT sibling).

**Workaround**: NA

*****************************
system host-disk-wipe command
*****************************

The system host-disk-wipe command is not supported in this release.

**Workaround**: NA

*************************************************************
Restrictions on the Size of Persistent Volume Claims (PVCs)
*************************************************************

There is a limitation on the size of Persistent Volume Claims (PVCs) that can
be used for all StarlingX Platform Releases.

**Workaround**: It is recommended that all PVCs should be a minimum size of
1GB. For more information, see, `https://bugs.launchpad.net/starlingx/+bug/1814595 <https://bugs.launchpad.net/starlingx/+bug/1814595>`__.

***************************************************************
Sub-Numa Cluster Configuration not Supported on Skylake Servers
***************************************************************

Sub-Numa cluster configuration is not supported on Skylake servers.

**Workaround**: For servers with Skylake Gold or Platinum CPUs, Sub-NUMA
clustering must be disabled in the BIOS.

*****************************************************************
The ptp-notification-demo App is Not a System-Managed Application
*****************************************************************

The ptp-notification-demo app is provided for demonstration purposes only.
Therefore, it is not supported on typical platform operations such as Backup
and Restore.

**Workaround**: NA

*************************************************************************
Deleting image tags in registry.local may delete tags under the same name
*************************************************************************

When deleting image tags in the registry.local docker registry, you should be
aware that the deletion of an **<image-name:tag-name>** will delete all tags
under the specified <image-name> that have the same 'digest' as the specified
<image-name:tag-name>. For more information, see, :ref:`Delete Image Tags in the Docker Registry <delete-image-tags-in-the-docker-registry-8e2e91d42294>`.

**Workaround**: NA

------------------
Deprecated Notices
------------------

****************************
Airship Armada is deprecated
****************************

.. note::

    Airship Armada will be removed in stx.9.0.

StarlingX Release 7.0 introduces FluxCD based applications that utilize FluxCD
Helm/source controller pods deployed in the flux-helm Kubernetes namespace.
Airship Armada support is now considered to be deprecated. The Armada pod will
continue to be deployed for use with any existing Armada based applications but
will be removed in StarlingX Release 8.0, once the stx-openstack Armada
application is fully migrated to FluxCD.

************************************
Cert-manager API Version deprecation
************************************

The upgrade of cert-manager from 0.15.0 to 1.7.1, deprecated support for
cert manager API versions cert-manager.io/v1alpha2 and cert-manager.io/v1alpha3.
When creating cert-manager |CRDs| (certificates, issuers, etc) with |prod-long|
Release 8.0, use cert-manager.io/v1.

***************
Kubernetes APIs
***************

Kubernetes APIs that will be removed in K8s 1.25 are listed below:

**See**: https://kubernetes.io/docs/reference/using-api/deprecation-guide/#v1-25


*******************
Pod Security Policy
*******************

|PSP| is deprecated as of Kubernetes v1.21 and will be
removed in Kubernetes v1.25. |PSP| will continue to be fully functional for
|prod-long| Release 8.0.

Since it has been introduced |PSP| has had usability problems. The way |PSPs|
are applied to pods has proven confusing especially when trying to use them.
It is easy to accidentally grant broader permissions than intended, and
difficult to inspect which |PSPs| apply in a certain situation. Kubernetes
offers a built-in |PSA| controller that will replace |PSPs| in the future.

**See**:

-   :ref:`Pod Security Policy <pod-security-policies>`

