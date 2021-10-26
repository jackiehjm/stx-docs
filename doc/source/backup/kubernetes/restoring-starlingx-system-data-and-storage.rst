
.. uzk1552923967458
.. _restoring-starlingx-system-data-and-storage:

========================================
Restore Platform System Data and Storage
========================================

You can perform a system restore \(controllers, workers, including or
excluding storage nodes\) of a |prod| cluster from available system data and
bring it back to the operational state it was when the backup procedure took
place.

.. rubric:: |context|

This procedure takes a snapshot of the etcd database at the time of backup,
stores it in the system data backup, and then uses it to initialize the
Kubernetes cluster during a restore. Kubernetes configuration will be
restored and pods that are started from repositories accessible from the
internet or from external repositories will start immediately. |prod|
specific applications must be re-applied once a storage cluster is configured.

.. warning::
    The system data backup file can only be used to restore the system from
    which the backup was made. You cannot use this backup file to restore
    the system to different hardware.

    To restore the data, use the same version of the boot image \(ISO\) that
    was used at the time of the original installation.

The |prod| restore supports the following optional modes:

.. _restoring-starlingx-system-data-and-storage-ol-tw4-kvc-4jb:

-   To keep the Ceph cluster data intact \(false - default option\), use the
    following parameter, when passing the extra arguments to the Ansible Restore
    playbook command:

    .. code-block:: none

       wipe_ceph_osds=false

-   To wipe the Ceph cluster entirely \(true\), where the Ceph cluster will
    need to be recreated, use the following parameter:

    .. code-block:: none

        wipe_ceph_osds=true

-   To indicate that the backup data file is under /opt/platform-backup
    directory on the local machine, use the following parameter:

    .. code-block:: none

        on_box_data=true

    If this parameter is set to **false**, the Ansible Restore playbook expects
    both the **initial_backup_dir** and **backup_filename** to be specified.

Restoring a |prod| cluster from a backup file is done by re-installing the
ISO on controller-0, running the Ansible Restore Playbook, applying updates
\(patches\), unlocking controller-0, and then powering on, and unlocking the
remaining hosts, one host at a time, starting with the controllers, and then
the storage hosts, ONLY if required, and lastly the compute \(worker\) hosts.

.. rubric:: |prereq|

Before you start the restore procedure you must ensure the following
conditions are in place:

.. _restoring-starlingx-system-data-and-storage-ul-rfq-qfg-mp:

-   All cluster hosts must be prepared for network boot and then powered
    down. You can prepare a host for network boot.

    .. note::
        If you are restoring system data only, do not lock, power off or
        prepare the storage hosts to be reinstalled.

-   The backup file is accessible locally, if restore is done by running
    Ansible Restore playbook locally on the controller. The backup file is
    accessible remotely, if restore is done by running Ansible Restore playbook
    remotely.

-   You have the original |prod| ISO installation image available on a USB
    flash drive. It is mandatory that you use the exact same version of the
    software used during the original installation, otherwise the restore
    procedure will fail.

-   The restore procedure requires all hosts but controller-0 to boot
    over the internal management network using the |PXE| protocol. Ideally, the
    old boot images are no longer present, so that the hosts boot from the
    network when powered on. If this is not the case, you must configure each
    host manually for network boot immediately after powering it on.

    .. note::
        After the backup or restore process, the nginx webhook should be
        restored.

-   If you are restoring a |prod-dc| subcloud first, ensure it is in
    an **unmanaged** state on the Central Cloud \(SystemController\) by using
    the following commands:

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>

    where ``<subcloud-name>`` is the name of the subcloud to be unmanaged.

.. rubric:: |proc|

#.  Power down all hosts.

    If you have a storage host and want to retain Ceph data, then power down
    all the nodes except the storage hosts; the cluster has to be functional
    during a restore operation.

    .. caution::
        Do not use :command:`wipedisk` before a restore operation. This will
        lead to data loss on your Ceph cluster. It is safe to use
        :command:`wipedisk` during an initial installation, while reinstalling
        a host, or during an upgrade.

#.  Install the |prod| ISO software on controller-0 from the USB flash
    drive.

    You can now log in using the host's console.

#.  Log in to the console as user **sysadmin** with password **sysadmin**.

#.  Install network connectivity required for the subcloud.

#.  Ensure that the backup file are available on the controller. Run both
    Ansible Restore playbooks, restore_platform.yml and restore_user_images.yml.
    For more information on restoring the back up file, see :ref:`Run Restore
    Playbook Locally on the Controller
    <running-restore-playbook-locally-on-the-controller>`, and :ref:`Run
    Ansible Restore Playbook Remotely
    <system-backup-running-ansible-restore-playbook-remotely>`.

    .. note::
        The backup files contain the system data and updates.

