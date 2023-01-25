
.. Greg updates required for -High Security Vulnerability Document Updates

.. kpt1571265015137

.. _running-ansible-backup-playbook-remotely:

====================================
Run Ansible Backup Playbook Remotely
====================================

In this method you can run Ansible Backup playbook on a remote workstation
and target it at controller-0.

.. rubric:: |prereq|

.. _running-ansible-backup-playbook-remotely-ul-evh-yn4-bkb:

-   You need to have Ansible installed on your remote workstation, along
    with the Ansible Backup/Restore playbooks.

-   Your network has IPv6 connectivity before running Ansible Playbook, if
    the system configuration is IPv6.

.. rubric:: |proc|

.. _running-ansible-backup-playbook-remotely-steps-bnw-bnc-ljb:

#.  Log in to the remote workstation.

#.  Create secret and backup folders.

    For example:

    .. code-block::

        cd $HOME
        mkdir -p <br> <overrides>

#.  Provide either a customized Ansible hosts file specified using the ``-i``
    option, or use the default one in the Ansible configuration directory
    \(that is, /etc/ansible/hosts\).

    #. If using a customized file, change to the ``<br>`` directory created
       in the previous step.

    #. Make the following modifications. You must specify the floating |OAM| IP
       of the controller host and the ``ansible_ssh_user`` information. If the
       host name is |prefix|\_Cluster, the inventory file should have an entry
       |prefix|\_Cluster.

       For example:

       .. parsed-literal::

           ---
           all:
             hosts:
               wc68:
                 ansible_host: 128.222.100.02
               |prefix|\_Cluster:
                 ansible_host: 128.224.141.74

              vars:
                ansible_ssh_user: sysadmin
                ansible_ssh_pass: <sysadmin-passwd>
                ansible_become_pass: <sysadmin-passwd>

#.  Switch to the <overrides> directory created previously.

#.  Create a new secret file encrypted with Ansible-Vault using the
    :command:`ansible-vault create $HOME/override_dir/secrets.yml` command.

    Set and confirm a new Ansible-Vault password. Ansible will open an editing
    window where you can enter your desired contents.

    The following settings are usually common to all hosts, in which case they
    can be placed in the ``secrets.yml`` file.


    .. code-block:: none

        vault_password_change_responses:
            yes/no: 'yes'
            sysadmin*: 'sysadmin'
            (current) UNIX password: 'sysadmin'
            New password: 'St8rlingX*'
            Retype new password: 'St8rlingX*'
        admin_password: St8rlingX*
        ansible_become_pass: St8rlingX*
        ansible_ssh_pass: St8rlingX*

    Save your changes and quit the editor. If you need to make additional
    changes, you can use the command :command:`ansible-vault edit
    $HOME/override_dir/secrets.yml`.

#.  Run Ansible Backup playbook:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook <path-to-backup-playbook-entry-file> -ask-vault-pass -e "host_backup_dir=$HOME/br_test override_files_dir=$HOME/override_dir"

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook backup.yml --limit sm5 -i $HOME/br_test/hosts --ask-vault-pass -e "host_backup_dir=$HOME/br_test override_files_dir=$HOME/override_dir"

    The generated backup tar file can be found in <host\_backup\_dir>, that
    is, /home/sysadmin, by default. You can overwrite it using the **-e**
    option on the command line or in an override file.

    .. warning::
        If a backup of the **local registry images** file is created, the file
        is not copied from the remote machine to the local machine. The
        ``inventory_hostname_docker_local_registry_backup_timestamp.tgz``
        file needs to copied off the host machine to be used if a restore is
        needed.
