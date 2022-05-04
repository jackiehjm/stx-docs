.. _tuning-plugin-08f8cdbf1763:

=============
Tuning Plugin
=============

The tuning plugin can change some system controls (``sysctls``) and interface
attributes.  It must be used as a chained plugin in conjunction with another
interface-creating plugin.

The following options are used to configure the plugin:

``name`` (string, required)
    The name of the network.

``type`` (string, required)
    ``tuning``

``mac`` (string, optional)
    Set the ``MAC`` address of the interface.

`mtu` (integer, optional)
    Set the ``MTU`` of the interface.

``promisc`` (bool, optional)
    Set the promiscuous mode of interface.

``allmulti`` (bool, optional)
    Set the all-multicast mode of interface. If enabled, all multicast packets
    on the network will be received by the interface.

``sysctl`` (object, optional)
    Change ``sysctls`` in the network namespace.


.. rubric:: |eg|

The following example creates a pod with an additional bridge interface which
has its |MTU|, |MAC|, promiscuous mode, ``allmulti`` mode, and ``ipforwarding``
values changed by the tuning plugin. Note the chained nature of the plugins.

.. code-block:: yaml

   kind: NetworkAttachmentDefinitionapiVersion: "k8s.cni.cncf.io/v1"
   metadata:
     name: bridge1
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bridgenet",
         "plugins": [
             {
                 "type": "bridge",
                 "bridge": "mybr0",
                 "ipam": {
                     "type": "host-local",
                     "subnet": "10.10.10.0/24"
                 }
             },
             {
                 "name": "brtuning",
                 "type": "tuning",
                 "sysctl": {
                   "net.ipv4.conf.net1.forwarding": "1"
                 },
                 "mtu": 9000,
                 "mac": "c2:b0:57:49:47:f1",
                 "promisc": true,
                 "allmulti": true
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
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
