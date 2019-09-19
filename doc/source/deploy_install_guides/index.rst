==================================
Installation and Deployment Guides
==================================

Installation and deployment guides for StarlingX are release-specific.
Each guide provides instruction on a specific StarlingX configuration
(e.g. All-in-one Simplex).

-----------------------
Latest release (stable)
-----------------------

StarlingX R2.0 is the latest officially released version of StarlingX.

*************************
R2.0 virtual installation
*************************

.. toctree::
   :maxdepth: 1

   current/virtual_aio_simplex
   current/virtual_aio_duplex
   current/virtual_controller_storage
   current/virtual_dedicated_storage

****************************
R2.0 bare metal installation
****************************

.. toctree::
   :maxdepth: 1

   current/bare_metal_aio_simplex
   current/bare_metal_aio_duplex
   current/bare_metal_controller_storage
   current/bare_metal_dedicated_storage
   current/bare_metal_ironic

.. toctree::
   :maxdepth: 1
   :hidden:

   current/access_starlingx_kubernetes
   current/access_starlingx_openstack
   current/install_openstack
   current/uninstall_delete_openstack
   current/ansible_bootstrap_configs

---------------------
Upcoming R3.0 release
---------------------

The upcoming R3 release is the forthcoming version of StarlingX under development.

-----------------
Archived releases
-----------------

**************
StarlingX R1.0
**************

.. toctree::
   :maxdepth: 1

   r1_release/index
   r1_release/simplex
   r1_release/duplex
   r1_release/controller_storage
   r1_release/dedicated_storage



.. toctree::
   :maxdepth: 1
   :hidden:

   bootable_usb

.. Steps you must take when a new release of the deployment and installation
   guides occurs:

.. 1. Archive the "current" release:
         1. Rename the "current" folder to the release name to the release number eg. "r1_release".
         2. Go into the renamed folder (i.e. the old "current" folder) and update all links in the *.rst
         files to use the new path (e.g. :doc:`Libvirt/QEMU </installation_guide/current/installation_libvirt_qemu>`
         becomes
         :doc:`Libvirt/QEMU </installation_guide/<rX_release>/installation_libvirt_qemu>`
         3. You might want to change your working directory to /<Year_Month> and use Git to grep for
         the "current" string (i.e. 'git grep "current" *').  For each applicable occurrence, make
         the call whether or not to convert the string to the actual archived string "<Year_Month>".
         Be sure to scrub all files for the "current" string in both the "installation_guide"
         and "developer_guide" folders downward.
   2. Add the new "current" release:
         1. Rename the existing "upcoming" folders to "current".  This assumes that "upcoming" represented
         the under-development release that just officially released.
         2. Get inside your new folder (i.e. the old "upcoming" folder) and update all links in the *.rst
         files to use the new path (e.g. :doc:`Libvirt/QEMU </installation_guide/latest/installation_libvirt_qemu>`
         becomes
         :doc:`Libvirt/QEMU </installation_guide/current/installation_libvirt_qemu>`
         3. Again, scrub all files as per step 1.3 above.
         4. Because the "upcoming" release is now available, make sure to update these pages:
            - index
            - installation guide
            - developer guide
            - release notes
   3. Create a new "upcoming" release, which are the installation and developer guides under development:
         1. Copy your "current" folders and rename them "upcoming".
         2. Make sure the new files have the correct version in the page title and intro
         sentence (e.g. '2019.10.rc1 Installation Guide').
         3. Make sure all files in new "upcoming" link to the correct versions of supporting
         docs.  You do this through the doc link, so that it resolves to the top of the page
         (e.g. :doc:`/installation_guide/latest/index`)
         4. Make sure the new release index is labeled with the correct version name
         (e.g .. _index-2019-05:)
         5. Add the archived version to the toctree on this page.  You want all possible versions
         to build.
         6. Since you are adding a new version ("upcoming") *before* it is available
         (e.g. to begin work on new docs), make sure page text still directs user to the
         "current" release and not to the under development version of the manuals.













