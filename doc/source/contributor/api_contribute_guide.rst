===================================
API Documentation Contributor Guide
===================================

OpenStack API working group has defined a guideline to follow for API
documentation when a project provides a REST API service. API
documentation information comes from RST source files stored in the
project repository, that when built, generate HTML files.

For additional information about the OpenStack guideline, refer to the
`OpenStack API documentation guide <https://docs.openstack.org/doc-contrib-guide/api-guides.html>`_.

.. contents::
   :local:
   :depth: 1

---------
Locations
---------

StarlingX API reference documentation exists in the following projects:

*  `starlingx/config`_: StarlingX System Configuration Management
*  `starlingx/docs`_: StarlingX Documentation

   *  *stx-python-cinderclient* // only StarlingX-specific
      extensions to Cinder API are documented here
   *  *stx-nova* // only StarlingX-specific extensions to Nova
      API are documented here
   *  *stx-glance* // only StarlingX-specific extensions to
      Glance API are documented here
   *  *stx-neutron* // only StarlingX-specific extensions to
      Neutron API are documented here

*  `starlingx/distcloud`_: StarlingX Distributed Cloud
*  `starlingx/fault`_: StarlingX Fault Management
*  `starlingx/ha`_: StarlingX High Availability/Process Monitoring/Service
   Management
*  `starlingx/metal`_: StarlingX Bare Metal and Node Management, Hardware
   Maintenance
*  `starlingx/nfv`_: StarlingX NFVI Orchestration

--------------------
Directory structures
--------------------

The directory structure of the API reference documentation under each
StarlingX project repository is fixed. This example shows the `starlingx/config`_
project:

::

	 stx-config/api-ref/
	 └── source
	     ├── api-ref-sysinv-v1-config.rst
	     ├── conf.py
	     └── index.rst

The initial modifications and additions to enable the API documentation
service in each StarlingX project are as follows:

``.gitignore``
	Modifications to ignore the building directories and HTML files for the API
	reference.

``.zuul.yaml``
	Modifications to add jobs to build and publish the ``api-ref`` document.

``api-ref/source``
	Directory created to store your API Reference project directory.

``api-ref/source/conf.py``
	Configuration file to set the HTML theme, Sphinx extensions, and project
	information.

``api-ref/source/index.rst``
	Source file to create your index RST source file.

``doc/requiremets.txt``
	Modifications to add the ``os-api-ref`` Sphinx extension.

``tox.ini``
	Modifications to add the configuration to build the API reference locally.

See `starlingx/config`_ [Doc] OpenStack API Reference Guide as an example of this
first commit: https://review.opendev.org/#/c/603258/

--------------------------
Create the RST source file
--------------------------

Once the API documentation service has been enabled, create the RST source files
that document the API operations under the same API reference documentation
project directory. The following example shows the RST source file for the
`starlingx/config`_ StarlingX System Configuration Management Configuration API v1:

::

	stx-config/api-ref/
	└── source
		└── api-ref-sysinv-v1-config.rst

---------------------
Create the index file
---------------------

After providing the RST source file as shown in the previous example, add the
``index.rst`` file. This file provides captioning, a brief description of the
document, and the Table-of-Contents structure with depth restrictions. The
``index.rst`` file is located in the same folder as the RST source file:

::

	stx-config/api-ref/
	|___source
	    |___api-ref-sysinv-v1-config.rst
	    |___index.rst

The syntax of the ``index.rst`` file is fixed. The following example shows the
``index.rst`` file used in the `starlingx/config`_:

::

	========================
	stx-config API Reference
	========================
	StarlingX System Configuration Management

	.. toctree::
	   :maxdepth: 2

	   api-ref-sys-v1-config


The ``index.rst`` file contains:

``Reference title``
	Literal title that is used in the rendered document. In this case it is
	"stx-config API Reference".

``Reference summary``
	Literal summary of the rendered document. In this case it is
	"StarlingX System Configuration Management".

