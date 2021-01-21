==================
Backup and Restore
==================

This guide describes the StarlingX backup and restore functionality.


.. contents::
   :local:
   :depth: 2

--------
Overview
--------

This feature provides a last resort disaster recovery option for situations
where the StarlingX software and/or data are compromised. The provided backup
utility creates a deployment state snapshot, which can be used to restore the
deployment to a previously good working state.

There are two main options for backup and restore:

* Platform restore, where the platform data is re-initialized, but the
  applications are preserved – including OpenStack, if previously installed.
  During this process, you can choose to keep the Ceph cluster (Default
  option: ``wipe_ceph_osds=false``) or to wipe it and restore Ceph data from
  off-box copies (``wipe_ceph_osds=true``).

* OpenStack application backup and restore, where only the OpenStack application
  is restored. This scenario deletes the OpenStack application, re-applies the
  OpenStack application, and restores data from off-box copies (Glance, Ceph
  volumes, database).

This guide describes both restore options, including the backup procedure.

.. note::

      * Ceph application data is **not** backed up. It is preserved by the
        restore process by default (``wipe_ceph_osds=false``), but it is not
        restored if ``wipe_ceph_osds=true`` is used. You can protect against
        Ceph cluster failures by using off-box custom backups.

      * During restore, images for applications that are integrated with
        StarlingX are automatically downloaded to the local registry from
        external sources. If your system has custom Kubernetes pods that use the
        local registry and are **not** integrated with StarlingX, after restore
        you should confirm that the correct images are present, so the
        applications can restart automatically.

----------
Backing up
----------

There are two methods for backing up: local play method and remote play method.

~~~~~~~~~~~~~~~~~
Local play method
~~~~~~~~~~~~~~~~~

Run the following command:

::

  ansible-playbook /usr/share/ansible/stx-ansible/playbooks/backup.yml -e "ansible_become_pass=<sysadmin password> admin_password=<sysadmin password>"

The ``<admin_password>`` and ``<ansible_become_pass>`` must be set correctly by
one of the following methods:

* The ``-e`` option on the command line
* An override file
* In the Ansible secret file

The output of the command is a file named in this format:
``<inventory_hostname>_platform_backup_<timestamp>.tgz``

The prefixes ``<platform_backup_filename_prefix>`` and
``<openstack_backup_filename_prefix>`` can be overridden via the ``-e`` option
on the command line or an override file.

The generated backup tar files will look like this:
``localhost_platform_backup_2019_08_08_15_25_36.tgz`` and
``localhost_openstack_backup_2019_08_08_15_25_36.tgz``. They are located in
the ``/opt/backups`` directory on controller-0.

~~~~~~~~~~~~~~~~~~
Remote play method
~~~~~~~~~~~~~~~~~~

#.  Log in to the host where Ansible is installed and clone the playbook code
    from opendev at https://opendev.org/starlingx/ansible-playbooks.git

#.  Provide an inventory file, either a customized one that is specified via the
    ``-i`` option or the default one which resides in the Ansible configuration
    directory (``/etc/ansible/hosts``). You must specify the IP of the controller
    host. For example, if the host-name is ``my_vbox``, the inventory-file should
    have an entry called ``my_vbox`` as shown in the example below:

    ::

      all:
        hosts:
          wc68:
            ansible_host: 128.222.100.02
         my_vbox:
            ansible_host: 128.224.141.74

#.  Run Ansible with the command:

    ::

      ansible-playbook <path-to-backup-playbook-entry-file> --limit host-name -i <inventory-file> -e <optional-extra-vars>

    The generated backup tar files can be found in ``<host_backup_dir>`` which
    is ``$HOME`` by default. It can be overridden by the ``-e`` option on the
    command line or in an override file.

    The generated backup tar file has the same naming convention as the local
    play method.

Example:

::

  ansible-playbook /localdisk/designer/repo/cgcs-root/stx/stx-ansible-playbooks/playbookconfig/src/playbooks/backup-restore/backup.yml --limit my_vbox -i $HOME/br_test/hosts -e "host_backup_dir=$HOME/br_test ansible_become_pass=Li69nux* admin_password=Li69nux* ansible_ssh_pass=Li69nux* ansible_ssh_pass=Li69nux*"


~~~~~~~~~~~~~~~~~~~~~~
Backup content details
~~~~~~~~~~~~~~~~~~~~~~

The backup contains the following:

* Postgresql config: Backup roles, table spaces and schemas for databases

