===============================
Documentation contributor guide
===============================

This guide provides information that allows you to contribute to the
`StarlingX documentation <https://docs.starlingx.io/>`_.

Information common to OpenStack workflow, writing styles, and conventions
is not included in this guide. Instead refer to the
`OpenStack Documentation Contributor Guide <https://docs.openstack.org/doc-contrib-guide/index.html>`_.

---------
Locations
---------

StarlingX documentation consists of several types of manuals and is found
in the `starlingx/docs`_ and `starlingx/specs`_ repositories.

You can clone these repositories by:

::

   $ git clone https://opendev.org/starlingx/docs.git
   $ git clone https://opendev.org/starlingx/specs.git

These projects contain hierarchy that organizes the documentation by topic:

Installation Guide
    Describes how to install StarlingX onto Bare Metal or into a virtual
    environment.

Developer Guide
    Describes how to build a StarlingX ISO image from the "master" branch.

Project Specifications
    Describes specifications, specification templates, and processes for
    submitting a specification.

REST API Reference
    Describes StarlingX APIs.

Release Notes
    Provides release-specific information.

Contribute
    Provides guides on how to contribute to StarlingX API documentation,
    release notes, and general documentation.

--------------------
Directory Structures
--------------------

Directory structures vary depending on the type of documentation involved.
Think of the structure as one or more RST files per book.

* A simple book consists of a single **index.rst** file.
* A more complicated book could consist of an **index.rst** file as the book's
  landing page and a set of additional RST files for major sections of the book.

The structure for the API Reference documentation deserves some extra explanation.
Most RST files for the API Reference content reside in top-level
StarlingX repositories, for example `starlingx/metal`_ or `starlingx/config`_.
However, four API Reference RST files reside in `starlingx/docs`_,
in **/api-ref/source**:

* "Block Storage"
* "Compute"
* "Image"
* "Network".

While there is a **/api-ref/source/index.rst** file along
side these other four RST files, it exists only because the Sphinx process
needs that index file to build out the final web documentation tree.
The actual landing page (content) for the API Reference documents
is in the **/doc/source/api-ref/index.rst** file.

