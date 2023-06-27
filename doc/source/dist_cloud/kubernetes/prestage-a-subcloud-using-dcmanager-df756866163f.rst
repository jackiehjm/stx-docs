.. _prestage-a-subcloud-using-dcmanager-df756866163f:

===================
Prestage a Subcloud
===================

Before you start an |AIO-SX| subcloud upgrade or reinstall for the purpose of
restoring the subcloud; the subcloud can be prestaged with OSTree repo
(software updates) and container image archives outside the maintenance window
using the dcmanager CLI. The prestaged data is stored in the subcloud
persistent file system ``/opt/platform-backup/<sw_version>``. This data will be
used when the subcloud is reinstalled next.

Where, the `<sw_version>` number is the active load of the System Controller.

.. note::

    Only |AIO-SX| subclouds can be prestaged using the dcmanager CLI.

For information on prestaging a batch of subclouds, see,
:ref:`prestage-subcloud-orchestration-eb516473582f`.

.. rubric:: |context|

The main steps of this task are:

#.  Ensure prestaging prerequisites are met, see :ref:`prestaging-prereqs`.

#.  Upload the list of container images to prestage. This step is relevant to
    upgrade and must be performed after the System Controller
    has been upgraded. See :ref:`Upload Prestage Image List <prestaging-image-list>`.

#.	Use dcmanager commands to prestage the subcloud(s).

To increase Subcloud Platform Backup Size using dcmanager CLI, see
:ref:`note <increase-subcloud-platform-backup-size>`.

.. _prestaging-prereqs:

-----------------------
Prestaging Requirements
-----------------------

.. rubric:: |prereq|

Prestaging can be done for a single subcloud or a batch of subclouds via
orchestration. See :ref:`prestage-subcloud-orchestration-eb516473582f`.

There are two types of subcloud prestage:

-   **Prestage for upgrade**: when the subcloud is running a different (older)
    load than the System Controller at the time of prestaging.

-   **Prestage for reinstall**: When the subcloud is running the same load as the
    System Controller at the time of prestaging.

    .. note::
        Only |AIO-SX| subclouds can be prestaged using the dcmanager CLI.

**Pre-conditions common to both types of prestage**:

-  Subclouds to be prestaged must be |AIO-SX|, online, managed and free
   of any management affecting alarms.

   .. note::

       You can force prestaging using ``--force`` option. However,
       it is not recommended unless it is certain that the prestaging
       process will not exacerbate the alarm condition on the subcloud.

-  Subcloud ``/opt/platform-backup`` must have enough available disk space
   for prestage data.

-  Subcloud ``/var/lib/docker`` must have enough space for all prestage
   image pulls and archive file generation. If the total size of prestage
   images is N GB, available Docker space should be N*2 GB.

.. warning::

    If the available docker space is inadequate, some application pods can get
    evicted due to temporary disk pressure during the prestaging process. The
    cert-manager application will fail subcloud upgrade if its evicted pods are
    not cleaned up.

**Pre-conditions specific to prestage for upgrade**:

-  The total size of prestage images and custom images restored over upgrade
   must not exceed docker-distribution capacity.

-  Prestage images must already exist in the configured source(s) prior to
   subcloud prestaging. For example, if the subcloud is configured to
   download images from the central registry; the specified images must
   already exist in the registry on the System Controller.

.. _prestaging-image-list:

--------------------------
Upload Prestage Image List
--------------------------

The prestage image list specifies what container images are to be pulled from
the configured sources and included in the image archive files during prestaging.
This list is only used if the prestage is intended for subcloud upgrade i.e.
the System Controller and subclouds are running different loads at the time of
prestaging.

The prestage image list must contain:

-  Images required for subcloud platform upgrade.

-  Images required for the restore and update or |prod-long| applications,
   currently applied on the subcloud, for example, cert-manager, |OIDC|, and
   metrics-server.

.. only:: partner

   .. include:: /_includes/prestage-a-subcloud-using-dcmanager-df756866163f.rest
      :start-after: prestage-image-begin
      :end-before: prestage-image-end

If the available docker and docker-distribution storage is ample, prestage
image list should also contain:

- (Optional) Images required for Kubernetes version upgrades post subcloud upgrade.

- (Optional) Images required for the update of end users' Helm applications
  post subcloud upgrade.

