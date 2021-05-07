
.. bqg1571264986191
.. _running-ansible-backup-playbook-locally-on-the-controller:

=====================================================
Run Ansible Backup Playbook Locally on the Controller
=====================================================

In this method the Ansible Backup playbook is run on the active controller.

Use the following command to run the Ansible Backup playbook and back up the
|prod| configuration, data, and user container images in registry.local data:

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml -e "ansible_become_pass=<sysadmin password> admin_password=<sysadmin password>" -e "backup_user_local_registry=true"

The <admin\_password> and <ansible\_become\_pass\> need to be set  correctly
using the ``-e`` option on the command line, or an override file, or in the
Ansible secret file.

The output files will be named:

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-wj1-vxh-pmb:

-   inventory\_hostname\_platform\_backup\_timestamp.tgz

-   inventory\_hostname\_openstack\_backup\_timestamp.tgz

-   inventory\_hostname\_docker\_local\_registry\_backup\_timestamp.tgz

-   inventory\_hostname\_dc\_vault\_backup\_timestamp.tgz

The variables prefix can be overridden using the ``-e`` option on the command
line or by using an override file.

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-rdp-gyh-pmb:

-   platform\_backup\_filename\_prefix

-   openstack\_backup\_filename\_prefix

-   docker\_local\_registry\_backup\_filename\_prefix

-   dc\_vault\_backup\_filename\_prefix

The generated backup tar files will be displayed in the following format,
for example:

.. _running-ansible-backup-playbook-locally-on-the-controller-ul-p3b-f13-pmb:

-   localhost\_docker\_local\_registry\_backup\_2020\_07\_15\_21\_24\_22.tgz

-   localhost\_platform\_backup\_2020\_07\_15\_21\_24\_22.tgz

-   localhost\_openstack\_backup\_2020\_07\_15\_21\_24\_22.tgz

-   localhost\_dc\_vault\_backup\_2020\_07\_15\_21\_24\_22.tgz

These files are located by default in the /opt/backups directory on
controller-0, and contains the complete system backup.

If the default location needs to be modified, the variable backup\_dir can
be overridden using the ``-e`` option on the command line or by using an
override file.

