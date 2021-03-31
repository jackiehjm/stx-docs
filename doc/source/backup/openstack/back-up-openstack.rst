
.. mdt1596804427371
.. _back-up-openstack:

=================
Back up OpenStack
=================

|prod-os| is backed up using the |prod| back-up facilities.

.. rubric:: |context|

The backup playbook will produce a OpenStack backup tarball in addition to the
platform tarball. This can be used to perform |prod-os| restores independently
of restoring the underlying platform.

.. note::

    Data stored in Ceph such as Glance images, Cinder volumes or volume backups
    or Rados objects \(images stored in ceph\) are not backed up automatically.


.. _back-up-openstack-ul-ohv-x3k-qmb:

-   To backup glance images use the image\_backup.sh script. For example:

    .. code-block:: none

        ~(keystone_admin)$ image-backup export <uuid>

-   To back-up other Ceph data such as cinder volumes, backups in ceph or
    rados objects use the :command:`rbd export` command for the data in
    OpenStack pools cinder-volumes, cinder-backup and rados.

    For example if you want to export a Cinder volume with the ID of:
    611157b9-78a4-4a26-af16-f9ff75a85e1b you can use the following command:

    .. code-block:: none

        ~(keystone_admin)$ rbd export -p cinder-volumes
        611157b9-78a4-4a26-af16-f9ff75a85e1b
        /tmp/611157b9-78a4-4a26-af16-f9ff75a85e1b

    To see the the Cinder volumes, use the :command:`openstack volume-list`
    command.


    After export, copy the data off-box for safekeeping.

For details on performing a |prod| back-up, see :ref:`
System Backup and Restore <backing-up-starlingx-system-data>`.