#.  If the backup file contains patches, Ansible Restore playbook
    restore_platform.yml will apply the patches and prompt you to reboot the
    system, you will need to re-run Ansible Restore playbook.

    The current software version on the controller is compared against the
    version available in the backup file. If the backed-up version includes
    updates, the restore process automatically applies the updates and
    forces an additional reboot of the controller to make them effective.

    After the reboot, you can verify that the updates were applied, as
    illustrated in the following example:

    .. code-block:: none

        $ sudo sw-patch query
                Patch ID          RR          Release  Patch State
        ========================  ==========  =======  ===========
        COMPUTECONFIG             Available    nn.nn      n/a
        LIBCUNIT_CONTROLLER_ONLY   Applied     nn.nn      n/a
        STORAGECONFIG              Applied     nn.nn      n/a

    Rerun the Ansible Playbook if there were patches applied and you were
    prompted to reboot the system.

#.  Restore the local registry using the file restore_user_images.yml.

    This must be done before unlocking controller-0.

#.  Unlock Controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

    After you unlock controller-0, storage nodes become available and Ceph
    becomes operational.

#.  If the system is a Distributed Cloud system controller, restore the **dc-vault**
    using the restore_dc_vault.yml playbook. Perform this step after unlocking
    controller-0:

    .. code-block:: none

        $ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/restore_dc_vault.yml -e "initial_backup_dir=/home/sysadmin backup_filename=localhost_dc_vault_backup_2020_07_15_21_24_22.tgz ansible_become_pass=St0rlingX*"

    .. note::
       The dc-vault backup archive is created by the backup.yml playbook.

#.  Authenticate the system as Keystone user **admin**.

    Source the **admin** user environment as follows:

    .. code-block:: none

        $ source /etc/platform/openrc

#.  Apps transition from 'restore-requested' to 'applying' state, and
    from 'applying' state to 'applied' state.

    If apps are transitioned from 'applying' to 'restore-requested' state,
    ensure there is network access and access to the docker registry.

    The process is repeated once per minute until all apps are transitioned to
    'applied'.

#. If you have a Duplex system, restore the **controller-1** host.

   #.  List the current state of the hosts.

       .. code-block:: none

            ~(keystone_admin)]$ system host-list
            +----+-------------+------------+---------------+-----------+------------+
            | id | hostname    | personality| administrative|operational|availability|
            +----+-------------+------------+---------------+-----------+------------+
            | 1  | controller-0| controller | unlocked      |enabled    |available   |
            | 2  | controller-1| controller | locked        |disabled   |offline     |
            | 3  | storage-0   | storage    | locked        |disabled   |offline     |
            | 4  | storage-1   | storage    | locked        |disabled   |offline     |
            | 5  | compute-0   | worker     | locked        |disabled   |offline     |
            | 6  | compute-1   | worker     | locked        |disabled   |offline     |
            +----+-------------+------------+---------------+-----------+------------+

   #.  Power on the host.

       Ensure that the host boots from the network, and not from any disk
       image that may be present.

       The software is installed on the host, and then the host is
       rebooted. Wait for the host to be reported as **locked**, **disabled**,
       and **offline**.

   #.  Unlock controller-1.

       .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-1
            +-----------------+--------------------------------------+
            | Property        | Value                                |
            +-----------------+--------------------------------------+
            | action          | none                                 |
            | administrative  | locked                               |
            | availability    | online                               |
            | ...             | ...                                  |
            | uuid            | 5fc4904a-d7f0-42f0-991d-0c00b4b74ed0 |
            +-----------------+--------------------------------------+

   #.  Verify the state of the hosts.

       .. code-block:: none

            ~(keystone_admin)]$ system host-list
            +----+-------------+------------+---------------+-----------+------------+
            | id | hostname    | personality| administrative|operational|availability|
            +----+-------------+------------+---------------+-----------+------------+
            | 1  | controller-0| controller | unlocked      |enabled    |available   |
            | 2  | controller-1| controller | unlocked      |enabled    |available   |
            | 3  | storage-0   | storage    | locked        |disabled   |offline     |
            | 4  | storage-1   | storage    | locked        |disabled   |offline     |
            | 5  | compute-0   | worker     | locked        |disabled   |offline     |
            | 6  | compute-1   | worker     | locked        |disabled   |offline     |
            +----+-------------+------------+---------------+-----------+------------+

