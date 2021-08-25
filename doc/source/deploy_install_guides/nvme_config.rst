.. _nvme_config:

====================================
Configure NVMe Drive as Primary Disk
====================================

To use a :abbr:`Non-Volatile Memory Express (NVMe)` drive as the primary disk for
any of your nodes, you must configure your host and adjust kernel parameters
during installation:

#. Configure the host to be in UEFI mode.

#. Edit the kernel boot parameter.

   After you are presented with the StarlingX ISO boot options and have selected
   the preferred installation option (for example Standard Configuration or
   All-in-One Controller Configuration), press the TAB key to edit the kernel
   boot parameters.

   Modify the **boot_device** and **rootfs_device** from the default **sda** so
   that it is the correct device name for the NVMe drive (for example "nvme0n1").

   ::

     vmlinuz rootwait console=tty0 inst.text inst.stage2=hd:LABEL=oe_iso_boot
     inst.ks=hd:LABEL=oe_iso_boot:/smallsystem_ks.cfg boot_device=nvme0n1
     rootfs_device=nvme0n1 biosdevname=0 usbcore.autosuspend=-1 inst.gpt
     security_profile=standard user_namespace.enable=1 initrd=initrd.img
