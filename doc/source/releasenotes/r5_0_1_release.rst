====================
R5.0.1 Release Notes
====================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

The pre-built ISO and Docker images for StarlingX release 5.0.1 are located at
the `CENGN StarlingX mirror
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/5.0.1/centos/flock/outputs/>`_.

------
Branch
------

The source code for StarlingX release 5.0.1 is available in the r/stx.5.0.1
branch in the `StarlingX repositories <https://opendev.org/starlingx>`_.

----------
Deployment
----------

A system install is required to deploy StarlingX release 5.0.1. There is no
upgrade path from previous StarlingX releases.

Use the `R5.0 Installation Guides <https://docs.starlingx.io/r/stx.5.0/deploy_install_guides/r5_release/index-install-r5-ca4053cb3ab9.html>`
to install R5.0.1.

-----------------------------
New features and enhancements
-----------------------------

None.


----------
Bug status
----------

**********
Fixed bugs
**********

This release provides fixes for the following bug.

* `1940696 <https://bugs.launchpad.net/starlingx/+bug/1940696>`_ Bootstrap of
  controller-0 failing due to missing tag in gcr.io registry


-----------------
Known limitations
-----------------

The following are known limitations in this release. Workarounds
are suggested where applicable. Note that these limitations are considered
temporary and will likely be resolved in a future release.

* `1925668 <https://bugs.launchpad.net/starlingx/+bug/1925668>`_ Bootstrap
  replay fails when changing mgmt subnet

  This item is fixed in the master branch.

  Running the bootstrap playbook will fail if it is re-run after first running
  it with one management subnet (default or specified) and then specifying a new
  management subnet.
