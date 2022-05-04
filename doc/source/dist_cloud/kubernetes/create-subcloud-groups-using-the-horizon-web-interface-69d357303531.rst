.. _create-subcloud-groups-using-the-horizon-web-interface-69d357303531:

======================================================
Create Subcloud Groups Using the Horizon Web Interface
======================================================

.. rubric:: |prereq|

You must be in **SystemController** region. To change the region, see
:ref:`RegionOne and SystemController Modes
<regionone-and-systemcontroller-modes>`.

.. rubric:: |proc|

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** > **Orchestration**.

#.  On the **Orchestration** page, select the **Subcloud Group
    Management** tab.

#.  On the **Subcloud Group Management** tab, click **Add Subcloud Group**.

    .. image:: figures/create-subcloud-1.jpg
        :width: 1000px

#.  In the **Create New Subcloud Group** dialog box, adjust the settings as
    needed:

    -   Name
    -   Description
    -   Update apply type: Parallel or Serial; default Parallel.
    -   Maximum parallel subclouds: default 2

    .. image:: figures/create-subcloud-2.png

#.  Click **Create Subcloud Group**.
