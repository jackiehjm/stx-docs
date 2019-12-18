===================
Installation Guides
===================

Installation and deployment guides for StarlingX are release-specific.
Each guide provides instruction on a specific StarlingX configuration
(e.g. All-in-one Simplex).

.. _latest_release:

-----------------------
Latest release (stable)
-----------------------

StarlingX R3.0 is the latest officially released version of StarlingX.

.. toctree::
   :maxdepth: 1

   r3_release/index

---------------------
Upcoming R4.0 release
---------------------

StarlingX R4.0 is the forthcoming version of StarlingX under development.

.. toctree::
   :maxdepth: 1

   r4_release/index


-----------------
Archived releases
-----------------

.. toctree::
   :maxdepth: 1

   r2_release/index
   r1_release/index


.. Add common files to toctree

.. toctree::
   :maxdepth: 1
   :hidden:

   bootable_usb
   nvme_config


.. Making a new release
.. 1. Archive the previous 'latest' release.
      Move the toctree link from the Latest release section into the Archived
      releases toctree.
.. 2. Make the previous 'upcoming' release the new 'latest.'
      Move the toctree link from the Upcoming release section into the Latest
      release. Update narrative text for the Latest release section to use the
      latest version.
.. 3. Add new 'upcoming' release.
      If the new upcoming release docs arent ready, remove toctree from Upcoming
      section and just leave narrative text. Update text for the upcoming release
      version. Once the new upcoming docs are ready, add them in the toctree here.

..      Adding new release docs
      .. 1. Make sure the most recent release versioned docs are complete for that
            release.
      .. 2. Make a copy of the most recent release folder e.g. 'r2_release.' Rename the
            folder for the new release e.g. 'r3_release'.
      .. 3. Search and replace all references to previous release number with the new
            release number. For example replace all 'R2.0' with 'R3.0.' Also search and
            replease any links that may have a specific release in the path.
      .. 4. Link new version on this page (the index page).
