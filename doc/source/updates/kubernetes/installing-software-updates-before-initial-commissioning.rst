
.. tla1552920677022
.. _installing-software-updates-before-initial-commissioning:

=====================================================
Install Software Updates Before Initial Commissioning
=====================================================

This section describes installing software updates before you can commission
|prod-long|.

.. rubric:: |context|

This procedure assumes that the software updates to install are available on a
USB flash drive, or from a server reachable by **controller-0**.

.. rubric:: |prereq|

When initially installing the |prod-long| software, it is required that you
install the latest available updates on **controller-0** before running Ansible
Bootstrap Playbook, and before installing the software on other hosts. This
ensures that:

.. _installing-software-updates-before-initial-commissioning-ul-gsq-1ht-vp:

-   The software on **controller-0**, and all other hosts, is up to date when
    the cluster comes alive.

-   You reduce installation time by avoiding updating the system right after an
    out-of-date software installation is complete.

.. rubric:: |proc|

#.  Install software on **controller-0**.

    Use the |prod-long| bootable ISO image to initialize **controller-0**.

    This step takes you to the point where you use the console port to log in
    to **controller-0** as user **sysadmin**.

#.  Populate the storage area.

    Upload the updates from the USB flash drive using the command
    :command:`sw-patch upload` or :command:`sw-patch upload-dir` as described
    in :ref:`Populating the Storage Area <populating-the-storage-area>`.

#.  Delete the update files from the root drive.

    After the updates are uploaded to the storage area, the original files are
    no longer required. You must delete them to ensure enough disk space to
    complete the installation.

    .. caution::
        If the original files are not deleted before the updates are applied,
        the installation may fail due to a full disk.

#.  Apply the updates.

    Apply the updates using the command :command:`sw-patch apply --all`.

    The updates are now in the repository, ready to be installed.

#.  Install the updates on the controller.

    .. code-block:: none

        $ sudo sw-patch install-local
        Patch installation is complete.
        Please reboot before continuing with configuration.

    This command installs all applied updates on **controller-0**.

#.  Reboot **controller-0**.

    You must reboot the controller to ensure that it is running with the
    software fully updated.

    .. code-block:: none

        $ sudo reboot

#.  Bootstrap system on controller-0.

    #.  Configure an IP interface.

        .. note::
            The |prod| software will automatically enable all interfaces and
            send out a |DHCP| request, so this may happen automatically if a
            |DHCP| Server is present on the network. Otherwise, you must
            manually configure an IP interface.

    #.  Run the Ansible Bootstrap Playbook. This can be run remotely or locally
        on controller-0.

.. include:: /_includes/installing-software-updates-before-initial-commissioning.rest

.. rubric:: |result|

Once all hosts in the cluster are initialized and they are all running fully
updated software. The |prod-long| cluster is up to date.


.. xbooklink From step 1
    For details, see :ref:`Install Software on controller-0
    <installing-software-on-controller-0>` for your system.