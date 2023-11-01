.. _internal-ca-and-nodeport-example-2afa2a84603a:

================================
Internal CA and NodePort Example
================================

This section provides an example of how to configure an application to use
NodePort to expose its self-managed |TLS|-based service and to use an Internal
|CA| for signing CERTIFICATEs.

Note that alternatively an External |CA| could be used with a NodePort-based
solution as well.

.. rubric:: |prereq|

This example requires that:

-   Ensure that your |prod| administrator has enabled use of the
    cert-manager apiGroups in your |RBAC| policies.

.. rubric:: |proc|

#.  Create an internal RootCA ISSUER in the default namespace by applying the
    following manifest file.

    .. code-block:: none

        # Create a cluster-wide ISSUER for create self-signed certificates
        ---
        apiVersion: cert-manager.io/v1
        kind: ClusterIssuer
        metadata:
            name: system-selfsigning-issuer
        spec:
            selfSigned: {}


        # Create a Certificate (and key) for my RootCA
        ---
        apiVersion: cert-manager.io/v1
        kind: Certificate
        metadata:
            name: abccompany-starlingx-rootca-certificate
        spec:
            secretName: abccompany-starlingx-rootca-certificate
            duration: 8640h
            commonName: "abccompany-starlingx-rootca"
            isCA: true
            issuerRef:
                name: system-selfsigning-issuer
                kind: ClusterIssuer


        # Create the RootCA ISSUER
        ---
        apiVersion: cert-manager.io/v1
        kind: Issuer
        metadata:
            name: abccompany-starlingx-rootca-issuer
        spec:
            ca:
                secretName: abccompany-starlingx-rootca-certificate

#.  Share the public certificate of your internal RootCA to clients such that
    they can trust certificates signed by this RootCA.

    .. code-block:: none

        CERT64=`kubectl get secret abccompany-starlingx-rootca-certificate -n default -o yaml | fgrep tls.crt | fgrep -v "f:tls.crt" | awk '{print $2}'`
        echo $CERT64 | base64 --decode > abccompany-starlingx-rootca-certificate.pem

#.  Create a deployment of an example demo application that uses NodePort to
    expose its service and therefore manages its |TLS| connection on its own,
    using a certificate it creates on its own.

    Apply the following manifest.

    Where ``10.10.10.45`` is the |OAM| Floating IP of the |prod| and
    ``abccompany-starlingx.mycompany.com`` is the |FQDN| for this address.

    (You should substitute with the IP Address and |FQDN| for the |prod|
    installation.)

    .. code-block:: none

        apiVersion: cert-manager.io/v1
        kind: Certificate
        metadata:
          name: abccompany-starlingx.mycompany.com-certificate
        spec:
          duration: 2160h # 90d
          renewBefore: 360h # 15d
          secretName: abccompany-starlingx.mycompany.com-certificate
          issuerRef:
            name: abccompany-starlingx-rootca-issuer
            kind: Issuer
          commonName: abccompany-starlingx.mycompany.com
          dnsNames:
          - abccompany-starlingx.mycompany.com
          ipAddresses:
          - 10.10.10.45
        ---
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: example-app
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: example-app
          template:
            metadata:
              labels:
                app: example-app
            spec:
              containers:
              - name: example-app
                image: example-app         # not a real app, could substitute ‘busybox’ here to look at mounted cert files inside container
                imagePullPolicy: Always
                ports:
                - containerPort: 8443
                protocol: TCP
                volumeMounts:
                - name: mycert
                  mountPath: "/etc/mycert"  # the files tls.crt, tls.key and ca.crt will be under /etc/mycert/ in container
                  readOnly: true
              volumes:
              - name: mycert
                secret:
                  secretName: abccompany-starlingx.mycompany.com-certificate
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: example-app
          labels:
            app: example-app
        spec:
          type: NodePort
          ports:
            - port: 443
              protocol: TCP
              targetPort: 8443
              nodePort: 31118
          selector:
            app: example-app

    .. include:: /shared/_includes/recommended-renewbefore-value-for-certificates-c929cf42b03b.rest

#.  If example-app existed, you would access it from your browser
    with ``https://abccompany-starlingx.mycompany.com:31118``.

    If you are using busybox to look at mounted cert files, attach to container
    (e.g. ``kubectl exec busybox-... -it -- sh`` and ``cd /etc/mycert; ls``).
