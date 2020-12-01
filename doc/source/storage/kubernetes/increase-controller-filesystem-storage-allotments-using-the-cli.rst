
.. xuj1552678789246
.. _increase-controller-filesystem-storage-allotments-using-the-cli:

===============================================================
Increase Controller Filesystem Storage Allotments Using the CLI
===============================================================

You can use the |CLI| to list or increase the allotments for controller-based
storage at any time after installation.

.. rubric:: |context|

For more information about increasing filesystem allotments, or to use the
Horizon Web interface, see :ref:`Increase Controller Filesystem Storage
Allotments Using Horizon
<increase-controller-filesystem-storage-allotments-using-horizon>`.

.. caution::
    Decreasing the filesystem size is not supported, and can result in
    synchronization failures requiring system re-installation. Do not
    attempt to decrease the size of the filesystem.

.. rubric:: |prereq|

Before proceeding, review the prerequisites given for :ref:`Increase
Controller Filesystem Storage Allotments Using Horizon
<increase-controller-filesystem-storage-allotments-using-horizon>`.

.. rubric:: |proc|


.. _increase-controller-filesystem-storage-allotments-using-the-cli-steps-ims-sxx-mcb:

#.  To review the existing storage configuration, use the
    :command:`system controllerfs-list` command.

    .. code-block:: none

        ~(keystone_admin)$ system controllerfs-list
        +-------------+-----------+------+--------------+------------+-----------+
        | UUID        | FS Name   | Size | Logical      | Replicated | State     |
        |             |           | in   | Volume       |            |           |
        |             |           | GiB  |              |            |           |
        |             |           |      |              |            |           |
        +-------------+-----------+------+--------------+------------+-----------+
        | aa9c7eab... | database  | 10   | pgsql-lv     | True       | available |
        |             |           |      |              |            |           |
        | 173cbb02... | docker-   | 16   | docker       |            |           |
        |             |           |      | distribution | True       | available |
        |             |           |      |-lv           |            |           |
        |             |           |      |              |            |           |
        | 448f77b9... | etcd      | 5    | etcd-lv      | True       | available |
        |             |           |      |              |            |           |
        | 9eadf06a... | extension | 1    | extension-lv | True       | available |
        |             |           |      |              |            |           |
        | afcb9f0e... | platform  | 10   | platform-lv  | True       | available |
        +-------------+-----------+------+--------------+------------+-----------+

    .. note::
        The values shown by :command:`system controllerfs-list` are not
        adjusted for space used by the filesystem, and therefore may not
        agree with the output of the Linux :command:`df` command. Also,
        they are rounded compared to the :command:`df` output.

#.  Modify the backup filesystem size on controller-0.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-modify controller-0 backup=35
        +-------------+---------+---------+----------------+
        | UUID        | FS Name | Size in | Logical Volume |
        |             |         | GiB     |                |
        +-------------+---------+---------+----------------+
        | bf0ef915... | backup  | 35      | backup-lv      |
        | e8b087ea... | docker  | 30      | docker-lv      |
        | 4cac1020... | kubelet | 10      | kubelet-lv     |
        | 9c5a53a8... | scratch | 8       | scratch-lv     |
        +-------------+---------+---------+----------------+

#.  On a non AIO-Simplex system, modify the backup filesystem size on
    controller-1.

    The backup filesystem is not replicated across controllers. You must
    repeat the previous step on the other controller.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-modify controller-1 backup=35
        +-------------+---------+------+----------------+
        | UUID        | FS Name | Size | Logical Volume |
        |             |         | in   |                |
        |             |         | GiB  |                |
        +-------------+---------+------+----------------+
        | 45f22520... | backup  | 35   | backup-lv      |
        | 173cbb02... | docker  | 30   | docker-lv      |
        | 4120d512... | kubelet | 10   | kubelet-lv     |
        | 8885ad63... | scratch | 8    | scratch-lv     |
        +-------------+---------+------+----------------+


