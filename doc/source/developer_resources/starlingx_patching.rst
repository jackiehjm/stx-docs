.. _starlingx_patching:

==================
StarlingX patching
==================

This section describes how to update StarlingX systems using patches.

.. contents::
   :local:
   :depth: 1

------------
Introduction
------------

Deployed StarlingX systems can be updated using the StarlingX patching
feature, which provides the capability to update StarlingX systems before the
next major version is released. It can be used for bug fixes, security
vulnerabilities, feature enhancements, etc.

StarlingX patching supports two kinds of patches:

*  *In-service* patches, which don’t require a reboot for those hosts to be
   patched. Only affected processes need to be restarted.

*  *Reboot-required* patches, which require a host reboot operation to make the
   changes take effect. Hosts to be patched should be locked before applying the
   patch and unlocked after the patch is applied.

This document describes the patching process from the developer's perspective,
rather than being a product user guide. The patching process can be divided
into two stages: patch generation and patch applying, which are described in
the following sections.


----------------
Generate a patch
----------------

A StarlingX patch includes one or more rpms that contain some updates to the
system. Before starting to generate a patch, you must identify rpms to be
installed against the deployed system.

*****************************
Identify rpms to be installed
*****************************

First, figure out the software version of the deployed system, using either
the StarlingX Horizon GUI or using the CLI.

###############
Use Horizon GUI
###############

#. Access the StarlingX Horizon GUI by entering the OAM floating IP address in
   your browser: `\http://<oam-floating-ip-address>:8080`

   Discover your OAM floating IP address with the :command:`system oam-show` command.

#. Log in to Horizon with an admin/<sysadmin-password>.

#. Identify the software version of the deployed system by clicking
   :menuselection:`Admin > Platform > System Configuration` and clicking the
   :guilabel:`Systems` tab in the left-hand pane.

#################
Use StarlingX CLI
#################

#. In the CLI, use the :command:`system show` command on the active controller
   node to show the software version. In the example below, the software version
   is "19.09".

   ::

	controller-0:~$ . /etc/platform/openrc
	[sysadmin@controller-0 ~(keystone_admin)]$ system show
	+----------------------+--------------------------------------+
	| Property             | Value                                |
	+----------------------+--------------------------------------+
	| contact              | None                                 |
	| created_at           | 2019-10-14T03:10:50.862114+00:00     |
	| description          | None                                 |
	| https_enabled        | False                                |
	| location             | None                                 |
	| name                 | 608dfe48-9a05-4b21-afc1-ea122574caa7 |
	| region_name          | RegionOne                            |
	| sdn_enabled          | False                                |
	| security_feature     | spectre_meltdown_v1                  |
	| service_project_name | services                             |
	| software_version     | 19.09                                |
	| system_mode          | duplex                               |
	| system_type          | All-in-one                           |
	| timezone             | UTC                                  |
	| updated_at           | 2019-10-14T03:12:41.983029+00:00     |
	| uuid                 | 2639ad15-08a7-4f1b-a372-f927a5e4ab31 |
	| vswitch_type         | none                                 |
	+----------------------+--------------------------------------+


After you figure out the software version, check the latest StarlingX
build to identify updated rpms against that version. Select one or
more rpms for patch generation and continue to the next section.

*************
Build patches
*************

After you determine the rpms to be installed, set up an environment for
patch build. As a StarlingX developer, the easiest way to set up this type of
environment is to use a StarlingX build container, with a few changes.

#############
Prerequisites
#############

*  Set up a StarlingX build container following `the
   build guide <https://docs.starlingx.io/developer_resources/build_guide.html>`_.

*  Download StarlingX source code.

*  Be sure that the rpms to be installed are already available in the build
   container filesystem.

Set up the patch build environment using the steps below. Note that
this environment is intended for developers working on this feature
and is not intended to be used for a StarlingX-based product.

#. Install two python packages ``crypto`` and ``pycrypto``, which are the
   python dependencies of the ``cgcs-patch`` package.

   ::

    $ sudo pip install crypto pycrypto

