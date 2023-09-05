.. _doc_contribute_guide:

===============================
Documentation Contributor Guide
===============================

This section describes the guidelines for contributing to the StarlingX
documentation.

.. contents::
   :local:
   :depth: 1

----------
Quickstart
----------

The StarlingX documentation uses reStructuredText (RST) markup syntax with
Sphinx extensions. It uses the same contribution setup and workflow as the
OpenStack documentation.

* `OpenStack Documentation Contributor Guide <https://docs.openstack.org/doc-contrib-guide/index.html>`_.

**********************
Setup for contribution
**********************

Follow the OpenStack instructions for `setting up for contribution
<https://docs.openstack.org/doc-contrib-guide/quickstart/first-timers.html#setting-up-for-contribution>`_.

*************
Make a change
*************

#. Make changes following the OpenStack instructions for:

   #. `Starting a change <https://docs.openstack.org/infra/manual/developers.html#starting-a-change>`_
   #. `Committing a change <https://docs.openstack.org/doc-contrib-guide/quickstart/first-timers.html#committing-a-change>`_.

      .. note::

         StarlingX requires the use of a **Signed-off-by** header. Use the
         :command:`-s` option with :command:`git commit`.


#. When writing documentation, follow `Writing style`_ and `RST conventions`_.

#. Build the documentation locally to verify your changes before committing.
   Follow the OpenStack instructions for
   `Building documentation <https://docs.openstack.org/doc-contrib-guide/docs-builds.html>`_.

#. If needed, follow up with edits to your patch following the OpenStack
   instructions for `Responding to requests <https://docs.openstack.org/doc-contrib-guide/quickstart/first-timers.html#responding-to-requests>`_.


--------------------------
Find tasks and help needed
--------------------------

If you are looking for work to complete:

* Refer to the `StarlingX documentation StoryBoard
  <https://storyboard.openstack.org/#!/project/starlingx/docs>`_ for topics that
  need content. Many topics have stub pages in the documentation with a link to
  the associated story.

* Find open `documentation bugs on Launchpad
  <https://bugs.launchpad.net/starlingx/+bugs?field.tag=stx.docs>`_.


If you make a contribution that has an the associated story, task, or bug in the
comment, link to the related story or bug as described in the
:ref:`Code Submission Guidelines <link-review-to-story>`.

-----------------
Docs organization
-----------------

Documentation for StarlingX is organized into the following sections:

:ref:`Introduction <index-intro-27197f27ad41>`
  Overview of the StarlingX project.

:ref:`Deployment Configurations <index-deploy-da06a98b83b1>`
  Supported deployment configuration options.

:ref:`Planning <index-planning-332af0718d15>`
  Requirements planning guidance.

:ref:`Installation <index-install-e083ca818006>`
  Release-specific installation and deployment guides.

:ref:`Security <index-security-84d0d8aa401b>`
  Detailed discusion of security configuration.

:ref:`System Configuration <index-sysconf-d511820651f0>`
  Detailed discussion of various post-installation configuration changes.

:ref:`Data Networks <index-datanet-e316bf6c2f6a>`
  Discussion of |prod| data network configuration and management.

:ref:`Node Management <index-node-mgmt-cd0f9d8eaee6>`
  Discussion of |prod| node configuration and management.

:ref:`Backup and Restore <index-backup-1b466179efc3>`
  Discussion of |prod| backup and restore procedures.

:ref:`Updates and Upgrades <index-updates-e3b970bb69ce>`
  Discussion of |prod| update and upgrade procedures.

:ref:`KubeVirt <index-kubevirt-f1bfd2a21152>`
  Overview of |VM| support using KubeVirt.

:ref:`Admin Tasks <index-admintasks-768a6e9aaeff>`
  Overview of common administrator tasks.

:ref:`User Tasks <index-usertasks-b18b379ab832>`
  Overview of common user tasks.

:ref:`Guest Integration <index-guest-ef8c9a20bf6c>`
  Overview of various guest integrations.

:ref:`Distributed Cloud <index-dist-cloud-f5dbeb16b976>`
  Discussion of |prod| |prod-dc| for edge computing.

:ref:`Sample Application Deployment <index-sample-apps-15fce86ad4bf>`

:doc:`/archive/configuration/index`
  Configuration references for post-installation StarlingX system configuration.

:doc:`/operations/index`
  System administration and maintenance guides.

