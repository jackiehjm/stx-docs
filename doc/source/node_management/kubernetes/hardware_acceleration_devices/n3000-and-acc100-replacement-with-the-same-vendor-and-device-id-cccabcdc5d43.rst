
.. _n3000-and-acc100-replacement-with-the-same-vendor-and-device-id-cccabcdc5d43:

===========================================================
Replace N3000 and ACC100 with the same vendor and device-id
===========================================================

The following procedure allows the replacement of an N3000 or ACC100 device on
a host, without requiring a host or system (in case of |AIO-SX|) re-install and
re-configuration, in the case of the replaced device having the same vendor and
device ID information.

The normal approach to doing such a change would be to do a ``system
host-delete``, a ``system host-add`` (re-install) and a re-configure of the
host. In the case of an |AIO-SX| deployment, with only one host, this would
result in a full system re-install and full system re-configuration.

Since this procedure reuses the same vendor and device ID information and
capabilities, the current |FEC| device database will be used internally, and no
reconfiguration is required if the replacement will be done on the same |PCI|
slot of the previous card.

.. rubric:: |prereq|

For information on replacing an N3000 or ACC100 with a different model, see
:ref:`fec-replacement-with-different-vendor-or-device-id-b1ab1440e15f`.


.. warning::

   Vendors may issue updated hardware with the same model, but with changed IDs
   and/or capabilities. You must verify that |PCI| ID and capabilities are the
   same before proceeding or you may be forced to perform a reinstallation.



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

