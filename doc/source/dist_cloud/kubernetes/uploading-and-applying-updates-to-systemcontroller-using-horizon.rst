
.. iru1558615665841
.. _uploading-and-applying-updates-to-systemcontroller-using-horizon:

=============================================================
Upload and Applying Updates to SystemController Using Horizon
=============================================================

You can upload and apply updates \(patches\) to the SystemController in order
to update the central update repository, from the Horizon Web interface.

.. rubric:: |context|

If you prefer, you can use the |CLI|. For more information, see :ref:`Uploading
and Applying Updates to SystemController Using the CLI
<uploading-and-applying-updates-to-systemcontroller-using-the-cli>`.

.. rubric:: |proc|

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** \> **Software Management**.

#.  On the **Software Management** page, select the **Patches** tab.

    .. image:: figures/tmj1525095688715.png
        :width: 1000px


#.  On the **Patches** tab, click **Upload Patches**.

    In the **Upload Patches** dialog box, click **Browse** to select updates
    \(patches\) for upload.

    .. image:: figures/cah1525101473925.png

#.  In the dialog, click **Upload Patches**.

    The update is added to the Patches list in the **Available** state.

    .. image:: figures/uzw1525102534768.png

#.  Click **Apply Patch**.

    The state is updated to **Partial-Apply**.

.. rubric:: |postreq|

To update the software on the System Controller and subclouds, you must use the
|prod-dc| Update Orchestration. For more information, see :ref:`Update
Orchestration of Central Cloud's RegionOne and Subclouds
<update-orchestration-of-central-clouds-regionone-and-subclouds>`.

