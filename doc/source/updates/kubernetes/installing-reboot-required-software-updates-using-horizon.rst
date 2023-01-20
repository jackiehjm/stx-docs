
.. phg1552920664442
.. _installing-reboot-required-software-updates-using-horizon:

======================================================
Install Reboot-Required Software Updates Using Horizon
======================================================

You can use the Horizon Web interface to upload, delete, apply, and remove
software updates.

.. rubric:: |context|

This section presents an example of a software update workflow using a single
update. The main steps of the procedure are:


.. _installing-reboot-required-software-updates-using-horizon-ul-mbr-wsr-s5:

-   Upload the updates.

-   Lock the host\(s\).

-   Install updates; any unlocked nodes will reject the request.

-   Unlock the host\(s\). Unlocking the host\(s\) automatically triggers a
    reboot.

.. rubric:: |proc|

.. _installing-reboot-required-software-updates-using-horizon-steps-lnt-14y-hjb:

#.  Log in to the Horizon Web interface as the **admin** user.

#.  In Horizon, open the Software Management page.

    The Software Management page is available from **Admin** \> **Platform** \>
    **Software Management** in the left-hand pane.

#.  Select the Patches tab to see the current status.

    The Patches page shows the current status of all updates uploaded to the
    system. If there are no updates, an empty Patch Table is displayed.

#.  Upload the update \(patch\) file to the update storage area.

    Click the **Upload Patches** button to display an upload window from which
    you can browse your workstation's file system to select the update file.
    Click the **Upload Patches** button once the selection is done.

    The update file is transferred to the Active Controller and is copied to
    the storage area, but it has yet to be applied to the cluster. This is
    reflected in the Patches page.

#.  Apply the update.

    Click the **Apply Patch** button associated with the update. Alternatively,
    select the update first using the selection boxes on the left, and then
    click the **Apply Patches** button at the top. You can use this selection
    process to apply all updates, or a selected subset, in a single operation.

    The Patches page is updated to report the update to be in the
    *Partial-Apply* state.

#.  Install the update on **controller-0**.

    .. _installing-reboot-required-software-updates-using-horizon-step-N10107-N10028-N1001C-N10001:

    #.  Select the **Hosts** tab.

        The **Hosts** tab on the Host Inventory page reflects the new status of
        the hosts with respect to the new update state. As shown below, both
        controllers are now reported as not 'patch current' and requiring
        reboot.

        .. image:: figures/ekn1453233538504.png

    #.  Transfer active services to the standby controller by selecting the
        **Swact Host** option from the **Edit Host** button associated with the
        active controller host.

        .. note::
            Access to Horizon may be lost briefly during the active controller
            transition. You may have to log in again.

    #.  Select the Lock Host option from the **Edit Host** button associated
        with **controller-0**.

    #.  Select the Install Patches option from the **Edit Host** button
        associated with **controller-0** to install the update.

        A confirmation window is presented giving you a last opportunity to
        cancel the operation before proceeding.

        Wait for the update install to complete.

    #.  Select the Unlock Host option from the **Edit Host** button associated
        with controller-0.

#.  Repeat steps :ref:`6
    <installing-reboot-required-software-updates-using-horizon-step-N10107-N10028-N1001C-N10001>`
    a to e, with **controller-1** to install the update on **controller-1**.

    .. note::
        For |prod| Simplex systems, this step does not apply.

#.  Repeat steps :ref:`6
    <installing-reboot-required-software-updates-using-horizon-step-N10107-N10028-N1001C-N10001>`
    a to e, for the worker and/or storage hosts.

    .. note::
        For |prod| Simplex or Duplex systems, this step does not apply.

#.  Verify the state of the update.

    Visit the Patches page. The update is now in the Applied state.


.. rubric:: |result|

The update is applied now, and all affected hosts have been updated.

Updates can be removed using the **Remove Patches** button from the Patches
page. The workflow is similar to the one presented in this section, with the
exception that updates are being removed from each host instead of being
applied.
