.. _etcd-certificates-c1fc943e4a9c:

=================
Etcd Certificates
=================

Etcd is the consistent and highly-available key value store used as Kubernetes
backing store for all cluster data. Interaction with etcd service is by secure
HTTPs where x509 certificates are required.

Etcd certificates in |prod| includes:

-   Etcd Root |CA| certificate
-   Etcd server certificate
-   Etcd client certificate
-   ``kube-apiserver``'s etcd client certificate

**etcd Root CA certificate**

This is the etcd Root |CA| certificate. It signs etcd server and client
certificates, and ``kube-apiserver`` etcd client certificate. This is also the
|CA| certificate used to verify various server and client certificates signed
by etcd Root |CA| certificate.

Etcd Root |CA| certificate and corresponding private keys are stored in file
systems:

-   ``/etc/etcd/ca.crt``

-   ``/etc/etcd/ca.key``

**etcd server certificate**

This is the etcd server’s serving certificate. Services such as
``kube-apiserver`` that access etcd verify this serving certificate with etcd
Root |CA| certificate.

Etcd server certificate and corresponding private keys are stored in file
systems:

-   ``/etc/etcd/etcd-server.crt``

-   ``/etc/etcd/etcd-server.key``

**etcd client certificate**

This is a client certificate generated from etcd Root |CA|. It can be used by
clients to identify itself when connecting to etcd by HTTPS.

Etcd client certificate and corresponding private key are stored in file system:

-   ``/etc/etcd/etcd-client.crt``

-   ``/etc/etcd/etcd-client.key``

**kube-apiserver's etcd client certificate**

This is the ``kube-apiserver`` client certificate generated from etcd Root |CA|. It
is used by ``kube-apiserver`` to identify itself when connecting to etcd by HTTPS.

Kube-apiserver’s etcd client certificate and corresponding private keys are
stored in file systems:

-   ``/etc/kubernetes/pki/apiserver-etcd-client.crt``

-   ``/etc/kubernetes/pki/apiserver-etcd-client.key``

---------------------------------------
Install custom etcd Root CA certificate
---------------------------------------

By default, etcd Root |CA| certificate and corresponding private key are
generated during system bootstrap and have 10 years validation.

The other etcd certificates are generated from the Root |CA| certificate during
system bootstrap once the Root |CA| certificate is generated and available.
The following generated certificates have 1 year validation:

-   ``etcd-client``
-   ``etcd-server``
-   ``kube-apiserver-etcd-client``

To provide a Root |CA| for etcd, add the ``etcd_root_ca_key`` and
``etcd_root_ca_cert`` overrides to ``localhost.yml`` before bootstrap.

For example:

.. code-block::

    etcd_root_ca_key: /home/sysadmin/<my-root-ca-key.pem>
    etcd_root_ca_cert: /home/sysadmin/<my-root-ca-cert.pem>

.. note::

    The values must be absolute file paths.

    Both key and cert must be provided (or omitted).

    The certificate should be valid for 5-10 years as currently there is no
    mechanism to update this certificate.

------------------------------
Update/Renew etcd certificates
------------------------------

Updating etcd Root |CA| certificate is a complex process, because it is not
only the Root |CA| certificate need to be updated, but also all the other etcd
certificates signed by it need to be regenerated and updated. The update of the
etcd Root |CA| is currently not supported.

The other child certificates generated from the etcd Root |CA| are monitored by
a cronjob, which runs every day at midnight to check if any of these
certificates’ expiry date is approaching and renew them if the expiry date is
within 15 days.

If the renewal fails, a **250.003** alarm will be raised:

-   `Kubernetes certificates have been renewed but not all services have been
    updated.`

    For this alarm, controller nodes need to lock/unlock for the services to
    take the new certificates.

-   `Kubernetes certificates renewal failed.`

    For this alarm, the Kubernetes certificates need to be renewed manually,
    during which services need to restart.

If this alarm is raised, the administrator should follow the recommended action
for the specific alarm.