.. note::

    It is required to determine the total size of all images to be prestaged
    in advance. Too many images can result in subcloud upgrade failure due to
    docker-distribution (local registry) out of space error.
    See the Prerequisites section above for more details.

.. rubric:: |proc|

#.  To upload the prestage image list, use the following command after the
    System Controller has been upgraded.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-deploy upload --prestage-images nn.nn_images.lst

        +------------------+-----------------+
        | Field            | Value           |
        +------------------+-----------------+
        |deploy_playbook   | None            |
        |deploy_overrides  | None            |
        |deploy_chart      | None            |
        |prestage_images   | nn.nn_images.lst|
        +------------------+-----------------+

    Where, the name of the prestage image file can be user defined. However,
    it is recommended to use the following format `<software_version>_images.lst`,
    for example, `<21.12_images.lst>`.

#.  To confirm that the image list has been uploaded, use the following command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-deploy show

        +------------------+-------------------------+
        | Field            | Value                   |
        +------------------+-------------------------+
        | deploy_playbook  | None                    |
        | deploy_overrides | None                    |
        | deploy_chart     | None                    |
        | prestage_images  | nn.nn_images.lst        |
        +------------------+-------------------------+

.. warning::

    As prestage images will be pulled from Docker registries currently
    configured for the subcloud, images in the image list file must not contain
    custom/private registry prefix.

.. only:: partner

   .. include:: /_includes/prestage-a-subcloud-using-dcmanager-df756866163f.rest
      :start-after: image-list-begin
      :end-before: image-list-end

------------------------
Single Subcloud Prestage
------------------------

See :ref:`prestaging-prereqs` for preconditions prior to prestaging the subcloud.

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud prestage subcloud2

    Enter the sysadmin password for the subcloud:
    Re-enter sysadmin password to confirm:

    +-----------------------------+----------------------------+
    | Field                       | Value                      |
    +-----------------------------+----------------------------+
    | id                          | 2                          |
    | name                        | subcloud2                  |
    | description                 | None                       |
    | location                    | None                       |
    | software_version            | nn.nn                      |
    | management                  | managed                    |
    | availability                | online                     |
    | deploy_status               | prestage-prepare           |
    | management_subnet           | 2620:10a:a001:ac01::20/123 |
    | management_start_ip         | 2620:10a:a001:ac01::22     |
    | management_end_ip           | 2620:10a:a001:ac01::3e     |
    | management_gateway_ip       | 2620:10a:a001:ac01::21     |
    | systemcontroller_gateway_ip | 2620:10a:a001:a113::1      |
    | group_id                    | 3                          |
    | created_at                  | 2202-03-18 20:31:16.548903 |
    | updated_at                  | 2202-03-22 18:55:56:251643 |
    +-----------------------------+----------------------------+

-----------------------
Rerun Subcloud Prestage
-----------------------

A subcloud can be prestaged multiple times. However, only prestaging images
will be repeated. Once packages prestaging is successful, this step will be
skipped in subsequent prestage reruns for the same software version.

------------------------
Verify Subcloud Prestage
------------------------

After a subcloud is successfully prestaged, the ``deploy_status`` will change to
``prestage-complete``. Use the :command:`dcmanager subcloud show` command to
verify the status. The packages directory, repodata directory, and container
image bundles, and md5 file can be found on the subcloud in
``/opt/platform-backup/<sw_version>``.

Where, the `<sw_version>` number is the active load of the System Controller.

------------------------------
Troubleshoot Subcloud Prestage
------------------------------

If the subcloud prestage fails, check ``/var/log/dcmanager/dcmanager.log``
for the reason of failure. Once the issue has been resolved, prestage can be
retried using :command:`dcmanager subcloud prestage` command.

---------------------------------
Verifying Usage of Prestaged Data
---------------------------------

To verify that the prestaged data is used over subcloud upgrade, subcloud
reinstall, or subcloud remote restore:

-   Search for the the subcloud name in the log file, for example,
    subcloud1 from ``/www/var/log/lighttpd-access.log``. There should not be
    GET requests to download packages from  ``/iso/<sw_version>/nodes/subcloud1/Packages/``.

-  Check subcloud ansible log in ``/var/log/dcmanager/ansible`` directory.
   Images are imported from local archives and no images in the prestage image
   list need to be downloaded from configured sources.

