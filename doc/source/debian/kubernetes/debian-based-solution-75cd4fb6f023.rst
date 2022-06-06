.. _debian-based-solution-75cd4fb6f023:

=====================
Debian-based Solution
=====================

Major features of Debian-based |prod| will include:

*  Linux 5.10 Yocto-based kernel ( https://www.yoctoproject.org/ )

   The Yocto Project Kernel:

   * tracks stable kernel updates very closely; staying very current with the
     stable kernel,

   * provides a reliable implementation of the pre-empt-rt patchset (see:
     https://rt.wiki.kernel.org/index.php/Main_Page), and

   * provides predictable and searchable |CVE| handling.

|org| will also leverage its existing relationships with the Yocto Project to
enhance development, bug fixes and other activities in the Yocto Project kernel
to drive |prod| quality and feature content.

*   Debian Bullseye (11.3)

    Debian is a well-established Linux Distribution supported by a large and
    mature open-source community.

*   OSTree ( https://ostree.readthedocs.io/en/stable/manual/introduction/ )

    OSTree provides for robust and efficient versioning, packaging and
    upgrading of Linux-based systems.

*   An updated Installer to seamlessly adapt to Debian and OSTree

*   Updated software patching and upgrades for Debian and OSTree.


.. include:: /_includes/deb-tech-preview.rest
    :start-after: begin-prod-an-2
    :end-before: end-prod-an-2
