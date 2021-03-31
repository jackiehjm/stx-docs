
.. tok1566218039402
.. _use-local-clis:

==============
Use Local CLIs
==============

|prod-os| administration and other tasks can be carried out from the command
line interface \(|CLI|\)

.. rubric:: |context|

.. warning::
    For security reasons, only administrative users should have |SSH| privileges.

The Local |CLI| can be accessed via the local console on the active controller
or via SSH to the active controller. This procedure illustrates how to set the
context of |CLI| commands to openstack and access openstack admin privileges.

.. rubric:: |proc|

#.  Login into the local console of the active controller or login via |SSH| to
    the |OAM| Floating IP.

#.  Setup admin credentials for the containerized openstack application.

    .. code-block:: none

        # source /etc/platform/openrc
        # OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3


.. rubric:: |result|

OpenStack |CLI| commands for the |prod-os| Cloud Application are now available
via the :command:`openstack` command.

For example:

.. code-block:: none

    ~(keystone_admin)$ openstack flavor list
    +-----------------+------------------+------+------+-----+-------+-----------+
    | ID              | Name             |  RAM | Disk | Eph.| VCPUs | Is Public |
    +-----------------+------------------+------+------+-----+-------+-----------+
    | 054531c5-e74e.. | squid            | 2000 |   20 |  0  |   2   | True      |
    | 2fa29257-8842.. | medium.2c.1G.2G  | 1024 |    2 |  0  |   2   | True      |
    | 4151fb10-f5a6.. | large.4c.2G.4G   | 2048 |    4 |  0  |   4   | True      |
    | 78b75c6d-93ca.. | small.1c.500M.1G |  512 |    1 |  0  |   1   | True      |
    | 8b9971df-6d83.. | vanilla          |    1 |    1 |  0  |   1   | True      |
    | e94c8123-2602.. | xlarge.8c.4G.8G  | 4096 |    8 |  0  |   8   | True      |
    +-----------------+------------------+------+------+-----+-------+-----------+
    
    ~(keystone_admin)$ openstack image list
    +----------------+----------------------------------------+--------+
    | ID             | Name                                   | Status |
    +----------------+----------------------------------------+--------+
    | 92300917-49ab..| Fedora-Cloud-Base-30-1.2.x86_64.qcow2  | active |
    | 15aaf0de-b369..| opensquidbox.amd64.1.06a.iso           | active |
    | eeda4642-db83..| xenial-server-cloudimg-amd64-disk1.img | active |
    +----------------+----------------------------------------+--------+
    

