==================
R4.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO and Docker images for StarlingX release 4.0 are located at the
`StarlingX mirror
<https://mirror.starlingx.windriver.com/mirror/starlingx/release/4.0.1/centos/flock/outputs/>`_.

------
Branch
------

The source code for StarlingX release 4.0 is available in the r/stx.4.0
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

A system install is required to deploy StarlingX release 4.0. There is no
upgrade path from previous StarlingX releases. For detailed instructions, see
the `Installation guides for R5.0 and older releases
<https://docs.starlingx.io/r/stx.5.0/deploy_install_guides/index.html>`_.

-----------------------------
New features and enhancements
-----------------------------

The list below provides a detailed list of new features and links to the
associated user guides (if applicable).

* Intel FPGA support for Kubernetes

  The Intel N3000 FPGA Programmable Acceleration Card is now supported
  in StarlingX, including support for orchestrating updates to the
  card's firmware.

  Guide: :doc:`Host FPGA Configuration for the Intel N3000 FPGA Programmable
  Acceleration Card </archive/configuration/intel_n3000_fpga>`

* Kata Containers

  Workloads can now be deployed in Kata Containers by StarlingX, which
  provides a higher degree of isolation than workloads in generic containers.

  Guide: :doc:`How to run Kata Containers with Kubernetes on StarlingX
  </operations/kata_container>`

* Active Directory Integration for Kubernetes APIs

  StarlingX administrators can now deploy an optional system application
  to support using Windows Active Directory for authentication of the
  Kubernetes API.

  Guide: :doc:`Authenticate Kubernetes Users with Windows Active Directory
  Server </archive/configuration/k8s_auth_winactivedir>`

* Certificate Manager Integration

  StarlingX now provides a Certification Manager to enable automated
  certificate issuance, monitor certificate expiration dates, and configure
  an auto-renew process.

  Guide: :doc:`Enable secure HTTPS access and manage certificates </archive/configuration/cert_config>`

* Time-Sensitive Networking (TSN) in Kata Containers

  Time-Sensitive Networking has been enabled for workloads running in Kata
  Containers.

  Guide: :doc:`Enable TSN in Kata Containers
  </developer_resources/stx_tsn_in_kata>`

* Upversion OpenStack services

  The built-in OpenStack services, including Keystone, Horizon, Barbican, and
  others, have been updated to Train. For more details, consult the
  `OpenStack documentation for Train <https://docs.openstack.org/train/>`_.

* Upversion OpenStack application

  The built-in OpenStack application has been updated to Ussuri. For
  more details, consult the `OpenStack documentation for Ussuri
  <https://docs.openstack.org/ussuri/>`_.

* Kubernetes support in backup and restore functionality

  Back up and restore is now available for workloads running in
  Kubernetes pods.

  Guide: :doc:`Backup and restore your deployment </developer_resources/backup_restore>`

* Kubernetes manual upgrade capability

  StarlingX now has the capability of updating the Kubernetes images
  installed on the platform.

  Guide: :doc:`Upgrade your Kubernetes version </archive/configuration/k8s_upgrade>`

* Redfish virtual media support

  StarlingX now supports the Redfish Virtual Media Controller to
  support a secure BMC based ISO image boot.

* Kernel rebase to 4.18

  The Linux kernel used by StarlingX has been upgraded to version 4.18 as
  provided in CentOS 8.

* Upversion Kubernetes components

  Kubernetes was upversioned to v1.18.1, Calico was upversioned to v3.12, and
  Helm was upversioned to v3.

* Layered build

  StarlingX builds have been monolithic and time consuming. The new Layered
  build system decomposes the system into separate layers that can be built
  independently. Both Layered and Monolithic builds are supported in this
  release.

  Guides: :doc:`Layered build reference (overview) </developer_resources/Layered_Build>`
  and :doc:`Layered build guide (step by step instructions) </developer_resources/layered_build_guide>`

* Open Platform Communications Unified Architecture (OPC UA) support

  OPC UA is a data exchange standard for industrial communication in the
  Industrial IoT (IIoT) category. StarlingX now supports OPC UA.

  Guide: :doc:`How to enable OPC UA on StarlingX </developer_resources/stx_opcua>`

----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for a number of defects. Refer to the StarlingX bug
database to review the `R4.0 fixed defects
<https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&search=Search&field.status%3Alist=FIXRELEASED&field.tag=stx.4.0>`_.

*********
Open bugs
*********

Use the StarlingX bug database to review `R4.0 open bugs
<https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&field.status%3Alist=NEW&field.status%3Alist=CONFIRMED&field.status%3Alist=TRIAGED&field.status%3Alist=INPROGRESS&field.status%3Alist=FIXCOMMITTED&field.status%3Alist=FIXRELEASED&field.status%3Alist=INCOMPLETE_WITH_RESPONSE&field.status%3Alist=INCOMPLETE_WITHOUT_RESPONSE&assignee_option=any&field.assignee=&field.bug_reporter=&field.bug_commenter=&field.subscriber=&field.structural_subscriber=&field.tag=stx.4.0+not-yet-in-r-stx40&field.tags_combinator=ALL&field.has_cve.used=&field.omit_dupes.used=&field.omit_dupes=on&field.affects_me.used=&field.has_patch.used=&field.has_branches.used=&field.has_branches=on&field.has_no_branches.used=&field.has_no_branches=on&field.has_blueprints.used=&field.has_blueprints=on&field.has_no_blueprints.used=&field.has_no_blueprints=on&search=Search>`_.

At the time of release, the following R4.0 bugs were open:

* `1890350 <https://bugs.launchpad.net/starlingx/+bug/1890350>`_
* `1887589 <https://bugs.launchpad.net/starlingx/+bug/1887589>`_
* `1870999 <https://bugs.launchpad.net/starlingx/+bug/1870999>`_
* `1879018 <https://bugs.launchpad.net/starlingx/+bug/1879018>`_
* `1881915 <https://bugs.launchpad.net/starlingx/+bug/1881915>`_
* `1886429 <https://bugs.launchpad.net/starlingx/+bug/1886429>`_
* `1888546 <https://bugs.launchpad.net/starlingx/+bug/1888546>`_

-----------------
Known limitations
-----------------

The following are known limitations in this release. Workarounds
are suggested where applicable. Note that these limitations are considered
temporary and will likely be resolved in a future release.

* `1887589 <https://bugs.launchpad.net/starlingx/+bug/1887589>`_ Creating a
  new instance with Horizon fails.



