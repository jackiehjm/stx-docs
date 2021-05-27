===================
Installation Guides
===================

Installation and deployment guides for StarlingX are release-specific.
Each guide provides instruction on a specific StarlingX configuration
(e.g. All-in-one Simplex).

.. _latest_release:

------------------------
Supported release (R5.0)
------------------------

StarlingX R5.0 is the most recent supported release of StarlingX.

.. toctree::
   :maxdepth: 1

   r5_release/index



-----------------
Archived releases
-----------------

.. toctree::
   :maxdepth: 1

   r4_release/index
   r3_release/index
   r2_release/index
   r1_release/index


.. Add common files to toctree

.. toctree::
   :maxdepth: 1
   :hidden:

   bootable_usb
   nvme_config

.. Docs note: Starting with R5 (May 2021), team agreed that the latest/working
   branch will include the current install guides only. The archived releases
   will only be available in a release-specific branch. The instructions below
   are modified to reflect this change.

.. Making a new release
.. 1. Archive the previous 'supported' release.
      Move the toctree link from the Supported release section into the Archived
      releases toctree.
.. 2. Make the 'upcoming' release (in latest branch) the new 'supported'.
      Copy the toctree link from the latest branch into the Supported
      release section. Update intro text for the Supported release section to
      use the latest version number. Copy the new 'supported' install folder
      into this branch.

