.. _bridge-plugin-7caa94024df4:

=============
Bridge Plugin
=============

The bridge plugin allows a virtual device to be created in the container that
is attached via a ``veth`` pair to a bridge on the host.  If the bridge is not
already present, it will be created.  This way, multiple pods on the same host
can achieve connectivity with each other.

The following options are used to configure the plugin:

``name`` (string, required)
    The name of the network.

``type`` (string, required)
    ``bridge``

``bridge`` (string, optional)
    The name of the bridge to use/create. Default: ``cni0``.

``isGateway`` (boolean, optional)
    Assign an IP address to the bridge. Default: ``false``.

``isDefaultGateway`` (boolean, optional)
    Sets isGateway to true and makes the assigned IP the default route.
    Default: ``false``.

``forceAddress`` (boolean, optional)
    Indicates if a new IP address should be set if the previous value has been
    changed. Default: false.

``ipMasq`` (boolean, optional)
    set up IP Masquerade on the host for traffic originating from this network
    and destined outside of it. Default: ``false``.

``mtu`` (integer, optional)
    Set the |MTU| to the specified value. Default: chosen by the kernel.

``hairpinMode`` (boolean, optional)
    Set the hairpin mode for interfaces on the bridge. Default: ``false``.

``ipam`` (dictionary, required)
    The |IPAM| configuration to be used for this network. For an L2-only
    network, create empty dictionary.

``promiscMode`` (boolean, optional)
    Set promiscuous mode on the bridge. Default: ``false``.

``macspoofchk`` (boolean, optional)
    Limits the traffic originating from the container to the |MAC| address of
    the interface. Default: ``false``.


.. rubric:: |eg|

The following example creates a pod containing an additional network
interface corresponding to a bridge device ``mybr0``.

.. code-block:: yaml

   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bridge0
   spec:
     config: '{
         "cniVersion": "0.3.1",
         "name": "bridgenet",
         "type": "bridge",
         "bridge": "mybr0",
         "mtu": 1500,
         "promiscMode": false,
         "isGateway": false,
         "ipam": {
             "type": "host-local",
             "subnet": "10.10.10.0/24"
         }
       }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: bridgepod1
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
               { "name": "bridge0" }
       ]'
   spec:
     containers:
     - name: bridge0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
