===================
Installation Guides
===================

Installation and deployment guides for StarlingX are release-specific.
Each guide provides instruction on a specific StarlingX configuration
(e.g. All-in-one Simplex).

.. _latest_release:

------------------------
Supported release (R4.0)
------------------------

StarlingX R4.0 is the most recent supported release of StarlingX.

.. toctree::
   :maxdepth: 1

   r4_release/index

-------------------------
Upcoming release (latest)
-------------------------

StarlingX R5.0 is under development.

.. toctree::
   :maxdepth: 1

   r5_release/index


-----------------
Archived releases
-----------------

.. toctree::
   :maxdepth: 1

   r3_release/index
   r2_release/index
   r1_release/index


.. Add common files to toctree

.. toctree::
   :maxdepth: 1
   :hidden:

   bootable_usb
   nvme_config


.. Making a new release
.. 1. Archive the previous 'supported' release.
      Move the toctree link from the Supported release section into the Archived
      releases toctree.
.. 2. Make the previous 'upcoming' release the new 'supported'.
      Move the toctree link from the Upcoming release section into the Supported
      release. Update intro text for the Supported release section to use the
      latest version.
.. 3. Add new 'upcoming' release, aka 'Latest' on the version button.
      If new upcoming release docs aren't ready, remove toctree from Upcoming
      section and just leave intro text. Update text for the upcoming
      release version. Once the new upcoming docs are ready, add them in the
      toctree here.

.. Adding new release docs
.. 1. Make sure the most recent release versioned docs are complete for that
      release.
.. 2. Make a copy of the most recent release folder e.g. 'r4_release.' Rename
      the folder for the new release e.g. 'r5_release'.
.. 3. Search and replace all references to previous release number with the new
      release number. For example replace all 'R4.0' with 'R5.0.' Also search
      and replace any links that may have a specific release number in the path.
.. 4. Link new version on this page (the index page).
