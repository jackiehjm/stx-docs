==================
R2.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

You can find a pre-built ISO and Docker images for StarlingX release 2.0 at
`CENGN’s StarlingX mirror
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/2.0.0/centos/>`_.

------
Branch
------

The source code for StarlingX release 2.0 is available in the r/stx.2.0 branch
in the StarlingX git repositories.

----------
Deployment
----------

A full system install is required to deploy the StarlingX release 2.0.
There is no upgrade path from StarlingX release 1.0 (stx.2018.10)

-----------------------------
New features and enhancements
-----------------------------

The main feature in the StarlingX R2.0 release is the re-structuring of the
software to provide a containerized OpenStack cloud on top of a bare metal
Kubernetes cluster.  In R2.0 StarlingX manages the

* Dedicated physical servers
* Kubernetes services
* Containerized OpenStack services

This allows StarlingX to support the hosting of applications in multiple
scenarios. For example:

* On bare metal servers using OpenStack Ironic
* On virtual machines using OpenStack Nova
* In containers using Kubernetes

StarlingX 2.0 eliminates patches against upstream OpenStack. The 1.0 release of StarlingX included many patches against OpenStack Pike.  The 2.0 release contains
about 5 patches against Nova and is otherwise running completely unmodified Stein.

The 5 patches are back ports of the NUMA live migration fixes that were recently
accepted into upstream for OpenStack Train. This means that the next release of StarlingX will run completely unmodified OpenStack.

*****************************
R2.0 feature list and stories
*****************************

The list below provides a detailed list of features with the associated
StoryBoard entries for the features.

* Kubernetes container platform:

  `2002843, <https://storyboard.openstack.org/#!/story/2002843>`_
  `2004273, <https://storyboard.openstack.org/#!/story/2004273>`_
  `2004712, <https://storyboard.openstack.org/#!/story/2004712>`_
  `2004642, <https://storyboard.openstack.org/#!/story/2004642>`_
  `2004022, <https://storyboard.openstack.org/#!/story/2004022>`_
  `2003907, <https://storyboard.openstack.org/#!/story/2003907>`_
  `2003909, <https://storyboard.openstack.org/#!/story/2003909>`_
  `2004760, <https://storyboard.openstack.org/#!/story/2004760>`_
  `2005350, <https://storyboard.openstack.org/#!/story/2005350>`_
  `2003908, <https://storyboard.openstack.org/#!/story/2003908>`_
  `2004520, <https://storyboard.openstack.org/#!/story/2004520>`_
  `2005249, <https://storyboard.openstack.org/#!/story/2005249>`_
  `2004763, <https://storyboard.openstack.org/#!/story/2004763>`_
  `2002844, <https://storyboard.openstack.org/#!/story/2002844>`_
  `2005193, <https://storyboard.openstack.org/#!/story/2005193>`_
  `2002840, <https://storyboard.openstack.org/#!/story/2002840>`_
  `2005066, <https://storyboard.openstack.org/#!/story/2005066>`_
  `2004711, <https://storyboard.openstack.org/#!/story/2004711>`_
  `2004762, <https://storyboard.openstack.org/#!/story/2004762>`_
  `2005198, <https://storyboard.openstack.org/#!/story/2005198>`_
  `2004470, <https://storyboard.openstack.org/#!/story/2004470>`_
  `2003087, <https://storyboard.openstack.org/#!/story/2003087>`_
  `2004710, <https://storyboard.openstack.org/#!/story/2004710>`_
  `2004447, <https://storyboard.openstack.org/#!/story/2004447>`_
  `2004007, <https://storyboard.openstack.org/#!/story/2004007>`_
  `2003491, <https://storyboard.openstack.org/#!/story/2003491>`_
  `2002845, <https://storyboard.openstack.org/#!/story/2002845>`_
  `2002841, <https://storyboard.openstack.org/#!/story/2002841>`_
  `2002839 <https://storyboard.openstack.org/#!/story/2002839>`_

* Containerized Openstack services:

  `2002876, <https://storyboard.openstack.org/#!/story/2002876>`_
  `2003910, <https://storyboard.openstack.org/#!/story/2003910>`_
  `2004751, <https://storyboard.openstack.org/#!/story/2004751>`_
  `2005424, <https://storyboard.openstack.org/#!/story/2005424>`_
  `2004764, <https://storyboard.openstack.org/#!/story/2004764>`_
  `2004433, <https://storyboard.openstack.org/#!/story/2004433>`_
  `2005074 <https://storyboard.openstack.org/#!/story/2005074>`_

* Containerized OVS support as the default virtual switch:

  `2004649 <https://storyboard.openstack.org/#!/story/2004649>`_

* SR-IOV network device plug-in support:

  `2005208 <https://storyboard.openstack.org/#!/story/2005208>`_

* Ansible bootstrap deployment:

  `2004695 <https://storyboard.openstack.org/#!/story/2004695>`_

* Collected integration for platform resource monitoring:

  `2002823 <https://storyboard.openstack.org/#!/story/2002823>`_