#. Use the script ``$MY_REPO/stx/stx-update/extras/scripts/patch_build.sh``
   to build patches. This script sources the **PLATFORM_RELEASE**
   variable from the **release-info.inc** file, and sets up the PYTHONPATH to
   point to cgcs-patch package in the repo. This avoids the need to install
   cgcs-patch or manually set the PLATFORM_RELEASE variable.

   View the details of the patch build command using the command:
   ``$MY_REPO/stx/stx-update/extras/scripts/patch_build.sh -h``

   ::

	$ $MY_REPO/stx/stx-update/cgcs-patch/bin/patch_build --help
	Usage: patch_build [ <args> ] ... <rpm list>
	Options:
		--id <id>                   Patch ID
		--release <version>         Platform release version
		--status <status>           Patch Status Code (ie. O, R, V)
		--unremovable               Marks patch as unremovable
		--reboot-required <Y|N>     Marks patch as reboot-required (default=Y)
		--summary <summary>         Patch Summary
		--desc <description>        Patch Description
		--warn <warnings>           Patch Warnings
		--inst <instructions>       Patch Install Instructions
		--req <patch_id>            Required Patch
		--controller <rpm>          New package for controller
		--worker <rpm>              New package for worker node
		--worker-lowlatency <rpm>   New package for worker-lowlatency node
		--storage <rpm>             New package for storage node
		--controller-worker <rpm>   New package for combined node
		--controller-worker-lowlatency <rpm>   New package for lowlatency
		                            combined node
		--all-nodes <rpm>           New package for all node types

   You must specify the patch id, whether a reboot is required or not, any
   dependent patches, the file path of rpms, etc. For new rpm packages, you
   must specify which hosts require them using options, for example
   ``--controller``.

   When the command is finished, you get a patch file with the name
   ``<patch-id>.patch``.

Let’s dive a little deeper into the generated patch.

#. The patch file is a gzip compressed package. Check it
   using the :command:`file` command. Below is an example, including command output.

   ::

	$ file 001.patch
	001.patch: gzip compressed data, was "001.patch", last modified:
	Fri Aug 16 05:56:59 2019, max compression

#. Unzip the patch file to discover four files, ``software.tar``,
   ``metadata.tar``, ``signature``, and ``signature.v2``.

   ::

	$ tar -xf 001.patch
	$ tree
	├── 001.patch
	├── metadata.tar
	├── signature
	├── signature.v2
	└── software.tar

   *  Unzip ``software.tar`` to find that it contains all rpms to be
      installed. Note that all rpms have been signed during patch
      build using the key
      ``$MY_REPO/build-tools/signing/ima_signing_key.priv``.

   *  ``metadata.tar`` contains only one file ``metadata.xml``, which
      includes all the information provided by the patch build command. It is
      used by the StarlingX patching runtime system.

   *  ``signature`` is a combination of the md5 values of ``software.tar`` and
      ``metadata.tar``.

   *  ``signature.v2`` is a signature file for ``software.tar`` and
      ``metadata.tar``. In this case, it is generated using the key file
      ``$MY_REPO/build-tools/signing/dev-private-key.pem``.

-------------
Apply a patch
-------------

Once patches are generated, you can manually apply them to an applicable
StarlingX system. Both the StarlingX Horizon GUI and the CLI support the patch
applying operation. This example uses the CLI to show more detail.

The life cycle of a patch consists of the following states:

* **Available**: A patch in the Available state means it has been put into the
  patch storage area, but it has not been put into the software update
  repository and installed on any host yet.

* **Partial-Apply**: A patch in the Partial-Apply state means the patching
  process has been triggered by the :command:`sw-patch apply` command, but the
  patch has not been installed on all hosts that require it. It may have been
  installed on some hosts, but not all.

* **Applied**: A patch in the Applied state means it has been installed on all
  hosts that require it.

