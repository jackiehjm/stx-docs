
.. hil1593180554641
.. _aborting-the-distributed-upgrade-orchestration:

==============================================
Aborting the Distributed Upgrade Orchestration
==============================================

To abort the current upgrade orchestration operation, use the
:command:`upgrade-strategy abort` command.

.. note::

    The :command:`dcmanager upgrade-strategy abort` command completes the
    current upgrading stage before aborting, to prevent hosts from being left
    in a locked state requiring manual intervention.

.. code-block:: none

    ~(keystone_admin)]$ dcmanager upgrade-strategy abort

