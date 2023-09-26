
.. tvz1552007675065
.. _security-default-firewall-rules:

======================
Default Firewall Rules
======================

|prod| applies default firewall rules on the |OAM|, management, cluster-host,
pxeboot, admin, and storage platform networks. Each platform network will have
one ``GlobalNetworkPolicy`` per node role (controller or worker). The default
rules are recommended for most applications.

Traffic is permitted for the following protocols and ports to allow access
for platform services. By default, all other traffic is blocked.

You can view the configured |OAM| firewall rules with the following command:

.. code-block:: none

    [sysadmin@controller-0 ~(keystone_admin)]$ kubectl get globalnetworkpolicies.crd.projectcalico.org controller-oam-if-gnp -o yaml
    apiVersion: crd.projectcalico.org/v1
    kind: GlobalNetworkPolicy
    metadata:
      annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
          {"apiVersion":"crd.projectcalico.org/v1","kind":"GlobalNetworkPolicy","metadata":{"annotations":{},"name":"controller-oam-if-gnp"},"spec":{"applyOnForward":true,"egress":[{"action":"Allow","ipVersion":6,"metadata":{"annotations":{"name":"stx-egr-controller-oam-tcp6"}},"protocol":"TCP"},{"action":"Allow","ipVersion":6,"metadata":{"annotations":{"name":"stx-egr-controller-oam-udp6"}},"protocol":"UDP"},{"action":"Allow","ipVersion":6,"metadata":{"annotations":{"name":"stx-egr-controller-oam-icmpv66"}},"protocol":"ICMPv6"}],"ingress":[{"action":"Allow","destination":{"ports":[22,4545,5000,6385,6443,7480,7777,9001,9002,9311,15491,18002]},"ipVersion":6,"metadata":{"annotations":{"name":"stx-ingr-controller-oam-tcp6"}},"protocol":"TCP"},{"action":"Allow","destination":{"ports":[123,320,2222,2223]},"ipVersion":6,"metadata":{"annotations":{"name":"stx-ingr-controller-oam-udp6"}},"protocol":"UDP"},{"action":"Allow","ipVersion":6,"metadata":{"annotations":{"name":"stx-ingr-controller-oam-icmpv66"}},"protocol":"ICMPv6"}],"order":100,"selector":"has(nodetype) \u0026\u0026 nodetype == 'controller' \u0026\u0026 has(iftype) \u0026\u0026 iftype contains 'oam'","types":["Ingress","Egress"]}}
      creationTimestamp: "2023-07-26T02:53:50Z"
      generation: 1
      name: controller-oam-if-gnp
      resourceVersion: "189409"
      uid: d07c92ca-5cb6-4175-8891-16b4f66f5da4
    spec:
      applyOnForward: false
      egress:
      - action: Allow
        ipVersion: 6
        metadata:
          annotations:
            name: stx-egr-controller-oam-tcp6
        protocol: TCP
      - action: Allow
        ipVersion: 6
        metadata:
          annotations:
            name: stx-egr-controller-oam-udp6
        protocol: UDP
      - action: Allow
        ipVersion: 6
        metadata:
          annotations:
            name: stx-egr-controller-oam-icmpv66
        protocol: ICMPv6
      ingress:
      - action: Allow
        destination:
          ports:
          - 22
          - 4545
          - 5000
          - 6385
          - 6443
          - 7480
          - 7777
          - 9001
          - 9002
          - 9311
          - 15491
          - 18002
        ipVersion: 6
        metadata:
          annotations:
            name: stx-ingr-controller-oam-tcp6
        protocol: TCP
      - action: Allow
        destination:
          ports:
          - 123
          - 320
          - 2222
          - 2223
        ipVersion: 6
        metadata:
          annotations:
            name: stx-ingr-controller-oam-udp6
        protocol: UDP
      - action: Allow
        ipVersion: 6
        metadata:
          annotations:
            name: stx-ingr-controller-oam-icmpv66
        protocol: ICMPv6
      order: 100
      selector: has(nodetype) && nodetype == 'controller' && has(iftype) && iftype contains
        'oam'
      types:
      - Ingress
      - Egress


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

For internal traffic, the networks management, cluster-host, pxeboot, admin, and storage only filter
by source address and L4 protocol, not restricting the L4 port access. As can be seen in the example
below for the management network:

