
.. otn1579610005869
.. _deprovisioning-board-management-control-from-the-cli:

=================================================
Deprovision Board Management Control from the CLI
=================================================

|BMC| can be deprovisioned on a host by
setting the bm\_type option to none.

.. rubric:: |proc|

-   Use the :command:`system host-update` command to set bm\_type.

    For example:

    .. code-block:: none

        ~(keystone)admin)$ system host-update worker-0 bm_type=none