:doc:`/api-ref/index`
  REST API references for the StarlingX project. For additional information
  about where REST API documentation is located, see `API documentation`_.

:doc:`/cli_ref/index`
  Reference for the StarlingX project command line interface (CLI).

:doc:`/developer_resources/index`
  Resources for developers using or building StarlingX.

:doc:`/releasenotes/index`
  Release notes for all StarlingX releases.

:doc:`/contributor/index`
  Overview and guidelines for contributing to StarlingX documentation.

*****************
API documentation
*****************

The structure and location of the REST API documentation deserves extra
explanation.

Most REST API content is generated from the StarlingX project associated with
the API. For example, the documentation for the StarlingX metal REST API is
generated from the `metal repository <https://opendev.org/starlingx/metal>`_.

API references for StarlingX extensions are part of the docs repository, located
in the ``api-ref`` project:

* StarlingX extensions to the OpenStack Block Storage API
* StarlingX extensions to the OpenStack Compute API
* StarlingX extensions to the OpenStack Image API
* StarlingX extensions to the OpenStack Networking API

The ``api-ref`` project also contains index pages used by Sphinx to
generate the final content tree. Note that the REST API landing page used to
render content in the generated website is found in the ``doc`` project.

For additional information on the API documentation, refer to
:doc:`api_contribute_guide`.

******************
Spec documentation
******************

Spec documentation is found in the
`Starlingx specs project <https://opendev.org/starlingx/specs>`_.

The ``specs/2019.03`` directory contains the documentation files for approved
and implemented specs.

-------------
Writing style
-------------

.. begin-writing-style

StarlingX documentation follows many (but not all!) of the writing style
guidelines described in the `OpenStack documentation writing style guide
<https://docs.openstack.org/doc-contrib-guide/writing-style.html>`_. Differences
between the StarlingX and OpenStack practices are highlighted below.

* Use Title Case for page titles. For example:

  ::

    ===============================
    Documentation Contributor Guide
    ===============================

* Start section titles with an action verb. Do not use a gerund (word that ends
  with -ing). For example:

  ::

    ------------------
    Configure endpoint
    ------------------

.. end-writing-style

.. _create-rst-files:

----------------
Create rST Files
----------------

.. begin-create-rst-files

Use the :command:`tox -e newfile` command to create new |RST| files.

.. rubric:: |context|

All |RST| files created in StarlingX documentation repositories must have the
following characteristics:

* They must have unique file names.
* They must have |RST| labels at the beginning of the files that match the file
  names.

.. important::
    These rules apply to *index* files as well as those containing user
    documentation.

A utility is available for use from within each documentation repository you
have installed to generate uniquely named files for you.

.. rubric:: |prereq|

You must have :program:`uuidgen` installed on your system. This program is
included by default on most modern Linux distributions. If it is not installed,
consult your distribution's documentation for instructions.

.. rubric:: |proc|

#. Change to the directory where you wish to create a new topic.

   Typically, this will be below the :file:`doc/source` directory of the
   repository.

#. Run the following :command:`tox` command.

   .. code-block:: bash

       tox -e newfile

#. When prompted, enter a title for the new topic.

   .. code-block:: none
      :emphasize-lines: 3

       You are about to create a new reStructuredText file in

       /home/jdoe/starlingx/docs/doc/source/intro

       or a content fragment file in doc/source/_includes

       If this is not what you want, press CTL-C to quit and change to the directory
       you want to create the file in.

       Enter a title for the new topic. The file name and topic label used for
       linking will be based on this value.


       Topic title:

   #. Review the directory (an example is highlighted above) that the utility
      will create the new file in.

      .. note::
         This does not apply if you choose to create a content fragment using
         the :kbd:`f` option when prompted. In that case, the file will be
         saved to :file:`doc/source/_includes` regardless of your current
         working directory.

   #. If this is not correct, press :kbd:`CTL-C` to quit, change to the correct
      directory, and run the command again; otherwise, type the topic title and
      press :kbd:`ENTER`.

#. When prompted, select the type of |RST| stub file you want to create.

   .. code-block:: none

      Thanks. Now choose a topic type. Enter one of the following characters:

      t) A task topic. Will contain the outline of a procedure.
      i) An index.
      r) A reference topic. Will contain a minimal list-table definition.
      g) A minimal generic topic.
      f) A content fragment included in an rST file. Will be saved to doc/source/_includes.
      Topic type:

   Each option creates a stub file with different templated content useful for
   getting started. Press the corresponding key.

