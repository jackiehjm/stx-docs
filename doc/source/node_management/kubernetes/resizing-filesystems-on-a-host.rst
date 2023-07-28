
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
        +--------------------------------------+-----------+-------------+----------------+
        | UUID                                 | FS Name   | Size in GiB | Logical Volume |
        +--------------------------------------+-----------+-------------+----------------+
        | 42dba35b-d2cb-4cbe-85b5-4ffc0fd75d37 | backup    | 25          | backup-lv      |
        | 0c83c1cb-63f3-4d7a-961e-21b460890417 | docker    | 30          | docker-lv      |
        | dc212c9b-ba1b-49f1-8bbc-dc41f7f226f2 | kubelet   | 10          | kubelet-lv     |
        | 766ad3d7-e420-4aff-9e35-a8e495413ead | log       | 8           | log-lv         |
        | 0215defd-ded2-46df-9338-1d39e7648028 | root      | 20          | root-lv        |
        | 3079f0ca-28c8-444f-a955-44cc98f96156 | scratch   | 16          | scratch-lv     |
        | c987d5d7-729e-400c-8d51-ff464b2b9675 | var       | 20          | var-lv         |
        +--------------------------------------+-----------+-------------+----------------+

    Note that the **docker** and **kubelet** filesystems are 30 GiB and 10 GiB
    respectively.

    The syntax of the :command:`host-fs-list` command is:

    .. code-block:: none

        host-fs-list <hostname_or_id>

    **<hostname_or_id>** is the host name or UUID of the host.

#.  Optionally, list details about a filesystem.

    The syntax of the :command:`host-fs-show` command is:

    .. code-block:: none

        host-fs-show <hostname_or_id> <fs_name_or_uuid>

    **<hostname_or_id>**
        The host name or UUID of the host.

    **<fs_name_or_uuid>**
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

    **<hostname_or_id>**
        The host name or UUID of the node.

    **<fs_name>**
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
        | 3fe89994-a5b9-4612-8321-443fc9d2fba7 | log     | 8           | log-lv         |
        | 2c026d6f-5c03-4135-abca-c0047aa7f5a6 | scratch | 8           | scratch-lv     |
        | 0215defd-ded2-46df-9338-1d39e7648028 | root    | 20          | root-lv        |
        | c987d5d7-729e-400c-8d51-ff464b2b9675 | var     | 20          | var-lv         |
        +--------------------------------------+---------+-------------+----------------+
