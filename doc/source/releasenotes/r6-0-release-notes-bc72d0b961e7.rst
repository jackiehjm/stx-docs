.. _r6-0-release-notes-bc72d0b961e7:

==================
R6.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO and Docker images for StarlingX release 6.0 are located at
the `CENGN StarlingX mirror
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/6.0.0/centos/flock/outputs/>`_.

------
Branch
------

The source code for StarlingX release 6.0 is available in the r/stx.6.0
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

A system install is required to deploy StarlingX release 6.0. There is no
upgrade path from previous StarlingX releases. For detailed instructions, see
the `Installation Guide <https://docs.starlingx.io/r/stx.6.0/deploy_install_guides/index-install-e083ca818006.html>`_.

-----------------------------
New features and enhancements
-----------------------------

The list below provides a detailed list of new features and links to the
associated user guides (if applicable).


*   Kernel Upversion to 5.10

    |prod-long| now supports kernel version 5.10 to include |VRF| and the user
    space tooling to configure the routing and forwarding interfaces.

    Guide: https://www.kernel.org/doc/Documentation/networking/vrf.txt

*   Platform Certificates Managed by Cert-Manager

    Platform services can now use cert-manager to simplify the management
    (e.g. auto-renewals) of the following Platform certificates:

    *  RESTAPI /GUI certificate
    *  registry.local certificate
    *  OIDC/DEX certificate

    Guides:

    *    :ref:`Create a local CA Issuer <starlingx-rest-api-applications-and-the-web-admin-server-cert-9196c5794834>`

    *    :ref:`Configure REST API Applications and Web Administration Server Certificate <configure-rest-api-applications-and-web-administration-server-certificates-after-installation-6816457ab95f>`

    *    :ref:`Configure Docker Registry Certificate <configure-docker-registry-certificate-after-installation-c519edbfe90a>`

    *    :ref:`Set up OIDC Auth Applications <configure-oidc-auth-applications>`

    *    :ref:`OIDC Client Dex Server Certificates <oidc-client-dex-server-certificates-dc174462d51a>`

*   Management of Kubernetes Root CA Certificate

    You can update Kubernetes Root |CA| certificate on a running system, with
    either an uploaded certificate or an auto-generated certificate.
    Orchestration is also provided for both Cloud and Distributed Cloud.

    Guides:

    *    :ref:`Manual Kubernetes Root CA Certificate Update <manual-kubernetes-root-ca-certificate-update-8e9df2cd7fb9>`

    *    :ref:`Kubernetes Root CA Certificate Update Cloud Orchestration <kubernetes-root-ca-certificate-update-cloud-orchestration-a627f9d02d6d>`

•   Auditd support

    The Linux Auditing System helps system administrators track security
    violation events based on preconfigured audit rules. The events are
    recorded in a log file and the information in the log entries helps to
    detect misuse or unauthorized activities.

    The Linux Audit daemon, **auditd**, is the main component of the Linux
    Auditing System, and is responsible for writing the audit logs.

    Guide: :ref:`Linux Auditing System <auditd-support-339a51d8ce16>`

*   Alarm Support for Expiring and Expired Certificates

    Expired certificates may prevent the proper operation of platform and
    applications running on the platform. In order to avoid expired
    certificates, |prod-long| generates alarms for certificates that are within
    30 days (default) of expiry or have already expired.

    Guide: :ref:`Expiring-Soon and Expired Certificate Alarms <alarm-expiring-soon-and-expired-certificates-baf5b8f73009>`

*   Make a separate CA for Kubernetes and etcd

    This is the etcd Root |CA| certificate. It signs etcd server and client
    certificates, and ``kube-apiserver`` etcd client certificate. This is also
    the |CA| certificate used to verify various server and client certificates
    signed by etcd Root |CA| certificate. You can now provide a separate Root
    |CA| for Kubernetes and etcd.

    Guide: :ref:`Etcd Certificates <etcd-certificates-c1fc943e4a9c>`

*   Support for stx-ceph-manager

*   Ceph upversion from Mimic to Nautilus

    Upgraded the supported Ceph version to Nautilus (14.2.22).

    Guide: N/A

*   Firmware Update for BMC and Retimer

    The firmware for Intel MAX 10 |BMC| and C827 retimer can now be updated
    using the :command:`device-image-upload` command. A new option
    ``--retimer-included <true/false>`` has been added where a boolean
    indicates whether the |BMC| firmware includes a retimer firmware. A new
    parameter ``--bmc <true/false>`` is added to specify the functional |BMC|
    image (optional).

    Guide: :ref:`Update an N3000 FPGA Image <updating-an-intel-n3000-fpga-image>`

