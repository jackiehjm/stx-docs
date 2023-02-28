
.. rmw1552671149311
.. _network-planning-firewall-options:

================
Firewall Options
================

|prod| incorporates a default firewall for the |OAM| network. You can configure
additional Kubernetes Network Policies in order to augment or override the
default rules.

The |prod| firewall uses the Kubernetes Network Policies (using the Calico
|CNI|) to implement a firewall on the |OAM| network.

A minimal set of rules is always applied before any custom rules, as follows:


.. _network-planning-firewall-options-d342e35:

-   Non-|OAM| traffic is always accepted.

-   Egress traffic is always accepted.

-   Service manager (SM) traffic is always accepted.

-   |SSH| traffic is always accepted.


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
          - 443
        protocol: TCP
      order: 500
      selector: has(iftype) && iftype == 'oam'
      types:
      - Ingress
    EOF

It can be applied using the :command:`kubectl apply` command. For example:

.. code-block:: none

    $ kubectl apply -f gnp-oam-overrides.yaml

You can confirm the policy was applied properly using the :command:`kubectl
describe` command. For example:

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
      Selector:    has(iftype) && iftype == 'oam'
      Types:
        Ingress
    Events:  <none>

.. xbooklink For information about yaml rule syntax, see |sysconf-doc|: :ref:`Modify OAM Firewall Rules <modifying-oam-firewall-rules>`.

.. xbooklink For the default rules used by |prod| see |sec-doc|: :ref:`Default Firewall Rules <security-default-firewall-rules>`.

.. seealso::

   For a full description of |GNP| syntax:

   `https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetworkpolicy
   <https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetworkpolicy>`__.

