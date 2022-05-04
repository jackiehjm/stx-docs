.. _host-device-plugin-714d4862a825:

==================
Host-device Plugin
==================

The host-device plugin allows a device on the host to be moved into the
container namespace as an additional interface.  The device can be specified
with one of the following parameters:

``device`` (string)
   The device name.

``hwaddr`` (string)
   The |MAC| address of the device.

``kernelpath`` (string)
   The kernel device ``kobj``. For example:
   ``/sys/devices/pci0000:00/0000:00:1f.6``

``pciBusID`` (string)
   The |PCI| address of network device. For example, ``0000:00:1f.6``

.. rubric:: |eg|

The following example would create a pod which contains an additional network
interface corresponding to the ``eth1000`` device:

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: hd0
   spec:
     config: '{
       "cniVersion": "0.3.1",
       "name": "hd0",
       "type": "host-device",
       "device": "eth1000"
     }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: hdpod0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "hd0" }
       ]'
   spec:
     containers:
     - name: hdpod0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
