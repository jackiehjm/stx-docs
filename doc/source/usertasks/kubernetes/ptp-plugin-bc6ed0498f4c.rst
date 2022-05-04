.. _ptp-plugin-bc6ed0498f4c:

=====================
Point-to-Point Plugin
=====================

The |PTP| plugin allows a virtual device that is attached to a virtual
interface in the host to be created in the container.

The following options are used to configure the plugin:

``name`` (string, required)
    The name of the network.

``type`` (string, required)
    ``ptp``

``ipMasq`` (boolean, optional)
    Set up IP Masquerade on the host for traffic originating from the IP
    address of this network and destined outside of this network. Default:
    false.

``mtu`` (integer, optional)
    Set the |MTU| to the specified value. Default: chosen by the kernel.

``ipam`` (dictionary, required)
    The |IPAM| configuration to be used for this network.  For an interface
    without an IP address, use an empty dictionary.


.. rubric:: |eg|

The following example creates a pod containing an additional network
interface corresponding to a point-to-point interface.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: ptp0
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "ptp0",
         "type": "ptp",
         "ipam": {
             "type": "static",
             "addresses": [
                 {
                     "address": "10.10.10.2/24",
                     "gateway": "10.10.10.1"
                 }
             ]
         }
       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: ptppod0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "ptp0" }
       ]'
   spec:
     containers:
     - name: ptp1
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]