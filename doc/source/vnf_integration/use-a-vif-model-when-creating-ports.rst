
.. pey1602790994826
.. _use-a-vif-model-when-creating-ports:

=====================================
Using a VIF Model when Creating Ports
=====================================

For any non Virtio |NIC|, you must create a port beforehand using the VIF
model.

You can use the command line. For example:

.. code-block:: none

    ~(keystone_admin)$ openstack port create --network ${NETWORKID} --binding-profile vif_model=${VIF_MODEL} ${NAME}

For more information about port related commands, see
`https://docs.openstack.org/python-openstackclient/train/cli/command-objects/
port.html
<https://docs.openstack.org/python-openstackclient/train/cli/command-objects/
port.html>`__.

.. only:: partner

   .. include:: ../_includes/use-a-vif-model-when-creating-ports.rest
