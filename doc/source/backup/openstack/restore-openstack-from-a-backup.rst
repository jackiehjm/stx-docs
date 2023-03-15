
.. gmx1612810318507
.. _restore-openstack-from-a-backup:

===============================
Restore OpenStack from a Backup
===============================

You can restore |prod-os| from a backup with or without Ceph.

.. rubric:: |prereq|

.. _restore-openstack-from-a-backup-ul-ylc-brc-s4b:

-   You must have a backup of your |prod-os| installation as described in
    :ref:`Back up OpenStack <back-up-openstack>`.

-   You must have an operational |prod-long| deployment.

.. rubric:: |proc|

#.  Delete the old OpenStack application and upload it again.

    .. note::

        Images and volumes will remain in Ceph.

    .. parsed-literal::

        ~(keystone_admin)$ system application-remove |prefix|-openstack
        ~(keystone_admin)$ system application-delete |prefix|-openstack
        ~(keystone_admin)$ system application-upload |prefix|-openstack.tgz

#.  Restore |prod-os|.

    You can choose either of the following options:


    -   Restore only |prod-os| system data. This option will not restore the
        Ceph data (that is, it will not run commands like :command:`rbd
        import`). This procedure will preserve any existing Ceph data at
        restore-time.

    -   Restore |prod-os| system data, Cinder volumes and Glance images. You'll
        want to run this step if your Ceph data will be wiped after the backup.


------------------------------------
Restore only application system data
------------------------------------

Run the following command:

.. code-block:: none

    ~(keystone_admin)$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/ restore_openstack.yml -e "@localhost-restore.yaml"

.. code-block:: none

    cat << EOF > localhost-restore.yaml
    ---
    ansible_become_pass: "<admin_password>"
    admin_password: "<admin_password>"
    initial_backup_dir: "<location_of_backup_filename>"
    backup_filename: "<openstack_tgz_backup_filename>"
    ...
    EOF


-----------------------------------------------------------------
Restore application system data, cinder volumes and glance images
-----------------------------------------------------------------

#.  Run the following command:

    .. code-block:: none

        ~(keystone_admin)$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/ restore_openstack.yml -e "@localhost-restore.yaml"

    .. code-block:: none

        cat << EOF > localhost-restore.yaml
        ---
        ansible_become_pass: "<admin_password>"
        admin_password: "<admin_password>"
        initial_backup_dir: "<location_of_backup_filename>"
        backup_filename: "<openstack_tgz_backup_filename>"
        restore_cinder_glance_data="true"
        ...
        EOF


    When this step has completed, the Cinder, Glance and MariaDB services will
    be up, and Mariadb data restored.

#.  Restore Ceph data.

    #.  Restore Cinder volumes using the :command:`rbd import` command.

        For example:

        .. code-block:: none

            ~(keystone_admin)$ rbd import -p cinder-volumes /tmp/611157b9-78a4-4a26-af16-f9ff75a85e1b

        Where ``tmp/611157b9-78a4-4a26-af16-f9ff75a85e1b`` is a file saved
        earlier at the backup procedure as described in :ref:`Back up OpenStack<back-up-openstack>`.

    #.  Restore Glance images using the :command:`image-backup` script.

        For example, if we have an archive named
        ``image_3f30adc2-3e7c-45bf-9d4b-a4c1e191d879.tgz`` in the ``/opt/backups``
        directory, we can use restore it using the following command:

        .. code-block:: none

            ~(keystone_admin)$ sudo image-backup.sh import image_3f30adc2-3e7c-45bf-9d4b-a4c1e191d879.tgz

    #.  Use the :command:`tidy_storage_post_restore` utility to detect any
        discrepancy between Cinder/Glance DB and rbd pools:

        .. code-block:: none

            ~(keystone_admin)$ tidy_storage_post_restore <log_file>

        After the script finishes, some command output will be written to the
        log file. They will help reconcile discrepancies between the |prod-os|
        database and CEPH data.

#.  Run the playbook again with the ``restore_openstack_continue`` flag set to
    ``true`` to bring up the remaining OpenStack services.

    .. code-block:: none

        ~(keystone_admin)$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/ restore_openstack.yml -e "@localhost-restore.yaml"

    .. code-block:: none

        cat << EOF > localhost-restore.yaml
        ---
        ansible_become_pass: "<admin_password>"
        admin_password: "<admin_password>"
        initial_backup_dir: "<location_of_backup_filename>"
        backup_filename: "<openstack_tgz_backup_filename>"
        restore_openstack_continue="true"
        ...
        EOF
