.. _vlan-plugin-37938fe8578f:

===========
VLAN Plugin
===========

The |VLAN| plugin allows a virtual device to be created in the container that
is attached to a physical device in the host via a ``veth`` pair.  The veth in
the host namespace will be a ``VLAN`` sub-interface of the physical device.

The following options are used to configure the plugin:

``name`` (string, required)
    The name of the network.

``type`` (string, required)
    ``vlan``

``master`` (string, required)
    The name of the host interface to use. Default: default route interface.

``vlanId`` (integer, required)
    Id of the |VLAN|.

``mtu`` (integer, optional)
    Explicitly set |MTU| to the specified value. Default: chosen by the kernel.

``ipam`` (dictionary, required)
    |IPAM| configuration to be used for this network.  For an interface without
    an IP address, use an empty dictionary.

The following example creates a pod containing an additional network
interface corresponding to a |VLAN| interface.  There is no need to apply the
``vlan`` tag in the container.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: vlan0
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "vlan0",
         "type": "vlan",
         "master": "eth1001",
         "vlanId": 100,
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
     name: vlanpod0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "vlan0" }
       ]'
   spec:
     containers:
     - name: vlan0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]