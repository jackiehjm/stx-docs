
.. yqd1552574422118
.. _modifying-oam-firewall-rules:

==========================
Modify OAM Firewall Rules
==========================

|prod| supports custom |OAM| firewall rules using Kubernetes Global Network
Policies.

These policies are defined using yaml syntax. For example:

.. code-block:: yaml

    ~(keystone_admin)]$ kubectl get globalnetworkpolicies.crd.projectcalico.org -o yaml
    apiVersion: v1
    items:
    - apiVersion: crd.projectcalico.org/v1
      kind: GlobalNetworkPolicy
      metadata:
        creationTimestamp: "2019-06-28T17:06:33Z"
        generation: 1
        name: controller-oam-if-gnp
        resourceVersion: "1916"
        selfLink: /apis/crd.projectcalico.org/v1/globalnetworkpolicies/controller-oam-if-gnp
        uid: 146ec9a4-99c7-11e9-b187-0800275484ef
      spec:
        applyOnForward: false
        egress:
        - action: Allow
          ipVersion: 4
          protocol: TCP
        - action: Allow
          ipVersion: 4
          protocol: UDP
        - action: Allow
          protocol: ICMP
        ingress:
        - action: Allow
          destination:
            ports:
            - 22
            - 18002
            - 4545
            - 15491
            - 6385
            - 7777
            - 6443
            - 7480
            - 9311
            - 5000
            - 8080
          ipVersion: 4
          protocol: TCP
        - action: Allow
          destination:
            ports:
            - 2222
            - 2223
            - 123
            - 161
            - 162
            - 319
            - 320
          ipVersion: 4
          protocol: UDP
        - action: Allow
          protocol: ICMP
        order: 100
        selector: has(iftype) && iftype == 'oam'
        types:
        - Ingress
        - Egress
    kind: List
    metadata:
      resourceVersion: ""
      selfLink: ""

For a full description of |GNP| syntax,
see `https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetworkpolicy
<https://docs.projectcalico.org/v3.6/reference/calicoctl/resources/globalnetworkpolicy>`__.

Use the following command to edit the globalnetworkpolicy and modify the
|OAM| Firewall according to the above |GNP| syntax:

.. code-block:: none

    kubectl edit globalnetworkpolicy

.. xbooklink For more information about the |prod| firewall,
   see |sec-doc|: `Firewall Options <network-planning-firewall-options>`.
