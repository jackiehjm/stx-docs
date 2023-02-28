
.. tvz1552007675065
.. _security-default-firewall-rules:

======================
Default Firewall Rules
======================

|prod| applies default firewall rules on the |OAM| network. The default rules
are recommended for most applications.

Traffic is permitted for the following protocols and ports to allow access
for platform services. By default, all other traffic is blocked.

You can view the configured firewall rules with the following command:

.. code-block:: none

    ~(keystone_admin)]$ kubectl describe globalnetworkpolicy
    Name:         controller-oam-if-gnp
    Namespace:
    Labels:       <none>
    Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                    {"apiVersion":"crd.projectcalico.org/v1","kind":"GlobalNetworkPolicy","metadata":{"annotations":{},"name":"controller-oam-if-gnp"},"spec":...
    API Version:  crd.projectcalico.org/v1
    Kind:         GlobalNetworkPolicy
    Metadata:
      Creation Timestamp:  2019-08-08T20:18:34Z
      Generation:          1
      Resource Version:    1395
      Self Link:           /apis/crd.projectcalico.org/v1/globalnetworkpolicies/controller-oam-if-gnp
      UID:                 b28b74fe-ba19-11e9-9176-ac1f6b0eef28
    Spec:
      Apply On Forward:  false
      Egress:
        Action:      Allow
        Ip Version:  4
        Protocol:    TCP
        Action:      Allow
        Ip Version:  4
        Protocol:    UDP
        Action:      Allow
        Protocol:    ICMP
      Ingress:
        Action:  Allow
        Destination:
          Ports:
            22
            18002
            4545
            15491
            6385
            7777
            6443
            9001
            9002
            7480
            9311
            5000
            8080
        Ip Version:  4
        Protocol:    TCP
        Action:      Allow
        Destination:
          Ports:
            2222
            2223
            123
            161
            162
            319
            320
        Ip Version:  4
        Protocol:    UDP
        Action:      Allow
        Protocol:    ICMP
      Order:         100
      Selector:      has(iftype) && iftype == 'oam'
      Types:
        Ingress
        Egress
    Events:  <none>


Where:


.. _security-default-firewall-rules-d488e47:


.. table::
    :widths: auto

    +------------------------+------------------------+------------------------+
    | Protocol               | Port                   | Service Name           |
    +========================+========================+========================+
    | tcp                    | 22                     | ssh                    |
    +------------------------+------------------------+------------------------+
    | tcp                    | 8080                   | horizon (http only)    |
    +------------------------+------------------------+------------------------+
    | tcp                    | 8443                   | horizon (https only)   |
    +------------------------+------------------------+------------------------+
    | tcp                    | 5000                   | keystone-api           |
    +------------------------+------------------------+------------------------+
    | tcp                    | 6385                   | stx-metal              |
    |                        |                        |                        |
    |                        |                        | stx-config             |
    +------------------------+------------------------+------------------------+
    | tcp                    | 8119                   | stx-distcloud          |
    +------------------------+------------------------+------------------------+
    | tcp                    | 18002                  | stx-fault              |
    +------------------------+------------------------+------------------------+
    | tcp                    | 7777                   | stx-ha                 |
    +------------------------+------------------------+------------------------+
    | tcp                    | 4545                   | stx-nfv                |
    +------------------------+------------------------+------------------------+
    | tcp                    | 6443                   | Kubernetes api server  |
    +------------------------+------------------------+------------------------+
    | tcp                    | 9001                   | Docker registry        |
    +------------------------+------------------------+------------------------+
    | tcp                    | 9002                   | Registry token server  |
    +------------------------+------------------------+------------------------+
    | tcp                    | 15491                  | stx-update             |
    +------------------------+------------------------+------------------------+
    | icmp                   |                        | icmp                   |
    +------------------------+------------------------+------------------------+
    | udp                    | 123                    | ntp                    |
    +------------------------+------------------------+------------------------+
    | udp                    | 161                    | snmp                   |
    +------------------------+------------------------+------------------------+
    | udp                    | 2222                   | service manager        |
    +------------------------+------------------------+------------------------+
    | udp                    | 2223                   | service manager        |
    +------------------------+------------------------+------------------------+

.. note::
    Custom rules may be added for other requirements. For more information,
    see |sec-doc|: :ref:`Firewall Options <security-firewall-options>`.

.. note::
    UDP ports 2222 and 2223 are used by the service manager for state
    synchronization and heart beating between the controllers. All messages are
    authenticated with a SHA512 HMAC. Only packets originating from the peer
    controller are permitted; all other packets are dropped.

