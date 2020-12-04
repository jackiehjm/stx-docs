
.. rmy1571265233932
.. _running-restore-playbook-locally-on-the-controller:

==============================================
Run Restore Playbook Locally on the Controller
==============================================

To run restore on the controller, you need to download the backup to the
active controller.

.. rubric:: |context|

You can use an external storage device, for example, a USB drive. Use the
following command to run the Ansible Restore playbook:

.. code-block:: none

    ~(keystone_admin)$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=<location_of_tarball ansible_become_pass=<admin_password> admin_password=<admin_password backup_filename=<backup_filename> wipe_ceph_osds=<true/false>"

The |prod| restore supports two optional modes, keeping the Ceph cluster data
intact or wiping the Ceph cluster.

.. rubric:: |proc|

.. _running-restore-playbook-locally-on-the-controller-steps-usl-2c3-pmb:

#.  To keep the Ceph cluster data intact \(false - default option\), use the
    following command:

    .. code-block:: none

       wipe_ceph_osds=false

#.  To wipe the Ceph cluster entirely \(true\), where the Ceph cluster will
    need to be recreated, use the following command:

    .. code-block:: none

       wipe_ceph_osds=true

    Example of a backup file in /home/sysadmin

    .. code-block:: none

        ~(keystone_admin)$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=/home/sysadmin ansible_become_pass=St0rlingX* admin_password=St0rlingX* backup_filename=localhost_platform_backup_2020_07_27_07_48_48.tgz wipe_ceph_osds=true"

    .. note::
        If the backup contains patches, Ansible Restore playbook will apply
        the patches and prompt you to reboot the system. Then you will need to
        re-run Ansible Restore playbook.

.. rubric:: |postreq|

After running restore\_platform.yml playbook, you can restore the local
registry images.

.. note::
    The backup file of the local registry images may be large. Restore the
    backed up file on the controller, where there is sufficient space.

For example:

.. code-block:: none

    ~(keystone_admin)$  ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_user_images.yml -e "initial_backup_dir=/home/sysadmin backup_filename=localhost_docker_local_registry_backup_2020_07_15_21_24_22.tgz ansible_become_pass=St0rlingX*"
