=====================================
Host FPGA Configuration - Intel N3000
=====================================

.. note::

   This guide was replaced by: :ref:`N3000 FPGA Overview <n3000-overview>`

This guide describes how to configure and integrate an Intel N3000 |FPGA|
|PAC| on StarlingX.

.. contents:: |minitoc|
   :local:
   :depth: 1

--------
Overview
--------

The `Intel FPGA PAC N3000 <https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/intel-fpga-pac-n3000/overview.html>`_ contains two Intel
XL710 |NICs|, memory, and an Intel |FPGA|. The system discovers and inventories the
device as a |NIC|, with the XL710 ports available in the host port list and host
interface list.

--------------------
Update device images
--------------------

The Intel |FPGA| |PAC| N3000 as shipped from the factory is expected to have
production BMC and factory images. The following procedure describes how to
update the user image on a host.

Device image types:

*   root-key:  The root-key image sets the main authentication key on the
    hardware.

*   functional-key:  The functional device image performs the desired work on
    behalf of the application. If a rootkey device image has been written to the
    hardware, then the functional image will only be accepted if it has been
    signed by a |CSK| generated from the root key which has
    not been revoked.

*   key-revocation:  The key-revocation device image will revoke a |CSK|. If a
    root-key device image has been written to the hardware, then the
    key-revocation device image will only be accepted if it has been signed by
    the root key.

The following items are specific to the Intel |FPGA| |PAC| N3000:

*   The root-key image is called the *root entry hash bitstream* and can only be
    set once.
*   The functional device image is known as the *user image*.
*   The key-revocation device image is known as the *CSK ID cancellation
    bitstream*.
*   |CSKs| are revoked by specifying an integer |CSK| ID.
*   128 |CSK| ID cancellation slots exist.


For the Intel |FPGA| |PAC| N3000, a |CSK| is revoked by specifying an integer
ID, and all |CSKs| with that ID will be revoked. Writing the root-key device
image or a key-revocation device image is essentially permanent. Reverting to
factory status requires physical access to the card and specialized equipment.

#.  Upload the device image.

    To upload a root-key device image:

    .. code-block:: none

        ~(keystone_admin)$ system device-image-upload imagefile root-key pci_vendor
        pci_device --key-signature key_signature --name imagename --description
        description --image-version version

    To upload a functional device image:

    .. code-block:: none

        ~(keystone_admin)$ system device-image-upload imagefile functional pci_vendor
        pci_device --functional bitstream_id --name imagename --description description
        -image-version version

    To upload a revocation key device image:

    .. code-block:: none

        ~(keystone_admin)$ system device-image-upload imagefile key-revocation
        pci_vendor pci_device --revoke-key-id revoke_key_id --name imagename --
        description description --image-version version

    where:

    .. code-block:: none

        imagefile       # The filepath of the binary device image file.
        pci_vendor      # The hexadecimal string identifying the PCI vendor ID of the device this image applies to.
        pci_device      # The hexadecimal string identifying the PCI device ID of the device this image applies to.
        key_signature   # A hexadecimal string identifying the root key device image.
        revoke_key_id   # A decimal key ID for the key revocation device image.
        bitstream_id    # A hexadecimal string of the functional device image.
        name            # The name of the device image (optional).
        description     # The description of the device image (optional).
        image-version   # The version of the device image (optional).

#.  Assign a device label to the device.

    Labels are key-value pairs that are assigned to host |PCI| devices and are
    used to specify attributes of the devices. Labels can be used to identify
    certain properties of the |PCI| devices where the same device image can be
    used.

    The command syntax is:

    .. code-block:: none

        system host-device-label-assign [--overwrite] hostname_or_id pci_name_or_address
        name=value [name=value ...]

    Overwrite the label using the ``--overwrite`` option. This option is not
    allowed while the image update is in progress after running
    ``host-device-image-update``. Once assigned, a device label can be
    referenced by multiple ``device-image-apply`` commands.

#.  Apply the device image on one or all supported devices.

    .. note::

            A device firmware update in progress alarm is raised once the first
            device image is applied.

    The ``system device-image-state-list`` will show the status of the device as
    pending.

    *   Apply a device image to all supported devices:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-apply image_uuid

    *   Alternatively, apply a device image to devices with a specified label:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-apply image_uuid key1=value1

#.  Write pending device images on the host to hardware.

    .. code-block:: none

        ~(keystone)admin)$ system host-device-image-update hostname

    .. note::

            This operation currently supports one pending device image at a time.

    Any previously-attempted device image writes for this host that are in a
    failed state will be reset to pending and retried.

    Root and revocation key updates can be expected to take 1-2 minutes.

    Functional image updates can take approximately 40 minutes for the Intel
    |FPGA| |PAC| N3000.

    *   Once a device update is complete, ``system device-image-state-list``
        will show the status as completed for that device/image.

    *   Once all pending device updates for the host are complete,
        ``system host-show hostname`` will again display an empty string for
        ``device_image_update``.

