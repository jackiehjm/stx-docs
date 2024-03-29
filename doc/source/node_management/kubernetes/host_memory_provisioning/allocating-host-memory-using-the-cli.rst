
.. frx1552677291389
.. _allocating-host-memory-using-the-cli:

==================================
Allocate Host Memory Using the CLI
==================================

.. only:: starlingx

    You can edit the platform and huge page memory allocations for a |NUMA|
    node from the CLI.

.. only:: partner

    .. include:: /_includes/allocating-host-memory-using-the-cli.rest
       :start-after: introduction-text-begin
       :end-before: introduction-text-end

Due to limitations in Kubernetes, only a single huge page size can be used
per host.

.. only:: starlingx

    A node may only allocate huge pages for a single size, either 2MiB or 1GiB.

.. only:: partner

    .. include:: /_includes/allocating-host-memory-using-the-cli.rest
       :start-after: usage-text-begin
       :end-before: usage-text-end

You must also provision one 1GiB huge page per |NUMA| node prior to unlocking a
worker or an |AIO| controller.

.. rubric:: |proc|

.. _allocating-host-memory-using-the-cli-steps-brf-p33-dr:

#.  Examine current memory allocation.

    Two system commands, :command:`host-memory-list` and
    :command:`host-memory-show`, allow you to examine the current memory
    allocation on a host.

    #.  Use :command:`host-memory-list` to list memory nodes on a host.

        The syntax is

        .. code-block:: none

            system host-memory-list [--nowrap] <hostname_or_id>

        For example:

        .. code-block:: none

            (keystone_admin)$ system host-memory-list controller-0
            +-----------+---------+------------+---------+----------------+--------+--------+--------+-------+----------+--------+--------+----------+--------+--------+----------+---------------+
            | processor | mem_tot | mem_platfo | mem_ava | hugepages(hp)_ | vs_hp_ | vs_hp_ | vs_hp_ | vs_hp | app_tota | app_hp | app_hp | app_hp_p | app_hp | app_hp | app_hp_p | app_hp_use_1G |
            |           | al(MiB) | rm(MiB)    | il(MiB) | configured     | size(M | total  | avail  | _reqd | l_4K     | _total | _avail | ending_2 | _total | _avail | ending_1 |               |
            |           |         |            |         |                | iB)    |        |        |       |          | _2M    | _2M    | M        | _1G    | _1G    | G        |               |
            +-----------+---------+------------+---------+----------------+--------+--------+--------+-------+----------+--------+--------+----------+--------+--------+----------+---------------+
            | 0         | 13831   | 4600       | 13831   | True           | 2      | 0      | 0      | None  | 3540736  | 0      | 0      | None     | 0      | None   | None     | False         |
            +-----------+---------+------------+---------+----------------+--------+--------+--------+-------+----------+--------+--------+----------+--------+--------+----------+---------------+

        The sample tabular output above has been split for display purposes.
        Columns from **vs_hp_total** on appear to the right of
        **vs_hp_size (MiB)** and columns from **app_hp_total** appear
        to the right of **app_hp_pending_2M** in terminal output.

        For definitions of these columns, see the **Properties** column in
        the output from step
        :ref:`1.b <allocating-host-memory-using-the-cli-host-mem-show>` below.

        The column **app_hp_use_1G**, not shown below, indicates if apps
        are using 1GiB huge pages. If the value is **false**, they are using
        2MiB pages.

        .. _allocating-host-memory-using-the-cli-host-mem-show:

    #.  Use :command:`host-memory-show` to show additional details for a
        given processor.

        For example:

    .. only:: starlingx

        .. code-block:: none

            (keystone_admin)$ system host-memory-show controller-0 0
            +-------------------------------------+--------------------------------------+
            | Property                            | Value                                |
            +-------------------------------------+--------------------------------------+
            | Memory: Usable Total (MiB)          | 13831                                |
            |         Platform     (MiB)          | 4600                                 |
            |         Available    (MiB)          | 13831                                |
            | Huge Pages Configured               | True                                 |
            | Application  Pages (4K): Total      | 3540736                              |
            | Application  Huge Pages (2M): Total | 0                                    |
            |                 Available           | 0                                    |
            | Application  Huge Pages (1G): Total | 0                                    |
            |                 Available           | None                                 |
            | uuid                                | 94ec6057-0a65-48fa-a16b-081832de7072 |
            | ihost_uuid                          | e2e8a2f9-90bc-4ef5-b4e8-504fe4e68848 |
            | inode_uuid                          | 1af3baa4-b9e2-4e8e-bfdc-a1bb98e684e4 |
            | created_at                          | 2019-12-05T23:26:18.441077+00:00     |
            | updated_at                          | 2020-01-14T18:49:26.388919+00:00     |
            +-------------------------------------+--------------------------------------+

    .. only:: partner

        .. include:: /_includes/allocating-host-memory-using-the-cli.rest
           :start-after: memory-table-begin
           :end-before: memory-table-end

