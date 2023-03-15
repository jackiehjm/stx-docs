.. _r7-0-release-notes-85446867da2a:

.. All please review and comment

==================
R7.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO (CentOS and Debian) and Docker images for StarlingX release
7.0 are located at the ``CENGN StarlingX mirror`` repos:

-  http://mirror.starlingx.cengn.ca/mirror/starlingx/release/7.0.0/centos/flock/outputs/

-  http://mirror.starlingx.cengn.ca/mirror/starlingx/release/7.0.0/debian/monolithic/outputs/

.. note::
    Debian is a Technology Preview Release and only supports |AIO-SX| in StarlingX
    Release 7.0 and uses the same docker images as CentOS.

------
Branch
------

The source code for StarlingX release 7.0 is available in the r/stx.7.0
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

To deploy StarlingX release 7.0. Refer to :ref:`Consuming StarlingX <index-intro-27197f27ad41>`.

For detailed installation instructions, see `R7.0 Installation Guides <https://docs.starlingx.io/deploy_install_guides/index-install-e083ca818006.html>`_.

-----------------------------
New features and enhancements
-----------------------------

.. start-new-features-r7

The list below provides a detailed list of new features and links to the
associated user guides (if applicable).

*********************
Debian-based Solution
*********************

|prod| |deb-eval-release| inherits the 5.10 kernel version from the Yocto
project introduced in |prod| |deb-510-kernel-release|, i.e. the Debian
5.10 kernel is replaced with the Yocto project 5.10.x kernel (linux-yocto).

|prod| |deb-eval-release| is a Technology Preview Release of Debian |prod|
for evaluation purposes.

|prod| |deb-eval-release| release runs Debian Bullseye (11.3). It is limited in
scope to the |AIO-SX| configuration, |deb-dup-std-na|. It is also limited in
scope to Kubernetes apps and does not yet support running OpenStack on Debian.

.. .. **See**:

.. .. -  :ref:`index-debian-introduction-8eb59cf0a062`

.. .. -  :ref:`operational-impacts-9cf2e610b5b3`


******************************
Istio Service Mesh Application
******************************

The Istio Service Mesh application is integrated into |prod| as a system
application.

Istio provides traffic management, observability as well as security as a
Kubernetes service mesh. For more information, see `https://istio.io/
<https://istio.io/>`__.

|prod| includes istio-operator container to manage the life cycle management
of the Istio components.

**See**: :ref:`Istio Service Mesh Application <istio-service-mesh-application-eee5ebb3d3c4>`


*********************************
Pod Security Admission Controller
*********************************

The Beta release of Pod Security Admission (PSA) controller is available in
StarlingX release 7.0 as a Technology Preview feature. It will replace Pod
Security Policies in a future release.

PSA controller acts on creation and modification of the pod and determines
if it should be admitted based on the requested security context and the
policies defined. It provides a more usable k8s-native solution to enforce
Pod Security Standards.

**See**:

-  https://kubernetes.io/docs/concepts/security/pod-security-admission/
-  :ref:`pod-security-admission-controller-8e9e6994100f`


****************************************
Platform Application Components Revision
****************************************

The following applications have been updated to a new version in |prod|
Release 7.0.

-  cert-manager, 1.7.1
-  metric-server, 1.0.18
-  nginx-ingress-controller, 1.1.1
-  oidc-dex, 2.31.1

**cert-manager**

The upgrade of cert-manager from 0.15.0 to 1.7.1 deprecated support for
cert manager API versions cert-manager.io/v1alpha2 and cert-manager.io/v1alpha3.
When creating cert-manager |CRDs| (certificates, issuers, etc) with |prod-long|,
Release 7.0, use API version of cert-manager.io/v1.

Cert manager resources that are already deployed on the system will be
automatically converted to API version of cert-manager.io/v1. Anything created
using automation or previous |prod-long| releases should be converted with the
cert-manager kubectl plugin using the instructions documented in
https://cert-manager.io/docs/installation/upgrading/upgrading-0.16-1.0/#converting-resources
before being deployed to the new release.

**metric-server**

In |prod| Release 7.0 the Metrics Server will NOT be automatically updated.
To update the Metrics Server, see :ref:`Install Metrics Server <kubernetes-admin-tutorials-metrics-server>`

**oidc-dex**

