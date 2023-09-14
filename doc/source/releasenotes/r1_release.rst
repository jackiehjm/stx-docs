==================
R1.0 Release Notes
==================

These are the release notes for StarlingX R1.0.

.. contents::
   :local:
   :depth: 1

---------
ISO Image
---------

You can find a pre-built image for R1.0 at the
`StarlingX mirror
<https://mirror.starlingx.windriver.com/mirror/starlingx/centos/2018.10/20181110/outputs/iso/>`__.

------------
New Features
------------

+-----------------------------------+-----------------------------------+
| StoryBoard ID                     | Feature                           |
+===================================+===================================+
| N/A                               | ovs-dpdk integration              |
+-----------------------------------+-----------------------------------+
| 2002820                           | Support for external Ceph backend |
+-----------------------------------+-----------------------------------+
| 2202821                           | Support for adding compute nodes  |
|                                   | to all-in-one duplex deployments  |
+-----------------------------------+-----------------------------------+
| 2002822                           | Support remote client for Windows |
|                                   | and Mac OS                        |
+-----------------------------------+-----------------------------------+
| 2003115                           | Deprecate proprietary Cinder      |
|                                   | volume backup and restore         |
+-----------------------------------+-----------------------------------+
| 2002825                           | Support Gnocchi storage backend   |
|                                   | for OpenStack telemetry           |
+-----------------------------------+-----------------------------------+
| 2002847                           | Add ntfs-3g packages              |
+-----------------------------------+-----------------------------------+
| 2002826                           | Memcached integration             |
+-----------------------------------+-----------------------------------+
| 2002935                           | Support for Precision Time        |
|                                   | Protocol (PTP)                    |
+-----------------------------------+-----------------------------------+
| 2003087                           | Generalized interface and network |
|                                   | configuration                     |
+-----------------------------------+-----------------------------------+
| 2003518                           | Enable Swift on controllers       |
+-----------------------------------+-----------------------------------+
| 2002712                           | StarlingX API documentation       |
+-----------------------------------+-----------------------------------+

-------------
Other changes
-------------

+-----------------------------------+-----------------------------------+
| StoryBoard ID                     | Change                            |
+===================================+===================================+
| 2002827                           | Decouple Service Management REST  |
|                                   | API from sysinv                   |
+-----------------------------------+-----------------------------------+
| 2002828                           | Decouple Fault Management from    |
|                                   | stx-config                        |
+-----------------------------------+-----------------------------------+
| 2002829                           | Decouple Guest-server/agent from  |
|                                   | stx-metal                         |
+-----------------------------------+-----------------------------------+
| 2002832                           | Replace compute-huge init script  |
+-----------------------------------+-----------------------------------+
| 2002834                           | Add distributed cloud repos to    |
|                                   | StarlingX                         |
+-----------------------------------+-----------------------------------+
| 2002846                           | Python Optimization               |
+-----------------------------------+-----------------------------------+
| 2003389, 2003596                  | Upgrade kernel and srpm/rpms to   |
|                                   | CentOS 7.5                        |
+-----------------------------------+-----------------------------------+
| 3003396, 2003339                  | Upgrade libvirt to 4.7.0          |
+-----------------------------------+-----------------------------------+
| 3002891                           | Stx-gui plug-in for Horizon       |
+-----------------------------------+-----------------------------------+
| Many                              | Build enhancements, cleanups and  |
|                                   | optimizations                     |
+-----------------------------------+-----------------------------------+
| Many                              | Enable basic zuul checks and      |
|                                   | linters                           |
+-----------------------------------+-----------------------------------+
| Many                              | Python 2 to 3 upgrade for         |
|                                   | stx-update, stx-metal, stx-fault, |
|                                   | stx-integ                         |
+-----------------------------------+-----------------------------------+

-------
Testing
-------

Review the R1.0
`test plan <https://wiki.openstack.org/wiki/StarlingX/stx.2018.10_Testplan>`__
for a list of tests executed on the R1.0 release.

View the
`testing summary <https://wiki.openstack.org/wiki/StarlingX/stx.2018.10_TestingSummary>`__
to see the status of testing for the R1.0 release.
