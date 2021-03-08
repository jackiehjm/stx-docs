
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

#.  Provide an Ansible hosts file, either, a customized one that is
    specified using the ``-i`` option, or the default one that resides in the
    Ansible configuration directory \(that is, /etc/ansible/hosts\). You must
    specify the floating |OAM| IP of the controller host. For example, if the
    host name is |prefix|\_Cluster, the inventory file should have an entry
    |prefix|\_Cluster, for example:

    .. parsed-literal::

        ---
        all:
          hosts:
            wc68:
              ansible_host: 128.222.100.02
            |prefix|\_Cluster:
              ansible_host: 128.224.141.74

#.  Create an ansible secrets file.

    .. code-block:: none

        ~(keystone_admin)]$ cat <<EOF > secrets.yml
        vault_password_change_responses:
            yes/no: 'yes'
            sysadmin*: 'sysadmin'
            (current) UNIX password: 'sysadmin'
            New password: 'Li69nux*'
            Retype new password: 'Li69nux*'
        admin_password: Li69nux*
        ansible_become_pass: Li69nux*
        ansible_ssh_pass: Li69nux*
        EOF

#.  Run Ansible Backup playbook:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook <path-to-backup-playbook-entry-file> --limit host-name -i <inventory-file> -e "backup_user_local_registry=true"

    The generated backup tar file can be found in <host\_backup\_dir>, that
    is, /home/sysadmin, by default. You can overwrite it using the **-e**
    option on the command line or in an override file.

    .. warning::
        If a backup of the **local registry images** file is created, the file
        is not copied from the remote machine to the local machine. The
        inventory\_hostname\_docker\_local\_registry\_backup\_timestamp.tgz
        file needs to copied off the host machine to be used if a restore is
        needed.
