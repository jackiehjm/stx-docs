.. _orchestration-commands-for-dcmanager-4947f9fb9588:

=========================================================================
Kubernetes Root CA Certificate Update for Distributed Cloud Orchestration
=========================================================================

.. warning::

    During the Kubernetes Root |CA| update, ``deployments``, ``daemonsets``, and
    ``statefulsets`` present in the cluster are rolling restarted. This impacts
    services provided by the application. It is highly recommended to schedule
    a Kubernetes Root |CA| update during planned maintenance windows.

You can use the :command:`dcmanager` command to orchestrate the update of the
Kubernetes Root |CA| certificate(s) for one or more subclouds in a Distributed
Cloud Environment.

The Kubernetes Root |CA| update Distributed Cloud Orchestration commands for
DCManager uses the keyword ``kube-rootca-update-strategy`` and provides the same
five subcommands as the other orchestrations: :command:`create, delete, apply,
abort, and show` commands.

.. note::

    The DCmanager :command:`kube-rootca-update-strategy abort` command
    completes the current updating stage before aborting, to prevent hosts from
    being left in a state requiring manual intervention.

DCManager Kubernetes Root |CA| update orchestration considers a subcloud to be
'out of sync' that needs to be orchestrated based on the ``kube-rootca_sync_status``
field. This is updated based on the presence of alarms in the subcloud
related to the Kubernetes Root |CA| certificate expiring soon (or expired)
status.

-   Use the :command:`dcmanager subcloud show subcloud1` command to
    see synchronization details for a subcloud.

    .. code-block::

        ~(keystone_admin)]$ dcmanager subcloud show subcloud1

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        |id                           | 1                          |
        | name                        | subcloud1                  |
        | description                 | Ottawa Site                |
        | location                    | YOW                        |
        | software_version            | nn.nn                      |
        | management                  |  managed                   |
        | availability                | online                     |
        | deploy_status               | complete                   |
        | management_subnet           | 192.168.101.0/24           |
        | management_start_ip         | 192.168.101.2              |
        | management_end_ip           | 192.168.101.50             |
        | management_gateway_ip       | 192.168.101.1              |
        | systemcontroller_gateway_ip | 192.168.204.101            |
        | group_id                    | 1                          |
        | created_at                  | 2021-10-04 15:04:13.045076 |
        | updated_at                  | 2021-10-25 21:16:23.713858 |
        | dc-cert_sync_status         | in-sync                    |
        | firmware_sync_status        | in-sync                    |
        | identity_sync_status        | in-sync                    |
        | kubernetes_sync_status      | in-sync                    |
        | kube-rootca_sync_status     | in-sync                    |
        | load_sync_status            | in-sync                    |
        | patching_sync_status        | in-sync                    |
        | platform_sync_status        | in-sync                    |
        +-----------------------------+----------------------------+

-   A user can pass ``help``  to see all the arguments for the :command:`strategy create`
    command.

    .. code-block::

        ~(keystone_admin)]$ dcmanager help kube-rootca-update-strategy create
        usage: dcmanager kube-rootca-update-strategy create [-h]
        [-f \{json,shell,table,value,yaml}]
        [-c COLUMN]
        [--max-width <integer>]
        [--fit-width]
        [--print-empty]
        [--noindent]
        [--prefix PREFIX]
        [--subcloud-apply-type \{parallel,serial}]
        [--max-parallel-subclouds MAX_PARALLEL_SUBCLOUDS]
        [--stop-on-failure]
        [--force] [--group GROUP]
        [--subject SUBJECT]
        [--expiry-date EXPIRY_DATE]
        [--cert-file CERT_FILE]
        [cloud_name]

        Create a Kubernetes Root CA update strategy. This strategy supports
        expiry-date, subject and cert-file parameters.

        positional arguments:
        cloud_name Name of a single subcloud to update.

        optional arguments:
        -h, --help show this help message and exit
        --subcloud-apply-type {parallel,serial}
            Subcloud apply type (parallel or serial).
        --max-parallel-subclouds MAX_PARALLEL_SUBCLOUDS
            Maximum number of parallel subclouds.
        --stop-on-failure
            Do not update any additional subclouds after a failure.
        --force
            Disregard subcloud availability status, intended for some upgrade recovery scenarios. Subcloud name can be specified.
        --group GROUP
            Name or ID of subcloud group to update.
        --subject 'C=CA ST=ON L=OTT O=WR OU=STX CN=OTHER'
            Only applicable if not specifying '--cert-file', this will be the subject for the auto-generated rootca certificate.
        --expiry-date YYYY-MM-DD
            Only applicable if not specifying '--cert-file', this will be the expiry date for the auto-generated rootca certificate; expected format is YYYY-MM-DD.
        --cert-file CERT_FILE
            Path to a certificate to upload.

