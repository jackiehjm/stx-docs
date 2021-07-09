

.. _configure-pci-passthrough-interface-to-nvidia-gpu:

=========================================================
Configure PCI-Passthrough Interface to NVIDIA GPU in a VM
=========================================================

This section provides instructions for configuring PCI-Passthrough interface
to NVIDIA GPU Operator in a |VM|.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)$

#.  Lock controller-0 to enable the NVIDIA GPU device.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

    #.  Verify that the NVIDIA GPU device is available in the table.

        .. code-block:: none

            ~(keystone_admin)$ system host-device-list controller-0 -a


    #.  Enable the NVIDIA GPU device.

        .. code-block:: none

            ~(keystone_admin)$ system host-device-modify controller-0 <gpu_pci_address> --enable=True


#.  Unlock controller-0 to enable the NVIDIA GPU device.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0


#.  Add the NVIDIA GPU device information to the Nova overrides.

    #.  Check the Nova Helm overrides.

        .. parsed-literal::

            ~(keystone_admin)$ system helm-override-show |prefix|-openstack nova openstack

    #.  Check the **conf.nova.pci.alias.values** override. If your graphics
        card alias exists, for example, **"name": "nvidia-tesla-t4-vf"**,
        check if the values in step, 2.b., are correct and proceed to step 5.
        If the values do not exist or are incorrect, update the Nova Helm
        overrides.

        #.  Create a file containing the current **conf.nova.pci.alias.values**
            overrides and add the following additional entry in the values
            array for the NVIDIA device based on the values from step 2.b.,
            for example:

            .. code-block:: none

                '{"vendor_id": *<vendor_id>*, "product_id": *<product_id>*, "device_type": "type-PF", "name": "nvidia-tesla-t4-pf"}'

            Where

            *<vendor_id>* is the ID of the vendor

            *<product_id>* is the ID of the product

        #.  Save the **.yaml** file.

            .. code-block:: none

                conf:
                  nova:
                    pci:
                      alias:
                        values: ['{"vendor_id": "8086", "product_id": "0435", "name": "qat-dh895xcc-pf"}', '{"vendor_id": "8086", "product_id": "0443", "name": "qat-dh895xcc-vf"}', '{"vendor_id": "8086", "product_id": "37c8", "name": "qat-c62x-pf"}', '{"vendor_id": "8086", "product_id": "37c9", "name": "qat-c62x-vf"}', '{"name": "gpu"}', '{"vendor_id": "102b", "product_id": "0522", "name": "matrox-g200e"}', '{"vendor_id": "10de", "product_id": "13f2", "name": "nvidia-tesla-m60"}', '{"vendor_id": "10de", "product_id": "1b38", "name": "nvidia-tesla-p40"}', '{"vendor_id": "10de", "product_id": "1eb8", "device_type": "type-PF", "name": "nvidia-tesla-t4-pf"}']

        #.  Upload the **.yaml** file to the platform and apply it.

            .. parsed-literal::

                ~(keystone_admin)$ system helm-override-update |prefix|-openstack nova openstack --reuse-values --values=your-override-file.yaml

        #.  Apply the changes.

            .. parsed-literal::

                    ~(keystone_admin)$ system application-apply |prefix|-openstack

#.  In OpenStack, add a new flavor for the NVIDIA GPU device, for example.

    .. code-block:: none

        # setup admin credentials for the containerized openstack application
        $ source /etc/platform/openrc
        ~(keystone_admin)$ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
        # create new flavor with pci_passthrough:alias for nvidia device
        ~(keystone_admin)$ openstack flavor create --ram 8192 --vcpus 4 nvidiaT4gpu_8GB_v3 --property "pci_passthrough:alias"="nvidia-tesla-t4-pf:1" --property "hw:mem_page_size"="large"

    .. note::
        8 GB RAM, 4 VCPUs, and large memory page size are example values
        for GPU drivers' system requirements. For valid system requirements for
        GPU drivers, see, `https://www.nvidia.com/en-us/geforce/drivers/ <https://www.nvidia.com/en-us/geforce/drivers/>`__.


#.  In OpenStack, create a |VM| and test access to the NVIDIA GPU device.

    #.  Create a new |VM|, using the newly created flavor in step 5.

    #.  In the |VM|, install and test the CUDA drivers.
        See, `https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html <https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html>`__.
