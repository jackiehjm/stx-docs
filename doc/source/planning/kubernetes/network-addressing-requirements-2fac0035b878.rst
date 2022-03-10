
.. zff1612526659434
.. _network-addressing-requirements-2fac0035b878:

===============================
Network Addressing Requirements
===============================

Network addressing requirements must be taken into consideration when planning
a |prod-long| installation.


.. _minimum_subnet_sizes-simpletable-kfn-qwk-nx:

.. list-table:: IPv4 Network Addressing Requirements
   :header-rows: 1
   :stub-columns: 1

   * - Network
     - Recommended Prefix Length
     - Minimum Hosts
     - Maximum Hosts
     - Example
   * - oam
     - 24
     - 3
     - 2\ :superscript:`24`
     - 10.10.10.0/24
   * - pxeboot
     - 24
     - 3
     - 2\ :superscript:`24`
     - 169.254.202.0/24
   * - management
     - 24
     - 4
     - 2\ :superscript:`24`
     - 192.168.204.0/24
   * - multicast
     - 28
     - 4
     - 2\ :superscript:`8`
     - 239.1.1.0/28
   * - cluster-host
     - 24
     - 3
     - 2\ :superscript:`24`
     - 192.168.206.0/24
   * - cluster-pod
     - 16
     - 65536
     - 2\ :superscript:`24`
     - 172.16.0.0/16
   * - cluster-service
     - 12
     - 65536
     - 2\ :superscript:`20`
     - 10.96.0.0/12

.. list-table:: IPv6 Network Addressing Requirements
   :header-rows: 1
   :stub-columns: 1

   * - Network
     - Recommended Prefix Length
     - Minimum Hosts
     - Maximum Hosts
     - Example
   * - oam
     - 64
     - 3
     - 2\ :superscript:`64`
     - 2001:db8:1::/64
   * - management
     - 64
     - 4
     - 2\ :superscript:`64`
     - 2001:db8:2::/64
   * - multicast
     - 124
     - 4
     - 2\ :superscript:`8`
     - ff08::1:1:0/124
   * - cluster-host
     - 64
     - 3
     - 2\ :superscript:`64`
     - 2001:db8:3::/64
   * - cluster-pod
     - 64
     - 65536
     - 2\ :superscript:`64`
     - 2001:db8:4::/64
   * - cluster-service
     - 112
     - 65536
     - 2\ :superscript:`20`
     - 2001:db8:5::/112

