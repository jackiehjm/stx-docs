
.. clv1558615616705
.. _uploading-and-applying-updates-to-systemcontroller-using-the-cli:

=============================================================
Upload and Applying Updates to SystemController Using the CLI
=============================================================

You can upload and apply updates to the SystemController in order to update the
central update repository, from the CLI using the standard update procedures
for |prod|. For |prod-dc|, you must include an additional |CLI| parameter.

.. rubric:: |context|

If you prefer, you can use the Horizon Web interface. For more information, see
:ref:`Uploading and Applying Updates to SystemController Using Horizon
<uploading-and-applying-updates-to-systemcontroller-using-horizon>`, however
the specific procedure for incrementally uploading and applying one or more
patches for the SystemController is provided below.

For standard |prod| updating procedures, see the
 
.. xbooklink :ref:`|updates-doc| <software-updates-and-upgrades-software-updates>` guide.

For SystemController of |prod-dc| \(and the central update repository\), you
must include the additional |CLI| parameter ``--os-region-name`` with the value
SystemController when using |CLI| :command:`sw-patch` commands.

.. note::
    When adding a new subcloud, you only need to create and apply an update
    strategy to apply all updates that were previously applied in the system
    controller to the new subcloud.

.. note::
    The following existing :command:`sw-patch` commands are not supported in
    the System Controller region:


.. _uploading-and-applying-updates-to-systemcontroller-using-the-cli-ul-fvw-cj4-3jb:

-   :command:`sw-patch query-hosts`

-   :command:`sw-patch host-install`

-   :command:`sw-patch host-install-async`

-   :command:`sw-patch host-install-local`

-   :command:`sw-patch drop-host`

.. rubric:: |proc|

.. _uploading-and-applying-updates-to-systemcontroller-using-the-cli-steps-scm-jkx-fdb:

  
#.  Log in as the **sysadmin** user.

#.  Copy all patches to be uploaded and applied to /home/sysadmin/patches/.

#.  Upload all patches placed in /home/sysadmin/patches/ to the storage area.

    .. code-block:: none

        ~(keystone_admin)]$ sw-patch upload-dir /home/sysadmin/patches --os-region-name SystemController

    .. note::
    
        You may receive a warning about the update already being imported. This
        is expected and occurs if the update was uploaded locally to the system
        controller. The warning will only occur for patches that were applied
        to controller-0 \(system controller\) before it was first unlocked.

#.  Confirm that the newly uploaded patches have a status of **available**.

    .. code-block:: none

        ~(keystone_admin)]$ sw-patch query --os-region-name SystemController

#.  Apply all available updates in a single operation.

    .. code-block:: none

        ~(keystone_admin)]$ sw-patch apply --all --os-region-name SystemController

#.  Confirm that the updates have been applied.

    .. code-block:: none

        ~(keystone_admin)]$ sw-patch query --os-region-name SystemController

.. rubric:: |postreq|

To update the software on the System Controller and subclouds, you must use the
|prod-dc| Update Orchestration. For more information, see :ref:`Update
Orchestration of Central Cloud's RegionOne and Subclouds
<update-orchestration-of-central-clouds-regionone-and-subclouds>`.