|prod-long| Release 7.0 supports helm-overrides of oidc-auth-apps application.
The recommended and legacy example Helm overrides of
``oidc-auth-apps`` are supported for upgrades, as described in |prod|
documentation :ref:`User Authentication Using Windows Active Directory
<user-authentication-using-windows-active-directory-security-index>`.

**See**: :ref:`configure-oidc-auth-applications`.


***************
Bond CNI plugin
***************

The Bond CNI plugin v1.0.1 is now supported in |prod-long| Release 7.0.

The Bond CNI plugin provides a method for aggregating multiple network
interfaces into a single logical "bonded" interface.

To add a bonded interface to a container, a network attachment definition of
type ``bond`` must be created and added as a network annotation in the pod
specification. The bonded interfaces can either be taken from the host or
container based on the value of the ``linksInContainer`` parameter in the
network attachment definition. It provides transparent link aggregation for
containerized applications via K8s configuration for improved redundancy and
link capacity.

**See**:

:ref:`integrate-the-bond-cni-plugin-2c2f14733b46`

************************************************
PTP GNSS and Time SyncE Support for 5G Solutions
************************************************

Intel's E810 Westport Channel and **Logan Beach NICs** support a built-in GNSS
module and the ability to distribute clock via Synchronous Ethernet (SyncE).
This feature allows a PPS signal to be taken in via the |GNSS| module and
redistributed to additional NICs on the same host or on different hosts.
This behavior is configured on |prod| using the ``clock`` instance type in
the |PTP| configuration.

These parameters are used to enable the UFL/SMA ports, recovered clock
syncE etc. Refer to the user's guide for the Westport Channel or Logan
Beach NIC for additional details on how to operate these cards.

**See**: :ref:`SyncE and Introduction <gnss-and-synce-support-62004dc97f3e>`

*********************
PTP Clock TAI Support
*********************

A special ptp4l instance level parameter is provided to allow a PTP node to
set the **currentUtcOffsetValid** flag in its announce messages and to
correctly set the CLOCK_TAI on the system.

**PTP Multiple NIC Boundary Clock Configuration**
StarlingX 7.0 provides support for PTP multiple NIC Boundary Clock
configuration. Multiple instances of ptp4l, phc2sys and ts2phc can now be
configured on each host to support a variety of configurations including
Telecom Boundary clock (T-BC), Telecom Grand Primary clock (T-GM) and Ordinary
clock (OC).

**See**:

:ref:`ptp-server-config-index`


**************************************************
Enhanced Parallel Operations for Distributed Cloud
**************************************************

The following operations can now be performed on a larger number of subclouds
in parallel. The supported maximum parallel number ranges from 100 to 500
depending on the type of operation.

- Subcloud Install
- Subcloud Deployment (bootstrap and deploy)
- Subcloud Manage and Sync
- Subcloud Application Deployment/Update
- Patch Orchestration
- Upgrade Orchestration
- Firmware Update Orchestration
- Kubernetes Upgrade Orchestration
- Kubernetes Root CA Orchestration
- Upgrade Prestaging

**************
--force option
**************

The ``--force`` option has been added to the :command:`dcmanager upgrade-strategy create`
command. This option upgrades both online and offline subclouds for a single
subcloud or a group of subclouds.

See :ref:`Distributed Upgrade Orchestration Process Using the CLI <distributed-upgrade-orchestration-process-using-the-cli>`

****************************************
Subcloud Local Installation Enhancements
****************************************

Error preventive mechanisms have been implemented for subcloud local
installation.

- Pre-check to avoid overwriting installed systems
- Unified ISO image for multiple systems and disk configurations
- Prestage execution optimization
- Effective handling of resized docker and docker-distribution filesystems
  over subcloud upgrade

See :ref:`Subcloud Deployment with Local Installation <subcloud-deployment-with-local-installation-4982449058d5>`.

***********************************************
Distributed Cloud Horizon Orchestration Updates
***********************************************

You can use the Horizon Web interface to upgrade Kubernetes across the
Distributed Cloud system by applying the Kubernetes upgrade strategy for
Distributed Cloud Orchestration.

**See**: :ref:`apply-a-kubernetes-upgrade-strategy-using-horizon-2bb24c72e947`

You can use Horizon to update the device/firmware image across the Distributed
Cloud system by applying the firmware update strategy for Distributed Cloud
Update Orchestration.

**See**: :ref:`apply-the-firmware-update-strategy-using-horizon-e78bf11c7189`

