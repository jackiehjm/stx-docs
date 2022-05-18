
.. fyl1552681364538
.. _use-uefi-secure-boot:

====================
Use UEFI Secure Boot
====================

Secure Boot is supported in |UEFI| installations only. It is not used when
booting |prod| as a legacy boot target.

|prod| currently does not support switching from legacy to UEFI mode after a
system has been installed. Doing so requires a reinstall of the system. This
also means that upgrading from a legacy install to a secure boot install
\(UEFI\) is not supported.

When upgrading a |prod| system from a version which does not support secure
boot to a version that does, do not enable secure boot in |UEFI| firmware until
the upgrade is complete.

For each node that is going to use secure boot, you must populate the |prod|
public certificate/key in the |UEFI| Secure Boot authorized database in
accordance with the board manufacturer's process. This must be done for each
node before starting installation.

You may need to work with your hardware vendor to have the certificate
installed.

There is often an option in the UEFI setup utility which allows a user to
browse to a file containing a certificate to be loaded in the authorized
database. This option may be hidden in the UEFI setup utility unless UEFI
mode is enabled, and secure boot is enabled.

Many motherboards ship with Microsoft secure boot certificates
pre-programmed in the |UEFI| certificate database. These certificates may be
required to boot |UEFI| drivers for video cards, RAID controllers, or NICs
\(for example, the |PXE| boot software for a NIC may have been signed by a
Microsoft certificate\). While certificates can usually be removed from the
certificate database \(again, this is UEFI implementation specific\) it
may be required that you keep the Microsoft certificates to allow for
complete system operation.

Mixed combinations of secure boot and non-secure boot nodes are supported.
For example, a controller node may secure boot, while a worker node may not.
Secure boot must be enabled in the |UEFI| firmware of each node for that node
to be protected by secure boot.

