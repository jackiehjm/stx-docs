.. _ipvlan-plugin-150be92d0538:

=============
Ipvlan Plugin
=============

The Ipvlan plugin allows a virtual device that shares the physical capabilities
and connectivity of a device on the host to be created in the container. The
virtual device will have the same |MAC| address as the physical device.  The
kernel directs traffic to and from the virtualized device based on the IP
address.

The following options are used to configure the plugin:

``name`` (string, required)
   The name of the network.

``type`` (string, required)
   ``ipvlan``

``master`` (string, optional)
   The name of the host interface to use. Default: the default route interface.

``mode`` (string, optional)
  One of ``l2``, ``l3``, ``l3s``. Default: ``l2``.

``mtu`` (integer, optional)
   Set the |MTU| to the specified value. Default: chosen by the kernel.

``ipam`` (dictionary, required unless chained)
   The |IPAM| configuration to be used for this network.

.. rubric:: |eg|

The following example would create a pod which contains an additional network
interface corresponding to an ``ipvlan`` device which uses the ``eth1000``
interface on
the host:

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: ipvlan0
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "ipvlan0",
         "type": "ipvlan",
         "master": "eth1000",
         "mode": "l2",
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
     name: ipvpod0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "ipvlan0" }
       ]'
   spec:
     containers:
     - name: ipv0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
