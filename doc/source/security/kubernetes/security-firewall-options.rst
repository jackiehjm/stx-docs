
.. zlk1582057887959
.. _security-firewall-options:

=======================
Modify Firewall Options
=======================

|prod| incorporates a default firewall for the platform networks (|OAM|,
management, cluster-host, pxeboot, admin, and storage). You can configure
additional Kubernetes Network Policies to augment or override the default rules.

The |prod| firewall uses the Kubernetes Network Policies (using the Calico
|CNI|) to implement a firewall on the desired platform network.

The available labels to place the new ``GlobalNetworkPolicy`` selectors are:


.. _security-firewall-options-ul-xw2-qkw-g3b:

``ifname``
   nodename.interface-name e.g.: controller-0.mgmt0

``iftype``
   mgmt, admin, cluster-host, pxeboot, storage

``nodetype``
   controller or worker

Since a single interface can receive one or more networks, the ``iftype`` label
concatenates with "." as a separator, e.g.: ``cluster-host.mgmt.pxeboot`` (for
this case the host endpoint (``HostEndpoint`` in the example below) will use the
rules for all |GNPs| that contain those labels in the selector).


To get the installed labels check the host endpoints previously created:

.. code-block:: none

    $ kubectl get hostendpoints.crd.projectcalico.org
    NAME                           AGE
    controller-0-cluster0-if-hep   8h
    controller-0-mgmt0-if-hep      8h
    controller-0-oam-if-hep        8h
    controller-0-pxeboot0-if-hep   8h
    controller-1-cluster0-if-hep   7h58m
    controller-1-mgmt0-if-hep      7h58m
    controller-1-oam-if-hep        7h58m
    controller-1-pxeboot0-if-hep   7h58m

.. code-block:: none

    $ kubectl get hostendpoints.crd.projectcalico.org controller-0-mgmt0-if-hep -o yaml
    apiVersion: crd.projectcalico.org/v1
    kind: HostEndpoint
    metadata:
      annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
          {"apiVersion":"crd.projectcalico.org/v1","kind":"HostEndpoint","metadata":{"annotations":{},"labels":{"ifname":"controller-0.mgmt0","iftype":"mgmt","nodetype":"controller"},"name":"controller-0-mgmt0-if-hep"},"spec":{"interfaceName":"vlan383","node":"controller-0"}}
      creationTimestamp: "2023-08-03T06:01:50Z"
      generation: 1
      labels:
        ifname: controller-0.mgmt0
        iftype: mgmt
        nodetype: controller
      name: controller-0-mgmt0-if-hep
      resourceVersion: "2861"
      uid: 591694b5-e0ef-4562-a050-000e9473103a
    spec:
      interfaceName: vlan383
      node: controller-0

All platform interfaces have a ``HostEndpoint`` attached to it, hence all traffic
is blocked by default. The ``GlobalNetworkPolicies`` associated with a particular
``HostEndpoint`` provide the permission rules. All ``GlobalNetworkPolicies`` provided by
|prod| are set with order 100.


You can introduce custom rules by creating and installing custom Kubernetes
Network Policies.

The following example opens up default HTTPS port 443.

.. code-block:: none

    % cat <<EOF > gnp-oam-overrides.yaml
    apiVersion: crd.projectcalico.org/v1
    kind: GlobalNetworkPolicy
    metadata:
      name: gnp-oam-overrides
    spec:
      ingress:
      - action: Allow
        destination:
          ports:
        protocol: TCP
      order: 500
      selector: has(nodetype) && nodetype == 'controller' && has(iftype) && iftype contains 'oam'
      types:
      - Ingress
    EOF

It can be applied using the :command:`kubectl` apply command. For example:

.. code-block:: none

    $ kubectl apply -f gnp-oam-overrides.yaml

You can confirm the policy was applied properly using the :command:`kubectl`
describe command. For example:

.. code-block:: none

    $ kubectl describe globalnetworkpolicy gnp-oam-overrides
    Name:         gnp-oam-overrides
    Namespace:
    Labels:       <none>
    Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                    {"apiVersion":"crd.projectcalico.org/v1","kind":"GlobalNetworkPolicy","metadata":{"annotations":{},"name":"gnp-openstack-oam"},"spec...
    API Version:  crd.projectcalico.org/v1
    Kind:         GlobalNetworkPolicy
    Metadata:
      Creation Timestamp:  2019-05-16T13:07:45Z
      Generation:          1
      Resource Version:    296298
      Self Link:           /apis/crd.projectcalico.org/v1/globalnetworkpolicies/gnp-openstack-oam
      UID:                 98a324ab-77db-11e9-9f9f-a4bf010007e9
    Spec:
      Ingress:
        Action:  Allow
        Destination:
          Ports:
            443
        Protocol:  TCP
      Order:       500
      Selector:    has(nodetype) && nodetype == 'controller' && has(iftype) && iftype contains 'oam'
      Types:
        Ingress
    Events:  <none>

.. xbooklink

   For information about yaml rule syntax, see |sysconf-doc|: :ref:`Modifying OAM Firewall Rules <modifying-oam-firewall-rules>`.

For the default rules used by |prod| see |sec-doc|: :ref:`Default Firewall
Rules <security-default-firewall-rules>`.

For a full description of GNP syntax, see
`https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetwo
rkpolicy
<https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetwo
rkpolicy>`__.

