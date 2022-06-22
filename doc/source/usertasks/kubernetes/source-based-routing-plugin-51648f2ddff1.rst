.. _source-based-routing-plugin-51648f2ddff1:

===========================
Source-Based Routing Plugin
===========================

The |SBR| plugin enables source based routing on an interface. It must be used
as a chained plugin in conjunction with another interface-creating plugin.

The following options are used to configure the plugin:

``name`` (string, optional)
    The name of the network.

``type`` (string, required)
    ``sbr``

.. rubric:: |eg|

The following example creates a pod with an additional bridge interface which
has |SBR| enabled.  There is also a demonstration pod without |SBR| enabled and
an ``iperf`` server pod.  Note the chained nature of the plugins.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: sbrnet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "sbrnet",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "static",
                     "addresses" : [
                         {
                             "address": "10.10.10.98/24",
                             "gateway": "10.10.10.254"
                         }
                     ]
                 }
             },
             {
                 "name": "brsbr",
                 "type": "sbr"
             }
         ]

       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: nosbrnet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "type": "bridge",
         "bridge": "mybr0",
         "ipam": {
             "type": "static",
             "addresses" : [
                 {
                     "address": "10.10.10.99/24",
                     "gateway": "10.10.10.254"
                 }
             ]
         }
       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: iperfservernet0
   spec:
     config: '{
         "cniVersion": "0.3.1",
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
       }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: iperfservernet1
   spec:
     config: '{
         "cniVersion": "0.3.1",
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
       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: sbrpod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "sbrnet1" }
       ]'
   spec:
     containers:
     - name: sbr1
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: nosbrpod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "nosbrnet1" }
       ]'
   spec:
     containers:
     - name: sbr2
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: iperfserverpod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "iperfservernet0" },
               { "name": "iperfservernet1" }
       ]'
   spec:
     containers:
     - name: iperfserver1
       image: praqma/network-multitool:extra
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]

.. note::

    The default table number will be 100.  One can see the result of the |SBR|
    plugin below.  For an application to use source-based routing, it would
    bind its socket to the source address, causing the routes in the
    corresponding table to be used (rather than the default routes).

.. rubric:: **Related commands**

* Show the default routing table.

  .. code-block:: none

     kubectl exec -it sbrpod1 -- ip route show
        default via 169.254.1.1 dev eth0
        169.254.1.1 dev eth0 scope link

* Show the table created by |SBR|.

  .. code-block:: none

     kubectl exec -it sbrpod1 -- ip rule list

        0:      from all lookup local
        32765:  from 10.10.10.98 lookup 100  <----------
        32766:  from all lookup main
        32767:  from all lookup default

* Show the contents of table 100.

  .. code-block:: none

     kubectl exec -it sbrpod1 -- ip route show table 100

        default via 10.10.10.254 dev net1
        10.10.10.0/24 dev net1 proto kernel scope link src 10.10.10.98

* Start the iperf server.

  .. code-block:: none

     kubectl exec -it iperfserverpod1 -- iperf3 -s -B 20.20.20.254

* Example of failure to connect from a pod without source based routing.

  .. code-block:: none

     kubectl exec -it nosbrpod1 -- iperf3 -c 20.20.20.254 -B 10.10.10.99 -k 1

* Example of failure to connect without binding to the source address.

  .. code-block:: none

     kubectl exec -it sbrpod1 -- iperf3 -c 20.20.20.254 -k 1

* Example of connection success for application binding to the source address.

  .. code-block:: none

     kubectl exec -it sbrpod1 -- iperf3 -c 20.20.20.254 -B 10.10.10.98 -k 1
