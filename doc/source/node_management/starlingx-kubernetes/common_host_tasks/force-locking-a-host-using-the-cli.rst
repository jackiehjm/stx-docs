
.. rar1579722969916
.. _force-locking-a-host-using-the-cli:

===============================
Force Lock a Host Using the CLI
===============================

Force locking an unlocked host takes it out of service immediately for
configuration and maintenance purposes.

.. note::
    A force lock operation on a worker host causes an immediate service
    outage on all containers and causes the host to reboot.

.. rubric:: |proc|

#.  Try to lock the host normally.

    For more information,
    see :ref:`Lock a Host Using the CLI <locking-a-host-using-the-cli>`.

#.  If the :command:`host-lock` attempt fails for a worker host, manually
    relocate containers running on the host, and then try locking the host
    again.

#.  Use a force lock only if the above steps fail to lock the host.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock --force <hostname>
