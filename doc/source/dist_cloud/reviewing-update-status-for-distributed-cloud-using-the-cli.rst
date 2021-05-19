
.. hxt1558615716368
.. _reviewing-update-status-for-distributed-cloud-using-the-cli:

========================================================
Review Update Status for Distributed Cloud Using the CLI
========================================================

You can use the CLI to review the updates in the central update repository and
their synchronization status across the subclouds of the |prod-dc|.

.. rubric:: |context|

To use the Horizon Web interface instead, see :ref:`Reviewing Update Status for
Distributed Cloud Using Horizon
<reviewing-update-status-for-distributed-cloud-using-horizon>`.

.. rubric:: |proc|

.. _reviewing-update-status-for-distributed-cloud-using-the-cli-steps-unordered-d53-dlx-fdb:

-   To check the status of updates in the central update repository, use the
    query option on the SystemController region.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ sw-patch --os-region-name SystemController query
        Patch ID              RR  Release   Patch State
        ===================   ==  =======   ===========
        wrcp_nn.nn_PATCH_0001  N   20.06     Applied
        wrcp_nn.nn_PATCH_0002  N   20.06     Applied
        wrcp_nn.nn_PATCH_0003  N   20.06     Partial
        wrcp_nn.nn_PATCH_0004  N   20.06     Available
        wrcp_nn.nn_PATCH_0005  N   20.06     Available

    The **Patch State** column indicates whether the Patch is available,
    partially-applied or applied. **Applied** indicates that the update has
    been installed on all hosts of the cloud \(SystemController in this case\).

-   To identify which subclouds are update-current \(**in-sync**\), use the

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list
        +----+-----------+--------------+--------------------+-------------+
        | id | name      | management   | availability       | sync        |
        +----+-----------+--------------+--------------------+-------------+
        |  1 | subcloud1 | managed      | online             | in-sync     |
        |  2 | subcloud2 | managed      | online             | in-sync     |
        |  3 | subcloud3 | managed      | online             | out-of-sync |
        |  4 | subcloud4 | managed      | offline            | unknown     |
        +----+-----------+--------------+--------------------+-------------+

    .. note::

        The **sync** status is the rolled up sync status of
        **platform-sync-status**, **identity-sync-status**, and
        **patching-sync-status**.

-   To see synchronization details for a subcloud:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud show subcloud1
        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | id                          | 1                          |
        | name                        | subcloud1                  |
        | description                 | None                       |
        | location                    | None                       |
        | software_version            | 20.06                      |
        | management                  | managed                    |
        | availability                | online                     |
        | deploy_status               | complete                   |
        | management_subnet           | fd01:82::0/64              |
        | management_start_ip         | fd01:82::2                 |
        | management_end_ip           | fd01:82::11                |
        | management_gateway_ip       | fd01:82::1                 |
        | systemcontroller_gateway_ip | fd01:81::1                 |
        | group_id                    | 1                          |
        | created_at                  | 2020-07-15 19:23:50.966984 |
        | updated_at                  | 2020-07-17 12:36:28.815655 |
        | dc-cert_sync_status         | in-sync                    |
        | identity_sync_status        | in-sync                    |
        | load_sync_status            | in-sync                    |
        | patching_sync_status        | in-sync                    |
        | platform_sync_status        | in-sync                    |
        +-----------------------------+----------------------------+
