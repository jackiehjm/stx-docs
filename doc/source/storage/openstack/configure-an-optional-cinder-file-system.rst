
.. ble1606166239734
.. _configure-an-optional-cinder-file-system:

===================================================
Configure the Optional Image Conversion File System
===================================================

By default, **qcow2** to raw **image-conversion** is done using the
**docker_lv** file system. To avoid filling up the **docker_lv** file system,
you can create a new file system dedicated for image conversion as described in
this section.


.. rubric:: |prereq|


.. _configure-an-optional-cinder-file-system-ul-sbz-3zn-tnb:


*   The requested size of the image-conversion file system should be big enough
    to accommodate any image that is uploaded to Glance.

*   The recommended size for the file system must be at least twice as large as
    the largest converted image from qcow2 to raw.

*   The conversion file system can be added before or after |prefix|-openstack
    is applied.

*   The conversion file system must be added on both controllers. Otherwise,
    |prefix|-openstack will not use the new file system.

*   If the conversion file system is added after |prefix|-openstack is applied,
    changes to |prefix|-openstack will only take effect once the application is
    reapplied.

*   The **image-conversion** file system can only be added on the controllers, and
    must be added, with the same size, to both controllers. Alarms will be raised,
    if:


    -   The conversion file system is not added on both controllers.

    -   The size of the file system is not the same on both controllers.



.. _configure-an-optional-cinder-file-system-section-uk1-rwn-tnb:

--------------------------------------------
Adding a New Filesystem for Image-Conversion
--------------------------------------------


.. _configure-an-optional-cinder-file-system-ol-zjs-1xn-tnb:

#.  Use the :command:`host-fs-add` command to add a file system dedicated to
    qcow2 to raw **image-conversion**.

    .. code-block:: none

        ~(keystone_admin)]$ system host-fs-add <<hostname or id>> <<fs-name=size>>

    Where:

    **hostname or id**
        is the location where the file system will be added

    **fs-name**
        is the file system name

    **size**
        is an integer indicating the file system size in Gigabytes

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-fs-add controller-0 image-conversion=8
        +----------------+--------------------------------------+
        | Property       | Value                                |
        +----------------+--------------------------------------+
        | uuid           | 52bfd1c6-93b8-4175-88eb-a8ee5566ce71 |
        | name           | image-conversion                     |
        | size           | 8                                    |
        | logical_volume | conversion-lv                        |
        | created_at     | 2020-09-18T17:08:54.413424+00:00     |
        | updated_at     | None                                 |
        +----------------+--------------------------------------+

#.  When the **image-conversion** filesystem is added, a new partition
    /opt/conversion is created and mounted.

#.  Use the following command to list the file systems.

    .. code-block:: none

        ~(keystone_admin)]$ system host-fs-list controller-0
        +--------------------+------------------+-------------+----------------+
        | UUID               | FS Name          | Size in GiB | Logical Volume |
        +--------------------+------------------+-------------+----------------+
        | b5ffb565-4af2-4f26 | backup           | 25          | backup-lv      |
        | a52c5c9f-ec3d-457c | docker           | 30          | docker-lv      |
        | 52bfd1c6-93b8-4175 | image-conversion | 8           | conversion-lv  |
        | a2fabab2-054d-442d | kubelet          | 10          | kubelet-lv     |
        | 2233ccf4-6426-400c | scratch          | 16          | scratch-lv     |
        +--------------------+------------------+-------------+----------------+



.. _configure-an-optional-cinder-file-system-section-txm-qzn-tnb:

------------------------
Resizing the File System
------------------------

You can change the size of the **image-conversion** file system at runtime
using the following command:

.. code-block:: none

    ~(keystone_admin)]$ system host-fs-modify <hostname or id> <fs-name=size>

For example:

.. code-block:: none

    ~(keystone_admin)]$ system host-fs-modify controller-0 image-conversion=8



.. _configure-an-optional-cinder-file-system-section-ubp-f14-tnb:

------------------------
Removing the File System
------------------------


.. _configure-an-optional-cinder-file-system-ol-nmb-pg4-tnb:

#.  You can remove an **image-conversion** file system dedicated to qcow2
    **image-conversion** using the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system host-fs-delete <<hostname or id>> <<fs-name>>

#.  When the **image-conversion** file system is removed from the system, the
    /opt/conversion partition is also removed.


.. note::

    You cannot delete an **image-conversion** file system when
    |prefix|-openstack is in the **applying**,**applied**, or **removing**
    state.

    You cannot add or remove any other file systems using these commands.

