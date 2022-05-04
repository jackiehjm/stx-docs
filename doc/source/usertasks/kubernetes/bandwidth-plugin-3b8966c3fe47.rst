.. _bandwidth-plugin-3b8966c3fe47:

================
Bandwidth Plugin
================

The bandwidth plugin allows the configuration of the linux traffic control
subsystem for the interface.  It uses a |TBF| queuing discipline (``qdisc``)
on both ingress and egress traffic. It must be used as a chained plugin in
conjunction with another interface-creating plugin.

See https://man7.org/linux/man-pages/man8/tbf.8.html for more
information.

The following options are used to configure the plugin:

``name`` (string, optional)
    The name of the network.

``type`` (string, required)
    ``bandwidth``

``ingressRate`` (int, required)
    The rate, in bits per second, at which traffic can enter an interface.

``ingressBurst`` (int, required)
    The maximum amount in bits that tokens can be made available for
    instantaneously.

``egressRate`` (int, required)
    The rate, in bits per second, at which traffic can leave an interface.

``egressBurst`` (int, required)
    The maximum amount, in bits, that tokens can be made available for
    instantaneously.


.. rubric:: |eg|

The following example creates a pod with an additional bridge interface which
uses the bandwidth plugin to ensure the ingress/egress rate does not exceed
100Kbps.  Note the chained nature of the plugins.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bridge1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bridgenet1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "br1",
                 "ipam": {
                     "type": "static",
                     "addresses": [
                       {
                         "address": "10.10.10.1/24",
                         "gateway": "10.10.10.2"
                       }
                     ]
                 }
             },
             {
                 "name": "brbw",
                 "type": "bandwidth",
                 "ingressRate": 100000,
                 "ingressBurst": 50000,
                 "egressRate": 100000,
                 "egressBurst": 50000
             }
         ]
       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: bridgepod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "bridge1" }
       ]'
   spec:
     containers:
     - name: bridge1
       image: networkstatic/iperf3
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
