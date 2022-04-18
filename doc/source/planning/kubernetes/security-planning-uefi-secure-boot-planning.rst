
.. qzw1552672165570
.. _security-planning-uefi-secure-boot-planning:

====================================
Kubernetes UEFI Secure Boot Planning
====================================

|UEFI| Secure Boot Planning allows you to authenticate modules before they are
allowed to execute.

The initial installation of |prod| should be done in |UEFI| mode if you plan on
using the secure boot feature in the future.

The |prod| secure boot certificate can be found in the |prod| ISO, on the EFI
bootable FAT filesystem. The file is in the directory /CERTS. You must add this
certificate database to the motherboard's |UEFI| certificate database. How to
add this certificate to the database is determined by the |UEFI| implementation
provided by the motherboard manufacturer.

You may need to work with your hardware vendor to have the certificate
installed.

There is an option in the |UEFI| setup utility that allows a user to browse to
a file containing a certificate to be loaded in the authorized database. This
option may be hidden in the |UEFI| setup utility unless |UEFI| mode is enabled,
and secure boot is enabled.

Many motherboards ship with Microsoft secure boot certificates pre-programmed
in the |UEFI| certificate database. These certificates may be required to boot
|UEFI| drivers for video cards, |RAID| controllers, or |NICs| \(for example,
the |PXE| boot software for a |NIC| may have been signed by a Microsoft
certificate\). While certificates can be removed from the certificate database
\(this is |UEFI| implementation specific\) it may be required that you keep the
Microsoft certificates to allow for complete system operation.

Mixed combinations of secure boot and non-secure boot nodes are supported. For
example, a controller node may secure boot, while a worker node may not. Secure
boot must be enabled in the |UEFI| firmware of each node for that node to be
protected by secure boot.

.. _security-planning-uefi-secure-boot-planning-ul-h4z-lzg-bjb:

-   Secure Boot is supported in |UEFI| installations only. It is not used when
    booting |prod| as a legacy boot target.

-   |prod| does not currently support switching from legacy to |UEFI| mode
    after a system has been installed. Doing so requires a reinstall of the
    system. This means that upgrading from a legacy install to a secure boot
    install \(|UEFI|\) is not supported.

-   When upgrading a |prod| system from a version that did not support secure
    boot to a version that does, do not enable secure boot in |UEFI| firmware
    until the upgrade is complete.