.. rubric:: |result|

The new |RST| file is created.


The title used in the new |RST| file matches what you typed exactly. However,
some changes have been made to the file name and topic label.

For example, if you entered ``Architectural Considerations!`` as a title,
listing the directory will show a file similar to the following:

.. code-block:: bash

    $ ls

.. code-block:: none

    architectural-considerations--d9dd4c105700.rst

The following changes were made.

* All alphabetical characters were converted to lower case.
* *Not shown* The characters ``+``, ``-``, ``@``, and ``&`` are replaced with
  ``plus``, ``minus``, ``at``, and ``and`` respectively.
* All spaces and other special characters, such as the ``!`` were replaced by
  dashes.
* A final dash and 12 digit random string were appended to the file name.
* The extension :file:`.rst` was added for all options except :kbd:`f`, in
  which case the extension :file:`.rest` was added.
* If you chose to create an ``index`` file by selecting :kbd:`i` when prompted,
  :file:`index-` was prepended to the file name.

Examining the file reveals that the label matches the file name, while the
title is preserved as typed. No label was added if you selected :kbd:`f`.

.. code-block:: bash

    cat architectural-considerations--d9dd4c105700.rst

.. code-block:: none
   :emphasize-lines: 1,4

   .. _architectural-considerations--d9dd4c105700:

   =============================
   Architectural Considerations!
   =============================

   .. content here

When you reference this file in ``toctree`` and ``ref`` directives, use
the file name/label string like this:  ``architectural-considerations--d9dd4c105700``

.. end-create-rst-files

------------------------
Automated quality checks
------------------------

.. begin-automated-quality-checks

Several automated checks are available to help improve and maintain the quality
of your documentation.

Some of these checks are run every time you perform a build and are intended to
catch errors before they are submitted for review. Others are invoked
independently of regular builds and are intended to identify problems prior to
a release.

*****************
Formatting checks
*****************

.. begin-post-build-checks

You can build the HTML documentation locally using the ``tox -e docs`` command.
After every successful build, several quality checks are performed against the
build HTML output.

.. parsed-literal::

   Checking for "grey bar" formatting errors in output ...
   Found 2 HTML file(s) with greybar formatting issues:
   ./dist_cloud/kubernetes/reinstalling-a-subcloud-with-redfish-platform-management-service.html
   ./dist_cloud/kubernetes/installing-a-subcloud-without-redfish-platform-management-service.html
   Using a browser, locate vertical grey bars in the left margin of the above file(s), then correct the issue(s) in the corresponding rST file(s).
   Checking for ".. include::" errors in output ...
   Checking for unexpanded substitution errors in output ...
   Found 1 HTML file(s) that may have unexpanded substitution(s):

   ./node_management/kubernetes/hardware_acceleration_devices/enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads.html:| 1d02      | |html-pipe|\ SATA\ |html-pipe| controller               | Intel Corporation   |

   Correct the issue(s) in the corresponding rST file(s).

This sample shows three problems.

.. list-table:: Post-check issues and remedies
   :header-rows: 1
   :stub-columns: 1
   :widths: auto

   * - Test
     - Explanation
     - Remedy
   * - Grey bars
     - Scans the output for evidence of |RST| vertical grey bars inserted into the
       output next to formatting errors and reports which files they were found
       in.​
     - #. Open the file :file:`doc/build/html/index.html` in a browser and
          navigate to the page reported in the output.

       #. Locate the grey bars.

          .. tip::
             Grey bars can be hard to find in some locations, such as notes,
             where they are obscured by a background fill. Look for other
             evidence of a problem such as an oversized font, text that
             appears to be randomly bolded, or senseless line breaks.

       #. Open the corresponding :file:`.rst` file and find the location
          matching the grey bars in the output.
       #. Correct the issue.

       .. hint::
            Grey bars are often caused by indentation errors.
   * - Include errors
     - Scans the output for malformed ``.. include::`` statements that result
       in |RST| code and unintended content being exposed and reports which
       files they were found in.​
     - As above, find the problem in the appropriate
       :file:`.rst` file by examining the :file:`.html` file reported. Look for
       code fragments associated with ``.. include::`` directives such as
       :start\ |html-comment|-after: and :end\ |html-comment|-before:
       that have been exposed in the final output.

       Correct the issues by making the code comply with the documentation at:

       https://docutils.sourceforge.io/docs/ref/rst/directives.html#include
   * - Substitution errors
     - Scans the output for potential unexpanded substitutions such as
       |html-pipe|\ prod\ |html-pipe| and reports which files they were found in, along with the
       offending lines of HTML.

       .. note::
           This check cannot distinguish between a substitution and an ascii
           output table where cells are not properly padded. In either case, the
           problem needs to be fixed.

     - As above, find the problem in the appropriate :file:`.rst` file by
       examining the :file:`.html` file reported. Look for |html-pipe|\ <text>\ |html-pipe| code
       exposed in the output. In the corresponding :file:`.rst`, find and
       correct the issue.

       .. hint::
           Substitutions are not allowed in code blocks, :ref:, :doc:,
           or within |RST| markup such as ``**``, ``*```, `````, and so on.

           Substitutions cannot be used in ASCII "picture" style tables. If you
           need a substitution in a table, use the ``.. list-table::`` format
           instead.

