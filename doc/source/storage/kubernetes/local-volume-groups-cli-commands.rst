
.. rtm1590585833668
.. _local-volume-groups-cli-commands:

================================
Local Volume Groups CLI Commands
================================

You can use |CLI| commands to manage local volume groups.


.. _local-volume-groups-cli-commands-simpletable-kfn-qwk-nx:


.. table::
    :widths: auto

    +-------------------------------------------------------+-------------------------------------------------------+
    | Command Syntax                                        | Description                                           |
    +=======================================================+=======================================================+
    | .. code-block:: none                                  | List local volume groups.                             |
    |                                                       |                                                       |
    |     system host-lvg-list <hostname>                   |                                                       |
    +-------------------------------------------------------+-------------------------------------------------------+
    | .. code-block:: none                                  | Show details for a particular local volume group.     |
    |                                                       |                                                       |
    |     system host-lvg-show <hostname> <groupname>       |                                                       |
    +-------------------------------------------------------+-------------------------------------------------------+
    | .. code-block:: none                                  | Add a local volume group.                             |
    |                                                       |                                                       |
    |     system host-lvg-add <hostname> <groupname>        |                                                       |
    +-------------------------------------------------------+-------------------------------------------------------+
    | .. code-block:: none                                  | Delete a local volume group.                          |
    |                                                       |                                                       |
    |     system host-lvg-delete <hostname> <groupname>     |                                                       |
    +-------------------------------------------------------+-------------------------------------------------------+
    | .. code-block:: none                                  | Modify a local volume group.                          |
    |                                                       |                                                       |
    |     system host-lvg-modify [-b <instance_backing>]    |                                                       |
    |     [-c <concurrent_disk_operations>] [-l <lvm_type>] |                                                       |
    |     <hostname> <groupname>                            |                                                       |
    |                                                       |                                                       |
    +-------------------------------------------------------+-------------------------------------------------------+

**<instance_backing>**
    is the storage method for the local volume group (image or remote). The
    remote option is valid only for systems with dedicated storage.

**<concurrent_disk_operations>**
    is the number of I/O intensive disk operations, such as glance image
    downloads or image format conversions, that can occur at the same time.

**<lvm_type>**
    is the provisioning type for VM volumes (thick or thin). The default
    value is thin.

**<hostname>**
    is the name or ID of the host.

**<groupname>**
    is the name or ID of the local volume group.

