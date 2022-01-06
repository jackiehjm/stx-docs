.. _manual-kubernetes-root-ca-certificate-update-8e9df2cd7fb9:

============================================
Manual Kubernetes Root CA Certificate Update
============================================

.. rubric:: |context|

You can update Kubernetes Root |CA| certificate on a running system, with
either an uploaded certificate or an auto generated certificate.

A set of 'system' |CLI| subcommands, prefixed by ``kube-rootca-update-``, are
provided to accomplish this task. These |CLI| commands need to be executed in
certain order and phases, with most of the commands to be executed host by
host.

.. warning::
    Do **not** let the Kubernetes Root |CA| certificate expire on your system
    and ensure that certificates with valid/adequate expiry dates are used
    during renewal as there is no easy way to recover a system if the
    Kubernetes Root |CA| certificate expires.

    Special care should be taken when updating the Root |CA| certificate.

.. warning::
    During the Kubernetes Root |CA| update, ``deployments``, ``daemonsets``, and
    ``statefulsets`` present in the cluster are rolling restarted. This impacts
    services provided by the application. It is highly recommended to schedule
    a Kubernetes Root |CA| update during planned maintenance windows.

.. rubric:: |prereq|

-   The system must be clear of alarms \(with the exception of alarms for locked
    hosts, stopped instances, certificate expiring soon, certificate expired,
    and Kubernetes root ca update in progress\).

-   All hosts must be unlocked, enabled and available.

-   All Kubernetes pods must be ready.

-   Cert-manager app is applied.

-   A file containing a self-signed certificate and corresponding private key
    if choose to upload a new Root |CA| certificate.

.. rubric:: |proc|

Before starting the update, it is highly recommended to backup the existing
kubernetes Root |CA| certificate and key, i.e. ``/etc/kubernetes/pki/ca.crt``
and ``/etc/kubernetes/pki/ca.key``.

#.  Start the update.

    .. code-block::

        system kube-rootca-update-start

    The command supports ``--force`` option to force the update to start if
    there are non mgmt_affecting alarms.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-start

        +-------------------+---------------------------------------+
        | Property          | Value                                 |
        +-------------------+---------------------------------------+
        | uuid              | 95afbd19-d159-407b-abe0-9ecb6ba4eb56  |
        | state             | update-started                        |
        | from_rootca_cert  | 8503e172a63b23e6-12808492498813125379 |
        | to_rootca_cert    | None                                  |
        | created_at        | 2021-08-26T14:37:31.710407+00:00      |
        | updated_at	    | None                                  |
        +-------------------+---------------------------------------+

#.  Upload or generate a new Kubernetes Root |CA| certificate.

    To generate a new Kubernetes Root |CA| certificate:

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-generate-cert --expiry-date="2031-08-25" --subject="C=CA ST=ON L=Ottawa O=company OU=sale CN=kubernetes"
        Generated new rootca certificate: 66b4daf7bb4ca6dd-248389040031382177497040389244094812254

    The value returned is the ID of the new Root |CA| certificate.

    ``--expiry-date``

    Optional argment to specify the expiry date of the new certificate. It has
    to be in the "YYYY-MM-DD" format. If not specified, the new certificate
    will have the same valid period as the existing one (normally 10 years).

    ``--subject``

    Optional argment to specify the distinguished name of the new certificate.
    It has to be in the format ``C=<Country> ST=<State/Province> L=<Locality>
    O=<Organization> OU=<OrganizationUnit> CN=<commonName>``. If not specified,
    the new certificate will have "Kubernetes" as default.

    Alternatively, to upload a self-signed certificate as the new Root |CA|
    certificate:

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-upload-cert ca_with_key.crt
        Uploaded new rootca certificate: 8503e172a63b23e6-12808492498813125379

    The value returned is the ID of the uploaded Root |CA| certificate. The
    ``ca_with_key.crt`` file contains both the new certifcate and the
    corresponding private key.

#.  Show the cluster overall update status using the
    :command:`kube-rootca-update-show` command.

    This command can be run anytime during the update.

    For example, run the command after new certificate generated.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-show

        +----------------------------------------+------------------------------------+-----------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | uuid                                   | state                              | from_rootca_cert                        | to_rootca_cert                                             | created_at                         | updated_at                         |
        +----------------------------------------+------------------------------------+-----------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | 95afbd19-d159-407b-abe0-9ecb6ba4eb56   | update-new-rootca-cert-generated   | 8503e172a63b23e6-12808492498813125379   | 66b4daf7bb4ca6dd-248389040031382177497040389244094812254   | 2021-08-26T14:37:31.710407+00:00   | 2021-08-26T14:47:50.728284+00:00   |
        +----------------------------------------+------------------------------------+-----------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+