You can upgrade the platform software across the Distributed Cloud
system by applying the upgrade strategy for Distributed Cloud
Upgrade Orchestration.

**See**: :ref:`apply-the-upgrade-strategy-using-horizon-d0aab18cc724`

You can use the Horizon Web interface as an alternative to the CLI for managing
device / firmware image update strategies (Firmware update).

**See**: :ref:`create-a-firmware-update-orchestration-strategy-using-horizon-cfecdb67cef2`

You can use the Horizon Web interface as an alternative to the CLI for managing
Kubernetes upgrade strategies.

**See**: :ref:`create-a-kubernetes-upgrade-orchestration-using-horizon-16742b62ffb2`

For more information, **See**: :ref:`Distributed Cloud Guide <index-dist-cloud-kub-95bef233eef0>`

********************************************
Security Audit Logging for Platform Commands
********************************************

|prod| logs all StarlingX REST API operator commands, except commands that use
only GET requests. |prod| also logs all |SNMP| commands, including ``GET``
requests.

**See**:

-  :ref:`Operator Command Logging <operator-command-logging>`
-  :ref:`Operator Login/Authentication Logging <operator-login-authentication-logging>`

**********************************
Security Audit Logging for K8s API
**********************************

Kubernetes API Logging can be enabled and configured in |prod|, and can be
fully configured and enabled at bootstrap time. Post-bootstrap, Kubernetes API
logging can only be enabled or disabled. Kubernetes auditing provides a
security-relevant, chronological set of records documenting the sequence of
actions in a cluster.

**See**: :ref:`kubernetes-operator-command-logging-663fce5d74e7`

*******************************************
Playbook for managing local LDAP Admin User
*******************************************

The purpose of this playbook is to simplify and automate the management of
composite Local |LDAP| accounts across multiple |DC| systems or standalone
systems. A composite Local |LDAP| account is defined as a Local |LDAP| account
that also has a unique keystone account with admin role credentials and access
to a K8S serviceAccount with ``cluster-admin`` role credentials.

**See**: :ref:`Manage Composite Local LDAP Accounts at Scale <manage-local-ldap-39fe3a85a528>`

*******************************
Kubernetes Custom Configuration
*******************************

Kubernetes configuration can be customized during deployment by specifying
bootstrap overrides in the ``localhost.yml`` file during the Ansible bootstrap
process. Additionally, you can also override the **extraVolumes** section in the
apiserver to add new configuration files that may be needed by the server.

**See**: :ref:`Kubernetes Custom Configuration <kubernetes-custom-configuration-31c1fd41857d>`

***********************************
Configuring Host CPU MHz Parameters
***********************************

Some hosts support setting a maximum frequency for their CPU cores (application
cores and platform cores). You may need to configure a maximum scaled
frequency to avoid variability due to power and thermal issues when configured
for maximum performance. For these hosts, the parameters control the maximum
frequency of their CPU cores.

Enable support for power saving modes available on Intel processors to
facilitate a balance between latency and power consumption.

-  |prod-long| permits the CPU "p-states" and "c-states" control via the BIOS

-  Introduce a new starlingx-realtime tuned profile, specifically configured
   for the low latency profile to align with Intel recommendations for maximum
   performance while enabling support for higher c-states.

**See**: :ref:`Host CPU MHz Parameters Configuration <host-cpu-mhz-parameters-configuration-d9ccf907ede0>`

**************************
vRAN Intel Tool Enablement
**************************

The following open-source |vRAN| tools are delivered in the following container
image, ``docker.io/starlingx/stx-centos-tools-dev:stx.7.0-v1.0.1``:

-   ``dmidecode``

-   ``net-tools``

-   ``iproute``

-   ``ethtool``

-   ``tcpdump``

-   ``turbostat``

-   OPAE Tools (`Open Programmable Acceleration Engine
    <https://opae.github.io/latest/>`__, ``fpgainfo``, ``fpgabist``, etc.)

-   ACPICA Tools (``acpidump``, ``acpixtract``, etc.)

-   PCM Tools (`https://github.com/opcm/pcm <https://github.com/opcm/pcm>`__,
    pcm, pcm-core, etc.)

**See**: :ref:`vRAN Tools <vran-tools-2c3ee49f4b0b>`

******************************
Coredump Configuration Support
******************************

You can change the default core dump configuration used to create *core*
files. These are images of the system's working memory used to debug crashes or
abnormal exits.