#.  Lock and unlock the host.

#.  (Optional) Upload, apply, and update any additional key-revocation device
    images or functional device images as needed.

    New device images can be uploaded as needed, and already-uploaded images
    can be applied with new labels. Devices can also have new labels applied to
    them, and any device images with matching labels will be automatically
    applied.

--------------------------
Device management commands
--------------------------

This section lists the commands used to control the Intel |FPGA| |PAC| N3000.

.. code-block:: none

    Listing uploaded device images
        system device-image-list

    Listing device labels
        system host-device-label-list hostname_or_id devicename_or_address

    Removing device labels
        system host-device-label-remove hostname_or_id key

    Remove a device image
        To remove a device image from all devices
            system device-image-remove image_uuid
        To remove the device image from all devices with a matching label
            system device-image-remove image_uuid key1=value1

    Initiating a Device Image Update for a Host
        system host-device-image-update hostname_or_host_ID

    Displaying the status of device images
        system device-image-state-list

-------------------------------
Enable Forward Error Correction
-------------------------------

The Intel |FPGA| |PAC| N3000 supports |FEC| capabilities, which are exposed as
a |PCI| device. The |PCI| device can be used by a `DPDK
<https://www.dpdk.org/>`_ enabled container application to perform accelerated
5G LDPC encoding and decoding operations.

After the |FPGA| device is programmed, the list of host devices shows the |FEC|
device with device ID 0xd8f, as shown below.

.. code-block:: none

    system host-device-list <worker-node>

    +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+
    | name             | address      | class id | vendor id | device id | class name                | vendor name             | device name                         | numa_node | enabled |
    +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+
    | pci_0000_b7_00_0 | 0000:b7:00.0 | 120000   | 8086      | 0d8f      | Processing accelerators   | Intel Corporation       | Device 0d8f                         | 1         | True    |
    +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+
    ...

To enable the |FEC| device for |SRIOV|, set the number of |VFs| and set the
appropriate userspace drivers for the |PF| and |VF|.

For example:

.. code-block:: none

    system host-lock <worker>
    system host-device-modify <worker> <name> --driver <vf driver> --vf-driver <vf driver> -N <number of vfs>
    system host-unlock <worker>

    The supported PF driver(s) are:
    - igb_uio

    The supported VF driver(s) are currently:
    - igb_uio
    - vfio

To pass the |FEC| device to a container, enter the following requests/limits
into the pod specification:

.. code-block:: none

    intel.com/intel_fpga_fec: '<number of vfs>'

For example:

.. code-block:: none

    apiVersion: v1
    kind: Pod
    metadata:
      name: 5gnr
      annotations:
        k8s.v1.cni.cncf.io/networks: '[
                { "name": "sriov1" }
        ]'
    spec:
      restartPolicy: Never
      containers:
      - name: 5gnr
        image: "5gnr-image"
        volumeMounts:
        - mountPath: /mnt/huge-1048576kB
          name: hugepage
        stdin: true
        tty: true
        resources:
          requests:
            memory: 4Gi
            intel.com/intel_fpga_fec: '1'
            intel.com/pci_sriov_net_datanetwork_a: '1'
          limits:
            hugepages-1Gi: 4Gi
            memory: 4Gi
            intel.com/intel_fpga_fec: '1'
            intel.com/pci_sriov_net_datanetwork_a: '1'
      volumes:
      - name: hugepage
        emptyDir:
          medium: HugePages

-------------------------
Configure NICs for SR-IOV
-------------------------

You can configure the Intel XL710 NICs for |SRIOV| by first identifying the
|NICs| on the Intel |FPGA| |PAC| N3000 using the following command:

.. code-block:: none

    system host-port-list <worker>

    +--------------------------------------+------------+----------+--------------+--------+-----------+-------------+------------------------------------------------+
    | uuid                                 | name       | type     | pci address  | device | processor | accelerated | device type                                    |
    +--------------------------------------+------------+----------+--------------+--------+-----------+-------------+------------------------------------------------+
    | 6c79c0d0-0463-4551-a19a-24d52a9403c6 | enp177s0f0 | ethernet | 0000:b1:00.0 | 0      | 1         | False       | Device [0d58]                                  |
    +--------------------------------------+------------+----------+--------------+--------+-----------+-------------+------------------------------------------------+
    ...

Next, set the number of |VFs| and set the appropriate
userspace drivers for the |VF|.

For example:

.. code-block:: none

    system host-lock <worker>
    system host-if-list -a <worker>
    system host-if-modify <worker> <interface name or uuid> -c pci-sriov --vf-driver <vf driver> -N <number of vfs>
    system interface-datanetwork-assign <worker> <interface> <datanetwork>
    system host-unlock <worker>

    The supported VF driver(s) are currently:
    - vfio
    - netdevice

.. note::

    If ``--vf-driver`` is not specified in the ``system host-if-modify``
    command, then ``netdevice`` (kernel driver) will be assigned.
