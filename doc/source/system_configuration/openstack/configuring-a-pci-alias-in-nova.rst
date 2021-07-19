
.. zrf1596656450198
.. _configuring-a-pci-alias-in-nova:

=============================
Configure a PCI Alias in Nova
=============================

|PCI| passthrough devices are exposed to |VMs| using system-wide |PCI| alias.

.. rubric:: |context|

Each alias specifies |PCI| matching optional attributes: vendor\_id, product\_id,
and device\_type.

where

**name**
    is a string identifying the |PCI| alias

**device\_id**
    is the device\_id value obtained from the device list

**vendor\_id**
    is the vendor\_id value obtained from the device list

**device\_type**
    is a string indicating the type of |PCI| device to add \(valid values are:
    type-PCI, type-PF, or type-VF\)

The following command displays the current configured |PCI| aliases:

.. code-block:: none

    $ kubectl exec -it -n openstack \
    $(kubectl get pod --selector=application=nova,component=os-api -o name -n openstack) -- grep -e '\[pci\]' -e alias /etc/nova/nova.conf


By default it contains a list of general |PCI| aliases, such as:

.. code-block:: none

    [pci]
    alias = {"vendor_id": "8086", "product_id": "0435", "name": "qat-dh895xcc-pf"}
    alias = {"vendor_id": "8086", "product_id": "0443", "name": "qat-dh895xcc-vf"}
    alias = {"vendor_id": "8086", "product_id": "37c8", "name": "qat-c62x-pf"}
    alias = {"vendor_id": "8086", "product_id": "37c9", "name": "qat-c62x-vf"}
    alias = {"name": "gpu"}

Additional |PCI| aliases may configured using a helm override for nova.

The following example replaces the previous list of |PCI| aliases with a custom
list.

.. rubric:: |proc|

#.  Create a yaml configuration file containing the configuration update.

    .. code-block:: none

        ~(keystone_admin)]$ cat << EOF > ./gpu_override.yaml
        conf:
          nova:
            pci:
              alias:
                type: multistring
                values:
                - '{"vendor_id": "8086", "product_id": "0435", "name":
                  "qat-dh895xcc-pf"}'
                - '{"vendor_id": "8086", "product_id": "0443", "name":
                  "qat-dh895xcc-vf"}'
                - '{"vendor_id": "8086", "product_id": "37c8", "name":
                  "qat-c62x-pf"}'
                - '{"vendor_id": "8086", "product_id": "37c9", "name":
                  "qat-c62x-vf"}'
                - '{"name": "gpu"}'
                - '{"vendor_id": "102b", "product_id": "0522", "name":
                  "matrox-g200e"}'
                - '{"vendor_id": "10de", "product_id": "13f2", "name":
                  "nvidia-tesla-m60"}'
                - '{"vendor_id": "10de", "product_id": "1b38", "name":
                  "nvidia-tesla-p40"}'
                - '{"vendor_id": "10de", "product_id": "1eb8",
                  "device_type":
                  "type-PF", "name": "nvidia-tesla-t4-pf"}'
        EOF

#.  Update the Helm overrides using the new configuration file.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update --reuse-values --values ./gpu_override.yaml |prefix|-openstack nova openstack --reuse-values

#.  Apply the changes.

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack