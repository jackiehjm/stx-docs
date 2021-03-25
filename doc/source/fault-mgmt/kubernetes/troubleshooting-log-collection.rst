
.. ley1552581824091
.. _troubleshooting-log-collection:

===========================
Troubleshoot Log Collection
===========================

The |prod| log collection tool gathers detailed information.

.. contents::
   :local:
   :depth: 1

.. _troubleshooting-log-collection-section-N10061-N1001C-N10001:

------------------------------
Collect Tool Caveats and Usage
------------------------------

.. _troubleshooting-log-collection-ul-dpj-bxp-jdb:

-   Log in as **sysadmin**, NOT as root, on the active controller and use the
    :command:`collect` command.

-   All usage options can be found by using the following command:

    .. code-block:: none

        (keystone_admin)$ collect --help

-   For |prod| Simplex or Duplex systems, use the following command:

    .. code-block:: none

        (keystone_admin)$ collect --all

-   For |prod| Standard systems, use the following commands:


    -   For a small deployment \(less than two worker nodes\):

        .. code-block:: none

            (keystone_admin)$ collect -–all

    -   For large deployments:

        .. code-block:: none

            (keystone_admin)$ collect --list host1 host2 host3


-   For systems with an up-time of more than 2 months, use the date range options.

    Use ``--start-date`` for the collection of logs on and after a given date:

    .. code-block:: none

        (keystone_admin)$ collect [--start-date | -s] <YYYYMMDD>

    Use ``--end-date`` for the collection of logs on and before a given date:

    .. code-block:: none

        (keystone_admin)$ collect [--end-date | -s] <YYYYMMDD>

-   To prefix the collect tar ball name and easily identify the
    :command:`collect` when several are present, use the following command.

    .. code-block:: none

        (keystone_admin)$ collect [--name | -n] <prefix>

    For example, the following prepends **TEST1** to the name of the tarball:

    .. code-block:: none

        (keystone_admin)$ collect --name TEST1
        [sudo] password for sysadmin:
        collecting data from 1 host(s): controller-0
        collecting controller-0_20200316.155805 ... done (00:01:39   56M)
        creating user-named tarball /scratch/TEST1_20200316.155805.tar ... done (00:01:39   56M)

-   Prior to using the :command:`collect` command, the nodes need to be
    unlocked-enabled or disabled online and are required to be unlocked at
    least once.

-   Lock the node and wait for the node to reach the disabled-online state
    before collecting logs for a node that is rebooting indefinitely.

-   You may be required to run the local :command:`collect` command if the
    collect tool running from the active controller node fails to collect
    logs from one of the system nodes. Execute the :command:`collect` command
    using the console or BMC connection on the node that displays the failure.

.. only:: partner

    .. include:: ../../_includes/troubleshooting-log-collection.rest