.. end-post-build-checks

***********
Link checks
***********

Link checks are not performed as part of regular documentation builds. They are
intended to be run periodically and prior to a release.

You can invoke the Sphinx link checker with the following command:

.. code-block:: bash

    $ tox -e linkcheck

Sphinx will perform a temporary build and then attempt to follow all external
links from the output files. Results are reported on the console and
logged for future use.

.. note::

   You may need to disconnect any corporate firewall or VPN to allow the link
   checker to reach external sites.

**Console output**

The following two lines illustrate output for a valid and a bad link on lines 1
and 2 respectively. In each case the name of the file being checked, the line
number the link was found on, and the link itself are reported. In the case of
a broken link, the server error code is also shown, in this case a 404 *file
not found* error. This indicates that the page may have moved or been deleted.

.. code-block:: none
    :linenos:

    (developer_resources/build_docker_image: line  120) ok        http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-stable-wheels.tar
    (developer_resources/build_docker_image: line  122) broken    http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-dev-wheels.tar - 404 Client Error: Not Found for url: http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-dev-wheels.tar

**Logs**

Non "OK" results such as *file not found* and *permanent redirect* are
logged under :file:`doc/build/linkcheck` in two files:

* :file:`doc/build/linkcheck/output.txt` provides a results log in plain-text
  format.

*  :file:`doc/build/linkcheck/output.json` provides the same information in
   ``JSON`` format.

Investigate all issues and update the links as needed. In the case of permanent
redirects, replace the existing URL with that of the redirect target.

************
Spell checks
************

Spell checks are not performed as part of regular documentation builds. They
are intended to be run periodically and prior to a release.

You can invoke the Sphinx link checker with the following command:

.. code-block:: bash

    $ tox -e spellcheck

Sphinx will perform a temporary build and then check the output against a US
English dictionary. Results are reported on the console and logged for future
use.

**Console output**

Console output shows the path and name of the file an error was found in, the
line number, the misspelled term and the full line to provide context.

.. code-block:: none

    doc/source/storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:41: Spell check: aditional: used as aditional disk volumes for VMs booted from images.


**Logs**

Spell check logs are stored under :file:`doc/build/spelling` in
:file:`*.spelling` files located and named for their :file:`rst` counterparts.

For example, errors found in the file:

:file:`doc/source/storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst`

are logged in the file:

:file:`doc/build/spelling/storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.spelling`

Log files itemize one issue per line. For example:

.. code-block:: none

    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:41: (aditional)  used as aditional disk volumes for VMs booted from images
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:68: (num)  For more information on how placement group numbers, (pg_num) can be set
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:72: (num)  group numbers (pg_num) required based on pg_calc algorithm, estimates on
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:116: (num)  To list all the pools with their pg_num values, use the following command,
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:119: (num)  To get only the pg_num / pgp_num value, use the following command,
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:119: (num)  To get only the pg_num / pgp_num value, use the following command,
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:142: (num)  Increasing pg_num of a pool has to be done in increments of 64/
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:142: (num)  pg_num number, retry and wait for the cluster to be
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:149: (num)  pg_num of that pool, using the following commands:
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:162: (num)  pgp_num should be equal to pg_num.
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:162: (num)  pgp_num should be equal to pg_num.
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:203: (num)  pg_num, pgp_num, crush_rule.
    storage/openstack/config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster.rst:203: (num)  pg_num, pgp_num, crush_rule

Note that the spell check in this example matched on the substring ``num``
several times in contexts such as ``pgp_num``. Cases such as this may call for
additional spell check customization.

