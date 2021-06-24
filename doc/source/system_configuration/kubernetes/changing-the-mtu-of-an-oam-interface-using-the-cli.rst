
.. nnm1552672805879
.. _changing-the-mtu-of-an-oam-interface-using-the-cli:

================================================
Change the MTU of an OAM Interface Using the CLI
================================================

You can change the |MTU| value of an |OAM| interface using the CLI.

If you prefer, you can use the Horizon Web interface; see
:ref:`Change the MTU of an OAM Interface Using Horizon
<changing-the-mtu-of-an-oam-interface-using-horizon>`.

Controller configuration changes require each controller to be locked. This
requires a swact.

.. rubric:: |proc|

#.  Lock the standby controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-1

#.  Use the :command:`system host-if-modify` command to specify the interface
    and the new MTU value on the standby controller. This example assumes the
    |OAM| interface name as **oam0**.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-modify controller-1 oam0 --imtu 1600

#.  Unlock the standby controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-1

#.  Swact the controllers.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

#.  Lock the new standby controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0

#.  Modify the |MTU| of the corresponding interface on the standby controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-modify controller-0 oam0 --imtu 1600

#.  Unlock the standby controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0
