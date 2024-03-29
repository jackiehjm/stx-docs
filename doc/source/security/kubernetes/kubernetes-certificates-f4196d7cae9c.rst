.. _kubernetes-certificates-f4196d7cae9c:

=======================
Kubernetes Certificates
=======================

For Kubernetes, HTTPS is always enabled for both internal and external
endpoints.

Kubernetes automatically creates all of its client and server certificates, and
signs them with a Kubernetes Root |CA|. This includes the server certificate
for the external ``kube-apiserver`` API endpoint.

Kubernetes certificates include:

-  Kubernetes Root |CA| Certificate
-  Cluster admin client certificate
-  ``kube-controller-manager`` client certificate
-  ``kube-scheduler`` client certificate
-  ``kube-apiserver`` server certificate
-  ``kube-apiserver``'s kubelet client certificate
-  ``kubelet`` client certificate

**Kubernetes Root CA Certificate**

The Kubernetes Root |CA| certificate signs all the other Kubernetes
certificates. This is also the |CA| certificate various components use to
verify server and client certificates signed by the Kubernetes Root |CA|
certificate. For example, applications running in pods use Kubernetes Root |CA|
certificate embedded in service account token to verify the
``kube-apiserver``'s server certificate when it makes calls to the
kube-apiserver.

By default, the Kubernetes Root |CA| is automatically generated at install time.

If desired, you can externally generate a Root |CA| certificate and key, and
configure it as the Kubernetes Root |CA| during installation, see
:ref:`kubernetes-root-ca-certificate`. 

.. warning::

   This must be a Root |CA|, not an Intermediate |CA|.

In a Distributed Cloud system, by default, the Subclouds are deployed with the
same Kubernetes Root CA as the SystemController.

The public certificate of the Kubernetes Root |CA|, whether auto-generated or
specified, needs to be configured as a trusted |CA| by external servers
connecting to Cloud Platform’s Kubernetes API endpoint (e.g. via a remotely
installed kubectl client).  The Kubernetes Root |CA| public certificate can be
found at ``/etc/kubernetes/pki/ca.crt``.


Kubernetes Root |CA| certificate and corresponding private key are stored in
file system:

-   ``/etc/kubernetes/pki/ca.crt``

-   ``/etc/kubernetes/pki/ca.key``

Updating/Renewing the Kubernetes Root |CA| is a complex process, because it is
not only the Root |CA| certificate that needs to be updated, but also all the
other Kubernetes certificates signed by it need to be regenerated and updated.
See :ref:`manual-kubernetes-root-ca-certificate-update-8e9df2cd7fb9` or
:ref:`kubernetes-root-ca-certificate-update-cloud-orchestration-a627f9d02d6d`
for information on how to update the Kubernetes Root |CA| certificate.

**Cluster admin client certificate**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
the ``/etc/kubernetes/admin.conf`` KUBECONFIG file for kubectl. This is used by
internal StarlingX services and users logged in via SSH with sys_protected
group permissions, to access kubernetes-admin credentials for kubernetes API or
CLI commands.

This certificate is monitored and auto-renewed by a cronjob, which runs every
day at midnight to check if the expiry date is approaching, and renew the
certificate if the expiry date is within 15 days.

.. note::

    If the cronjob certificate renewal fails, a 250.003 alarm will be raised:

    * Kubernetes certificates have been renewed but not all services have been
      updated.

      For this alarm, controller nodes need to lock/unlock for the services to
      take the new certificates.

    * Kubernetes certificates renewal failed.

      For this alarm, the Kubernetes certificates need to be renewed manually,
      during which services need to restart.

      If this alarm is raised, the administrator should follow the recommended
      action for the specific alarm.

**kube-controller-manager client certificate**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
``/etc/kubernetes/controller-manager.conf``. It is used by
``kube-controller-manager`` pod to identify itself to ``kube-apiserver``.

This certificate is monitored and auto-renewed by a cronjob, which runs every
day at midnight to check if the expiry date is approaching, and renew the
certificate if the expiry date is within 15 days.

**kube-scheduler client certificate**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
``/etc/kubernetes/scheduler.conf``. It is used by ``kube-scheduler`` pod to
identify itself to the ``kube-apiserver``.

This certificate is monitored and auto-renewed by a cronjob, which runs every
day at midnight to check if the expiry date is approaching, and renew the
certificate if the expiry date is within 15 days.

**kube-apiserver server certificate**

This is the kube-apiserver's serving certificate. Clients connecting to the
``kube-apiserver`` will verify this certificate using Kubernetes Root |CA|
certificate. The certificate and the corresponding private key are stored in
file system:

-   ``/etc/kubernetes/pki/apiserver.crt``

-   ``/etc/kubernetes/pki/apiserver.key``

This certificate is monitored and auto-renewed by a cronjob, which runs every
day at midnight to check if the expiry date is approaching, and renew the
certificate if the expiry date is within 15 days.

**kube-apiserver's kubelet client certificate**

``kube-apiserver``'s client certificate for communications with ``kubelet``.
``kube-apiserver`` identifies itself with this certificate when it connects to
``kubelet``. The certificate and the corresponding private keys are stored in
file system:

-   ``/etc/kubernetes/pki/apiserver-kubelet-client.crt``

-   ``/etc/kubernetes/pki/apiserver-kubelet-client.key``

This certificate is monitored and auto-renewed by a cronjob, which runs every
day at midnight to check if the expiry date is approaching, and renew the
certificate if the expiry date is within 15 days.

**kubelet client certificate**

This is the ``kubelet``’s client certificate (with private key in it).
``kubelet`` identifies itself with this certificate when it connects to
``kube-apiserver``. ``kubelet`` has Kubernetes Root |CA| certificate in
``/etc/kubernetes/kubelet.conf`` to verify peer certificates.

The certificate and its corresponding private key are store in file system as
one file:

-   ``/var/lib/kubelet/pki/kubelet-client-current.pem``

Kubelet is configured to auto-renew this certificate.


**front-proxy-client certificate**

Client certificates signed by ``front-proxy`` Root |CA| certificate. It is used
by ``apiserver/aggregator`` to connect to aggregated apiserver(extension
APIserver).

**front-proxy-ca certificate**

The ``front-proxy`` Root |CA| certificate. front-proxy certificates are
required only if you run ``kube-proxy`` to support an extension API server.

.. toctree::
   :maxdepth: 1
   :hidden:

   kubernetes-root-ca-certificate
   update-renew-kubernetes-certificates-52b00bd0bdae
   manual-kubernetes-root-ca-certificate-update-8e9df2cd7fb9
   kubernetes-root-ca-certificate-update-cloud-orchestration-a627f9d02d6d
