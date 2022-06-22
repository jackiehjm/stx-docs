.. _istio-service-mesh-application-eee5ebb3d3c4:

===================================================
Technology Preview - Istio Service Mesh Application
===================================================

.. rubric:: |context|

The Istio Service Mesh application Technology Preview is integrated into |prod|
as a system application.

Istio provides traffic management, observability as well as security as a
Kubernetes service mesh. For more information, see `https://istio.io/
<https://istio.io/>`__.

|prod| includes istio-operator container to manage the life cycle management
of the Istio components.

The following Istio components are enabled when applying the Istio system
application:

-   Istio data plane - Envoy - Kubernetes side-car proxy

-   Istio control plane - Istiod - service discovery, configuration and
    certificate management

-   Istio gateway - Traffic management of ingress and egress L4-L7 traffic

-   Istio-cni - Kubernetes |CNI| plugin

The Kiali (`https://kiali.io/ <https://kiali.io/>`__) management console for
Istio is also integrated with |prod|, in the Istio system application.
It provides management functions and visualizations to the service mesh
operation. Metrics and tracing functionalities are not supported at this time.

.. rubric:: |proc|

You can install Istio and Kiali on |prod| from the command line.

#.  Locate the Istio tarball in ``/usr/local/share/application/helm``.

    For example:

    .. code-block:: none

        /usr/local/share/application/helm/istio-<version>.tgz

#.  Upload the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-upload /usr/local/share/application/helm/istio-<version>.tgz

#.  Apply the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply istio

#.  Monitor the application status.

    .. code-block:: none

        ~(keystone_admin)]$ watch -n 5 system application-list

    OR

    .. code-block:: none

        ~(keystone_admin)]$ watch kubectl get pods -n istio-system

#.  Setup network attachment definition.

    .. code-block:: none

        cat > istio-cni-nad.yaml <<EOF
        apiVersion: "k8s.cni.cncf.io/v1"
        kind: NetworkAttachmentDefinition
        metadata:
         name: istio-cni
        EOF
        kubectl apply -f istio-cni-nad.yaml

    |CNI| is managed by Multus. The NetworkAttachmentDefinition is required in
    the application namespace in order to invoke the ``istio-cni`` plugin.

#.  Enable side car for a particular namespace.

    .. code-block:: none

        kubectl label namespace <namespace> istio-injection=enabled


    When the ``istio-injection=enabled`` label on a namespace is set and the
    injection webhook is enabled, any new pods that are created in that
    namespace will automatically have a sidecar added to them.

#.  At this point, you may launch services in the above namespace.

    When the user application is deployed, the sidecar container
    ``istio-proxy`` is injected into the user application pod:

    Events:

    .. code-block:: none

        Type    Reason     Age   From               Message
        ----    ------     ----  ----               -------
        ...
        Normal  Created    10s   kubelet            Created container <user app>
        Normal  Started    10s   kubelet            Started container <user app>
        ...
        Normal  Created    9s    kubelet            Created container istio-proxy
        Normal  Started    8s    kubelet            Started container istio-proxy

    The ``istio-proxy`` sidecar extracts telemetry of all ingress and egress
    traffic of the user application that can be monitored and available for
    display in Kiali, and it mediates all ingress and egress traffic of the
    user application by enforcing policy decisions.

---------
Use Kiali
---------

After the Istio application has been installed, you can launch the Kiali
management console in a browser.

#.  Get the port of Kiali service.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get svc -n istio-system kiali -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}'

#.  Launch Kiali on a browser.

    .. code-block:: none

        http:<oam-floating-ip>:<kiali_port>/kiali

#.  Get the login token.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get secret -n istio-system $(kubectl get sa kiali -n istio-system -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 -d

#.  Login to Kiali.

    Enter the token from the previous step and press Login.

------------------------
Remove Istio application
------------------------

You can remove the Istio application from |prod|.

#.  Remove pods and their resources.

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove istio

#.  Delete the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete istio

#.  Delete Istio |CNI| Network Attachment Definition.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl delete -f istio-cni-nad.yaml
