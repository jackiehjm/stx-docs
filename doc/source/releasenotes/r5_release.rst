==================
R5.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO and Docker images for StarlingX release 5.0 are located at
the `CENGN StarlingX mirror
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/5.0.0/centos/flock/outputs/>`_.

------
Branch
------

The source code for StarlingX release 5.0 is available in the r/stx.5.0
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

A system install is required to deploy StarlingX release 5.0. There is no
upgrade path from previous StarlingX releases. For detailed instructions, see
the :doc:`R5.0 Installation Guides </deploy_install_guides/r5_release/index>`.

-----------------------------
New features and enhancements
-----------------------------

The list below provides a detailed list of new features and links to the
associated user guides (if applicable).

* Rook / Ceph

  A new storage backend rook-ceph to provide storage service to StarlingX.

  Guide: :ref:`Install StarlingX Kubernetes on Bare Metal Standard with Rook
  Storage <rook_storage_install_kubernetes>`

* FPGA image update orchestration for distributed cloud

  Added support for orchestrating updates to the Intel N3000 FPGA Programmable
  Acceleration Card across the subclouds in a distributed cloud configuration.

  Guide:  :ref:`Device Image Update
  Orchestration <device-image-update-orchestration>`

* Automatic certificate renewal for DC admin endpoints

  In Distributed Cloud configurations, ``admin`` endpoints for the platform
  keystone services (e.g. Configuration API, DC Manager API, etc.) on
  systemController and subclouds are HTTPS with internally generated
  certificates. This feature adds support for automatically renewing the
  certificates associated with these ``admin`` endpoints.

  Guide:  :ref:`Certificate Management for Admin REST API Endpoints
  <certificate-management-for-admin-rest-api-endpoints>`

* Vault integration for secret management support

  StarlingX now integrates the open source Vault secret management into the
  StarlingX solution. The StarlingX integration of Vault uses open source Raft
  (PVC-based) as its storage backend. For more information, refer to:
  https://www.vaultproject.io/

  The following services are supported:

  * Encryption-as-a-service / Secret Management: Vault provides data encryption
    for applications and is used to store and access secrets.
  * Vault-manager: The Vault-manager pod handles the initialization of Vault,
    configuring Transport Layer Security (TLS) for all Vault communication that
    provides the ability to automatically unseal Vault pods in deployments
    where an external autounseal provider is not available.

  Guide:  :ref:`Vault Overview <security-vault-overview>`

* Support for container image signature validation

  StarlingX supports image security policies using the Portieris admission
  controller. Portieris uses a Kubernetes Mutating Admission Webhook to modify
  Kubernetes resources such as pods, deployments, and others, at the point of
  creation, to ensure that Kubernetes runs only policy compliant images; for
  example, only signed images. The StarlingX integration of Portieris is
  integrated with cert-manager and works with external registries, with an
  associated Notary server for holding images’ trust data.

  Guide:  :doc:`Portieris Overview </security/kubernetes/portieris-overview>`

* Edgeworker for industrial deployments

  ``EdgeWorker`` is a new personality of nodes. Edgeworker nodes are typically
  small systems running dedicated workloads with Ubuntu as its operating system.
  They usually do not meet worker nodes' minimum requirements but now they can
  be managed by StarlingX.

  Guide: :doc:`Deploy Edgeworker Nodes </deploy/kubernetes/deploy-edgeworker-nodes>`

* SNMP v3 support

  StarlingX has updated its SNMP solution to be a containerized SNMP solution,
  delivered as an optional system application. Net-SNMP is still used as the
  underlying SNMP Agent. SNMP is configured through helm-overrides of the SNMP
  system application. The SNMP system application now supports both SNMPv2c
  and SNMPv3.

  Guide:  :ref:`SNMP Overview <snmp-overview>`

* Distributed cloud scaling

  The distributed cloud deployment now supports up to 200 |AIO-SX| subclouds.

  Guide:  :ref:`Distributed Cloud Architecture <distributed-cloud-architecture>`

* Secure Device Onboard (SDO)

  |SDO| is open source software that automates the “onboard” process, which
  occurs when an SDO device establishes the first trusted connection with a
  device management service. This release adds support for the SDO Rendezvous
  (RV) service.

  Guide:  :doc:`Enable SDO Rendezvous Service </developer_resources/stx_sdo_rv>`

* Hardware enablement

  Added support for Intel Ice Lake CPU, Intel Mt. Bryce eASIC (Pomona Lake),
  and Intel Columbiaville NIC.

  Guides:  :ref:`Configuring VF Interfaces Rate Limiting Using the CLI
  <configuring-vf-interfaces-rate-limiting-using-cli>` and :ref:`Verified
  Commercial Hardware <verified-commercial-hardware>`


----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for a number of defects. Refer to the StarlingX bug
database to review the `R5.0 fixed defects
<https://bugs.launchpad.net/starlingx/+bugs?field.searchtext=&orderby=-importance&search=Search&field.status%3Alist=FIXRELEASED&field.tag=stx.5.0>`_.


-----------------
Known limitations
-----------------

The following are known limitations in this release. Workarounds
are suggested where applicable. Note that these limitations are considered
temporary and will likely be resolved in a future release.

* `1925668 <https://bugs.launchpad.net/starlingx/+bug/1925668>`_ This item is
  fixed in the master branch.

  Running the bootstrap playbook will fail if it is re-run after first running
  it with one management subnet (default or specified) and then specifying a new
  management subnet.
