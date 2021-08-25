
.. vmh1579710476905
.. _locking-a-host-using-horizon:

=========================
Lock a Host Using Horizon
=========================

Locking an unlocked host takes it out of service for configuration and
maintenance purposes.

On a controller node, the state transition only succeeds if there are no
services running in active mode on the host.

On a worker node \(or |AIO| Controller\), the state
transition only succeeds if all currently running containers
\(hosted applications\) on the host can be re-located on alternative worker
nodes or |AIO| Controller. Re-location of containers is
initiated automatically by |prod| as soon as the state transition is requested.
For containers, a live re-location of the container to another host is
attempted. A ``NoExecute`` taint, as shown below, is applied to
the host, causing any containers on that host to be evicted.

.. code-block:: none

    services=disabled:NoExecute

.. note::
    On a |prod| Simplex system, where re-location of containers is not
    possible, all running containers are stopped when a host is locked.
    Other services continue to run.

.. rubric:: |proc|

#.  From **Admin** \> **Platform** \> **Host Inventory**, select the
    **Hosts** tab.

#.  From the **Edit** menu for the host, select **Lock Host**.

    .. figure:: /shared/figures/system_configuration/rst1442611298701.png
        :scale: 100%