*   AIO-SX to AIO-DX Migration

    You can migrate an |AIO-SX| subcloud to an |AIO-DX| subcloud without
    reinstallation. This operation involves updating the system mode, adding
    the OAM unit IP addresses of each controller, and installing the second
    controller.

    Guide: :ref:`Migrate an AIO-SX to an AIO-DX Subcloud <migrate-an-aiosx-subcloud-to-an-aiodx-subcloud>`

*   Distributed Cloud Subcloud Rehoming

    You can move subclouds from one Distributed Cloud system to another while
    the current System Controller is reinstalled in a disaster recovery
    scenario. Another use case for the subcloud rehoming process is to add
    already deployed subclouds when the subclouds from multiple System
    Controllers are being consolidated into a single System Controller, because
    the rehoming playbook does not work with freshly installed/bootstrapped
    subclouds.

    Guide: :ref:`Rehome a Subcloud <rehoming-a-subcloud>`

*   Container Component Upversion

    The default version of a fresh install for Kubernetes is 1.21.8, while for
    an upgrade from 5.0, it will be 1.18.1. You will need to upgrade
    Kubernetes to each version up to 1.21.8 in order to be ready to upgrade to
    the next version of |prod|.

    Guide: :ref:`Manual Kubernetes Version Upgrade <manual-kubernetes-components-upgrade>`

*   Use pf-bb-config to configure Intel FPGA N3000

    The **pf-bb-config** package is used to statically configure the baseband
    device within N3000 devices.

    Guide: :ref:`N3000 FPGA Overview <n3000-overview>`

*   AIO-SX: Support for pci device/NIC replacement without host reinstall

    For replacement of N3000 or ACC100 device on a host, without requiring a
    host or system (in case of |AIO-SX|) re-install and re-configuration, in
    the case of the replaced device having **different vendor** or **device
    ID** information, see :ref:`N3000 and ACC100 replacement with different vendor or device-id <fec-replacement-with-different-vendor-or-device-id-b1ab1440e15f>`.

    For the replacement of a N3000 or ACC100 device on a host, without requiring
    a host or system (in case of |AIO-SX|) re-install and re-configuration, in
    the case of the replaced device having the **same vendor** and **device
    ID** information, see :ref:`N3000 and ACC100 replacement with the same vendor and device-id <n3000-and-acc100-replacement-with-the-same-vendor-and-device-id-cccabcdc5d43>`.

    For the replacement of a NIC on a host, without requiring a host or system
    (in case of |AIO-SX|) re-install and re-configuration, in the case of the
    replaced NIC having the same vendor or device ID information, see
    :ref:`NIC replacement with the same vendor and device-id <nic-replacement-with-the-same-vendor-and-device-id-32942b7b05e5>`.

    For the replacement of a NIC on a host, without requiring a host or system
    (in case of |AIO-SX|) re-install and re-configuration, in the case of the
    replaced NIC having different vendor or device ID information, see
    :ref:`NIC replacement with a different vendor or device-id <replace-a-nic-with-a-different-vendor-or-device-id-b406c1c190a9>`.

•   Allow admin password change without controller host lock

    In a subcloud, if the |CLI| command returns an authentication after you
    source the script ``/etc/platform/openrc``, you can verify the password on
    the subcloud by using the :command:`env \| grep OS\_PASSWORD` command. If it
    returns the old password, you will need to run the :command:`keyring set CGCS admin`
    command and provide the new admin password.

*   Subcloud Deployment with Local Installation

    Subcloud Install is enhanced to support a local install option for Redfish
    supported servers that are “Prestaged” with a valid install bundle.

    Prestaging can be done manually or automated by building a
    self-installing “Prestaging ISO” image using the ``gen-prestaged-is.sh`` tool.
    This tool accepts parameters that include install bundle components and
    produces a “Prestaging ISO”.

    Guide: :ref:`Subcloud Deployment with Local Installation <subcloud-deployment-with-local-installation-4982449058d5>`


----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for a number of defects. Refer to the StarlingX bug
database to review the `R6.0 fixed defects
<https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&search=Search&field.status%3Alist=FIXRELEASED&field.tag=stx.6.0>`_.


-----------------
Known limitations
-----------------

The following are known limitations in this release. Workarounds
are suggested where applicable. Note that these limitations are considered
temporary and will likely be resolved in a future release.

*   N/A


