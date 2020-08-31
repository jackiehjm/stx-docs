
.. rsl1588342741919
.. _firewall-port-overrides:

=======================
Firewall Port Overrides
=======================

Although nginx-ingress-controller is configured by default to listen on
ports 80 and 443, for security reasons the opening of these ports is left
to be explicitly done by the system installer/administrator.

.. rubric:: |proc|

-   To open these ports you need to edit the existing globalnetworkpolicy
    controller-oam-if-gnp, or create another globalnetworkpolicy with your user
    overrides. |org| recommends creating a new globalnetworkpolicy.

    For example:

    .. code-block:: none

        apiVersion: crd.projectcalico.org/v1
        kind: GlobalNetworkPolicy
        metadata:
          name: gnp-oam-overrides
        spec:
          ingress:
          - action: Allow
            destination:
              ports:
              - 80
              - 443
            protocol: TCP
          order: 500
          selector: has(iftype) && iftype == 'oam'
          types:
          - Ingress