* Postgresql data:

  * template1, sysinv, barbican db data, fm db data,

  * keystone db for primary region,

  * dcmanager db for dc controller,

  * dcorch db for dc controller

* ETCD database

* LDAP db

* Ceph crushmap

* DNS server list

* System Inventory network overrides. These are needed at restore to correctly
  set up the OS configuration:

  * addrpool

  * pxeboot_subnet

  * management_subnet

  * management_start_address

  * cluster_host_subnet

  * cluster_pod_subnet

  * cluster_service_subnet

  * external_oam_subnet

  * external_oam_gateway_address

  * external_oam_floating_address

* Docker registries on controller

* Docker proxy  (See :doc:`../configuration/docker_proxy_config` for details.)

* Backup data:

  * OS configuration

    ok: [localhost] => (item=/etc) Note:  Although everything here is backed up,
    not all of the content will be restored.

  * Home directory ‘sysadmin’ user and all LDAP user accounts

    ok: [localhost] => (item=/home)

  * Generated platform configuration

    ok: [localhost] => (item=/opt/platform/config/<SW_VERSION>)

    ok: [localhost] => (item=/opt/platform/puppet/<SW_VERSION>/hieradata) - All the
    hieradata in this folder is backed up. However, only the static hieradata
    (static.yaml and secure_static.yaml) will be restored to bootstrap
    controller-0.

  * Keyring

    ok: [localhost] => (item=/opt/platform/.keyring/<SW_VERSION>)

  * Patching and package repositories

    ok: [localhost] => (item=/opt/patching)

    ok: [localhost] => (item=/www/pages/updates)

  * Extension filesystem

    ok: [localhost] => (item=/opt/extension)

  * atch-vault filesystem for distributed cloud system-controller

    ok: [localhost] => (item=/opt/patch-vault)

  * Armada manifests

    ok: [localhost] => (item=/opt/platform/armada/<SW_VERSION>)

  * Helm charts

    ok: [localhost] => (item=/opt/platform/helm_charts)


---------
Restoring
---------

This section describes the platform restore and OpenStack restore processes.

~~~~~~~~~~~~~~~~
Platform restore
~~~~~~~~~~~~~~~~

In the platform restore process, the etcd and system inventory databases are
preserved by default. You can choose to preserve the Ceph data or to wipe it.

* To preserve Ceph cluster data, use ``wipe_ceph_osds=false``.

* To start with an empty Ceph cluster, use ``wipe_ceph_osds=true``. After the
  restore procedure is complete and before you restart the applications, you
  must restore the Ceph data from off-box copies.

Steps:

#.  Backup: Run the backup.yml playbook, whose output is a platform backup
    tarball. Move the backup tarball outside of the cluster for safekeeping.