#. Restore storage configuration. If :command:`wipe_ceph_osds` is set to
   **True**, follow the same procedure used to restore **controller-1**,
   beginning with host **storage-0** and proceeding in sequence.

   .. note::
      This step should be performed ONLY if you are restoring storage hosts.

   #.  For storage hosts, there are two options:

       With the controller software installed and updated to the same level
       that was in effect when the backup was performed, you can perform
       the restore procedure without interruption.

       Standard with Controller Storage install or reinstall depends on the
       :command:`wipe_ceph_osds` configuration:

       #.  If :command:`wipe_ceph_osds` is set to **true**, reinstall the
           storage hosts.

       #.  If :command:`wipe_ceph_osds` is set to **false** \(default
           option\), do not reinstall the storage hosts.

           .. caution::
                Do not reinstall or power off the storage hosts if you want to
                keep previous Ceph cluster data. A reinstall of storage hosts
                will lead to data loss.

   #.  Ensure that the Ceph cluster is healthy. Verify that the three Ceph
       monitors \(controller-0, controller-1, storage-0\) are running in
       quorum.

       .. code-block:: none

            ~(keystone_admin)]$ ceph -s
            cluster:
                id:     3361e4ef-b0b3-4f94-97c6-b384f416768d
                health: HEALTH_OK

              services:
                mon: 3 daemons, quorum controller-0,controller-1,storage-0
                mgr: controller-0(active), standbys: controller-1
                osd: 10 osds: 10 up, 10 in

              data:
                pools:   5 pools, 600 pgs
                objects: 636  objects, 2.7 GiB
                usage:   6.5 GiB used, 2.7 TiB / 2.7 TiB avail
                pgs:     600 active+clean

              io:
                client:   85 B/s rd, 336 KiB/s wr, 0 op/s rd, 67 op/s wr

       .. caution::
           Do not proceed until the Ceph cluster is healthy and the message
           HEALTH_OK appears.

       If the message HEALTH_WARN appears, wait a few minutes and then try
       again. If the warning condition persists, consult the public
       documentation for troubleshooting Ceph monitors \(for example,
       `http://docs.ceph.com/docs/master/rados/troubleshooting/troubleshootin
       g-mon/
       <http://docs.ceph.com/docs/master/rados/troubleshooting/troubleshootin
       g-mon/>`__\).

#. Restore the compute \(worker\) hosts, one at a time.

   Restore the compute \(worker\) hosts following the same procedure used to
   restore controller-1.

#. Allow Calico and Coredns pods to be recovered by Kubernetes. They should
   all be in 'N/N Running' state.

   The state of the hosts when the restore operation is complete is as
   follows:

   .. code-block:: none

        ~(keystone_admin)]$ kubectl get pods -n kube-system | grep -e calico -e coredns
        calico-kube-controllers-5cd4695574-d7zwt  1/1     Running
        calico-node-6km72                         1/1     Running
        calico-node-c7xnd                         1/1     Running
        coredns-6d64d47ff4-99nhq                  1/1     Running
        coredns-6d64d47ff4-nhh95                  1/1     Running

#. If **wipe_ceph_osds** is set to true and all the system hosts are in an
   unlocked/enabled/available state, do the following:

   #.  Remove and reapply **platform-integ-apps**. This step will re-create
       the default ceph pools (they were deleted):

       .. code-block:: none

            $ system application-remove platform-integ-apps
            $ system application-apply platform-integ-apps

   #.  Delete completely and reapply all the applications that have
       persistent volumes (WRO or custom apps). For example for WRO, run the
       following commands

       .. parsed-literal::

            $ system application-remove |prefix|-openstack
            $ system application-delete |prefix|-openstack
            $ system application-upload |prefix|-openstack-20.12-0.tgz
            $ system application-apply |prefix|-openstack

#. Run the :command:`system restore-complete` command.

   .. code-block:: none

       ~(keystone_admin)]$ system restore-complete

#. Alarms 750.006 alarms disappear one at a time, as the apps are auto applied.

.. rubric:: |postreq|

.. _restoring-starlingx-system-data-and-storage-ul-b2b-shg-plb:

-   Passwords for local user accounts must be restored manually since they
    are not included as part of the backup and restore procedures.

-   After restoring a |prod-dc| subcloud, you need to bring it back
    to the **managed** state on the Central Cloud \(SystemController\), by
    using the following commands:

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>

    where ``<subcloud-name>`` is the name of the subcloud to be managed.


.. comments in steps seem to throw numbering off.

.. xreflink removed from step 'Install the |prod| ISO software on controller-0 from the USB flash
    drive.':
    For details, refer to the |inst-doc|: :ref:`Installing Software on
    controller-0 <installing-software-on-controller-0>`. Perform the
    installation procedure for your system and *stop* at the step that
    requires you to configure the host as a controller.

..  xreflink  removed from step 'Install network connectivity required for the subcloud.':
    For details, refer to the |distcloud-doc|: :ref:`Installing and
    Provisioning a Subcloud <installing-and-provisioning-a-subcloud>`.

-   When you complete the backup the following steps must be done:

    .. code-block:: none

        $ system helm-override-update nginx-ingress-controller ingress-nginx kube-system --set controller.admissionWebhooks.enabled=true

-   Then, reapply the nginx app to restore the admissionWebhook

    .. code-block:: none

        $ system application-apply nginx-ingress-controller