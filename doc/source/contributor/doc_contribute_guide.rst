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

:doc:`/introduction/index`
  Overview of the StarlingX project.

:doc:`/deploy_install_guides/index`
  Release-specific installation and deployment guides.

:doc:`/configuration/index`
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

---------------
RST conventions
---------------

StarlingX documentation follows many (but not all!) of the RST conventions
described in the `OpenStack documentation RST conventions guide <https://docs.openstack.org/doc-contrib-guide/rst-conv.html>`_. If RST markup is
not listed in this section's quick reference, refer to the OpenStack guide.

For detailed information about RST and Sphinx extensions, refer to the following
documents:

* `Sphinx documentation <http://www.sphinx-doc.org/en/master/usage/restructuredtext/index.html>`_
* `reStructuredText primer <http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`_

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

  ~~~~~~~~~~
  My section
  ~~~~~~~~~~

  This is the section we want to reference.

  ...

  This is the reference to :ref:`my_named_target`.

**Output:**

.. _my_named_target:

~~~~~~~~~~
My section
~~~~~~~~~~

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

   Integer sed tortor nisi. Vivamus feugiat, urna in posuere gravida, ligula nunc hendrerit magna, nec tristique ex tortor non lorem.

