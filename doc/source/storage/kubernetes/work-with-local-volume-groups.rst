
.. zqw1590583956872
.. _work-with-local-volume-groups:

=============================
Work with Local Volume Groups
=============================

You can use the |prod-long| Horizon Web interface or the |CLI| to add local
volume groups and to adjust their settings.

.. rubric:: |context|

To manage the physical volumes that support local volume groups, see
:ref:`Work with Physical Volumes <work-with-physical-volumes>`.

.. rubric:: |proc|

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <hostname>

    <hostname> is the name or ID of the host.

#.  Open the Storage page for the host.

    #.  Select **Admin** \> **Platform** \> **Host Inventory**.

    #.  Click the name of the host to open the Host Details page.

    #.  Select the **Storage** tab.


#.  Click the Name of the group in the **Local Volume Groups** list.

#.  Select the Parameters tab on the Local Volume Group Detail page.

    You can now review and modify the parameters for the local volume group.

    .. image:: /shared/figures/storage/qig1590585618135.png
       :width: 550