* **Partial-Remove**: A patch in the Partial-Remove state means the removing
  process has been triggered by the :command:`sw-patch remove` command, but the
  patch has not been removed from all hosts that installed it. It may have been
  removed from some hosts, but not all.

Before applying a patch, you must upload it to the file system of the active
controller. Uploading can be performed in many ways. Here is an example using
``scp``.

::

	scp <patch-id>.patch sysadmin@<oam_ip>:~/


The StarlingX patching system provides the client tool ``sw-patch``, which can
perform all types of patching operations. The many operations supported by
``sw-patch`` are listed below.

::

	controller-0:~$ sw-patch --help
	usage: sw-patch [--debug]
	                  <subcommand> ...

	Subcommands:
	    upload:         Upload one or more patches to the patching system.

	    upload-dir:     Upload patches from one or more directories to the
	                    patching system.

	    apply:          Apply one or more patches. This adds the specified
	                    patches to the repository, making the update(s)
	                    available to the hosts in the system. Use --all to
	                    apply all available patches.
	                    Patches are specified as a space-separated list of
	                    patch IDs.

	    remove:         Remove one or more patches. This removes the specified
	                    patches from the repository.
	                    Patches are specified as a space-separated list of
	                    patch IDs.

	    delete:         Delete one or more patches from the patching system.
	                    Patches are specified as a space-separated list of
	                    patch IDs.

	    query:          Query system patches. Optionally, specify 'query
	                    applied' to query only those patches that are applied,
	                    or 'query available' to query those that are not.

	    show:           Show details for specified patches.

	    what-requires:  List patches that require the specified patches.

	    query-hosts:    Query patch states for hosts in the system.

	    host-install:   Trigger patch install/remove on specified host. To
	                    force install on unlocked node, use the --force option.

	    host-install-async: Trigger patch install/remove on specified host. To
	                    force install on unlocked node, use the --force option.
	                    Note: This command returns immediately upon dispatching
	                    installation request.

	    install-local:  Trigger patch install/remove on the local host. This
	                    command can only be used for patch installation prior
	                    to initial configuration.

	    drop-host:      Drop specified host from table.

	    query-dependencies: List dependencies for specified patch. Use
	                    --recursive for recursive query.

	    is-applied:     Query Applied state for list of patches. Returns True
	                    if all are Applied, False otherwise.

	    report-app-dependencies: Report application patch dependencies,
	                    specifying application name with --app option, plus a
	                    list of patches. Reported dependencies can be dropped
	                    by specifying app with no patch list.

	    query-app-dependencies: Display set of reported application patch
	                    dependencies.

	    commit:         Commit patches to free disk space. WARNING: This
	                    action is irreversible!

	    --os-region-name: Send the request to a specified region

The following example demonstrates how to apply a patch to the system using
``sw-patch`` commands. This example applies an in-service patch to be
installed on all hosts in the system, and the StarlingX system is in a 2+2+2
configuration.

#. Upload the patch to the patching storage area using the
   :command:`sw-patch upload` command.

   ::

	controller-0:~$ sudo sw-patch upload 001.patch
	001 is now available

   Check the status of the patch with the :command:`sw-patch query` command.
   The “Patch State” value indicates that the patch is available in the system.

   ::

	controller-0:~$ sudo sw-patch query
	Patch ID  RR  Release  Patch State
	========  ==  =======  ===========
	001       N    19.09    Available

   Check the status of all hosts in the cluster with the
   :command:`sw-patch query-hosts` command.

   ::

	controller-0:/$ sudo sw-patch query-hosts
	Hostname      IP Address      Patch Current  Reboot Required  Release State
	============  ==============  =============  ===============  ======  =====
	worker-0      192.178.204.7        Yes             No          19.09   idle
	worker-1      192.178.204.9        Yes             No          19.09   idle
	controller-0  192.178.204.3        Yes             No          19.09   idle
	controller-1  192.178.204.4        Yes             No          19.09   idle
	storage-0     192.178.204.12       Yes             No          19.09   idle
	storage-1     192.178.204.11       Yes             No          19.09   idle

   The “Patch Current” value indicates whether or not there are patches
   pending for installation or removal on the host. “Yes” means no patch
   pending, and “No” means there is at least one patch pending.

