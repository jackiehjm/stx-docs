.. _n3000-and-acc100-replacement-with-the-same-vendor-and-device-id-cccabcdc5d43:

===============================================================
N3000 and ACC100 replacement with the same vendor and device-id
===============================================================

The following procedure allows the replacement of a N3000 or ACC100 device on a
host, without requiring a host or system (in case of |AIO-SX|) re-install and
re-configuration, in the case of the replaced device having the same vendor and
device id info.

The normal approach to doing such a change would be to do a ``system
host-delete``, a ``system host-add`` (re-install) and a re-configure of the
host. In the case of an |AIO-SX| deployment, with only one host, this would
result in a full system re-install and full system re-configuration.

.. note::
    The N3000 card comes with both NIC and |FEC| functionality and requires the
    procedure to be done for both types.

.. rubric:: |prereq|

The vendor and device-id of currently installed |PCI| card can be
obtained with:

.. code-block:: none

   (keystone_admin)]# system host-port-show <hostname> port-name
   (keystone_admin)]# system host-device-list <hostname>

For information on replacing an N3000 or ACC100 with a different model, see
:ref:`fec-replacement-with-different-vendor-or-device-id-b1ab1440e15f`.

.. rubric:: |proc|

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <hostname>

#.  Power down the host manually and make the N3000 or ACC100 card replacement.

#.  Power up the host.

#.  After rebooting, if the replaced |PCI| card is an N3000 and its |FPGA| was
    not pre-loaded with an updated image, follow the steps described in
    :ref:`index_hardware-acceleration-devices`.

#.  Unlock the host to make it available for use.

    .. code-block:: none

        system host-unlock <hostname>
