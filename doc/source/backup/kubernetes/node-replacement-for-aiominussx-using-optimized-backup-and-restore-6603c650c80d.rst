
.. _node-replacement-for-aiominussx-using-optimized-backup-and-restore-6603c650c80d:

================================
AIO-SX - Restore on new hardware
================================

For |AIO-SX| Node Replacement with configured ceph storage backend it is not
possible to restore ceph data, since OSD disks will not be present to recover.
The flag ``wipe_ceph_osds=true`` should be set in this case when running the
optimized restore playbook.

The improved backup and restore supports |AIO-SX| Node Replacement, by the
following method.

Restore Playbook Parameter to Specify Node Replacement
------------------------------------------------------

An optional parameter is provided to the restore playbook with the new
management MAC address:

.. code-block:: none

    -e replacement_mgmt_mac <mgmt_mac>

This parameter is accepted only for controller-0.

For example:

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=/home/sysadmin" -e "ansible_become_pass=St8rlingX*" -e "admin_password=St8rlingX*" -e "backup_filename=localhost_platform_backup.tgz" -e "restore_mode=optimized" -e "restore_registry_filesystem=true" -e "replacement_mgmt_mac=a1:a2:a3:a4:a5:a6"