#.  Update Kubernetes components of each host to trust both the old and new
    Root |CA| certificates using the :command:`system kube-rootca-host-update <hostname> --phase=trust-both-cas`
    command.

    The command needs to be executed sequentially on each of the nodes in the
    cluster (except dedicated storage nodes if there are any).

    For example, update controller-1 to trust both old and new Root |CA|
    certificates.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-host-update controller-1 --phase=trust-both-cas

        +------------------------+----------------------------------------------------------+
        | Property               | Value                                                    |
        +------------------------+----------------------------------------------------------+
        | uuid                   | 513d626c-559e-4df7-8e15-f92481dc190f                     |
        | state                  | updating-host-trust-both-cas                             |
        | effective_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | target_rootca_cert     | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at             | 2021-08-26T15:48:39.903793+00:00                         |
        | updated_at             | 2021-08-26T15:50:14.299276+00:00                         |
        +------------------------+----------------------------------------------------------+

#.  List the update status of all the hosts in the cluster system
    ``kube-rootca-host-update-list``.

    The :command:`kube-rootca-host-update-list` command can be run anytime
    during the update.

    For example, list the status of hosts after controller-0, controller-1 have
    been updated to trust both old and new |CAs|.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-host-update-list

        +--------------+-------------+------------------------------+----------------------------------------+-----------------------------------------------------------+-----------------------------------+-----------------------------------+
        | hostname     | personality | state                        | effective_rootca_cert                  | target_rootca_cert                                        | created_at                        | updated_at                        |
        +--------------+-------------+------------------------------+----------------------------------------+-----------------------------------------------------------+-----------------------------------+-----------------------------------+
        | controller-0 | controller  | updated-host-trust-both-cas  | 8503e172a63b23e6-12808492498813125379  | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610  | 2021-08-26T15:48:39.888935+00:00  | 2021-08-26T15:51:47.343297+00:00  |
        | controller-1 | controller  | updated-host-trust-both-cas  | 8503e172a63b23e6-12808492498813125379  | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610  | 2021-08-26T15:48:39.903793+00:00  | 2021-08-26T15:50:30.716854+00:00  |
        | worker-0     | worker      | None                         | 8503e172a63b23e6-12808492498813125379  | None                                                      | 2021-08-26T15:48:39.915956+00:0   | None                              |
        +--------------+-------------+------------------------------+----------------------------------------+-----------------------------------------------------------+-----------------------------------+-----------------------------------+

#.  Update pods deployed by Deployments and Daemonsets to trust both old and
    new Root |CA| certificates.

    Run this command only once on active controller. It takes a few minutes for
    all the pods to restart after updated.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-pods-update --phase=trust-both-cas

        +-------------------+----------------------------------------------------------+
        | Property          | Value                                                    |
        +-------------------+----------------------------------------------------------+
        | uuid              | 6bc2ff57-e82c-4da1-af69-4d52c67917f7                     |
        | state             | updating-pods-trust-both-cas                             |
        | from_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | to_rootca_cert    | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at        | 2021-08-26T15:48:39.860160+00:00                         |
        | updated_at	    | 2021-08-26T15:59:53.851646+00:00                         |
        +-------------------+----------------------------------------------------------+

#.  Update client and server certificates for Kubernetes components of each
    host using the new Root |CA| certificate.

    The command needs to be executed sequentially on each of the nodes in the
    cluster (except dedicated storage nodes if there are any).

    For example, update Kubernetes client and server certificates on
    controller-0 using the new Root |CA| certificate.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-host-update controller-0 --phase=update-certs

        +------------------------+----------------------------------------------------------+
        | Property               | Value                                                    |
        +------------------------+----------------------------------------------------------+
        | uuid                   | 18c5b474-8d7a-4b15-bee8-06d4feb704dd                     |
        | state                  | updating-host-update-certs                               |
        | effective_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | target_rootca_cert     | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at             | 2021-08-26T15:48:39.888935+00:00                         |
        | updated_at             | 2021-08-26T16:13:22.064894+00:00                         |
        +------------------------+----------------------------------------------------------+

