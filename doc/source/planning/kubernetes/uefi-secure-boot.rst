
.. avv1595963682527
.. _uefi-secure-boot:

================
UEFI Secure Boot
================

Secure Boot is a technology where the system firmware checks that the
system boot loader is signed with a cryptographic key authorized by a
configured database of certificate\(s) contained in the firmware or a
security device. It is used to secure various boot stages.

|prod|'s implementation of Secure Boot also validates the signature of the
second-stage boot loader, the kernel, and kernel modules.

Operational complexity:

.. _uefi-secure-boot-ul-cfz-cvf-mmb:

-   For each node that is going to use secure boot, you must populate the
    |prod| public certificate (with public key) in the |UEFI| Secure Boot
    authorized database in accordance with the board manufacturer's process.

-   You may need to work with your hardware vendor to have the certificate
    installed.

-   This must be done for each node before starting the installation.

For more information, see the section :ref:`UEFI Secure Boot
<overview-of-uefi-secure-boot>`.

