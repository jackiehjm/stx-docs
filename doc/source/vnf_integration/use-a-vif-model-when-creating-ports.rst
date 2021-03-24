
.. pey1602790994826
.. _use-a-vif-model-when-creating-ports:

=====================================
Using a VIF Model when Creating Ports
=====================================

For any non Virtio |NIC|, you must create a port beforehand using the VIF
model.

For example, to set up two |AVPs|, the heat template's binding:profile
would contain definitions similar to the following.

.. code-block:: yaml

       port_tenant_net_tenant1_avp:
          type: OS::Neutron::Port
          properties:
             name: heat_port_port-tenant-net-tenant1-avp
             network: tenant1-net1
             value_specs: {"binding:profile": {"vif_model":"avp"}}

       port_internal_net_tenant1_avp:
          type: OS::Neutron::Port
          properties:
             name: heat_port_port-internal-net-tenant1-avp
             network: internal0-net1
             value_specs: {"binding:profile": {"vif_model":"avp"}}

       tenant1_avp:
          type: OS::Nova::Server
          properties:
            name: tenant1-avp4
            flavor: small
            block_device_mapping:
            - {device_name: vda, volume_id: { get_resource: vol_tenant1_avp } }
            networks:
            - {network: tenant1-mgmt-net}
            - {port: { get_resource: port_tenant_net_tenant1_avp } }
            - {port: { get_resource: port_internal_net_tenant1_avp } }


Alternatively, you can use the command line. For example:

.. code-block:: none

    ~(keystone_admin)$ openstack port create --network ${NETWORKID} --binding-profile vif_model=${VIF_MODEL} ${NAME}

For more information about port related commands, see
`https://docs.openstack.org/python-openstackclient/train/cli/command-objects/
port.html
<https://docs.openstack.org/python-openstackclient/train/cli/command-objects/
port.html>`__.

