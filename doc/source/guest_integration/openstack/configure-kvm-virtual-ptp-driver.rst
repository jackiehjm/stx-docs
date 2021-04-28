
.. hdw1619620921761
.. _configure-kvm-virtual-ptp-driver:

================================
Configure KVM Virtual PTP Driver
================================

The |KVM| virtual |PTP| driver allows guests to sync the |VM| reference clock
to the host's high precision PTP clock reference.

.. rubric:: |prereq|

|PTP| must be enabled on |prod| in order to use the |KVM| virtual |PTP|
driver in guest |VMs|.

To leverage |PTP| in a |VM| and sync the |VM| reference clock with the
hosting compute or |AIO|-controller node, do the following in the |VM|:

.. rubric:: |proc|

#.  Load the |KVM| |PTP| driver:

    .. code-block:: none

        ~(keystone_admin)$ modprobe kvm_ptp

#.  Update the reference clock in the chrony config file \(/etc/chrony.conf\):

    .. code-block:: none

        ~(keystone_admin)$ refclock PHC /dev/ptp0 poll 3 dpoll -2 offset 0

#.  Restart the chronyd service:

    .. code-block:: none

        ~(keystone_admin)$ systemctl restart chronyd.service

#.  Confirm that the |PTP| device is in the list of time sources:

    .. code-block:: none

        ~(keystone_admin)$ systemctl restart chronyd.service


