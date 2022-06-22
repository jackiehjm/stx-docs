.. _virtual-routing-and-forwarding-plugin-0e53f2c2de21:

=====================================
Virtual Routing and Forwarding Plugin
=====================================

The |VRF| plugin enables virtual routing and forwarding in the network
namespace of the container and assigns it an interface. It must be used as a
chained plugin in conjunction with another interface-creating plugin.

See https://www.kernel.org/doc/Documentation/networking/vrf.txt for more
information.

The following options are used to configure the plugin:

``vrfname`` (string, required)
    The name of the network.

``type`` (string, required)
    ``vrf``

.. rubric:: |eg|

The following example creates a pod with an additional bridge interface that
has two |VRFs| enabled (blue and red).  There are also two demonstration router
pods and a demonstration endpoint pod.  Note the chained nature of the plugins
and the usage of the tuning plugin to enable forwarding in the router pods.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bluenet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bluenet1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "10.10.10.2/24",
                             "gateway": "10.10.10.1"
                         }
                     ]
                 }
             },
             {
                 "type": "vrf",
                 "vrfname": "blue"
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bluerouter1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bluerouter1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "10.10.10.1/24"
                         }
                     ]
                 }
             },
             {
                 "name": "brtuning",
                 "type": "tuning",
                 "sysctl": {
                   "net.ipv4.conf.net1.forwarding": "1"
                 }
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bluerouter2
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bluerouter2",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr1",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "20.20.20.1/24"
                         }
                     ]
                 }
             },
             {
                 "name": "brtuning",
                 "type": "tuning",
                 "sysctl": {
                   "net.ipv4.conf.net2.forwarding": "1"
                 }
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: rednet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "rednet1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "10.10.10.2/24",
                             "gateway": "10.10.10.254"
                         }
                     ]
                 }
             },
             {
                 "type": "vrf",
                 "vrfname": "red"
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: redrouter1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "redrouter1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "10.10.10.254/24"
                         }
                     ]
                 }
             },
             {
                 "name": "brtuning",
                 "type": "tuning",
                 "sysctl": {
                   "net.ipv4.conf.net1.forwarding": "1"
                 }
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: redrouter2
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "redrouter2",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr1",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "20.20.20.254/24"
                         }
                     ]
                 }
             },
             {
                 "name": "brtuning",
                 "type": "tuning",
                 "sysctl": {
                   "net.ipv4.conf.net2.forwarding": "1"
                 }
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: epnet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "epnet1",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr1",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "20.20.20.2/24",
                             "gateway": "20.20.20.1"
                         }
                     ],
                     "routes" : [
                       { "dst" : "10.10.10.0/24", "gw": "20.20.20.1"}
                     ]
                 }
             }
         ]

       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: vrfpod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "bluenet1" },
               { "name": "rednet1" }
       ]'
   spec:
     containers:
     - name: vrfpod1
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
       securityContext:
         capabilities:
           add:
             - NET_ADMIN
     nodeName: controller-0
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: routerblue
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "bluerouter1" },
               { "name": "bluerouter2" }
       ]'
   spec:
     containers:
     - name: routerblue
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
     nodeName: controller-0
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: routerred
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "redrouter1" },
               { "name": "redrouter2" }
       ]'
   spec:
     containers:
     - name: routerred
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
     nodeName: controller-0
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: endpoint1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "epnet1" }
       ]'
   spec:
     containers:
     - name: endpoint1
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
     nodeName: controller-0

Once the ``yaml`` configuration listed above has been applied, do the
following:

#. Ensure the |VRFs| are listed in the ``vrfpod``.

   .. code-block:: none

      kubectl exec -it vrfpod1 -- ip vrf show
      Name              Table
      -----------------------
      blue                 1
      red                  2

#. Ensure both ``net1`` and ``net2`` interfaces both have the same IP address.

   .. code-block:: none

      $ kubectl exec -it vrfpod1 -- ip addr list

#. Add different routes through each |VRF|.

   .. code-block:: none

      $ kubectl exec -it vrfpod1 -- ip route add 20.20.20.0/24 via 10.10.10.1 vrf blue
      $ kubectl exec -it vrfpod1 -- ip route add 20.20.20.0/24 via 10.10.10.254 vrf red

#. Ping the endpoint via the blue |VRF|.

   .. code-block:: none

      kubectl exec -it vrfpod1 -- ping -I net1 20.20.20.2

#. Observe via tcpdump or pkt stats that the blue router gets all the traffic

   .. code-block:: none

      $ kubectl exec -it routerblue -- tcpdump -enn -i net1

#. Ping the endpoint via the red |VRF|.

   .. code-block:: none

      $ kubectl exec -it vrfpod -- ping -I net2 20.20.20.2

#. Observe via :command:`tcpdump` or :command:`pkt`` stats that the red router
   gets all outgoing traffic from the ``vrfpod``.  Return traffic goes via the
   blue router, as that is the default ``gw`` for the endpoint.

   .. code-block:: none

      $ kubectl exec -it routerred -- tcpdump -enn -i net1
