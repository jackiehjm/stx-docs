.. _macvlan-plugin-e631cca21ffb:

==============
Macvlan Plugin
==============

The Macvlan plugin allows a virtual device to be created in the container that
shares the physical capabilities and connectivity of a device on the host.  The
virtual device will have a distinct |MAC| address from the physical device.  As
such, multiple containers can share the device on the host.

The following options are used to configure the plugin:

``name`` (string, required)
   The name of the network.

``type`` (string, required)
   ``macvlan``

``master`` (string, optional)
   The name of the host interface to use. Default: default route interface.

``mode`` (string, optional)
   One of “bridge”, “private”, “vepa”, “passthru”. Default: “bridge”.

``mtu`` (integer, optional)
   Set |MTU| to the specified value. Default: the value chosen by the kernel.

``ipam`` (dictionary, required)
   The |IPAM| configuration to be used for this network. For an interface
   without ip address use an empty dictionary.

.. rubric:: |eg|

The following example would create a pod which contains an additional network
interface corresponding to a ``macvlan`` device which uses the ``eth1000``
interface on the host:

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: macvlan0
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "macvlan0",
         "type": "macvlan",
         "master": "eth1000",
         "mode": "bridge",
         "ipam": {
             "type": "static",
             "addresses": [
                 {
                     "address": "10.10.10.1/24",
                     "gateway": "10.10.10.2"
                 }
             ]
         }
       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: mvpod0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "macvlan0" }
       ]'
   spec:
     containers:
     - name: mv0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]