.. code-block:: none

    root@controller-0:/var/home/sysadmin# kubectl get globalnetworkpolicies.crd.projectcalico.org controller-mgmt-if-gnp -o yaml
    apiVersion: crd.projectcalico.org/v1
    kind: GlobalNetworkPolicy
    metadata:
      annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
          {"apiVersion":"crd.projectcalico.org/v1","kind":"GlobalNetworkPolicy","metadata":{"annotations":{},"name":"controller-mgmt-if-gnp"},"spec":{"applyOnForward":true,"egress":[{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-egr-controller-mgmt-tcp4"}},"protocol":"TCP"},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-egr-controller-mgmt-udp4"}},"protocol":"UDP"},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-egr-controller-mgmt-icmp4"}},"protocol":"ICMP"},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-egr-controller-mgmt-igmp4"}},"protocol":2}],"ingress":[{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-ingr-controller-mgmt-tcp4"}},"protocol":"TCP","source":{"nets":["10.8.87.0/24"]}},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-ingr-controller-mgmt-udp4"}},"protocol":"UDP","source":{"nets":["10.8.87.0/24"]}},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-ingr-controller-mgmt-icmp4"}},"protocol":"ICMP","source":{"nets":["10.8.87.0/24"]}},{"action":"Allow","destination":{"ports":[67]},"ipVersion":4,"metadata":{"annotations":{"name":"stx-ingr-controller-dhcp-udp4"}},"protocol":"UDP"},{"action":"Allow","ipVersion":4,"metadata":{"annotations":{"name":"stx-ingr-controller-mgmt-igmp4"}},"protocol":2,"source":{"nets":["10.8.87.0/24"]}}],"order":100,"selector":"has(nodetype) \u0026\u0026 nodetype == 'controller' \u0026\u0026 has(iftype) \u0026\u0026 iftype contains 'mgmt'","types":["Ingress","Egress"]}}
      creationTimestamp: "2023-08-03T06:01:49Z"
      generation: 1
      name: controller-mgmt-if-gnp
      resourceVersion: "136914"
      uid: 8ec83ec2-2664-46cd-907f-d48360e50029
    spec:
      applyOnForward: true
      egress:
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-egr-controller-mgmt-tcp4
        protocol: TCP
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-egr-controller-mgmt-udp4
        protocol: UDP
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-egr-controller-mgmt-icmp4
        protocol: ICMP
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-egr-controller-mgmt-igmp4
        protocol: 2
      ingress:
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-ingr-controller-mgmt-tcp4
        protocol: TCP
        source:
          nets:
          - 10.8.87.0/24
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-ingr-controller-mgmt-udp4
        protocol: UDP
        source:
          nets:
          - 10.8.87.0/24
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-ingr-controller-mgmt-icmp4
        protocol: ICMP
        source:
          nets:
          - 10.8.87.0/24
      - action: Allow
        destination:
          ports:
          - 67
        ipVersion: 4
        metadata:
          annotations:
            name: stx-ingr-controller-dhcp-udp4
        protocol: UDP
      - action: Allow
        ipVersion: 4
        metadata:
          annotations:
            name: stx-ingr-controller-mgmt-igmp4
        protocol: 2
        source:
          nets:
          - 10.8.87.0/24
      order: 100
      selector: has(nodetype) && nodetype == 'controller' && has(iftype) && iftype contains
        'mgmt'
      types:
      - Ingress
      - Egress


In a |prod-dc| configuration there will be dedicated rules to allow communications
between the the system controller and subcloud. These are added in the management
or admin network. The example below shows a rule added in the system controller
to allow TCP traffic in the management network:

.. code-block:: none

    - action: Allow
      metadata:
        annotations:
          name: stx-ingr-controller-systemcontroller-tcp6
      destination:
        ports:
        - 22
        - 389
        - 636
        - 4546
        - 5001
        - 5492
        - 5498
        - 6386
        - 6443
        - 8080
        - 8220
        - 9001
        - 9002
        - 9312
        - 18003
        - 31001
        - 31090
        - 31091
        - 31092
        - 31093
        - 31094
        - 31095
        - 31096
        - 31097
        - 31098
        - 31099
      ipVersion: 6
      protocol: TCP
      source:
        nets:
        - fd00:8:24::/64
        - fd00:8:25::/64
        - fd00:8:26::/64
        - fd00:8:27::/64


The values provided in the source: > nets: section above are the subcloud
management networks controlled by this system controller, in the same way the
subcloud management (or admin) firewall will contain a TCP rule containing the
system controller management network:

.. code-block:: none

    - action: Allow
      destination:
        ports:
        - 22
        - 4546
        - 5001
        - 5492
        - 6386
        - 8080
        - 8220
        - 9001
        - 9002
        - 9312
        - 18003
        - 31001
      ipVersion: 6
      metadata:
        annotations:
          name: stx-ingr-controller-subcloud-tcp6
      protocol: TCP
      source:
        nets:
        - fd00:8:32::/64


Each protocol (TCP, UDP) contains a specific set of L4 ports depending on the
role (system controller or subcloud). The selected L4 ports are described in
:ref:`distributed-cloud-ports-reference`.

.. note::
    Custom rules may be added for other requirements. For more information,
    see |sec-doc|: :ref:`Firewall Options <security-firewall-options>`.

.. note::
    UDP ports 2222 and 2223 are used by the service manager for state
    synchronization and heart beating between the controllers. All messages are
    authenticated with a SHA512 HMAC. Only packets originating from the peer
    controller are permitted; all other packets are dropped.