In the `starlingx/specs`_ project, the **/doc/source/index.rst**
file is the main landing page for the StarlingX specifications page
(<https://docs.starlingx.io/specs/index.html>`_).

The **/specs/2019.03** area contains the RST files for approved and
implemented specs.

-----------------
Updating a Manual
-----------------

If you need to update an existing manual, you need to find the appropriate RST
source file, make your modifications, test them (i.e. build the manual), and
then submit the changes to Gerrit for approval.

-----------------
Creating a Manual
-----------------

Creating a new manual involves at minimum providing a new **index.rst** file.
If the manual is more complex with additional content outside of the
**index.rst** file, you need to provide additional RST files as well.

As an example, consider a new manual that resides in **/doc/source/my-guide**.
Furthermore, suppose this manual's **index.rst** file contained two
links to additional complicated topics: "Topic 1" and
"Topic 2".

The content for the new manual exists in three files:

* **/doc/source/my-guide/index.rst**
* **/doc/source/my-guide/topic_1.rst**
* **/doc/source/my-guide/topic_2.rst**

Following shows the hierarchy:

::

    ├── doc
    │   └── source
    │       ├── my_guide
    │       │   ├── index.rst
    │       │   ├── topic_1.rst
    │       │   ├── topic_2.rst


-----------------------
Creating the Index File
-----------------------

The **index.rst** file provides captioning, a brief
description of the document, and the table-of-contents (TOC) structure
with instructions on how to display or hide sub-topics.

The syntax of the **index.rst** file is fixed. Following shows the
sample **index.rst** file for the new guide:

::

     ========
     My Guide
     ========

     The new guide.

     - :ref:`Topic 1 <topic_1>`
     - :ref:`Topic 2 <topic_2>`

     .. toctree::
        :hidden:

        topic_1
        topic_2

Following are explanations for each of the four areas of the
**index.rst** file:

-  **Reference title:** Literal title that is used in the rendered
   document.
   In this case it is "My Guide".
-  **Reference summary:** Literal summary of the rendered document.
   In this case it is "The new guide."
-  **Table-of-Contents tree structure and sub-topic parameters:** The
   directive to create a TOC and to specify the embedded topic links
   should remain hidden.
   If you want sub-topics to be part of the TOC, use the
   ":maxdepth: x" directive where "x" is the depth you desire for
   sub-topics in the TOC.
-  **RST source file root name:** The source files to use as content.
   In this case, the file references are "topic_1" and "topic_2".
   These reference the **topic_1.rst** and **topic_2.rst** files
   in the same folder as the **index.rst** file.

----------------------------------------------------
Integrating the New Guide Into the Documentation Set
----------------------------------------------------

The previous section described how you can provide the files
you need to create a new guide.
This section describes how to add your new guide to the table of contents in the 
documentation site.

The **/doc/source/index.rst** file contains the structure
that defines the StarlingX Documentation landing page.
Inside the file, is a "Sections" area that lists the documents
that appear in the table of contents.
Add your new guide to the toctree definition in the index.rst file.

--------------------------
Closing Out a Bug or Story
--------------------------

If you are modifying a document as a result of a defect or
feature that is associated with a StoryBoard Story or Launchpad
Bug, you must take steps to link your submission (Gerrit Review)
to the story or bug.

To link a story, add the following lines in your
commit message.
Be sure to use the actual story ID and task ID with the commit:

* Story: $story_id
* Task: $task_id

Following is an example that links a Gerrit Review with Story
2003375 and Task 2444:

::

   Change the tox.ini directory regarding tox.ini dependencies

   Story: 2003375
   Task: 24444

**NOTE:** You must provide a blank line before the lines
used to identify the Story and the Task.
Furthermore, you must place these lines as the last lines
in your commit message.
If you do not follow these guidelines, your submission will not
link to the Storyboard's story.

To link a bug, add the appropriate lines in your commit message.
Be sure to provide the actual bug numbers:

* Closes-Bug: $bug_id
* Partial-Bug: $bug_id
* Related-Bug: $bug_id

If your fix requires multiple commits, use "Partial-Bug"
for all the commits except the final one.
For the final commit, use "Closes-Bug".

Following is an example commit message that closes out bug
1804024:

::

   AIO Hardware Requirements: Updated AIO HW requirements.

   Added Small HW form factor information simplex/duplex
   AIO hardware requirements.

   Closes-Bug: #1804024

When you associate a story or bug with a Gerrit review, Gerrit
automatically updates the status of the story or bug once the
commit is merged.
Again, be sure to provide a blank line just before the line
identifying the bug.

You can find more information on the StarlingX code submission
guidelines on the
`wiki <https://wiki.openstack.org/wiki/StarlingX/CodeSubmissionGuidelines>`_.

To see the list of defects against StarlingX, see the
`Launchpad Application <https://bugs.launchpad.net/starlingx>`_.

--------------------------
Building the Documentation
--------------------------

To build the documentation locally in HTML format, use the
following command:

.. code:: sh

   $ tox -e docs

The resulting HTML files will be located in the **/doc/build**
directory:

::

     starlingx/docs/doc/
     ├── build
     │   └── html

----------------------------------
Viewing the Rendered Documentation
----------------------------------

To view the rendered documentation in a browser, open up
the **index.html** file in your browser.

**NOTE:** The PDF build uses a different tox environment and is
currently not supported for StarlingX.


.. _starlingx/docs: https://opendev.org/starlingx/docs
.. _starlingx/specs: https://opendev.org/starlingx/specs
.. _starlingx/metal: https://opendev.org/starlingx/metal
.. _starlingx/config: https://opendev.org/starlingx/config