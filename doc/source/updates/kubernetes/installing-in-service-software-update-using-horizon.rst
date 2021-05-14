
.. jfc1552920636790
.. _installing-in-service-software-update-using-horizon:

================================================
Install In-Service Software Update Using Horizon
================================================

The procedure for applying an in-service update is similar to that of a
reboot-required update, except that the host does not need to be locked and
unlocked as part of applying the update.

.. rubric:: |proc|

.. _installing-in-service-software-update-using-horizon-steps-x1b-qnv-vw:

#.  Log in to the Horizon Web interface as the **admin** user.

#.  In |prod| Horizon, open the Software Management page.

    The Software Management page is available from **Admin** \> **Platform** \>
    **Software Management** in the left-hand pane.

#.  Select the Patches tab to see the current update status.

    The Patches page shows the current status of all updates uploaded to the
    system. If there are no updates, an empty Patch Table is displayed.

#.  Upload the update \(patch\) file to the update storage area.

    Click the **Upload Patch** button to display an upload window from which
    you can browse your workstation's file system to select the update file.
    Click the **Upload Patch** button once the selection is done.

    The update file is transferred to the Active Controller and is copied to
    the update storage area, but it has yet to be applied to the cluster. This
    is reflected in the Patches page.

#.  Apply the update.

    Click the **Apply Patch** button associated with the update. Alternatively,
    select the update first using the selection boxes on the left, and then
    click the **Apply Patches** button at the top. You can use this selection
    process to apply all updates, or a selected subset, in a single operation.

    The Patches page is updated to report the update to be in the
    *Partial-Apply* state.

#.  Install the update on **controller-0**.

    #.  Select the **Hosts** tab.

        The **Hosts** tab on the Host Inventory page reflects the new status of
        the hosts with respect to the new update state. In this example, the
        update only applies to controller software, as can be seen by the
        worker host's status field being empty, indicating that it is 'patch
        current'.

        .. image:: figures/ekn1453233538504.png

    #.  Next, select the Install Patches option from the **Edit Host** button
        associated with **controller-0** to install the update.

        A confirmation window is presented giving you a last opportunity to
        cancel the operation before proceeding.

#.  Repeat the steps 6 a,b, above with **controller-1** to install the update
    on **controller-1**.

#.  Repeat the steps 6 a,b above for the worker and/or storage hosts \(if
    present\).

    This step does not apply for |prod| Simplex or Duplex systems.

#.  Verify the state of the update.

    Visit the Patches page again. The update is now in the *Applied* state.

.. rubric:: |result|

The update is now applied, and all affected hosts have been updated.
