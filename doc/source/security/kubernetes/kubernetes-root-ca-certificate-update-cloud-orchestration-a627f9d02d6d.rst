.. _kubernetes-root-ca-certificate-update-cloud-orchestration-a627f9d02d6d:

=========================================================
Kubernetes Root CA Certificate Update Cloud Orchestration
=========================================================

.. rubric:: |context|

You can update Kubernetes Root |CA| certificate on a running system, with
either an uploaded certificate or an auto generated certificate.

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

-   The system is clear of alarms \(with the exception of alarms for locked
    hosts, stopped instances, certificate expiring soon, certificate expired,
    and Kubernetes root ca update in progress\).

-   All hosts must be unlocked, enabled and available.

-   All Kubernetes pods must be ready.

-   Cert-manager app is applied.

-   A file containing a self-signed certificate and corresponding private key
    if choose to upload a new Root |CA| certificate.

.. rubric:: |proc|

Before starting the update, it is highly recommended to backup the existing
Kubernetes Root |CA| certficiate and key, i.e. ``/etc/kubernetes/pki/ca.crt``
and ``/etc/kubernetes/pki/ca.key``.

#.  Create the strategy.

    .. code-block::

        ~(keystone_admin)$ sw-manager kube-rootca-update-strategy create --subject "C=CA ST=ON L=OTT O=WR OU=STX CN=STX" --expiry-date YYYY-MM-DD

        Strategy Kubernetes RootCA Update Strategy:
        strategy-uuid: 47163c5b-44ac-432a-bd25-6e5c353046e9
        controller-apply-type: serial
        storage-apply-type: serial
        worker-apply-type: serial
        default-instance-action: stop-start
        alarm-restrictions: strict
        current-phase: build
        current-phase-completion: 0%
        state: building
        inprogress: true

    .. code-block::

        ~(keystone_admin)$ sw-manager kube-rootca-update-strategy create --cert-file some_cert.pem

        strategy-uuid: 9575f1ea-4d66-4f13-8013-b04c2f420eff
        controller-apply-type: serial
        storage-apply-type: serial
        worker-apply-type: serial
        default-instance-action: stop-start
        alarm-restrictions: strict
        current-phase: build
        current-phase-completion: 0%
        state: building
        inprogress: true

    ``--expiry-date``

    Optional argument to specify the expiry date of the new certificate. It has
    to be in the "YYYY-MM-DD" format. If not specified, the new certificate
    will have the same valid period as the existing one (normally 10 years).

    ``--subject``

    Optional argument to specify the distinguished name of the new certificate.
    It has to be in the format ``C=<Country> ST=<State/Province> L=<Locality>
    O=<Organization> OU=<OrganizationUnit> CN=<commonName>``. If not specified,
    the new certificate will have "Kubernetes" as default.

    ``--cert-file``

    Optional argument to upload a self-signed certificate as the new Root |CA|
    certificate.

    .. note::

        Passing ``--cert-file`` uses an existing certificate, but
        ``--expiry-date`` and ``--subject`` generate a certificate.  Using an
        existing certificate will ignore any arguments to generate a
        certificate.

#.  Apply the strategy.

    .. code-block::

        sw-manager kube-rootca-update-strategy apply

#.  Show the status of the update strategy.

    .. code-block::

        ~(keystone_admin)$ sw-manager kube-rootca-update-strategy show

        Strategy Kubernetes RootCA Update Strategy:
        strategy-uuid: 47163c5b-44ac-432a-bd25-6e5c353046e9
        controller-apply-type: serial
        storage-apply-type: serial
        worker-apply-type: serial
        default-instance-action: stop-start
        alarm-restrictions: strict
        current-phase: build
        current-phase-completion: 100%
        state: ready-to-apply
        build-result: success
        build-reason:

    .. note::

        Passing ``--details``  will show all the internal steps and stages for
        the orchestration strategy.

        Passing ``--active``  will show which step is currently running for the
        orchestration strategy.

#.  If you want to delete the strategy.

    .. code-block::

        ~(keystone_admin)$ sw-manager kube-rootca-update-strategy delete

        Strategy deleted
