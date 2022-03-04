.. _starlingx-rest-api-applications-and-the-web-admin-server-cert-9196c5794834:

========================
Create a local CA Issuer
========================


|org| recommends that a single local |CA| Issuer be created on the platform to
create, sign, and anchor all of your platform certificates. This |CA| can be
either a stand-alone local Root |CA| or a local Intermediate |CA| (whose
certificate is signed by an external Root |CA|). This simplifies your overall
platform certificate configuration, and means that external clients interfacing
with the platform's HTTPS endpoints, need only be given a single Root |CA|
certificate to add to their trusted |CAs|.


Create the ClusterIssuer
========================

Create a local Root CA
----------------------

The following sample procedure illustrates how to create a unique standalone
local Root |CA| (``system-local-ca``) that can be used to create, sign, and
anchor all of your platform certificates.

Update the ``subject`` fields to identify your particular system.

It is recommended that a 3-5 year duration be used for operational simplicity
since, although the certificate will automatically renew locally, when it does
renew, you will need to re-distribute the |CA|'s new public certificate to all
external clients using the platform's HTTPS endpoints.

The created ``system-local-ca`` Root |CA| is cluster-wide, so it can be used to
create all platform certificates and can also be used for hosted applications'
certificates.

.. rubric:: |proc|

#. Create a cluster issuer yaml configuration file.

   .. code-block:: none

      ~(keystone_admin)]$ cat <<EOF > cluster-issuer.yaml
      ---
      apiVersion: cert-manager.io/v1alpha2
      kind: ClusterIssuer
      metadata:
        name: system-selfsigning
      spec:
        selfSigned: {}
      ---
      apiVersion: cert-manager.io/v1alpha2
      kind: Certificate
      metadata:
        name: system-local-ca
        namespace: cert-manager
      spec:
        subject:
          organizationalUnits:
            - StarlingX-system-local-ca
        secretName: system-local-ca
        commonName: system-local-ca
        isCA: true
        duration: 43800h # 5 year
        renewBefore: 720h # 30 days
        issuerRef:
          name: system-selfsigning
          kind: ClusterIssuer
      ---
      apiVersion: cert-manager.io/v1alpha2
      kind: ClusterIssuer
      metadata:
        name: system-local-ca
      spec:
        ca:
          secretName: system-local-ca
      EOF

   For more information on supported parameters, see
   https://cert-manager.io/v0.14-docs/reference/api-docs/#acme.cert-manager.io%2fv1alpha2


#. Apply the configuration.

   .. code-block:: none

       ~(keystone_admin)]$ kubectl apply –f cluster-issuer.yaml

#. Verify the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl get clusterissuer

#. Write the public certificate of this |CA| to a ``.pem`` file that can be
   distributed to external clients using the platform's HTTPS endpoints.

   .. code-block::

       ~(keystone_admin)]$ kubectl get secret <secretname> -n <namespacename> -o=jsonpath='{.data.ca\.crt}' | base64 --decode > <pemfilename>

Create a local Intermediate CA
------------------------------

Alternatively, if you are using an external RootCA, the following procedure is
an example of how to create a local Intermediate |CA| (whose certificate is
signed by an external Intermediate or Root |CA|) that can be used to
create, sign, and anchor all of your platform certificates.  Refer to the
documentation for your external Intermediate or Root |CA| for information on
how to create a public certificate and private key for an intermediate |CA|.
It is recommended that a 3-5 year duration be used for operational simplicity
since this certificate will need to be manually renewed with the externally
generated certificate and key, and then referenced via the ClusterIssuer's
``spec.ca.secretName``. The |TLS| secret must be created in the Cluster
Resource Namespace, which defaults to ``cert-manager`` on the platform.

The ``system-local-ca`` Root |CA| is cluster-wide, so it can be used to create
all platform certificates and can also be used for hosted applications'
certificates.

#. Copy the |PEM| encoded certificate and key from the externally generated
   |CA| to the controller host.

#. Create a |TLS| secret in ‘cert-manager’ namespace with the certificate/Key
   files:

   .. code-block:: none

       ~(keystone_admin)]$ kubectl -n cert-manager create secret tls system-local-ca --cert=./cert.pem  --key=./key.pem

#. Create ClusterIssuer and the |CA| certificate.

   .. code-block:: none

       ~(keystone_admin)]$ cat <<EOF > cluster-issuer.yaml
       ---
       apiVersion: cert-manager.io/v1alpha2
       kind: ClusterIssuer
       metadata:
         name: system-local-ca
       spec:
         ca:
           secretName: system-local-ca

       EOF

#. Apply the configuration.

   .. code-block:: none

       ~(keystone_admin)]$ kubectl apply –f cluster-issuer.yaml

#. Verify the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl get clusterissuer

   If the configuration is successful, the clusterissuer for
   ``system-local-ca`` will have Ready status of ``True``.

The clusterissuer is now ready to issue certificates on the platform.
