
.. Greg updates required for -High Security Vulnerability Document Updates

.. rmy1571265233932
.. _running-restore-playbook-locally-on-the-controller:

==============================================
Run Restore Playbook Locally on the Controller
==============================================

To run restore on the controller, you need to upload the backup to the
active controller.

You can use an external storage device, for example, a USB drive. Use the
following commands to run the Ansible Restore playbook:

**Optimized**: Optmized restore must be used on |AIO-SX|.

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "restore_mode=optimized initial_backup_dir=<location_of_tarball ansible_become_pass=<admin_password> admin_password=<admin_password backup_filename=<backup_filename> wipe_ceph_osds=<true/false> restore_registry_filesystem=true"

**Legacy**:  Legacy restore must be used on systems that are not |AIO-SX|.

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=<location_of_tarball ansible_become_pass=<admin_password> admin_password=<admin_password backup_filename=<backup_filename> wipe_ceph_osds=<true/false>"

Below you can find other ``-e`` command line options:

**Common**

``-e restore_mode=optimized``
    Enable optimized restore mode

    .. note::

        Optimized restore is currently supported only on |AIO-SX| systems.

``-e "initial_backup_dir=/home/sysadmin"``
    Where the backup tgz files are located on box.

``-e backup_filename=localhost_platform_backup.tgz``
    The basename of the platform backup tgz.  The full path will be a
    combination ``{initial_backup_dir}/{backup_filename}``

.. _running-restore-playbook-locally-on-the-controller-steps-usl-2c3-pmb:

(Optional): You can select one of the following restore modes:

-   To keep the Ceph cluster data intact (false - default option), use the
    ``wipe_ceph_osds=false`` parameter.

-   To wipe the Ceph cluster entirely (true), where the Ceph cluster will
    need to be recreated, use the ``wipe_ceph_osds=true`` parameter.

-   To define a convinient place to store the backup files, defined by
    ``initial-backup_dir``, on the system (such as the home folder for
    sysadmin, or /tmp, or even a mounted USB device), use the
    ``on_box_data=true/false`` parameter.

    If this parameter is set to true, Ansible Restore playbook will look
    for the backup file provided on the target server. The parameter
    ``initial_backup_dir`` can be ommited from the command line. In this
    case, the backup file will be under ``/opt/platform-backup`` directory.

    If this parameter is set to false, the Ansible Restore playbook will
    look for backup file provided on the Ansible controller. In this
    case, both the ``initial_backup_dir`` and ``backup_filename`` must be
    specified in the command.

    Example of a backup file in ``/home/sysadmin``:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=/home/sysadmin ansible_become_pass=St8rlingX* admin_password=St8rlingX* backup_filename=localhost_platform_backup_2020_07_27_07_48_48.tgz wipe_ceph_osds=true"

    .. note::

        If the backup contains patches, Ansible Restore playbook will apply
        the patches and prompt you to reboot the system. Then you will need
        to re-run Ansible Restore playbook.

        The flag ``wipe_ceph_osds=true`` is required for a restore in a new
        hardware. For more details, see :ref:`node-replacement-for-aiominussx-using-optimized-backup-and-restore-6603c650c80d`.


-   ``ssl_ca_certificate_file`` defines a single certificate that
    contains all the ssl_ca certificates that will be installed during the
    restore. It will replace
    ``/opt/platform/config/<software-version>/ca-cert.pem``, which is a
    single certificate containing all the ssl_ca certificates installed in
    the host when the backup was done. The certificate assigned to this
    parameter must follow this same pattern.

    For example:

    .. code-block:: none

        ssl_ca_certificate_file=<complete path>/<ssl_ca certificates file>

        E.g.:

        -e "ssl_ca_certificate_file=/home/sysadmin/new_ca-cert.pem"

    This parameter depends on ``on_box_data`` value.

    When ``on_box_data=true`` or not defined, ``ssl_ca_certificate_file``
    will be the location of the ``ssl_ca`` certificate file on the target host.
    This is the default case.

    When ``on_box_data=false``, ``ssl_ca_certificate_file`` will be the
    location of the ``ssl_ca`` certificate file where the Ansible controller is
    running. This is useful for remote play.

    .. note::

        To use this option on local restore mode, you need to download the
        ``ssl_ca`` certificate file to the active controller.

**Legacy**

``-e skip_patching=true``
    Patching will not be restored from the backup. With this option, you
    will need to manually restore any patching before running the restore
    playbook.

``-e restore_user_images=true``
    Restores the user images created during backup when ``backup_user_images`` was
    true. If the user images are not restored, the images must be pulled from
    upstream or ``registry.central``.

**Optimized**

``-e restore_registry_filesystem=true``
    Restores the registry images created during backup when
    ``backup_registry_filesystem`` was true.  If the registry filesystem is not
    restored the images must be pulled from upstream or registry.central.

``-e registry_backup_filename=custom_name_registry_filesystem_backup.tgz``
    By default this override is not required.  When
    ``restore_registry_filesystem`` is true and a custom name was used during
    backup, ``registry_backup_filename`` needs to be set to match. The full
    path will be a combination
    ``{initial_backup_dir}/{registry_backup_filename}``

.. note::

    After restore is completed it is not possible to restart (or rerun) the
    restore playbook.
