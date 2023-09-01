
.. Greg updates required for -High Security Vulnerability Document Updates

.. bqg1571264986191
.. _running-ansible-backup-playbook-locally-on-the-controller:

=====================================================
Run Ansible Backup Playbook Locally on the Controller
=====================================================

In this method the Ansible Backup playbook is run on the active controller.

Use the following command to run the Ansible Backup playbook and back up the
|prod| configuration, data, and user container images in registry.local:

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml -e "ansible_become_pass=<sysadmin password> admin_password=<sysadmin password>" -e "backup_registry_filesystem=true"
    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml --ask-vault-pass -e "override_files_dir=$HOME/override_dir"


To exclude a directory and all the files in it like ``/var/home*`` you can use
the optional parameter:

:command:`-e "exclude_dirs=/var/home/**,/var/home"`

.. note::

    A 'glob' pattern is required to use ``-e "exclude_dirs=/var/home/**,/var/home"``,
    in order to ensure there is sufficient free space in the required
    directories in any event.

.. note::

    To exclude multiple files and directories, separate them with a comma.

    Excluding patch data can save a significant amount of storage space,
    transfer time, and compress/decompress computation.

To exclude patch data from being included in the backup, you can use the parameter:
``-e exclude_dirs=/opt/patching/**/*``.

.. warning::
    
    Patch data should only be excluded for |AIO-SX| deployments when optimized
    Restore is used.

The <admin_password> and <ansible_become_pass> need to be set  correctly
using the ``-e`` option on the command line, with an override file secured with
ansible-vault (recommended).

For example, create your override file with the :command:`ansible-vault create $HOME/override_dir/localhost-backup.yaml`
command and copy the following lines into the file. You will be prompted for a
password to protect/encrypt the file. Use the :command:`ansible-vault edit $HOME/override_dir/localhost-backup.yaml`
command if the file needs to be edited after it is created.

.. code-block:: none

   ansible_become_pass: "<admin_password>"
   admin_password: "<admin_password>"
   backup_registry_filesystem: "true"
   exclude_dirs: /var/home/**,/var/home"
   ...
   EOF

The extra var ``backup_registry_filesystem`` is an optional parameter and it is
used to backup all images on the registry backup, generating a file named
``{inventory_hostname}_image_registry_backup_YYYY_MM_DD_HH_mm_ss.tgz``. When
not specified, the restore will download images from the upstream docker
registry.

For example:

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml -e "backup_registry_filesystem=true"


A list of possible output files, files created depend on backup options and
system configuration.

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-wj1-vxh-pmb:

-   ``inventory_hostname_platform_backup_timestamp.tgz``

-   ``inventory_hostname_wr-openstack_backup_timestamp.tgz``

-   ``inventory_hostname_user_images_backup_timestamp.tgz``

-   ``inventory_hostname_dc_vault_backup_timestamp.tgz``

-   ``inventory_hostname_image_registry_backup_timestamp.tgz``

The output files' prefixes can be overridden with the following variables
using the ``-e`` option on the command line or by using an override file.

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-rdp-gyh-pmb:

-   platform_backup_filename_prefix

-   openstack_backup_filename_prefix

-   docker_local_registry_backup_filename_prefix

-   dc_vault_backup_filename_prefix

-   openstack_app_name: "|prod-os|" (optional for |prod-os| application backup)

-   registry_filesystem_backup_filename_prefix

The generated backup tar files will be displayed in the following format, when
custom prefixes are not specified, for example:

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-p3b-f13-pmb:

-   ``localhost_docker_local_registry_backup_2020_07_15_21_24_22.tgz``

-   ``localhost_platform_backup_2020_07_15_21_24_22.tgz``

-   ``localhost_openstack_backup_2020_07_15_21_24_22.tgz``

-   ``localhost_dc_vault_backup_2020_07_15_21_24_22.tgz``

-   ``localhost_image_registry_backup_2020_07_15_21_24_22.tgz``

These files are located by default in the ``/opt/backups`` directory on
controller-0, and contains the complete system backup.

If the default location needs to be modified, the variable backup_dir can
be overridden using the ``-e`` option on the command line or by using an
override file.