``Table-of-Contents tree structure and depth parameters``
	The directive to create a TOC and to limit the depth of topics to "2".

``RST source file root name``
	The source file to use as content. In this case, the file reference is
	`api-ref-sys-v1-config`. This references the ``api-ref-sys-v1-config.rst``
	file in the same folder as the ``index.rst`` file.

------------------
REST method syntax
------------------

This section describes the syntax for each REST method in the RST source file
(for example ``api-ref-sys-v1-config.rst``).

::

	******************************************
	Modifies attributes of the System object
	******************************************
	.. rest_method:: PATCH /v1/isystems

	<  TEXT - description of the overall REST API >

	**Normal response codes**

	< TEXT - list of normal response codes  >

	**Error response codes**

	< TEXT – list of  error response codes  >

	**Request parameters**

	.. csv-table::
	   :header: "Parameter", "Style", "Type", "Description"
	   :widths: 20, 20, 20, 60
	   "ihosts (Optional)", "plain", "xsd:list", "Links for retreiving the list of hosts for this system."
	   "name (Optional)", "plain", "xsd:string", "A user-specified name of the cloud system. The default value is the system UUID."
	   < etc. >


::

	< verbatim list of an example REQUEST body >
	[
	    {
	       "path": "/name",
	       "value": "OTTAWA_LAB_WEST",
	       "op": "replace"
	    }
	    {
	       "path": "/description",
	       "value": "The Ottawa Cloud Test Lab - West Wing.",
	       "op": "replace"
	    }
	]


::

	**Response parameters**

	.. csv-table::
	   :header: "Parameter", "Style", "Type", "Description"
	   :widths: 20, 20, 20, 60
	   "ihosts (Optional)", "plain", "xsd:list", "Links for retreiving the list of hosts for this system."
	   "name (Optional)", "plain", "xsd:string", "A user-specified name of the cloud system. The default value is the system UUID."
	   < etc. >


::

	< verbatim list of an example RESPONSE body >
	{
	   "isystems": [
		  {
		    "links": [
		      {
		        "href": "http://192.168.204.2:6385/v1/isystems/5ce48a37-f6f5-4f14-8fbd-ac6393464b19",
		        "rel": "self"
		      },
		      {
		        "href": "http://192.168.204.2:6385/isystems/5ce48a37-f6f5-4f14-8fbd-ac6393464b19",
		        "rel": "bookmark"
		      }
		    ],
		    "description": "The Ottawa Cloud Test Lab - West Wing.",
		    "software_version": "18.03",
		    "updated_at": "2017-07-31T17:44:06.051441+00:00",
		    "created_at": "2017-07-31T17:35:46.836024+00:00",
	      }
	    ]
	}

---------------------------------
Build the reference documentation
---------------------------------

To build the API reference documentation locally in HTML format, use the
following command:

.. code:: sh

   tox -e api-ref

The resulting directories and HTML files looks like:

::

	api-ref
	|__build/
	├── doctrees
	│   ├── api-ref-sysinv-v1-config.doctree
	      ...
	└── html
	    ├── api-ref-sysinv-v1-config.html
	    ├── index.html
	     ...
	    └── _static

-----------------------------------------
View the rendered reference documentation
-----------------------------------------

To view the rendered HTML API reference document in a browser, open up
the ``index.html`` file.

.. _starlingx/config: https://opendev.org/starlingx/config
.. _starlingx/docs: https://opendev.org/starlingx/docs
.. _starlingx/distcloud: https://opendev.org/starlingx/distcloud
.. _starlingx/fault: https://opendev.org/starlingx/fault
.. _starlingx/ha: https://opendev.org/starlingx/ha
.. _starlingx/metal: https://opendev.org/starlingx/metal
.. _starlingx/nfv: https://opendev.org/starlingx/nfv

.. _starlingx/tools: https://opendev.org/starlingx/tools
.. _starlingx/update: https://opendev.org/starlingx/update
.. _starlingx/upstream: https://opendev.org/starlingx/upstream

