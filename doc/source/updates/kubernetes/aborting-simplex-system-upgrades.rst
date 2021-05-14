
.. syj1592947192958
.. _aborting-simplex-system-upgrades:

=============================
Abort Simplex System Upgrades
=============================

You can abort a Simplex System upgrade before or after upgrading controller-0.

.. _aborting-simplex-system-upgrades-section-N10025-N1001B-N10001:

.. contents:: |minitoc|
   :local:
   :depth: 1

-----------------------------
Before upgrading controller-0
-----------------------------

.. _aborting-simplex-system-upgrades-ol-nlw-zbp-xdb:

#.  Abort the upgrade with the upgrade-abort command.

    .. code-block:: none

        $ system upgrade-abort

    The upgrade state is set to aborting. Once this is executed, there is no
    canceling; the upgrade must be completely aborted.

#.  Complete the upgrade.

    .. code-block:: none

        $ system upgrade-complete

    At this time any upgrade data generated as part of the upgrade-start
    command will be deleted. This includes the upgrade data in
    /opt/platform-backup.

.. _aborting-simplex-system-upgrades-section-N10063-N1001B-N10001:

----------------------------
After upgrading controller-0
----------------------------

After controller-0 has been upgraded it is possible to roll back the software
upgrade. This involves performing a system restore with the previous release.

.. _aborting-simplex-system-upgrades-ol-jmw-kcp-xdb:

#.  Abort the upgrade with the :command:`upgrade-abort` command.

    .. code-block:: none

        $ system upgrade-abort

    The upgrade state is set to aborting. Once this is executed, there is no
    canceling; the upgrade must be completely aborted.

#.  Lock and downgrade controller-0

    .. code-block:: none

        $ system host-lock controller-0
        $ system host-downgrade controller-0

    The data is stored in /opt/platform-backup. Ensure the data is present,and
    preserved through the downgrade.

#.  Install the previous release of |prod-long| Simplex software via network or
    USB.

#.  Restore the system data. The restore is preserved in /opt/platform-backup.

    For more information, see, :ref:`Upgrading All-in-One Simplex
    <upgrading-all-in-one-simplex>`.

#.  Abort the upgrade with the :command:`upgrade-abort` command.

    .. code-block:: none

        $ system upgrade-abort

    The system will be restored to the state when the :command:`upgrade-start`
    command was issued. The :command:`upgrade-abort` command must be issued at
    this time.

    The upgrade state is set to aborting. Once this is executed, there is no
    canceling; the upgrade must be completely aborted.

#.  Complete the upgrade.

    .. code-block:: none

        $ system upgrade-complete
