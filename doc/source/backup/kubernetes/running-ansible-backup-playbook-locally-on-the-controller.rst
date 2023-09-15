
.. bqg1571264986191
.. _running-ansible-backup-playbook-locally-on-the-controller:

=====================================================
Run Ansible Backup Playbook Locally on the Controller
=====================================================

In this method the Ansible Backup playbook is run on the active controller.

Use one of the following commands to run the Ansible Backup playbook and back
up the |prod| configuration, data, and user container images in registry.local:

-
    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml -e "ansible_become_pass=<sysadmin password> admin_password=<sysadmin password>" -e "backup_registry_filesystem=true"

-
    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml --ask-vault-pass -e "override_files_dir=$HOME/override_dir"

The <admin_password> and <ansible_become_pass> need to be set correctly
using the ``-e`` option on the command line, with an override file secured with
ansible-vault (recommended).

For example, create your override file with the :command:`ansible-vault create $HOME/override_dir/localhost-backup.yaml`
command and copy the following lines into the file. You will be prompted for a
password to protect/encrypt the file. Use the :command:`ansible-vault edit $HOME/override_dir/localhost-backup.yaml`
command if the file needs to be edited after it is created.

.. code-block:: none

   cat << EOF > localhost-backup.yaml
   ---
   ansible_become_pass: "<admin_password>"
   admin_password: "<admin_password>"
   backup_user_local_registry: "true"
   ...
   EOF

The output files will be named:

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-wj1-vxh-pmb:

-   inventory_hostname_platform_backup_timestamp.tgz

-   inventory_hostname_wr-openstack_backup_timestamp.tgz

-   inventory_hostname_docker_local_registry_backup_timestamp.tgz

-   inventory_hostname_dc_vault_backup_timestamp.tgz

The output files' prefixes can be overridden with the following variables
using the ``-e`` option on the command line or by using an override file.

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-rdp-gyh-pmb:

-   platform_backup_filename_prefix

-   openstack_backup_filename_prefix

-   docker_local_registry_backup_filename_prefix

-   dc_vault_backup_filename_prefix

-   openstack_app_name: "|prod-os|" (optional for |prod-os| application backup)

The generated backup tar files will be displayed in the following format,
for example:

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-p3b-f13-pmb:

-   localhost_docker_local_registry_backup_2020_07_15_21_24_22.tgz

-   localhost_platform_backup_2020_07_15_21_24_22.tgz

-   localhost_openstack_backup_2020_07_15_21_24_22.tgz

-   localhost_dc_vault_backup_2020_07_15_21_24_22.tgz

These files are located by default in the /opt/backups directory on
controller-0, and contains the complete system backup.

If the default location needs to be modified, the variable backup_dir can
be overridden using the ``-e`` option on the command line or by using an
override file.

