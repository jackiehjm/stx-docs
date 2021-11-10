.. _kubernetes-certificates-f4196d7cae9c:

=======================
Kubernetes Certificates
=======================

For Kubernetes, HTTPS is always enabled for both internal and external
endpoints.

Kubernetes automatically creates all of its client and server certificates, and
signs them with a Kubernetes Root |CA|. This includes the server certificate
for the external ``kube-apiserver`` API endpoint. By default, the Kubernetes
Root |CA| is automatically generated at install time.

If desired, you can externally generate a Root |CA| certificate and key, and
configure it as the Kubernetes Root |CA| during installation. Upstream
Kubernetes (v1.18) only supports a Root |CA| for the Kubernetes Root |CA|; NOT
an Intermediate |CA|.

The public certificate of the Kubernetes Root |CA|, whether auto-generated or
specified, needs to be configured as a trusted |CA| by external servers
connecting to |prod|'s Kubernetes API endpoint (e.g. via a remotely installed
``kubectl`` client).

.. note::

    Some platform services (sysinv, cert-mon and VIM for example) also use X509
    certificates to access Kubernetes by HTTPS.

It is optional that you update the Kubernetes Root |CA| with a custom Root CA
certificate and key, generated by yourself, and trusted by your external
servers connecting to |prod|’s Kubernetes API endpoint. The |prod|’s Kubernetes
Root |CA| certificate and key are configured as part of the bootstrap during
installation.

.. note::

    You must use a Root |CA| certificate; Intermediate |CA| certificates
    are not supported by upstream Kubernetes.

Kubernetes certificates include:

-  Kubernetes Root |CA| Certificate
-  Cluster admin client certificate used by ``kubectl``
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
certificate embedded in service account token to verify the ``kube-apiserver``'s
server certificate when it makes calls to the kube-apiserver.

Kubernetes Root |CA| certificate and corresponding private key are stored in
file system:

-   ``/etc/kubernetes/pki/ca.crt``

-   ``/etc/kubernetes/pki/ca.key``

.. note::

    Kubernetes Root |CA| certificate is also embedded in various
    configuration files and service account token.

**Cluster admin client certificate used by kubectl**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
``/etc/kubernetes/admin.conf``. It is used by kubectl command to identify
itself to the ``kube-apiserver``.

**kube-controller-manager client certificate**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
``/etc/kubernetes/controller-manager.conf``. It is used by
``kube-controller-manager`` pod to identify itself to ``kube-apiserver``.

**kube-scheduler client certificate**

This is the client certificate signed by Kubernetes Root |CA| and embedded in
``/etc/kubernetes/scheduler.conf``. It is used by ``kube-scheduler`` pod to
identify itself to the ``kube-apiserver``.

**kube-apiserver server certificate**

This is the kube-apiserver's serving certificate. Clients connecting to the
``kube-apiserver`` will verify this certificate using Kubernetes Root |CA|
certificate. The certificate and the corresponding private key are stored in
file system:

-   ``/etc/kubernetes/pki/apiserver.crt``

-   ``/etc/kubernetes/pki/apiserver.key``

**kube-apiserver's kubelet client certificate**

``kube-apiserver``'s client certificate for communications with ``kubelet``.
``kube-apiserver`` identifies itself with this certificate when it connects to
``kubelet``. The certificate and the corresponding private keys are stored in
file system:

-   ``/etc/kubernetes/pki/apiserver-kubelet-client.crt``

-   ``/etc/kubernetes/pki/apiserver-kubelet-client.key``

**kubelet client certificate**

This is the ``kubelet``’s client certificate (with private key in it).
``kubelet`` identifies itself with this certificate when it connects to
``kube-apiserver``. ``kubelet`` has Kubernetes Root |CA| certificate in
``/etc/kubernetes/kubelet.conf`` to verify peer certificates.

The certificate and its corresponding private key are store in file system as
one file:

-   ``/var/lib/kubelet/pki/kubelet-client-current.pem``

This certificate is configured to auto renew.

.. toctree::
   :maxdepth: 1

   kubernetes-root-ca-certificate
   update-renew-kubernetes-certificates-52b00bd0bdae