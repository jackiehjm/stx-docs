
.. ngk1552920570137
.. _reclaiming-disk-space:

==================
Reclaim Disk Space
==================

You can free up and reclaim disk space taken by previous updates once a newer
version of an update has been committed to the system.

.. rubric:: |proc|

#.  Run the :command:`query-dependencies` command to show a list of updates
    that are required by the specified update \(patch\), including itself.

    .. code-block:: none

        sw-patch query-dependences [ --recursive ] <patch-id>

    The :command:`query-dependencies` command will show a list of updates that
    are required by the specified update \(including itself\). The
    ``--recursive`` option will crawl through those dependencies to return a
    list of all the updates in the specified update's dependency tree. This
    query is used by the :command:`commit` command in calculating the set of
    updates to be committed. For example,

    .. parsed-literal::

        controller-0:/home/sysadmin# sw-patch query-dependencies |pn|-|pvr|-PATCH_0004
        |pn|-|pvr|-PATCH_0002
        |pn|-|pvr|-PATCH_0003
        |pn|-|pvr|-PATCH_0004

        controller-0:/home/sysadmin# sw-patch query-dependencies |pn|-|pvr|-PATCH_0004 --recursive
        |pn|-|pvr|-PATCH_0001
        |pn|-|pvr|-PATCH_0002
        |pn|-|pvr|-PATCH_0003
        |pn|-|pvr|-PATCH_0004

#.  Run the :command:`sw-patch commit` command.

    .. code-block:: none

        sw-patch commit [ --dry-run ] [ --all ] [ --release ] [ <patch-id> … ]

    The :command:`sw-patch commit` command allows you to specify a set of
    updates to be committed. The commit set is calculated by querying the
    dependencies of each specified update.

    The ``--all`` option, without the ``--release`` option, commits all updates
    of the currently running release. When two releases are on the system use
    the ``--release`` option to specify a particular release's updates if
    committing all updates for the non-running release. The ``--dry-run``
    option shows the list of updates to be committed and how much disk space
    will be freed up. This information is also shown without the ``--dry-run``
    option, before prompting to continue with the operation. An update can only
    be committed once it has been fully applied to the system, and cannot be
    removed after.

    Following are examples that show the command usage.

    The following command lists the status of all updates that are in an
    *Applied* state.

    .. code-block:: none

        controller-0:/home/sysadmin# sw-patch query

    The following command commits the updates.

    .. parsed-literal::

        controller-0:/home/sysadmin# sw-patch commit |pvr|-PATCH_0001 |pvr|-PATCH_0002
        The following patches will be committed:
            |pvr|-PATCH_0001
            |pvr|-PATCH_0002

        This commit operation would free 2186.31 MiB

        WARNING: Committing a patch is an irreversible operation. Committed patches
                 cannot be removed.

        Would you like to continue? [y/N]: y
        The patches have been committed.

    The following command shows the updates now in the *Committed* state.

    .. parsed-literal::

        controller-0:/home/sysadmin# sw-patch query
        Patch ID             RR  Release   Patch State
        ================   ===== ========  =========
        |pvr|-PATCH_0001     N    |pvr|    Committed
        |pvr|-PATCH_0002     Y    |pvr|    Committed