#.  Update Kubernetes components of each host to trust only the new Root |CA|
    certificate.

    The command needs to be executed sequentially on each of the nodes in the
    cluster (except dedicated storage nodes if there are any).

    For example, update controller-0 to trust only the new Root |CA|
    certificate.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-host-update controller-0 --phase=trust-new-ca

        +------------------------+----------------------------------------------------------+
        | Property               | Value                                                    |
        +------------------------+----------------------------------------------------------+
        | uuid                   | 18c5b474-8d7a-4b15-bee8-06d4feb704dd                     |
        | state                  | updating-host-trust-new-ca                               |
        | effective_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | target_rootca_cert     | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at             | 2021-08-26T15:48:39.888935+00:00                         |
        | updated_at             | 2021-08-26T19:19:19.366338+00:00                         |
        +------------------------+----------------------------------------------------------+

#.  Update pods deployed by Deployments and Daemonsets to trust only the new
    Root |CA| certificate.

    Run this command only once on active controller. It takes a few minutes for
    all the pods to restart after updated.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-pods-update --phase=trust-new-ca

        +-------------------+----------------------------------------------------------+
        | Property          | Value                                                    |
        +-------------------+----------------------------------------------------------+
        | uuid              | 6bc2ff57-e82c-4da1-af69-4d52c67917f7                     |
        | state             | updating-pods-trust-new-ca                               |
        | from_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | to_rootca_cert    | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at        | 2021-08-26T15:48:39.860160+00:00                         |
        | updated_at	    | 2021-08-26T19:26:34.347519+00:00                         |
        +-------------------+----------------------------------------------------------+

#.  Complete the update.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-complete

        +-------------------+----------------------------------------------------------+
        | Property          | Value                                                    |
        +-------------------+----------------------------------------------------------+
        | uuid              | 6bc2ff57-e82c-4da1-af69-4d52c67917f7                     |
        | state             | update-completed                                         |
        | from_rootca_cert  | 8503e172a63b23e6-12808492498813125379                    |
        | to_rootca_cert    | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | created_at        | 2021-08-26T15:48:39.860160+00:00                         |
        | updated_at	    | 2021-08-26T20:19:36.579505+00:00                         |
        +-------------------+----------------------------------------------------------+

