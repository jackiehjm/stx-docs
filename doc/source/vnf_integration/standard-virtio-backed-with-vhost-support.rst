
.. gzn1477524672918
.. _standard-virtio-backed-with-vhost-support:

===========================================
Standard Virtio - Backed with Vhost Support
===========================================

Unmodified guests can use Linux networking and virtio drivers. This provides a
mechanism to bring existing applications into the production environment
immediately.

For virtio interfaces, |prod-os| supports vhost-user transparently by default.
This allows QEMU and AVS to share virtio queues through shared memory,
resulting in improved performance over standard virtio. The transparent
implementation provides a simplified alternative to the open-source |AVP|
kernel and |AVP|-|PMD| drivers. For more about these drivers, see
:ref:`Accelerated Virtual Interfaces <accelerated-virtual-interfaces>`. The
availability of vhost-user also offers additional performance enhancements
through optional multi-queue support for virtio interfaces.