Adding words
************

|org| documentation makes use of many technical terms that are not known to the
default dictionary.

You can add these to the file
:file:`doc/source/spelling_wordlist.txt`.

This file contains one term per line.

.. note::

    * Care should be taken when adding terms to a custom dictionary to avoid
      errors not being reported. For example, "fs" may be correct in a code
      block but a typo in some other context. As a general rule, it is better
      to have the spell checker over-report than under-report.

    * It is important that :file:`spelling_wordlist.txt` be kept in
      alphabetical order.

    * :file:`spelling_wordlist.txt` is under :program:`git` management and
      changes must be submitted for review and merge via a :program:`gerrit`
      review.

.. end-automated-quality-checks

---------------
RST conventions
---------------

StarlingX documentation follows many (but not all!) of the RST conventions
described in the `OpenStack documentation RST conventions guide
<https://docs.openstack.org/doc-contrib-guide/rst-conv.html>`_. If RST markup
is not listed in this section's quick reference, refer to the OpenStack guide.

For detailed information about RST and Sphinx extensions, refer to the following
documents:

* `Sphinx documentation <http://www.sphinx-doc.org/en/master/usage/restructuredtext/index.html>`_
* `reStructuredText primer <http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`_

--------------------------
Command prompt conventions
--------------------------

Command examples in |prod| are preceeded by a shell prompt. These prompts
provide readers with important hints about the context in which the command is
to be used. It is important that the following prompts be used consistently
throughout the |prod| documentation.

``$`` (dollar sign)
  Used to indicate that a command should be run in a Linux terminal as a
  regular user.

``#`` (pound or hash sign)
  Used to indicate that a command should be run in a Linux terminal as a
  root user.

``~(keystone_admin)]$``
  Used to indicate that the command must be run within the sourced environment
  of a system controller, i.e. after running 
  
  ``$ source /etc/platform/openrc``

-------------
Content reuse
-------------

.. _using-includes:

Content can be reused in multiple places using the Sphinx ``.. include::``
directive.

For example:

.. code-block::

   .. include:: /_includes/my_reusable_content.rest

"Include" files must not end in ``.rst``. The StarlingX convention is to use
``.rest``.

You can store multiple fragements of content in a single include file and use
them in various places. To do this, use ``rst`` comments to deliniate where
each begins and ends:

.. code-block::

   .. begin-fragement-1

      This content will be inserted using ``.. include::`` example 1, below.

   .. end-fragment-1

   .. begin-fragement-2

      This content will be inserted using ``.. include::`` example 2, below. 

   .. end-fragment-2

To use one or the other in an ``rst`` topic, use the *start after*
and *end before* parameters as shown below:

.. rubric:: **Example 1**

.. parsed-literal::

   ========
   My Topic
   ========

   Integer sed tortor nisi. Vivamus feugiat, urna in posuere gravida, ligula
   nunc hendrerit magna, nec tristique ex tortor non lorem.

   ...

   .. include:: /_includes/my_reusable_content.rest
      :start\ |html-comment|-after: begin-fragement-1
      :end\ |html-comment|-before: end-fragement-1

.. rubric:: **Example 2**

.. parsed-literal::

   ==============
   My Other Topic
   ==============

   Lorem ipsum dolor sit amet, consectetur adipiscing elit.

   ...

   .. include:: /_includes/my_reusable_content.rest
      :start\ |html-comment|-after: begin-fragement-2
      :end\ |html-comment|-before: end-fragement-2

**********************
Content reuse in steps
**********************

.. begin-content--in-steps

Inserting reusable or conditional steps in a numbered list context causes the
list to restart. For example:

An include file, ``mysteps.rest``, containing:

.. code-block:: rst

   .. begin-step

   #. Blue

   .. end-step

used in an ``rst`` file as follows:

.. parsed-literal::

   #. Orange

   #. Red

   .. include:: mysteps.rest
      :start\ |html-comment|-after: begin-step
      :end\ |html-comment|-before: end-step

   #. Green

Results in:

1. Orange

2. Red

1. Blue

2. Green

To avoid this, use substitute .. pre\ |html-comment|-include:: for ``.. include::``

.. parsed-literal::

   #. Orange

   #. Red

   .. pre\ |html-comment|-include:: mysteps.rest
      :start\ |html-comment|-after: begin-step
      :end\ |html-comment|-before: end-step

   #. Green

This will result in the expected numbering sequence:

1. Orange

