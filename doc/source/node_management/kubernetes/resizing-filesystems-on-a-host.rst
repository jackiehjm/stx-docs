
.. rso1566311417793
.. _resizing-filesystems-on-a-host:

============================
Resize Filesystems on a Host
============================

You can resize a filesystem on a host using the
:command:`system host-fs-modify` command.

The following combinations of filesystem and host types are supported.

.. _resizing-filesystems-on-a-host-table-w4n-wvn-53b:

.. table::
    :widths: auto

    +-------------+----------------+------------------+----------------+--------------+
    | Filesystem  | Host Type      | Folder           | Logical Volume | Default Size |
    +=============+================+==================+================+==============+
    | **backup**  | controller     | /opt/backups     | backup-lv      | 25 GiB       |
    +-------------+----------------+------------------+----------------+--------------+
    | **docker**  | All node types | /var/lib/docker  | docker-lv      | 30 GiB       |
    +-------------+----------------+------------------+----------------+--------------+
    | **kubelet** | All node types | /var/lib/kubelet | kubelet-lv     | 10 GiB       |
    +-------------+----------------+------------------+----------------+--------------+
    | **log**     | All node types | /var/log         | log-lv         | 7.5 GiB      |
    +-------------+----------------+------------------+----------------+--------------+
    | **scratch** | All node types | /scratch         | scratch-lv     | variable     |
    +-------------+----------------+------------------+----------------+--------------+

The following example changes the **docker** and **kubelet** filesystem
sizes on a controller.

.. rubric:: |proc|

#.  List the filesystems on the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-list controller-1
        +--------------------------------------+---------+-------------+----------------+
        | UUID                                 | FS Name | Size in GiB | Logical Volume |
        +--------------------------------------+---------+-------------+----------------+
        | a4d83571-a555-4ba5-999f-af709206ae35 | backup  | 25          | backup-lv      |
        | d57652a1-af17-47b8-b941-9ebfeee4a56f | docker  | 30          | docker-lv      |
        | a84374c6-8917-4db5-bd34-2a8d244f2bf6 | kubelet | 10          | kubelet-lv     |
        | f0c5a8a9-57c7-4072-932d-8f7aac519f8c | log     | 8           | log-lv         |
        | 2c026d6f-5c03-4135-abca-c0047aa7f5a6 | scratch | 8           | scratch-lv     |
        +--------------------------------------+---------+-------------+----------------+

    Note that the **docker** and **kubelet** filesystems are 30 GiB and 10 GiB
    respectively.

    The syntax of the :command:`host-fs-list` command is:

    .. code-block:: none

        host-fs-list <hostname_or_id>

    **<hostname\_or\_id>** is the host name or UUID of the host.

#.  Optionally, list details about a filesystem.

    The syntax of the :command:`host-fs-show` command is:

    .. code-block:: none

        host-fs-show <hostname_or_id> <fs_name_or_uuid>

    **<hostname\_or\_id>**
        The host name or UUID of the host.

    **<fs\_name\_or\_uuid>**
        The name or UUID of the file system.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-show controller-1 d57652a1-af17-47b8-b941-9ebfeee4a56f
        +----------------+--------------------------------------+
        | Property       | Value                                |
        +----------------+--------------------------------------+
        | uuid           | d57652a1-af17-47b8-b941-9ebfeee4a56f |
        | name           | docker                               |
        | size           | 30                                   |
        | logical_volume | docker-lv                            |
        | created_at     | 2019-08-08T03:05:25.341669+00:00     |
        | updated_at     | None                                 |
        +----------------+--------------------------------------+

#.  Modify the sizes of the **docker** and **kubelet** filesystems.

    The syntax of the :command:`host-fs-modify` command is:

    .. code-block:: none

        host-fs-modify <hostname_or_id> <fs_name>=<size> [<fs_name>=<size>]

    **<hostname\_or\_id>**
        The host name or UUID of the node.

    **<fs\_name>**
        The name of the filesystem.

    **<size>**
        The new size of the filesystem, in GiB.

    The following command changes the size of the **docker** filesystem to 31
    GiB and that of the **kubelet** filesystem to 11 GiB.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-modify controller-1 docker=31 kubelet=11
        +--------------------------------------+---------+-------------+----------------+
        | UUID                                 | FS Name | Size in GiB | Logical Volume |
        +--------------------------------------+---------+-------------+----------------+
        | a4d83571-a555-4ba5-999f-af709206ae35 | backup  | 25          | backup-lv      |
        | d57652a1-af17-47b8-b941-9ebfeee4a56f | docker  | 31          | docker-lv      |
        | a84374c6-8917-4db5-bd34-2a8d244f2bf6 | kubelet | 11          | kubelet-lv     |
        | 2c026d6f-5c03-4135-abca-c0047aa7f5a6 | scratch | 8           | scratch-lv     |
        +--------------------------------------+---------+-------------+----------------+
