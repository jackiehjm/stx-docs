
.. qmi1579723342974
.. _swacting-a-master-controller-using-the-cli:

===============================
Swact Controllers Using the CLI
===============================

Swacting initiates a switch of the active/standby roles between two
controllers.

.. rubric:: |context|

Swact is an abbreviated form of the term Switch Active \(host\). When
selected, this option forces the other controller to become the active one
in the HA cluster. This means that all active system services on this
controller move to standby operation, and that the corresponding services
on the other controller become active.

Complete this procedure when you need to lock the currently active
controller, or undertake any kind of maintenance procedures; for example,
when updating hardware or replacing faulty components.

.. rubric:: |proc|

-   Run the following command from the controller's command line.

    .. code-block:: none

        ~(keystone_admin)$ system host-swact <hostname>

    If necessary, you can use the ``--force`` option to force a swact.

    .. code-block:: none

        ~(keystone_admin)$ system host-swact --force <hostname>

    .. caution::
        The ``--force`` option bypasses semantic checks and may cause service
        failures.
