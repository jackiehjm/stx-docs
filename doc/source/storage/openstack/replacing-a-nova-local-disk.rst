
.. tjr1539798511628
.. _replacing-a-nova-local-disk:

===========================
Replace a Nova-Local Disk
===========================

You can replace failed nova-local disks on compute nodes.

.. rubric:: |context|

To replace a nova-local storage disk on a compute node, follow the instructions
in Cloud Platform Node Management: :ref:`Changing Hardware Components for a
Worker Host <changing-hardware-components-for-a-worker-host>`.

To avoid reconfiguration, ensure that the replacement disk is assigned to the
same location on the host, and is the same size as the original. The new disk
is automatically provisioned for nova-local storage based on the existing
system configuration.