#. Once the patch is in the Available state, trigger patch applying using the
   :command:`sw-patch apply` command.

   ::

	controller-0:/$ sudo sw-patch apply 001
	001 is now in the repo

   Check the status of the patch and the hosts again. As shown below, the
   patch is in the Partial-Apply state because it has not been installed on
   any host yet. The “Patch Current” value for all hosts are “No”.

   ::

	controller-0:~$ sudo sw-patch query
	Patch ID  RR  Release   Patch State
	========  ==  =======  =============
	001       N    19.09   Partial-Apply

   ::

	controller-0:~$ sudo sw-patch query-hosts
	Hostname      IP Address      Patch Current  Reboot Required  Release State
	============  ==============  =============  ===============  ======  =====
	worker-0      192.178.204.7        No              No          19.09   idle
	worker-1      192.178.204.9        No              No          19.09   idle
	controller-0  192.178.204.3        No              No          19.09   idle
	controller-1  192.178.204.4        No              No          19.09   idle
	storage-0     192.178.204.12       No              No          19.09   idle
	storage-1     192.178.204.11       No              No          19.09   idle

#. Install the patch on each host. In this case, it is an in-service patch, so
   you don’t need to lock hosts. (If the patch is a reboot-required patch, each
   node must be locked before the patch can be installed.)

   ::

	controller-0:~$ sudo sw-patch host-install controller-0
	...
	Installation was successful.

   Check the host status again. The “Patch Current” value of controller-0 has
   changed to “Yes” and the other “Patch Current” values are still “No”, which
   is expected.

   ::

	controller-0:~$ sudo sw-patch query-hosts
	Hostname      IP Address    Patch Current    Reboot Required  Release State
	============  ==============  =============  ===============  ======  =====
	worker-0      192.178.204.7        No              No          19.09   idle
	worker-1      192.178.204.9        No              No          19.09   idle
	controller-0  192.178.204.3        Yes             No          19.09   idle
	controller-1  192.178.204.4        No              No          19.09   idle
	storage-0     192.178.204.12       No              No          19.09   idle
	storage-1     192.178.204.11       No              No          19.09   idle

   To install the patch on all hosts, execute the command against each host.

   ::

	controller-0:~$ sudo sw-patch host-install controller-1
	....
	Installation was successful.
	controller-0:~$ sudo sw-patch host-install worker-0
	....
	Installation was successful.
	controller-0:~$ sudo sw-patch host-install worker-1
	....
	Installation was successful.
	controller-0:~$ sudo sw-patch host-install storage-0
	...
	Installation was successful.
	controller-0:~$ sudo sw-patch host-install storage-1
	...
	Installation was successful.

   Check the status of the patch and the hosts. The patch has been installed
   on all hosts as shown below. The “Patch Current” value of the hosts changed
   to “Yes” and the "Patch State" value changed to “Applied”.

   ::

	controller-0:~$ sudo sw-patch query
	Patch ID  RR  Release  Patch State
	========  ==  =======  ===========
	001       N    19.09     Applied

   ::

	controller-0:~$ sudo sw-patch query-hosts
	Hostname      IP Address      Patch Current Reboot Required  Release  State
	============  ==============  ============  ===============  =======  =====
	worker-0      192.178.204.7        Yes             No          19.09   idle
	worker-1      192.178.204.9        Yes             No          19.09   idle
	controller-0  192.178.204.3        Yes             No          19.09   idle
	controller-1  192.178.204.4        Yes             No          19.09   idle
	storage-0     192.178.204.12       Yes             No          19.09   idle
	storage-1     192.178.204.11       Yes             No          19.09   idle

   This output confirms that the patch ``001.patch`` has been applied to the
   whole system.

