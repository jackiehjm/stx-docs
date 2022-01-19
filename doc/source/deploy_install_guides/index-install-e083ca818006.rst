.. _index-install-e083ca818006:

===================
Installation Guides
===================

Installation and deployment guides for StarlingX are release-specific.
Each guide provides instruction on a specific StarlingX configuration
(e.g. All-in-one Simplex).

-------------------------
Upcoming release (latest)
-------------------------

StarlingX R6.0 is under development.

.. toctree::
   :maxdepth: 1

   r6_release/index-install-r6-8966076f0e81


-----------------
Supported release
-----------------

StarlingX R5.0.1 is the most recent supported release of StarlingX.

Use the R5.0 Installation Guides to install R5.0.1.

.. toctree::
   :maxdepth: 1

   r5_release/index-install-r5-ca4053cb3ab9


-----------------
Archived releases
-----------------

To view the archived installation guides, see `Installation guides for R5.0 and
older releases <https://docs.starlingx.io/r/stx.5.0/deploy_install_guides/index.html>`_.




.. Add common files to toctree

.. toctree::
   :maxdepth: 1
   :hidden:

   bootable_usb
   nvme_config

.. Docs note: Starting with R5 (May 2021), team agreed that the latest/working
   branch will include the current & supported install guides only. The archived
   releases will only be available in a release-specific branch. The
   instructions below are modified to reflect this change.

.. Making a new release
.. 1. Copy the previous 'upcoming' release to the 'supported' release section.
      Copy the old 'supported' folder to the release-specific branch.
      Copy the toctree link into the Supported section of install landing page.
      Update intro text for the Supported release section to use the
      latest version.
.. 2. Add new 'upcoming' release, aka 'Latest' on the version button.
      If new upcoming release docs aren't ready, remove toctree from Upcoming
      section and just leave intro text. Update text for the upcoming
      release version. Once the new upcoming docs are ready, add them in the
      toctree here.

.. Adding new release docs
.. 1. Make sure the most recent release versioned docs are complete for that
      release.
.. 2. Make a copy of the most recent release folder e.g. 'r6_release.' Rename
      the folder for the new release e.g. 'r7_release'.
.. 3. Search and replace all references to previous release number with the new
      release number. For example replace all 'R6.0' with 'R7.0.' Also search
      and replace any links that may have a specific release number in the path.
.. 4. Link new version on this page (the index page).

