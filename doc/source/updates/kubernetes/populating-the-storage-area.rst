
.. fek1552920702618
.. _populating-the-storage-area:

=========================
Populate the Storage Area
=========================

Software updates \(patches\) have to be uploaded to the |prod| storage area
before they can be applied.

.. rubric:: |proc|

#.  Log in as **sysadmin** to the active controller.

#.  Upload the update file to the storage area.

    .. parsed-literal::

        $ sudo sw-patch upload /home/sysadmin/patches/|pn|-CONTROLLER_<nn.nn>_PATCH_0001.patch
        Cloud_Platform__CONTROLLER_nn.nn_PATCH_0001 is now available

    where *nn.nn* in the update file name is the |prod| release number.

    This example uploads a single update to the storage area. You can specify
    multiple update files on the same command separating their names with
    spaces.

    Alternatively, you can upload all update files stored in a directory using
    a single command, as illustrated in the following example:

    .. code-block:: none

        $ sudo sw-patch upload-dir /home/sysadmin/patches

    The update is now available in the storage area, but has not been applied
    to the update repository or installed to the nodes in the cluster.

#.  Verify the status of the update.

    .. code-block:: none

        $ sudo sw-patch query

    The update state is *Available* now, indicating that it is included in the
    storage area. Further details about the updates can be retrieved as
    follows:

    .. code-block:: none

       $ sudo sw-patch show <patch_id>
 
    The :command:`sudo sw-patch query` command returns a list of patch IDs.
    The :command:`sudo sw-patch show` command provides further detail about
    the specified <patch_id>.

#.  Delete the update files from the root drive.

    After the updates are uploaded to the storage area, the original files are
    no longer required. You must delete them to ensure there is enough disk
    space to complete the installation.

    .. code-block:: none

        $ rm /home/sysadmin/patches/*

    .. caution::
        If the original files are not deleted before the updates are applied,
        the installation may fail due to a full disk.

.. rubric:: |postreq|

When an update in the *Available* state is no longer required, you can delete
it using the following command:

.. parsed-literal::

    $ sudo sw-patch delete |pn|-|pvr|-PATCH_0001

The update to delete from the storage area is identified by the update
\(patch\) ID reported by the :command:`sw-patch query` command. You can provide
multiple patch IDs to the delete command, separating their names by spaces.