StarlingX patching also supports patch removal, using the
:command:`sw-patch remove` and :command:`sw-patch host-install` commands. The
procedure is similar to that of patch applying and is not described here.

-------------------
Patch orchestration
-------------------

In the example shown above, the hosts in the cluster were updated one by one.
For a case where the cluster size is very large, the updating process takes a
long time, and the situation takes longer for reboot-required patches. The
updating operation becomes very inefficient and can be a burden to the cluster
administrator. StarlingX has an advanced feature called *patch orchestration*.
It allows the whole system to be patched with a few operations, which
simplifies update tasks for the cluster administrator. The operations can be
performed using the CLI, the Horizon GUI, or the VIM RESTful API.

#. Using the StarlingX CLI client tool ``sw-manager``, you can create and
   apply a patch strategy, which then updates the whole system. The supported
   options are listed below.

   ::

	controller-0:~$ sw-manager patch-strategy -h
	usage: sw-manager patch-strategy [-h]  ...

	optional arguments:
	  -h, --help  show this help message and exit

	Software Patch Commands:

	    create    Create a strategy
	    delete    Delete a strategy
	    apply     Apply a strategy
	    abort     Abort a strategy
	    show      Show a strategy

   ::

	controller-0:~$ sw-manager patch-strategy create -h
	usage: sw-manager patch-strategy create [-h]
				[--controller-apply-type {serial,ignore}]
				[--storage-apply-type {serial,parallel,ignore}]
				[--worker-apply-type {serial,parallel,ignore}]
				[--max-parallel-worker-hosts {2,3,4,5,6,7,8,9,10,
				11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
				28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
				45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,
				62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,
				79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,
				96,97,98,99,100}]
				[--instance-action {migrate,stop-start}]
				[--alarm-restrictions {strict,relaxed}]

	optional arguments:
	  -h, --help            show this help message and exit
	  --controller-apply-type {serial,ignore}
	                        defaults to serial
	  --storage-apply-type {serial,parallel,ignore}
	                        defaults to serial
	  --worker-apply-type {serial,parallel,ignore}
	                        defaults to serial
	  --max-parallel-worker-hosts {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
			17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
			37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,
			57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,
			77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,
			97,98,99,100}
	                        maximum worker hosts to patch in parallel
	  --instance-action {migrate,stop-start}
	                        defaults to stop-start
	  --alarm-restrictions {strict,relaxed}
	                        defaults to strict

#. Using the Horizon GUI, click :menuselection:`Admin > Platform > Software Management`
   and click the :guilabel:`Patch Orchestration` tab.

#. Using the VIM API, `<http://\<oam_ip\>:4545>`_

   +--------+---------------------------------------+----------------------------+
   | Method | URI                                   | Description                |
   +========+=======================================+============================+
   | Post   | /api/orchestration/sw-update/strategy | Create a patch strategy    |
   +--------+---------------------------------------+----------------------------+
   | Delete | /api/orchestration/sw-update/strategy | Delete current patch       |
   |        |                                       | strategy                   |
   +--------+---------------------------------------+----------------------------+
   | Get    | /api/orchestration/sw-update/strategy | Get detailed information of|
   |        |                                       | current patch strategy     |
   +--------+---------------------------------------+----------------------------+
   | Post   | /api/orchestration/sw-update/strategy/| Apply or abort a patch     |
   |        | actions                               | strategy                   |
   +--------+---------------------------------------+----------------------------+

   The system must be in good condition to use patch orchestration. For example:

   * All hosts must be in the state of unlocked-enabled-available.
   * The system is clear of alarms.
   * Enough spare worker nodes for VM migration.

--------------
Current status
--------------

* The whole patching source code is already in StarlingX repositories, across
  several projects, like “update” and “nfv”.

* Patch generation and manual patch application have been roughly verified for
  both in-service patches and reboot-required patches. They are working.

* Patch orchestration has not been verified yet.