A subcloud can have its Kubernetes Root |CA| updated by the orchestrator even
if it is 'in-sync' by using the :command:`--force` command.

The :command:`--force` command can be used to orchestrate all subclouds, or
used with other arguments to orchestrate just one subcloud or subcloud group.

.. rubric:: |eg|

This is an example of how to orchestrate a new certificate for all subclouds,
including those that are in-sync that will expire in one year.

#.  Create a Kubernetes Root |CA| update strategy.

    .. code-block::

        ~(keystone_admin)]$ dcmanager kube-rootca-update-strategy create --force --expiry-date YYYY-MM-DD

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | strategy type               | kube-rootca-update         |
        | subcloud apply type         | None                       |
        | max parallel subclouds      | None                       |
        | stop on failure             | False                      |
        | state                       | initial                    |
        | created_at                  | 2021-10-26T14:35:50.675988 |
        | updated_at                  |  None                      |
        +-----------------------------+----------------------------+

#.  Verify that the strategy will orchestrate the subcloud(s).

    .. code-block::

        ~(keystone_admin)]$ dcmanager strategy-step list

        +-----------+-------+---------+---------+------------+-------------+
        | cloud     | stage | state   | details | started_at | finished_at |
        +-----------+-------+---------+---------+------------+-------------+
        | subcloud1 | 2     | initial |         | None       | None        |
        +-----------+-------+---------+---------+------------+-------------+

#.  Apply the strategy.

    .. code-block::

        ~(keystone_admin)]$ dcmanager kube-rootca-update-strategy apply

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | strategy type               | kube-rootca-update         |
        | subcloud apply type         | None                       |
        | max parallel subclouds      | None                       |
        | stop on failure             | False                      |
        | state                       | applying                   |
        | created_at                  | 2021-10-26T14:36:30.327317 |
        | updated_at                  | 2021-10-26T14:37:36.865776 |
        +-----------------------------+----------------------------+

#.  You can view the status of the strategy using the following command.

    .. code-block::

        ~(keystone_admin)]$ dcmanager kube-rootca-update-strategy show

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | strategy type               | kube-rootca-update         |
        | subcloud apply type         | None                       |
        | max parallel subclouds      | None                       |
        | stop on failure             | False                      |
        | state                       | applying                   |
        | created_at                  | 2021-10-26 14:36:30.327317 |
        | updated_at                  | 2021-10-26 14:37:36.865776 |
        +-----------------------------+----------------------------+

    It is typically more useful to monitor the progress of the strategy as it
    runs in the subclouds.

    In example below, the |DC| strategy runs the VIM strategy in the subcloud.

    .. code-block::

        ~(keystone_admin)]$ dcmanager strategy-step list

        +-----------+-------+------------------------------------------+----------------------------+----------------------------+-------------+
        | cloud     | stage | state                                    | details                    | started_at                 | finished_at |
        +-----------+-------+------------------------------------------+----------------------------+----------------------------+-------------+
        | subcloud1 | 2     | applying vim kube rootca update strategy | apply phase is 0% complete | 2021-10-26 14:37:46.404736 | None        |
        +-----------+-------+------------------------------------------+----------------------------+----------------------------+-------------+

#.  Wait for the strategy to complete.  If there are failures, the
    :command:`show` command in the previous step indicates where the failure
    occurred.

#.  Only one type of DCManager strategy can exist at a time. Once completed,
    remember to delete it.

    .. code-block::

        ~(keystone_admin)]$ dcmanager kube-rootca-update-strategy delete

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | strategy type               | kube-rootca-update         |
        | subcloud apply type         | None                       |
        | max parallel subclouds      | None                       |
        | stop on failure             | False                      |
        | state                       | deleting                   |
        | created_at                  | 2021-10-26T14:27:44.856345 |
        | updated_at                  | 2021-10-26T14:30:53.557978 |
        +-----------------------------+----------------------------+