2. Red

3. Blue

4. Green

.. note::

   * Only the start\ |html-comment|-after and end\ |html-comment|-before paramters work with ..
     pre\ |html-comment|-include::.

   * Indentation within the ``rest`` file being referenced must match the calling context. 

     * If the list is not indented, the additional step(s) to be inserted should
       not be indented.

     * If the list is indented (a sublist or in a nested block context), the
       same indentation must be applied to the additional steps.

.. end-content--in-steps

--------------------------
Content conditionalization
--------------------------

****************************
Conditionalize across builds
****************************

.. begin-conditionalize-content-across-builds

If you need to conditionalize some content to be used in a specific build
context, such as StarlingX or a 3rd party build that reuses StarlingX content,
you can use the ``.. only::`` directive.

For example:

.. code-block::

   .. only:: starlingx

      Integer sed tortor nisi. Vivamus feugiat, urna in posuere gravida, ligula
      nunc hendrerit magna, nec tristique ex tortor non lorem.

Three build contexts are available:

``starlingx``
   Content will be included in the standard StarlingX documentation build.

``partner``
   Content will be excluded from the StarlingX documentation build. To reuse
   this content in a 3rd party build, ensure that the ``partner`` tag is based
   to the builder.

``openstack``
   Content will be included in an OpenStack documentation context. This content
   is included in the StarlingX documentation build.

.. end-conditionalize-content-across-builds

***************************
Conditionalize across pages
***************************

.. begin-conditionalize-content-across-pages

If you want to reuse a block of content in multiple ``rst`` files from the same
build using ``.. include::`` directives, but need to exclude specific strings
from one of those locations, you can use the ``hideable`` role and substitution.

You can hide both strings and blocks (paragraphs etc.).

Hiding strings
**************

To hide a string, use the ``hideable`` role. For example:

.. code-block:: 

   .. start-prepare-servers-common
   
   Prior to starting the |prod| installation, ensure that the |bare-metal|
   servers are in the following state:
   
   ...
   
   -   BIOS configured with Intel Virtualization (VTD, VTX)
   
       -  Disabled for controller-only servers and storage servers.
   
       -  Enabled for :hideable:`controller+worker (All-in-one) servers and` worker servers.
   
   -   The servers are powered off.

   .. end-prepare-servers-common

In the ``rst`` file where you want to include the text marked up with the
``:hideable:`` role, simply insert the content using the :ref:`include
<using-includes>` directive:

.. parsed-literal::

   .. _aio_duplex_install_kubernetes_r7:

   ================================================
   Install Kubernetes Platform on All-in-one Duplex
   ================================================

   ... 

   --------------------------------
   Prepare Servers for Installation
   --------------------------------
   
   .. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
      :start\ |html-comment|-after: start-prepare-servers-common
      :end\ |html-comment|-before: end-prepare-servers-common

   ...

The bullet:

``-  Enabled for :hideable:`controller+worker (All-in-one) servers and` worker servers.``

will render as:

-  Enabled for controller+worker (All-in-one) servers and worker servers.


In the ``rst`` file where you want to suppress the text marked up with the
``:hideable:`` role, do the same, but add the ``|hideable|`` substitution at the
top of the file:

.. parsed-literal::

   \|hideable\|

   .. _aio_duplex_install_kubernetes_r7:

   ================================================
   Install Kubernetes Platform on All-in-one Duplex
   ================================================

   ... 

   --------------------------------
   Prepare Servers for Installation
   --------------------------------
   
   .. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
      :start\ |html-comment|-after: start-prepare-servers-common
      :end\ |html-comment|-before: end-prepare-servers-common

   ...

The bullet:

``-  Enabled for :hideable:`controller+worker (All-in-one) servers and` worker servers.``

will render as:

-  Enabled for worker servers.

Hiding blocks
*************

To hide a block, wrap it in a ``container`` directive with the argument ``hideable``

For example, create an include file ``install-status.rest`` with the
following contents:

.. code-block::
   
   The **deploy status** field has the following values:
   
   .. container:: hideable
   
      ``Pre-Install``
          This status indicates that the ISO for the subcloud is being updated by
          the Central Cloud with the boot menu parameters, and kickstart
          configuration as specified in the ``install-values.yaml`` file.
   
      ``Installing``
          This status indicates that the subcloud's ISO is being installed from
          the Central Cloud to the subcloud using the Redfish Virtual Media
          service on the subcloud's |BMC|.
   
   .. container::
   
      ``Bootstrapping``
          This status indicates that the Ansible bootstrap of |prod-long|
          software on the subcloud's controller-0 is in progress.

