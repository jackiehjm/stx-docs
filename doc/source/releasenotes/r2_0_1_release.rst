====================
R2.0.1 Release Notes
====================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

You can find pre-built ISO and Docker images for stx.2.0.1 at
`CENGN's StarlingX mirror,
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/2.0.1/centos/>`_

------
Branch
------

The source code for stx.2.0.1 is available in the r/stx.2.0 branch
in the StarlingX git repositories. The exact source code can be cloned by:

::

    repo init -u https://opendev.org/starlingx/manifest -b refs/tags/2.0.1b
    repo sync --force-sync

----------
Deployment
----------

A full system install is required to deploy stx.2.0.1. There is no upgrade
patch from StarlingX release 2.0.

-------
Changes
-------

The StarlingX 2.0.1 release provides fixes for the following bugs:

* `1817936 <https://bugs.launchpad.net/starlingx/+bug//1817936/>`_
  Periodic message loss seen between VIM and OpenStac REST APIs
* `1827246 <https://bugs.launchpad.net/starlingx/+bug//1827246/>`_
  Access to VM console not working as Horion redirects to
  novncproxy.openstack.svc.cluster.local
* `1830736 <https://bugs.launchpad.net/starlingx/+bug//1830736/>`_
  Ceph osd process was not recovered after lock and unlock on storage
  node with journal disk
* `1843915 <https://bugs.launchpad.net/starlingx/+bug//1843915/>`_
  Cannot apply a chart with a local registry
* `1843453 <https://bugs.launchpad.net/starlingx/+bug//1843453/>`_
  Calico configuration file has yaml format error
* `1836638 <https://bugs.launchpad.net/starlingx/+bug//1836638/>`_
  RT kernel memory leak when creating/deleting pods
* `1840771 <https://bugs.launchpad.net/starlingx/+bug//1840771/>`_
  CVE-2018-14618:NTLM buffer overflow via integer overflow
* `1836685 <https://bugs.launchpad.net/starlingx/+bug//1836685/>`_
  CVE: integer overflow in the Linux kernel when handling TCP
  Selective Acknowledgments (SACKs)
* `1837919 <https://bugs.launchpad.net/starlingx/+bug//1837919/>`_
  dbmon timeouts are too low
* `1838692 <https://bugs.launchpad.net/starlingx/+bug//1838692/>`_
  ansible replay fails if kubeadm init was not successful