#.  Abort an on-going update.

    This command aborts the on-going update at any step. When an update is
    aborted, alarm **900.009** will be raised and the overall update status
    will be in ``update-aborted``. A new update should be started, and run to
    complete to fully update kubernetes certificates.

    .. code-block::

        system kube-rootca-update-abort

    For example, the update is aborted when:

    -   controller-0, controller-1 and worker-0 have been updated to trust both
        |CA| certificates,

    -   client and server certificates have been updated on controller-0 (a step
        further than controller-1, worker-0),

    -   overall update is in ``updating-host-update-certs`` state.

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-show

        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | uuid                                   | state                              | from_rootca_cert                                           | to_rootca_cert                                             | created_at                         | updated_at                         |
        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | 04863d56-2f36-404b-ad9d-a0b1d967939e   | updating-host-update-certs         | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610   | d70efa2daaee06f8-18974112351299353303834821971390931938    | 2021-08-26T20:28:09.383461+00:00   | 2021-08-26T20:42:40.673674+00:00   |
        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-host-update-list

        +--------------+-------------+------------------------------+-----------------------------------------------------------+----------------------------------------------------------+-----------------------------------+-----------------------------------+
        | hostname     | personality | state                        | effective_rootca_cert                                     | target_rootca_cert                                       | created_at                        | updated_at                        |
        +--------------+-------------+------------------------------+-----------------------------------------------------------+----------------------------------------------------------+-----------------------------------+-----------------------------------+
        | controller-0 | controller  | updated-host-update-certs    | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610  | d70efa2daaee06f8-18974112351299353303834821971390931938  | 2021-08-26T20:28:09.404809+00:00  | 2021-08-26T20:43:49.577920+00:00  |
        | controller-1 | controller  | updated-host-trust-both-cas  | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610  | d70efa2daaee06f8-18974112351299353303834821971390931938  | 2021-08-26T20:28:09.417891+00:00  | 2021-08-26T20:33:03.754760+00:00  |
        | worker-0     | worker      | updated-host-trust-both-cas  | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610  | d70efa2daaee06f8-18974112351299353303834821971390931938  | 2021-08-26T20:28:09.430753+00:00  | 2021-08-26T20:34:13.390571+00:00  |
        +--------------+-------------+------------------------------+-----------------------------------------------------------+----------------------------------------------------------+-----------------------------------+-----------------------------------+

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-abort

        +-------------------+----------------------------------------------------------+
        | Property          | Value                                                    |
        +-------------------+----------------------------------------------------------+
        | uuid              | 04863d56-2f36-404b-ad9d-a0b1d967939e                     |
        | state             | update-aborted                                           |
        | from_rootca_cert  | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610 |
        | to_rootca_cert    | d70efa2daaee06f8-18974112351299353303834821971390931938  |
        | created_at        | 2021-08-26T20:28:09.383461+00:00                         |
        | updated_at	    | 2021-08-26T20:53:04.493889+00:00                         |
        +-------------------+----------------------------------------------------------+

    .. code-block::

        ~(keystone_admin)]$ fm alarm-list

        +-----------+------------------------------------------------------------------+-----------------+---------+---------------+
        | Alarm ID  | Reason Text                                                      | Entity ID      | Severity | Time Stamp    |
        +-----------+------------------------------------------------------------------+-----------------+---------+---------------+
        | 900.009   | Kubernetes root CA update aborted, certificates may not be fully | host=controller | minor   | 2021-08-26T20 |
        +-----------+------------------------------------------------------------------+-----------------+---------+---------------+
        |           | updated                                                          |                 |         | :53:04.577578 |
        +-----------+------------------------------------------------------------------+-----------------+---------+---------------+

    .. code-block::

        ~(keystone_admin)]$ system kube-rootca-update-show

        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | uuid                                   | state                              | from_rootca_cert                                           | to_rootca_cert                                             | created_at                         | updated_at                         |
        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+
        | 04863d56-2f36-404b-ad9d-a0b1d967939e   | update-aborted                     | 66b4daf7bb4ca6dd-131908807141787487410130398776303207610   | d70efa2daaee06f8-18974112351299353303834821971390931938    | 2021-08-26T20:28:09.383461+00:00   | 2021-08-26T20:53:04.493889+00:00   |
        +----------------------------------------+------------------------------------+------------------------------------------------------------+------------------------------------------------------------+------------------------------------+------------------------------------+


**States of the update procedure**

``update-started``: semantic checks passed, health check passed, update started.

``update-new-rootca-cert-uploaded``: the new Root |CA| certificate is uploaded.

``update-new-rootca-cert-generated``: the new Root |CA| certificate is
generated.

``updating-host-trust-both-cas``: new Root |CA| certificate is being added to
Kubernetes components' trusted |CAs|.

``updated-host-trust-both-cas``: new Root |CA| certificate has been added to
Kubernetes components' trusted |CAs|.

``updating-host-trust-both-cas-failed``: new Root |CA| certificate failed to be
added to Kubernetes components' trusted |CAs|.

``updating-pods-trust-both-cas``: new Root |CA| certificate is being added to
pods' trusted |CA| list.

``updated-pods-trust-both-cas``: new Root |CA| certificate has been added to
pods' trusted |CA| list.

``updating-pods-trust-both-cas-failed``: new Root |CA| certificate failed to be
added to pods' trusted |CA| list.

``updating-host-update-certs``: server and client certificates is being updated
for Kubernetes components.

``updated-host-update-certs``: server and client certificates have been updated
for Kubernetes components.

``updating-host-update-certs-failed``: server and client certificates failed to
be updated for Kubernetes components.

``updating-host-trust-new-ca``: old Root |CA| certificate is being removed,
only new cert will be trusted for Kubernetes components.

``updated-host-trust-new-ca``: old Root |CA| certificate has been removed, only
new cert is trusted for Kubernetes components.

``updating-host-trust-new-ca-failed``: old Root |CA| certificate failed to be
removed, both old and new certs are trusted for Kubernetes components.

``updating-pods-trust-new-ca``: old Root |CA| certificate is being removed from
pods' trusted |CA| list.

``updated-pods-trust-new-ca``: old Root |CA| certificate has been removed from
pods' trusted |CA| list.

``updating-pods-trust-new-ca-failed``: old Root |CA| certificate failed to be
removed from pods' trusted |CA| list.

``update-compete``: Kubernetes components and pods are healthy, update
completed.

``update-aborted``: a Kubernetes Root |CA| update is aborted.
