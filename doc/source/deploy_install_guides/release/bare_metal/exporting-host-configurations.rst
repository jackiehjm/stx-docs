
.. fdm1552927801987
.. _exporting-host-configurations-r7:

==========================
Export Host Configurations
==========================

You can generate a host configuration file from an existing system for
re-installation, upgrade, or maintenance purposes.

.. rubric:: |context|

You can generate a host configuration file using the :command:`system
host-bulk-export` command, and then use this file with the :command:`system
host-bulk-add` command to re-create the system. If required, you can modify the
file before using it.

The configuration settings (management |MAC| address, BM IP address, and so
on) for all nodes except **controller-0** are written to the file.

.. note::
    To ensure that the hosts are not powered on unexpectedly, the **power-on**
    element for each host is commented out by default.

.. rubric:: |prereq|

To perform this procedure, you must be logged in as the **admin** user.

.. rubric:: |proc|

.. _exporting-host-configurations-steps-unordered-ntw-nw1-c2b-r7:

-   Run the :command:`system host-bulk-export` command to create the host
    configuration file.

    .. code-block:: none

        system host-bulk-export [--filename <FILENAME]>


    -   where <FILENAME> is the path and name of the output file. If the
        ``--filename`` option is not present, the default path ./hosts.xml is
        used.

.. rubric:: |postreq|

To use the host configuration file, see :ref:`Reinstall a System Using an
Exported Host Configuration File
<reinstalling-a-system-using-an-exported-host-configuration-file-r7>`.

For details on the structure and elements of the file, see :ref:`Bulk Host XML
File Format <bulk-host-xml-file-format-r7>`.
