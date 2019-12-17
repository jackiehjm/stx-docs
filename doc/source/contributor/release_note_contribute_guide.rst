===============================
Release Notes Contributor Guide
===============================

Release notes for StarlingX projects are managed using Reno allowing release
notes go through the same review process used for managing code changes.
Release documentation information comes from YAML source files stored in the
project repository, that when built in conjunction with RST source files,
generate HTML files. More details about the Reno Release Notes Manager can
be found at: https://docs.openstack.org/reno

.. contents::
   :local:
   :depth: 1

---------
Locations
---------

StarlingX release notes documentation exists in the following projects:

*  `starlingx/clients`_: StarlingX Client Libraries
*  `starlingx/config`_: StarlingX System Configuration Management
*  `starlingx/distcloud`_: StarlingX Distributed Cloud
*  `starlingx/distcloud-client`_: StarlingX Distributed Cloud Client
*  `starlingx/fault`_: StarlingX Fault Management
*  `starlingx/gui`_:  StarlingX Horizon plugins for new StarlingX services
*  `starlingx/ha`_: StarlingX High Availability/Process Monitoring/Service Management
*  `starlingx/integ`_: StarlingX Integration and Packaging
*  `starlingx/metal`_: StarlingX Bare Metal and Node Management, Hardware Maintenance
*  `starlingx/nfv`_: StarlingX NFVI Orchestration
*  `starlingx/tools`_: StarlingX Build Tools
*  `starlingx/update`_: StarlingX Installation/Update/Patching/Backup/Restore
*  `starlingx/upstream`_: StarlingX Upstream Packaging

--------------------
Directory structures
--------------------

The directory structure of release documentation under each StarlingX project
repository is fixed.  This example shows the ``stx-confi`` project:

::

	releasenotes/
	├── notes
	│   └── release-summary-6738ff2f310f9b57.yaml
	└── source
	    ├── conf.py
	    ├── index.rst
	    └── unreleased.rst


The initial modifications and additions to enable the API Documentation service
in each StarlingX project are as follows:

``.gitignore``
	Modifications to ignore the building directories and HTML files for the
	release notes.

``.zuul.yaml``
	Modifications to add jobs to build and publish the ``api-ref`` document.

``releasenotes/notes``
	Directory created to store your release notes files in YAML format.

``releasenotes/source``
	Directory created to store your API reference project directory.

``releasenotes/source/conf.py``
	Configuration file to determine the HTML theme, Sphinx extensions, and
	project information.

``releasenotes/source/index.rst``
	Source file to create your index RST source file.

``releasenotes/source/unrelased.rst``
	Source file to avoid breaking the real release notes build job on the master
	branch.

``doc/requiremets.txt``
	Modifications to add the ``os-api-ref`` Sphinx extension.

``tox.ini``
	Modifications to add the configuration to build the API reference locally.

See stx-config [Doc] Release Notes Management as an example of this first commit:
https://review.opendev.org/#/c/603257/

Once the Release Notes Documentation service has been enabled, you can create a new
release notes.

-------------------
Release notes files
-------------------

The following shows the YAML source file for the stx-config project:

`Release Summary R1.0 <http://git.openstack.org/cgit/openstack/stx-config/tree/releasenotes/notes/release-summary-6738ff2f310f9b57.yaml>`_

::

	stx-config/releasenotes/
	├── notes
	│   └── release-summary-6738ff2f310f9b57.yaml

To create a new release note that documents your code changes via the
tox newnote environment:

$ tox -e newnote hello-my-change

A YAML source file is created with a unique name under ``releasenote/notes/`` directory:

::

	stx-config/releasenotes/
	├── notes
	│   ├── hello-my-change-dcef4b934a670160.yaml

The content is grouped into logical sections based in the default template used by reno:

::

	features
	issues
	upgrade
	deprecations
	critical
	security
	fixes
	other

Modify the content in the YAML source file based on
`reStructuredText <http://www.sphinx-doc.org/en/stable/rest.html>`_ format.

------------------
Developer workflow
------------------

#. Start common development workflow to create your change: "Hello My Change".
#. Create its release notes, no major effort since title and content might
   be reused from the Git commit information.
#. Add your change including its release notes and submit for review.

---------------------
Release team workflow
---------------------

#. Start development work to prepare the release. This might include a
   Git tag.
#. Generate the Reno Report.
#. Add your change and submit for review.

.. _starlingx/clients: https://opendev.org/starlingx/clients
.. _starlingx/config: https://opendev.org/starlingx/config
.. _starlingx/distcloud: https://opendev.org/starlingx/distcloud
.. _starlingx/distcloud-client: https://opendev.org/starlingx/distcloud-client
.. _starlingx/fault: https://opendev.org/starlingx/fault
.. _starlingx/gui: https://opendev.org/starlingx/gui
.. _starlingx/ha: https://opendev.org/starlingx/ha
.. _starlingx/integ: https://opendev.org/starlingx/integ
.. _starlingx/metal: https://opendev.org/starlingx/metal
.. _starlingx/nfv: https://opendev.org/starlingx/nfv
.. _starlingx/tools: https://opendev.org/starlingx/tools
.. _starlingx/update: https://opendev.org/starlingx/update
.. _starlingx/upstream: https://opendev.org/starlingx/upstream