**See**: :ref:`Change the Default Coredump Configuration <change-the-default-coredump-configuration-51ff4ce0c9ae>`

******************************
FluxCD replaces Airship Armada
******************************

|prod| application management provides a wrapper around FluxCD and Kubernetes
Helm (see `https://github.com/helm/helm <https://github.com/helm/helm>`__)
for managing containerized applications. FluxCD is a tool for managing multiple
Helm charts with dependencies by centralizing all configurations in a single
FluxCD YAML definition and providing life-cycle hooks for all Helm releases.

**See**: :ref:`StarlingX Application Package Manager <kubernetes-admin-tutorials-starlingx-application-package-manager>`.
**See**: FluxCD Limitation note applicable to |prod| Release 7.0.

******************
Kubernetes Upgrade
******************

Kubernetes has now been upgraded to k8s 1.23.1 and is the default version for
|prod-long| Release 7.0.


******************************
NetApp Trident Version Upgrade
******************************

|prod| |prod-ver| contains the installer for Trident 22.01

If you are using NetApp Trident in |prod| |prod-ver| and have upgraded from
the |prod| previous version, ensure that your NetApp backend version is
compatible with Trident 22.01.

.. note::
    You need to upgrade the NetApp Trident driver to 22.01 before
    upgrading Kubernetes to 1.22.

**See**: :ref:`upgrade-the-netapp-trident-software-c5ec64d213d3`

.. end-new-features-r7

----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for a number of defects. Refer to the StarlingX bug
database to review the R7.0 `Fixed Bugs <https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&field.status%3Alist=FIXRELEASED&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=stx.7.0&field.tags_combinator=ANY&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search>`_.

.. All please confirm if any Limitations need to be removed / added

---------------------------------
Known Limitations and Workarounds
---------------------------------

The following are known limitations you may encounter with your |prod| Release
7.0 and earlier releases. Workarounds are suggested where applicable.

.. note::

    These limitations are considered temporary and will likely be resolved in
    a future release.

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

Installing a Debian ISO may fail with a message that the system is in emergency
mode. This occurs if the disks and disk partitions are not completely wiped
before the install, especially if the server was previously running a CentOS
ISO.

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

**********************************************
PTP 110.119 Alarm raised incorrectly on Debian
**********************************************

