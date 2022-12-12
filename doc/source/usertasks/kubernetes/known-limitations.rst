
.. ihj1591797204756
.. _known-limitations:

================================
Known Kata Container Limitations
================================

.. note::

    Kata Containers will not be supported in |prod-long| |prod-ver|.

This section describes the known limitations when using Kata containers.

.. _known-limitations-section-tsh-tl1-zlb:

--------------
SR-IOV Support
--------------

A minimal **kernel** and **rootfs** for Kata containers are shipped with
|prod-long|, and are present at /usr/share/kata-containers/. To enable certain
kernel features such as :abbr:`IOMMU (I/O memory management unit)`, and desired
network kernel modules, a custom kernel image, and rootfs has to be built. For
more information, see `https://katacontainers.io/
<https://katacontainers.io/>`__.

.. _known-limitations-section-ngp-ty3-bmb:

-------------------
CPU Manager Support
-------------------

Kata containers currently occupy only the platform cores. There is no
:abbr:`CPU (Central Processing Unit)` manager support.

.. _known-limitations-section-wcd-xy3-bmb:

---------
Hugepages
---------

.. _known-limitations-ul-uhz-xy3-bmb:

-   Similar to the SR-IOV limitation, hugepage support must be configured in a
    custom Kata kernel.

-   The size and number of hugepages must be written using the
    :command:`io.katacontainers.config.hypervisor.kernel\_params` annotation.

-   Creating a **hugetlbfs** mount for hugepages in the Kata container is
    specific to the end user application.
