
.. zrf1552681385017
.. _overview-of-uefi-secure-boot:

============================
Overview of UEFI Secure Boot
============================

Secure Boot is an optional capability of |UEFI| firmware.

Secure Boot is a technology where the system firmware checks that the system
boot loader is signed with a cryptographic key authorized by a database
contained in the firmware or a security device.

|prod|'s implementation of Secure Boot also validates the signature of the
second-stage boot loader, the kernel, and kernel modules.

|prod|'s public key, for programming in the hardware's Secure Boot database,
can be found in the |prod| ISO.