|PTP| Alarm 100.119 (controller not locked on remote PTP Grand Master
(|PTS| (Primary Time Source)) is raised on |prod| Release 7.0 systems
running Debian after configuring |PTP| instances. This alarm does not affect
system operations.

**Workaround**: Manually delete the alarm using the :command:`fm alarm-delete`
command.

.. note::

    Lock/Unlock and reboot events will cause the alarm to reappear. Use the
    workaround after these operations are completed.

***********************************************
N3000 image updates are not supported on Debian
***********************************************

N3000 image ``update`` and ``show`` operations are not supported on Debian.
Support will be included in a future release.

**Workaround**: Do not attempt these operations on a |prod| Release 7.0
Debian system.

**********************************
Security Audit Logging for K8s API
**********************************

-  In |prod| Release 7.0, a custom policy file can only be created at bootstrap
   in ``apiserver_extra_volumes`` section. If a custom policy file was
   configured at bootstrap, then after bootstrap the user has the option to
   configure the parameter ``audit-policy-file`` to either this custom policy
   file (``/etc/kubernetes/my-audit-policy-file.yml``) or the
   default policy file ``/etc/kubernetes/default-audit-policy.yaml``. If no
   custom policy file was configured at bootstrap, then the user can only
   configure the parameter ``audit-policy-file`` to the default policy file.

   Only the parameter ``audit-policy-file`` is configurable after bootstrap, so
   the other parameters (``audit-log-path``, ``audit-log-maxsize``,
   ``audit-log-maxage`` and ``audit-log-maxbackup``) cannot be changed at
   runtime.

   **Workaround**: NA

   **See**: :ref:`kubernetes-operator-command-logging-663fce5d74e7`.

******************************************
PTP is not supported on Broadcom 57504 NIC
******************************************

|PTP| is not supported on the Broadcom 57504 NIC.

**Workaround**: Do not configure |PTP| instances on the Broadcom 57504
NIC.

*********************************************************************
Backup and Restore: Remote restore fails to gather the SSH public key
*********************************************************************

IPv4 |AIO-DX| remote restore fails while running restore bootstrap.

**Workaround**: If remote restore fails due to failed authentication, perform
the restore on the box instead of remotely. This issue is caused when
remote restore fails to gather the SSH public key.

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

**********************************************************************
Cloud installation causes disk errors in /dev/mapper/mpatha and CentOS
**********************************************************************

During installation of the HPE SAN disk, an error "/dev/mapper/mpatha is invalid"
occurs (intermittent), and CentOS is not bootable (intermittent).

**Workaround**: Reboot the |prod-long| system to solve the issue.

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

***************
PTP Limitations
***************

NICs using the Intel Ice NIC driver may report the following in the `ptp4l``
logs, which might coincide with a |PTP| port switching to ``FAULTY`` before
re-initializing.

.. code-block:: none

    ptp4l[80330.489]: timed out while polling for tx timestamp
    ptp4l[80330.CGTS-30543489]: increasing tx_timestamp_timeout may correct
    this issue, but it is likely caused by a driver bug

This is due to a limitation of the Intel ICE driver.

**Workaround**: The recommended workaround is to set the ``tx_timestamp_timeout``
parameter to 700 (ms) in the ``ptp4l`` config using the following command.

.. code-block:: none

    ~(keystone_admin)]$ system ptp-instance-parameter-add ptp-inst1 tx_timestamp_timeout=700

***********************************************************************
Multiple Lock/Unlock operations on the controllers causes 100.104 alarm
***********************************************************************

Performing multiple Lock/Unlock operations on controllers while |prod-os|
is applied can fill the partition and can trigger an 100.104 alarm.

**Workaround**: Check the amount of space used by core dump using the
:command:`controller-0:~$ ls -lha /var/lib/systemd/coredump`` command.
Core dumps related to MariaDB can be safely deleted.

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

**Workaround**: StarlingX recommends not to use BPF with real time kernel.
If required it can still be used, for example, debugging only.

*****************
crashkernel Value
*****************

**crashkernel=auto** is no longer supported by newer kernels, and hence the
v5.10 kernel will not support the "auto" value.

**Workaround**: |prod-long| uses **crashkernel=512m** instead of
**crashkernel=auto**.

********************************************************
New Kubernetes Taint on Controllers for Standard Systems
********************************************************

In |prod| future Releases, a new Kubernetes taint will be applied to
controllers for Standard systems in order to prevent application pods from
being scheduled on controllers; since controllers in Standard systems are
intended ONLY for platform services. If application pods MUST run on
controllers, a Kubernetes toleration of the taint can be specified in the
application's pod specifications.

**Workaround**: Customer applications that need to run on controllers on
Standard systems will need to be enabled/configured for Kubernetes toleration
in order to ensure the applications continue working after an upgrade to
|prod-long| Release 7.0 and |prod-long| future Releases.

You can specify toleration for a pod through the pod specification (PodSpec).
For example:

.. code-block:: none

    spec:
    ....
    template:
    ....
        spec
          tolerations:
            - key: "node-role.kubernetes.io/master"
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
PCI address information in the CNI configuration.

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

*****************
Vault Application
*****************

The Vault application is not supported in |prod| Release 7.0.

**Workaround**: NA

*********************
Portieris Application
*********************

The Portieris application is not supported in |prod| Release 7.0.

**Workaround**: NA

------------------
Deprecated Notices
------------------

***********************
Control Group parameter
***********************

The control group (cgroup) parameter **kmem.limit_in_bytes** has been
deprecated, and results in the following message in the kernel's log buffer
(dmesg) during boot-up and/or during the Ansible bootstrap procedure:
"kmem.limit_in_bytes is deprecated and will be removed. Please report your
usecase to linux-mm@kvack.org if you depend on this functionality." This
parameter is used by a number of software packages in |prod|, including,
but not limited to, **systemd, docker, containerd, libvirt** etc.

**Workaround**: NA. This is only a warning message about the future deprecation
of an interface.

****************************
Airship Armada is deprecated
****************************

StarlingX Release 7.0 introduces FluxCD based applications that utilize FluxCD
Helm/source controller pods deployed in the flux-helm Kubernetes namespace.
Airship Armada support is now considered to be deprecated. The Armada pod will
continue to be deployed for use with any existing Armada based applications but
will be removed in StarlingX Release 8.0, once the stx-openstack Armada
application is fully migrated to FluxCD.

**Workaround**: NA
