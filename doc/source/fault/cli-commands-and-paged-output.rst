
.. idb1552680603462
.. _cli-commands-and-paged-output:

=============================
CLI Commands and Paged Output
=============================

There are some CLI commands that perform paging, and you can use options to
limit the paging or to disable it, which is useful for scripts.

CLI fault management commands that perform paging include:

.. _cli-commands-and-paged-output-ul-wjz-y4q-bw:

-   :command:`fm event-list`

-   :command:`fm event-suppress`

-   :command:`fm event-suppress-list`

-   :command:`fm event-unsuppress`

-   :command:`fm event-unsuppress-all`


To turn paging off, use the --nopaging option for the above commands. The
--nopaging option is useful for bash script writers.

.. _cli-commands-and-paged-output-section-N10074-N1001C-N10001:

--------
Examples
--------

The following examples demonstrate the resulting behavior from the use and
non-use of the paging options.

This produces a paged list of events.

.. code-block:: none

    ~(keystone_admin)$ fm event-list

This produces a list of events without paging.

.. code-block:: none

    ~(keystone_admin)$ fm event-list --nopaging

This produces a paged list of 50 events.

.. code-block:: none

    ~(keystone_admin)$ fm event-list --limit 50

This will produce a list of 50 events without paging.

.. code-block:: none

    ~(keystone_admin)$ fm event-list --limit 50 --nopaging