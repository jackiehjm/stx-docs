
.. Greg updates required for -High Security Vulnerability Document Updates

.. quy1571265365123
.. _system-backup-running-ansible-restore-playbook-remotely:

=====================================
Run Ansible Restore Playbook Remotely
=====================================

In this method you can run Ansible Restore playbook and point to controller-0.

.. rubric:: |prereq|

.. _system-backup-running-ansible-restore-playbook-remotely-ul-ylm-g44-bkb:

-   It is recommended that you have Ansible version 2.7.5 or higher installed
    on your remote workstation. Copy the Ansible Backup/Restore playbooks
    from directory ``/usr/share/ansible/stx-ansible/playbooks/``.

-   Your network has IPv6 connectivity before running Ansible Playbook, if
    the system configuration is IPv6.

.. rubric:: |proc|

.. _system-backup-running-ansible-restore-playbook-remotely-steps-sgp-jjc-ljb:

#.  Log in to the remote workstation.

    You can log in directly on the console or remotely using :command:`ssh`.

#.  Provide an inventory file, either a customized one that is specified
    using the ``-i`` option, or the default one that is in the Ansible
    configuration directory (that is, /etc/ansible/hosts). You must
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

    where ``optional-extra-vars`` can be:

    -   To keep Ceph data intact (false - default option), use the
        following parameter:

        :command:`wipe_ceph_osds=false`

    -   To start with an empty Ceph cluster (true), where the Ceph
        cluster will need to be recreated, use the following parameter:

        :command:`wipe_ceph_osds=true`

    -   To define a convinient place to store the backup files, defined by
        ``initial-backup_dir``, on the system (such as the home folder for
        sysadmin, or /tmp, or even a mounted USB device), use the following
        parameter:

        :command:`on_box_data=true/false`

        If this parameter is set to true, Ansible Restore playbook will look
        for the backup file provided on the target server. The parameter
        ``initial_backup_dir`` can be ommited from the command line. In this
        case, the backup file will be under ``/opt/platform-backup`` directory.

        If this parameter is set to false, the Ansible Restore playbook will
        look for backup file provided where is the Ansible controller. In this
        case, both the ``initial_backup_dir`` and ``backup_filename`` must be
        specified in the command.

    -   The ``backup_filename`` is the platform backup tar file. It must be
        provided using the ``-e`` option on the command line, for example:

        .. code-block:: none

           -e backup_filename= localhost_platform_backup_2019_07_15_14_46_37.tgz

    -   The ``initial_backup_dir`` is the location where the platform backup
        tar file is placed to restore the platform. It must be provided using
        ``-e`` option on the command line.

        .. note::

            When ``on_box_data=false``, ``initial_backup_dir`` must be defined.

    -   The :command:`admin_password`, :command:`ansible_become_pass`,
        and :command:`ansible_ssh_pass` need to be set correctly using
        the ``-e`` option on the command line or in the Ansible secret file.
        :command:`ansible_ssh_pass` is the password to the sysadmin user
        on controller-0.

    -   The :command:`ansible_remote_tmp` should be set to a new
        directory (not required to create it ahead of time) under
        /home/sysadmin on controller-0 using the ``-e`` option on the command
        line.

        For example:

        .. parsed-literal::

            ~(keystone_admin)]$ ansible-playbook /localdisk/designer/jenkins/tis-stx-dev/cgcs-root/stx/ansible-playbooks/playbookconfig/src/playbooks/restore_platform.yml --limit |prefix|\_Cluster -i $HOME/br_test/hosts -e "ansible_become_pass=St0rlingX* admin_password=St0rlingX* ansible_ssh_pass=St0rlingX* initial_backup_dir=$HOME/br_test backup_filename= |prefix|\_Cluster_system_backup_2019_08_08_15_25_36.tgz ansible_remote_tmp=/home/sysadmin/ansible-restore"

    -   The ``ssl_ca_certificate_file`` defines a single certificate that
        contains all the ssl_ca certificates that will be installed during the
        restore. It will replace the
        ``/opt/platform/config/<software-version>/ca-cert.pem``, which is a
        single certificate containing all the ssl_ca certificates installed in
        the host when backup was done. So, the certificate assigned to this
        parameter must follow this same pattern.

        For example:

        .. code-block:: none

            ssl_ca_certificate_file=<complete path>/<ssl_ca certificates file>

            E.g.:

            -e "ssl_ca_certificate_file=/home/sysadmin/new_ca-cert.pem"

    .. note::

        If the backup contains patches, Ansible Restore playbook will apply
        the patches and prompt you to reboot the system. Then you will need to
        re-run Ansible Restore playbook.

    .. note::

        After restore is completed it is not possible to restart (or rerun) the
        restore playbook.

#.  After running the ``restore_platform.yml`` playbook, you can restore the
    local registry images.

    .. note::
        The backup file of the local registry may be large. Restore the
        backed up file on the controller, where there is sufficient space.

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook path-to-restore-user-images-playbook-entry-file --limit host-name -i inventory-file -e optional-extra-vars

    where ``optional-extra-vars`` can be:

    -   The ``backup_filename`` is the local registry backup tar file. It
        must be provided using the ``-e`` option on the command line, for
        example:

        .. code-block:: none

            -e backup_filename= localhost_docker_local_registry_backup_2020_07_15_21_24_22.tgz

    -   The initial_backup_dir is the location on the Ansible control
        machine where the platform backup tar file is located. It must be
        provided using ``-e`` option on the command line.

    -   The :command:`ansible_become_pass`, and
        :command:`ansible_ssh_pass` need to be set correctly using the
        ``-e`` option on the command line or in the Ansible secret file.
        :command:`ansible_ssh_pass` is the password to the sysadmin user
        on controller-0.

    -   The backup_dir should be set to a directory on controller-0.
        The directory must have sufficient space for local registry backup
        to be copied. The backup_dir is set using the ``-e`` option on the
        command line.

    -   The :command:`ansible_remote_tmp` should be set to a new
        directory on controller-0. Ansible will use this directory to copy
        files, and the directory must have sufficient space for local
        registry backup to be copied. The :command:`ansible_remote_tmp`
        is set using the ``-e`` option on the command line.

    For example, run the local registry restore playbook, where
    /sufficient/space directory on the controller has sufficient space left
    for the archived file to be copied.

    .. parsed-literal::

        ~(keystone_admin)]$ ansible-playbook /localdisk/designer/jenkins/tis-stx-dev/cgcs-root/stx/ansible-playbooks/playbookconfig/src/playbooks/restore_user_images.ym --limit |prefix|\_Cluster -i $HOME/br_test/hosts -e "ansible_become_pass=St0rlingX* ansible_ssh_pass=St0rlingX* initial_backup_dir=$HOME/br_test backup_filename= |prefix|\_Cluster_docker_local_registry_backup_2020_07_15_21_24_22.tgz ansible_remote_tmp=/sufficient/space backup_dir=/sufficient/space"