* OVS-DPDK integration enhancements:

  `2004472, <https://storyboard.openstack.org/#!/story/2004472>`_
  `2002944, <https://storyboard.openstack.org/#!/story/2002944>`_
  `2002947 <https://storyboard.openstack.org/#!/story/2002947>`_

* CentOS upgrade to 7.6:

  `2004521, <https://storyboard.openstack.org/#!/story/2004521>`_
  `2004522, <https://storyboard.openstack.org/#!/story/2004522>`_
  `2004516, <https://storyboard.openstack.org/#!/story/2004516>`_
  `2004901, <https://storyboard.openstack.org/#!/story/2004901>`_
  `2004743, <https://storyboard.openstack.org/#!/story/2004743>`_
  `2003597 <https://storyboard.openstack.org/#!/story/2003597>`_

* qemu/libvirt updates:

  `2003395, <https://storyboard.openstack.org/#!/story/2003395>`_
  `2005212 <https://storyboard.openstack.org/#!/story/2005212>`_

* ceph upgrade to mimic:

  `2004540, <https://storyboard.openstack.org/#!/story/2004540>`_
  `2003605 <https://storyboard.openstack.org/#!/story/2003605>`_

* Openstack rebase to Stein:

  `2004765, <https://storyboard.openstack.org/#!/story/2004765>`_
  `2004583, <https://storyboard.openstack.org/#!/story/2004583>`_
  `2004455, <https://storyboard.openstack.org/#!/story/2004455>`_
  `2004751, <https://storyboard.openstack.org/#!/story/2004751>`_
  `2004765, <https://storyboard.openstack.org/#!/story/2004765>`_
  `2006167, <https://storyboard.openstack.org/#!/story/2006167>`_
  `2005750 <https://storyboard.openstack.org/#!/story/2005750>`_

* StarlingX-specific source patch removal:

  `2003857, <https://storyboard.openstack.org/#!/story/2003857>`_
  `2004583, <https://storyboard.openstack.org/#!/story/2004583>`_
  `2004600, <https://storyboard.openstack.org/#!/story/2004600>`_
  `2004869, <https://storyboard.openstack.org/#!/story/2004869>`_
  `2004610, <https://storyboard.openstack.org/#!/story/2004610>`_
  `2004607, <https://storyboard.openstack.org/#!/story/2004607>`_
  `2004427, <https://storyboard.openstack.org/#!/story/2004427>`_
  `2004386, <https://storyboard.openstack.org/#!/story/2004386>`_
  `2004312, <https://storyboard.openstack.org/#!/story/2004312>`_
  `2003394, <https://storyboard.openstack.org/#!/story/2003394>`_
  `2003112, <https://storyboard.openstack.org/#!/story/2003112>`_
  `2004455, <https://storyboard.openstack.org/#!/story/2004455>`_
  `2005212, <https://storyboard.openstack.org/#!/story/2005212>`_
  `2004557, <https://storyboard.openstack.org/#!/story/2004557>`_
  `2004477, <https://storyboard.openstack.org/#!/story/2004477>`_
  `2004406, <https://storyboard.openstack.org/#!/story/2004406>`_
  `2004404, <https://storyboard.openstack.org/#!/story/2004404>`_
  `2004216, <https://storyboard.openstack.org/#!/story/2004216>`_
  `2004203, <https://storyboard.openstack.org/#!/story/2004203>`_
  `2004135, <https://storyboard.openstack.org/#!/story/2004135>`_
  `2004133, <https://storyboard.openstack.org/#!/story/2004133>`_
  `2004109, <https://storyboard.openstack.org/#!/story/2004109>`_
  `2004108, <https://storyboard.openstack.org/#!/story/2004108>`_
  `2004020, <https://storyboard.openstack.org/#!/story/2004020>`_
  `2004019, <https://storyboard.openstack.org/#!/story/2004019>`_
  `2003803, <https://storyboard.openstack.org/#!/story/2003803>`_
  `2003767, <https://storyboard.openstack.org/#!/story/2003767>`_
  `2003765, <https://storyboard.openstack.org/#!/story/2003765>`_
  `2003759, <https://storyboard.openstack.org/#!/story/2003759>`_
  `2003758, <https://storyboard.openstack.org/#!/story/2003758>`_
  `2003757 <https://storyboard.openstack.org/#!/story/2003757>`_

* DevStack enablement:

  `2005285, <https://storyboard.openstack.org/#!/story/2005285>`_
  `2003160, <https://storyboard.openstack.org/#!/story/2003160>`_
  `2003163, <https://storyboard.openstack.org/#!/story/2003163>`_
  `2004370, <https://storyboard.openstack.org/#!/story/2004370>`_
  `2003161, <https://storyboard.openstack.org/#!/story/2003161>`_
  `2003159, <https://storyboard.openstack.org/#!/story/2003159>`_
  `2003126 <https://storyboard.openstack.org/#!/story/2003126>`_

* Miscellaneous build enhancements:

  `2004013, <https://storyboard.openstack.org/#!/story/2004013>`_
  `2004043 <https://storyboard.openstack.org/#!/story/2004043>`_