#.  Restore:

    a.  If using ``wipe_ceph_osds=true``, then power down all the nodes.

        **Do not** power down storage nodes if using ``wipe_ceph_osds=false``.

        .. important::

                It is mandatory for the storage cluster to remain functional
                during restore when ``wipe_ceph_osds=false``, otherwise data
                loss will occur. Power down storage nodes only when
                ``wipe_ceph_osds=true``.

    #.  Reinstall controller-0.

    #.  Run the Ansible restore_platform.yml playbook to restore a full system
        from the platform tarball archive. For this step, similar to the backup
        procedure, we have two options: local and remote play.

        **Local play**

        i.  Download the backup to the controller. You can also use an external
            storage device, for example, a USB drive.

        #.  Run the command:

        ::

          ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_platform.yml -e "initial_backup_dir=<location_of_tarball> ansible_become_pass=<admin_password> admin_password=<admin_password> backup_filename=<backup_filename>"

        **Remote play**

        i.  Log in to the host where Ansible is installed and clone the playbook
            code from OpenDev at
            https://opendev.org/starlingx/ansible-playbooks.git

        #.  Provide an inventory file, either a customized one that is specified
            via the ``-i`` option or the default one that resides in the Ansible
            configuration directory (``/etc/ansible/hosts``). You must specify
            the IP of the controller host. For example, if the host-name is
            ``my_vbox``, the inventory-file should have an entry called
            ``my_vbox`` as shown in the example below.

            ::

              all:
              hosts:
                  wc68:
                  ansible_host: 128.222.100.02
              my_vbox:
                  ansible_host: 128.224.141.74

        #.  Run Ansible:

            ::

              ansible-playbook <path-to-backup-playbook-entry-file> --limit host-name -i <inventory-file> -e <optional-extra-vars>

            Where ``optional-extra-vars`` include:

            * ``<wipe_ceph_osds>`` is set to either ``wipe_ceph_osds=false``
              (Default:  Keep Ceph data intact) or
              ``wipe_ceph_osds=true`` (Start with an empty Ceph cluster).

            * ``<backup_filename>`` is the platform backup tar file. It must be
              provided via the ``-e`` option on the command line. For example,
              ``-e “backup_filename=localhost_platform_backup_2019_07_15_14_46_37.tgz”``

            * ``<initial_backup_dir>`` is the location on the Ansible
              control machine where the platform backup tar file is placed to
              restore the platform. It must be provided via the ``-e`` option on
              the command line.

            * ``<admin_password>``, ``<ansible_become_pass>`` and
              ``<ansible_ssh_pass>`` must be set correctly via the ``-e``
              option on the command line or in the Ansible secret file.
              ``<ansible_ssh_pass>`` is the password for the sysadmin user on
              controller-0.

            * ``<ansible_remote_tmp>`` should be set to a new directory (no
              need to create it ahead of time) under ``/home/sysadmin`` on
              controller-0 via the ``-e`` option on the command line.

            Example command:

            ::

              ansible-playbook /localdisk/designer/jenkins/tis-stx-dev/cgcs-root/stx/ansible-playbooks/playbookconfig/src/playbooks/restore_platform.yml --limit my_vbox -i $HOME/br_test/hosts -e " ansible_become_pass=Li69nux* admin_password=Li69nux* ansible_ssh_pass=Li69nux* initial_backup_dir=$HOME/br_test backup_filename=my_vbox_system_backup_2019_08_08_15_25_36.tgz ansible_remote_tmp=/home/sysadmin/ansible-restore"

    #.  After Ansible is executed, perform the following steps based on your
        deployment mode:

        **AIO-SX**

        i. Unlock controller-0 and wait for it to boot.

        #. Applications should transition from `restore-requested` to
           `applying` and make a final transition to `applied` state. If
           applications transition from `applying` to `restore-requested`
           state, ensure there is network access and access to the Docker
           registry. The process is repeated once per minute until all
           applications are transitioned to the `applied` state.

        **AIO-DX**

        i. Unlock controller-0 and wait for it to boot.

        #. Applications should transition from `restore-requested` to
           `applying` and make a final transition to `applied` state. If
           applications transition from `applying` to `restore-requested`
           state, ensure there is network access and access to the Docker
           registry. The process is repeated once per minute until all
           applications are transitioned to the `applied` state.

        #. Reinstall controller-1 (boot it from PXE, wait for it to become
           `online`).

        #. Unlock controller-1.

        **Standard (with controller storage)**

        i. Unlock controller-0 and wait for it to boot. After unlock, you will
           see all nodes, including storage nodes, as offline.

        #. Applications should transition from `restore-requested` to
           `applying` and make a final transition to `applied` state. If
           applications transition from `applying` to `restore-requested`
           state, ensure there is network access and access to the Docker
           registry. The process is repeated once per minute until all
           applications are transitioned to the `applied` state.

        #. Reinstall controller-1 and compute nodes (boot them from PXE, wait
           for them to become `online`).

        #. Unlock controller-1 and wait for it to be available.

        #. Unlock compute nodes and wait for them to be available.

        **Standard (without controller storage)**

        i. Unlock controller-0 and wait for it to boot. After unlock, you will
           see all nodes, except storage nodes, as offline. If
           ``wipe_ceph_osds=false`` is used, storage nodes must be powered on
           and in the `available` state throughout the procedure. Otherwise,
           storage nodes must be powered off.

        #. Applications should transition from `restore-requested` to
           `applying` and make a final transition to `applied` state. If
           applications transition from `applying` to `restore-requested`
           state, ensure there is network access and access to the Docker
           registry. The process is repeated once per minute until all
           applications are transitioned to the `applied` state.

        #. Reinstall controller-1 and compute nodes (boot them from PXE, wait
           for them to become `online`).

        #. Unlock controller-1 and wait for it to be available.

        #. If ``wipe_ceph_osds=true`` is used, then reinstall storage nodes.

        #. Unlock compute nodes and wait for them to be available.

        #. (Optional) Reinstall storage nodes.

    #.  Wait for Calico and Coredns pods to start. Run the
        ``system restore-complete`` command. Type 750.006 alarms will disappear
        one at a time, as the applications are being auto-applied.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpenStack application backup and restore
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this procedure, only the OpenStack application will be restored.

Steps:

#.  Backup: Run the backup.yml playbook, whose output is a platform backup
    tarball. Move the backup tarball outside of the cluster for safekeeping.

    .. note::

            When OpenStack is running, the backup.yml playbook generates two
            tarballs: a platform backup tarball and an OpenStack backup tarball.

#.  Restore:

    a.  Delete the old OpenStack application and upload the application again.
        (Note that images and volumes will remain in Ceph.)

        ::

          system application-remove stx-openstack
          system application-delete stx-openstack
          system application-upload stx-openstack-<ver>.tgz

    #.  (Optional) If you want to delete the Ceph data, remove old Glance images
        and Cinder volumes from the Ceph pool.

    #.  Run the restore_openstack.yml Ansible playbook to restore the OpenStack
        tarball.

        If you don't want to manipulate the Ceph data, execute this command:

        ::

          ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'initial_backup_dir=<location_of_backup_filename> ansible_become_pass=<admin_password> admin_password=<admin_password> backup_filename=<backup_filename>'

        For example:

        ::

          ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'initial_backup_dir=/opt/backups ansible_become_pass=Li69nux* admin_password=Li69nux* backup_filename=localhost_openstack_backup_2019_12_13_12_43_17.tgz'

        If you want to restore Glance images and Cinder volumes from external
        storage (the Optional step above was executed) or you want to reconcile
        newer data in the Glance and Cinder volumes pool with older data, then
        you must execute the following steps:

        * Run restore_openstack playbook with the ``restore_cinder_glance_data``
          flag enabled. This step will bring up MariaDB services, restore
          MariaDB data, and bring up Cinder and Glance services.

          ::

            ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'restore_cinder_glance_data=true initial_backup_dir=<location_of_backup_filename> ansible_become_pass=<admin_password> admin_password=<admin_password> backup_filename=<backup_filename>'

          For example:

          ::

            ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'restore_cinder_glance_data=true ansible_become_pass=Li69nux* admin_password=Li69nux* backup_filename=localhost_openstack_backup_2019_12_13_12_43_17.tgz initial_backup_dir=/opt/backups'

        * Restore Glance images and Cinder volumes using image-backup.sh and
          tidy_storage_post_restore helper scripts.

          The tidy storage script is used to detect any discrepancy between
          Cinder/Glance DB and rbd pools.

          Discrepancies between the Glance images DB and the rbd images pool are
          handled in the following ways:

          * If an image is in the Glance images DB but not in the rbd images
            pool, list the image and suggested actions to take in a log file.

          * If an image is in the rbd images pool but not in the Glance images
            DB, create a Glance image in the Glance images DB to associate with
            the backend data. Also, list the image and suggested actions to
            take in a log file.

          Discrepancies between the Cinder volumes DB and the rbd cinder-volumes
          pool are handled in the following ways:

          * If a volume is in the Cinder volumes DB but not in the rbd
            cinder-volumes pool, set the volume state to "error". Also, list
            the volume and suggested actions to take in a log file.

          * If a volume is in the rbd cinder-volumes pool but not in the Cinder
            volumes DB, remove any snapshot(s) associated with this volume in
            the rbd pool and create a volume in the Cinder volumes DB to
            associate with the backend data. List the volume and suggested
            actions to take in a log file.

          * If a volume is in both the Cinder volumes DB and the rbd
            cinder-volumes pool and it has snapshot(s) in the rbd pool,
            re-create the snapshot in Cinder if it doesn't exist.

          * If a snapshot is in the Cinder DB but not in the rbd pool, it
            will be deleted.

          Usage:

          ::

            tidy_storage_post_restore <log_file>

          The image-backup.sh script is used to backup and restore Glance
          images from the ceph image pool.

          Usage:

          ::

            image-backup export <uuid> - export the image with <uuid> into backup file /opt/backups/image_<uuid>.tgz

            image-backup import image_<uuid>.tgz - import the image from the backup source file at /opt/backups/image_<uuid>.tgz

    #.  To bring up the remaining OpenStack services, run the playbook
        again with ``restore_openstack_continue`` set to true:

        ::

          ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'restore_openstack_continue=true initial_backup_dir=<location_of_backup_filename> ansible_become_pass=<admin_password> admin_password=<admin_password> backup_filename=<backup_filename>'

        For example:

        ::

          ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_openstack.yml -e 'restore_openstack_continue=true ansible_become_pass=Li69nux* admin_password=Li69nux* backup_filename=localhost_openstack_backup_2019_12_13_12_43_17.tgz initial_backup_dir=/opt/backups'