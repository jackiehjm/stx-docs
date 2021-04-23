
.. quy1571265365123
.. _system-backup-running-ansible-restore-playbook-remotely:

=====================================
Run Ansible Restore Playbook Remotely
=====================================

In this method you can run Ansible Restore playbook and point to controller-0.

.. rubric:: |prereq|

.. _system-backup-running-ansible-restore-playbook-remotely-ul-ylm-g44-bkb:

-   You need to have Ansible installed on your remote workstation, along
    with the Ansible Backup/Restore playbooks.

-   Your network has IPv6 connectivity before running Ansible Playbook, if
    the system configuration is IPv6.

.. rubric:: |proc|

.. _system-backup-running-ansible-restore-playbook-remotely-steps-sgp-jjc-ljb:

#.  Log in to the remote workstation.

    You can log in directly on the console or remotely using :command:`ssh`.

#.  Provide an inventory file, either a customized one that is specified
    using the ``-i`` option, or the default one that is in the Ansible
    configuration directory \(that is, /etc/ansible/hosts\). You must
    specify the floating |OAM| IP of the controller host. For example, if the
    host name is |prefix|\_Cluster, the inventory file should have an entry
    called |prefix|\_Cluster.

    .. parsed-literal::

        ---
        all:
          hosts:
            wc68:
              ansible_host: 128.222.100.02
            |prefix|\_Cluster:
              ansible_host: 128.224.141.74

#.  Run the Ansible Restore playbook:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook path-to-restore-platform-playbook-entry-file --limit host-name -i inventory-file -e optional-extra-vars

    where optional-extra-vars can be:

    -   **Optional**: You can select one of the following restore modes:

        -   To keep Ceph data intact \(false - default option\), use the
            following parameter:

            :command:`wipe_ceph_osds=false`

        -   To start with an empty Ceph cluster \(true\), where the Ceph
            cluster will need to be recreated, use the following parameter:

            :command:`wipe_ceph_osds=true`

        -   To indicate that the backup data file is under /opt/platform-backup
            directory on the local machine, use the following parameter:

            :command:`on_box_data=true`

            If this parameter is set to **false**, the Ansible Restore playbook
            expects both the **initial_backup_dir** and **backup_filename**
            to be specified.

    -   The backup\_filename is the platform backup tar file. It must be
        provided using the ``-e`` option on the command line, for example:

        .. code-block:: none

           -e backup\_filename= localhost_platform_backup_2019_07_15_14_46_37.tgz

    -   The initial\_backup\_dir is the location on the Ansible control
        machine where the platform backup tar file is placed to restore the
        platform. It must be provided using ``-e`` option on the command line.

    -   The :command:`admin\_password`, :command:`ansible\_become\_pass`,
        and :command:`ansible\_ssh\_pass` need to be set correctly using
        the ``-e`` option on the command line or in the Ansible secret file.
        :command:`ansible\_ssh\_pass` is the password to the sysadmin user
        on controller-0.

    -   The :command:`ansible\_remote\_tmp` should be set to a new
        directory \(not required to create it ahead of time\) under
        /home/sysadmin on controller-0 using the ``-e`` option on the command
        line.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ ansible-playbook /localdisk/designer/jenkins/tis-stx-dev/cgcs-root/stx/ansible-playbooks/playbookconfig/src/playbooks/restore_platform.yml --limit |prefix|\_Cluster -i $HOME/br_test/hosts -e "ansible_become_pass=St0rlingX* admin_password=St0rlingX* ansible_ssh_pass=St0rlingX* initial_backup_dir=$HOME/br_test backup_filename= |prefix|\_Cluster_system_backup_2019_08_08_15_25_36.tgz ansible_remote_tmp=/home/sysadmin/ansible-restore"

    .. note::
        If the backup contains patches, Ansible Restore playbook will apply
        the patches and prompt you to reboot the system. Then you will need to
        re-run Ansible Restore playbook.

#.  After running the restore\_platform.yml playbook, you can restore the local
    registry images.

    .. note::
        The backup file of the local registry may be large. Restore the
        backed up file on the controller, where there is sufficient space.

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook path-to-restore-user-images-playbook-entry-file --limit host-name -i inventory-file -e optional-extra-vars

    where optional-extra-vars can be:

    -   The backup\_filename is the local registry backup tar file. It
        must be provided using the ``-e`` option on the command line, for
        example:

        .. code-block:: none

            -e backup\_filename= localhost_docker_local_registry_backup_2020_07_15_21_24_22.tgz

    -   The initial\_backup\_dir is the location on the Ansible control
        machine where the platform backup tar file is located. It must be
        provided using ``-e`` option on the command line.

    -   The :command:`ansible\_become\_pass`, and
        :command:`ansible\_ssh\_pass` need to be set correctly using the
        ``-e`` option on the command line or in the Ansible secret file.
        :command:`ansible\_ssh\_pass` is the password to the sysadmin user
        on controller-0.

    -   The backup\_dir should be set to a directory on controller-0.
        The directory must have sufficient space for local registry backup
        to be copied. The backup\_dir is set using the ``-e`` option on the
        command line.

    -   The :command:`ansible\_remote\_tmp` should be set to a new
        directory on controller-0. Ansible will use this directory to copy
        files, and the directory must have sufficient space for local
        registry backup to be copied. The :command:`ansible\_remote\_tmp`
        is set using the ``-e`` option on the command line.

    For example, run the local registry restore playbook, where
    /sufficient/space directory on the controller has sufficient space left
    for the archived file to be copied.

    .. parsed-literal::

        ~(keystone_admin)]$ ansible-playbook /localdisk/designer/jenkins/tis-stx-dev/cgcs-root/stx/ansible-playbooks/playbookconfig/src/playbooks/restore_user_images.ym --limit |prefix|\_Cluster -i $HOME/br_test/hosts -e "ansible_become_pass=St0rlingX* ansible_ssh_pass=St0rlingX* initial_backup_dir=$HOME/br_test backup_filename= |prefix|\_Cluster_docker_local_registry_backup_2020_07_15_21_24_22.tgz ansible_remote_tmp=/sufficient/space backup_dir=/sufficient/space"