#.  Lock the affected host.

    .. code-block:: none

        (keystone_admin)$ system host-lock <hostname>

#.  Use the following command to set the memory allocations.

    .. code-block:: none

        (keystone_admin)$ system host-memory-modify <hostname> <processor>
        [-m <reserved>] [-f <function>] [-2M <2Mpages>] [-1G <1Gpages>]

    The following options are available:

    **hostname**
        This is the host name or ID of the worker node.

    **processor**
        This is the |NUMA| node of the
        worker node, either 0 or 1.

    **reserved**
        Use with the optional ``-m`` argument. This option sets the amount of
        memory reserved for platform use, in MiB.

    **function**

    .. only:: starlingx

        Use with the optional ``-f`` argument. This option specifies the
        intended function for hugepage allocation on application.

    .. only:: partner

        .. include:: /_includes/allocating-host-memory-using-the-cli.rest
           :start-after: function-text-begin
           :end-before: function-text-end

        The default function is **application**.

    **2Mpages**

    .. only:: starlingx

        Use with the optional ``-2M`` argument. This option specifies the
        number of 2 MiB huge pages to make available. Due to limitations in
        Kubernetes, only a single huge page size can be used per host, across
        Application memory.

    .. only:: partner

        .. include:: /_includes/allocating-host-memory-using-the-cli.rest
           :start-after: 2m-pages-text-begin
           :end-before: 2m-pages-text-end

    **1Gpages**

    .. only:: starlingx

        Use with the optional ``-1G`` argument. This option specifies the
        number of 1 GiB huge pages to make available. Due to limitations in
        Kubernetes, only a single huge page size can be used per host, across
        Application memory.

    .. only:: partner

        .. include:: /_includes/allocating-host-memory-using-the-cli.rest
           :start-after: 1g-pages-text-begin
           :end-before: 1g-pages-text-end

    For example, to allocate four 2 MiB huge pages for use by hosted
    applications on |NUMA| node 1 of worker node **worker-0**:

    .. code-block:: none

        (keystone_admin)$ system host-memory-modify worker-0 1 -2M 4

    .. only:: starlingx

        For openstack-compute labeled worker node or |AIO| controller, since
        Kubernetes only supports a single huge page size per worker node.
        'application' huge pages must also be 1G. The following example shows
        configuring 10 1G huge pages for application usage. For example:

    .. only:: partner

        .. include:: /_includes/allocating-host-memory-using-the-cli.rest
           :start-after: recommended-size-text-begin
           :end-before: recommended-size-text-end

    .. code-block:: none

        (keystone_admin)$ system host-memory-modify -f application -1G 10 worker-<n> 0
        (keystone_admin)$ system host-memory-modify -f application -1G 10 worker-<n> 1

#.  Unlock the host.

    .. code-block:: none

        (keystone_admin)$ system host-unlock <hostname>

#.  Wait for the host to be reported as **available**.

    .. code-block:: none

        (keystone_admin)$ system host-list <hostname>
        +----+--------------+-------------+----------------+-------------+--------------+
        | id | hostname     | personality | administrative | operational | availability |
        +----+--------------+-------------+----------------+-------------+--------------+
        | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
        | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
        | 3  | worker-0     | worker      | unlocked       | enabled     | available    |
        +----+--------------+-------------+----------------+-------------+--------------+

.. only:: partner

    .. include:: /_includes/avs-note.rest