and load it in two different contexts:

.. code-block::
   :caption: a.rst

   .. include:: install-status.rest

.. code-block::
   :caption: b.rst

   |hideable|

   .. include:: install-status.rest

The output from ``a.rst`` will include all three definitions. The output from
``b.rst`` will include only the ``bootstrap`` definition.

.. end-conditionalize-content-across-pages

-------------------
RST quick reference
-------------------

.. contents::
   :local:
   :depth: 1

********
Acronyms
********

Define acronym at first instance on page. After definition, use acronym only.

**Input:**

::

  :abbr:`CPU (Central Processing Unit)`

**Output:**

:abbr:`CPU (Central Processing Unit)`

************
Code samples
************

Format code snippets as standalone literal blocks.

**Input:**

::

  ::

    ping 8.8.8.8

**Output:**

::

    ping 8.8.8.8

********
Commands
********

Format commands using the Sphinx ``command`` role.

**Input:**

::

  :command:`system help`

**Output:**

Use the :command:`system help` command for the full list of options.

****************
Cross-references
****************

Cross-reference to arbitrary locations in a document using the ``ref`` role and a
named target. Named targets must precede a section heading. For more information
on references, see
`Internal Hyperlink Targets <http://docutils.sourceforge.net/docs/user/rst/quickref.html#internal-hyperlink-targets>`_.

**Input:**

::

  .. _my_named_target:

  **********
  My section
  **********

  This is the section we want to reference.

  ...

  This is the reference to :ref:`my_named_target`.

**Output:**

.. _my_named_target:

**********
My section
**********

This is the section we want to reference.

...

This is the reference to :ref:`my_named_target`.

******************
Information blocks
******************

Emphasize information using notices (an *admonition* in Sphinx). Different types
of notices exist to emphasize degrees of information importance.

**Input:**

::

  .. note::

     Use a ``note`` for a generic message.

  .. seealso::

     Use ``seealso`` for extra but helpful information.

  .. important::

     Use ``important`` for details that can be easily missed, but should not be
     ignored by a user and are valuable before proceeding.

  .. warning::

     Use ``warning`` to call out information the user must understand
     to avoid negative consequences.

**Output:**

.. note::

   Use a ``note`` for a generic message.

.. seealso::

   Use ``seealso`` for extra but helpful information.

.. important::

   Use ``important`` for details that can be easily missed, but should not be
   ignored by a user and are valuable before proceeding.

.. warning::

   Use ``warning`` to call out information the user must understand
   to avoid negative consequences.


***************
Inline elements
***************

Format most inline elements such as filenames and paths, code fragments,
parameters, or options with double back ticks.

**Input:**
::

  ``/path/to/file.name``
  ``--option``

**Output:**

Open the ``/path/to/file.name`` file.

Optionally pass the ``--option`` with the command.

Refer to the
`OpenStack Inline elements guide <https://docs.openstack.org/doc-contrib-guide/rst-conv/inline-markups.html>`_
for markup for other inline elements.

*****
Lists
*****

Use a bulleted list for a sequence of items whose order does not matter, such as
a list of features.

**Input:**

::

  * Banana
  * Apple
  * Orange

**Output:**

* Banana
* Apple
* Orange

Use an enumerated list for a sequence of items whose order matters, such as in
an ordered sequence of installation steps.

**Input:**

::

  #. Wash apple.
  #. Peel apple.
  #. Eat apple.

**Output:**

#. Wash apple.
#. Peel apple.
#. Eat apple.

Use a definition list for an unordered list where each item has a short
definition, such as term/definition pairs.

**Input:**

::

  Command A
    Description of command A.

  Command B
    Description of command B.

**Output:**

Command A
  Description of command A.

Command B
  Description of command B.

****************
Section headings
****************

Use up to three levels of headings in one file using the following characters:

* Heading 1 (Page Title in Title Case) - underline and overline with equal signs;

  * Heading 2 (Major page sections in Sentence case) - underline and overline with dashes;

    * Heading 3 (subsections in Sentence case) - underline and overline with asterisks.

Example RST:

.. code-block:: rest

   ==============
   Document Title
   ==============

   Introduce the topic using 1-2 concise sentences. It should tell the user what
   info can be found on this page.

   .. contents::  // Use a local TOC to aid user navigation in the page
      :local:
      :depth: 1

   ---------------
   Section heading
   ---------------

   Lorem ipsum dolor sit amet, consectetur adipiscing elit.

   ******************
   Subsection heading
   ******************

   Integer sed tortor nisi. Vivamus feugiat, urna in posuere gravida, ligula
   nunc hendrerit magna, nec tristique ex tortor non lorem.

------------------
Release activities
------------------

Several activies must be completed in preparation for each release.

*********************
Release notes updates
*********************

Various sections in the |prod| release notes must be updated on the ``master``
branch before the release branch for the upcoming release (for example
``r/stx.9.0``) is created. 

The Release notes can be found in the directory
:file:`doc/source/releasenotes`.

**********************
Version number updates
**********************

Product and related software version numbers must be updated throughout the
source :file:`rst` files.

* Some of these changes must me made manually by searching for and replacing
  the appropriate values.

* More common version values are implemented as Sphinx substitutions: simple,
  reusable placeholders.

  * For the current version of |prod|, edit the value of ``this-ver`` in the
    file :file:`doc/source/_this.txt`.

    .. code-block::

      .. |this-ver| replace:: r9.0

  * For other values, consult the file
    :file:`doc/source/_vendor/vendor_strings.txt`.

********************
Version menu updates
********************

A menu is available on each page of |prod| documentation to allow easy
switching between documentation versions. This menu must be updated on
``master`` and each release branch.

To do so:

#. On a working branch, open the file :file:`doc/source/conf.py`.

#. If you are updating on a new branch, change the configuration assignment
   ``starlingxdocs_plus_this_version`` to the name of the new branch. 

   For example:

   .. code-block::

      starlingxdocs_plus_this_version="Version 9.0"

   Otherwise, confirm that the value is correct for the branch you are
   updating.

#. Locate the configuration assignment ``starlingxdocs_plus_other_versions``.

   This assignment takes a *key,value* pair for each branch other than the
   branch you are configuring.

   * Each key is the name of the branch that will appear in the menu. 
   * Each value is the name of the branch.
   
   For example, if you are editing :file:`conf.py` on the branch ``r/stx.7.0``,
   then this assignment would container a key pair for each of 

   ``r/stx.6.0``, ``r/stx.8.0``, ``<newer-release>`` ..., and ``master``.

   These pairs are separated by commas and must be listed from oldest to most
   recent, always ending with the ``master`` branch. The *key* for the
   ``master`` branch is ``Latest``.

   For example, for release 9.0, the ``r/stx.9.0`` version of this file would
   have this assignment:

   .. code-block::

      starlingxdocs_plus_other_versions = [("Version 6.0","r/stx.6.0"),("Version 7.0","r/stx.7.0"),("Version 8.0","r/stx.8.0"),("Latest","")]

   .. note::

      During a documentation build, Sphinx prepends a forward slash to each
      *value* in ``starlingxdocs_plus_other_versions`` to construct the correct
      URLs, such as ``https://docs.starlingx.io/r/stx.8.0/``. Since the
      ``master`` documentation is at the base URL ``docs.startlingx.io``, this
      means that the value must be an empty string, as show above.

*********************
Adding the promte job
*********************

A ``promote`` job must be created for merged reviews on a new release branch to
be published to docs.starlingx.io. 

.. rubric:: |prereq|

You must have the OpenStack ``project-config`` repo available.

.. rubric:: |proc|

#. In the ``project-config`` repo, open the file
   :file:`zuul.d/starlingx-jobs.yaml`.

#. Locate the ``promote-stx-tox-docs-site`` job.

#. Add the new branch to the list of branches that will be published.

   For example:

   .. code-block:: yaml
      :emphasize-lines: 21

      - job:
          name: promote-stx-tox-docs-site
          parent: opendev-promote-docs-base
          description: |
            Promote content from openstack-tox-docs job for
            starlingx/doc repository only.
      
            Publish the results of a sphinx build to
            /afs/.openstack.org/project/starlingx.io/www      
      
          final: true
          vars:
            download_artifact_job: openstack-tox-docs
          # add older release branches as desired
          branches:
            - master
            - r/stx.5.0
            - r/stx.6.0
            - r/stx.7.0
            - r/stx.8.0
            - r/stx.9.0

#. Save the file and commit a gerrit review.

See https://review.opendev.org/c/openstack/project-config/+/873266 for a
sample promote job update with reviewers.