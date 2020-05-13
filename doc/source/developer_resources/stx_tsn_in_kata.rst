=============================
Enable TSN in Kata Containers
=============================

.. contents::
   :local:
   :depth: 2

----------
Background
----------

`Time sensitive networking (TSN) <https://1.ieee802.org/tsn/>`_ is a set of
standards developed by the IEEE 802.1 Working Group (WG) with the aim of
guaranteeing determinism in delivering time-sensitive traffic with low and
bounded latency, while allowing non-time-sensitive traffic to be carried through
the same network.

As a cloud infrastructure software stack for the edge, TSN is a very important
feature for StarlingX as the deterministic low latency is required by edge
applications in industrial IOT, video delivery and other ultra-low latency use
cases. Furthermore, TSN support in containers naturally becomes a demand for
StarlingX as StarlingX is a cloud-native platform.

The challenge is some TSN features are only available on Linux from 4.19 or higher
version. StarlingX is built on top of CentOS. As of StarlingX 3.0 release, it is
based on CentOS 7 which provides a Linux 3.10 kernel with some backported patches
(StarlingX CentOS 8 upgrade would be finished by 5.0 release as planned). As
we all know, generic containers share the same kernel with the host.

Fortunately, StarlingX already supported Kata containers on the master branch,
and it will become an officially supported feature from StarlingX 4.0 release.
A Kata container has its own kernel which doesn't depend on the kernel of the
host. Therefore, TSN support in containers on StarlingX starts from Kata
container.

`Kata Containers <https://katacontainers.io/>`_ is an open source project to
build a secure container runtime with lightweight virtual machines that feel
and perform like containers but provide stronger workload isolation using
hardware virtualization technology as a second layer of defense.

-----------------------------------------------------
How to build a Linux kernel with TSN support for Kata
-----------------------------------------------------

As of writing this article, the latest Kata release is Kata 1.11.0-rc0. This
release includes a Linux 5.4.32 kernel image with Kata patches. Though the
kernel version is high enough, TSN features are not fully enabled in the kernel
build. It is needed to build a customized kernel image based on the same
code base. Below is a guide about how to build a customized kernel image for
Kata.

#. Get the ``packaging`` repository of Kata

   ::

     git clone https://github.com/kata-containers/packaging.git

#. Prepare the building environment by executing the command in the directory
   ``packaging/kernel``.

   ::

     ./build-kernel.sh -v 5.4.32 -f -d setup

#. Prepare a kernel config file ``stx.conf`` with TSN-related options enabled
   as shown below, and put it in the directory.
   ``~/go/src/github.com/kata-containers/packaging/kernel/configs/fragments/x86_64``.

   ::

     # qdisc for tsn
     CONFIG_NET_SCH_TAPRIO=y
     CONFIG_NET_SCH_ETF=y
     # I210 adapter driver
     CONFIG_IGB=y
     # ptp
     CONFIG_NET_PTP_CLASSIFY=y
     CONFIG_NETWORK_PHY_TIMESTAMPING=y
     CONFIG_PTP_1588_CLOCK=y
     # vlan
     CONFIG_VLAN_8021Q=y

#. Re-run setup command to update stx.conf to the config

   ::

     ./build-kernel.sh -v 5.4.32 -f -d setup

#. Build the kernel image

   ::

     ./build-kernel.sh -v 5.4.32 -f -d build

#. Install the built kernel images to the destination directory

   ::

     sudo ./build-kernel.sh -v 5.4.32 -f -d install

Once these commands are done, there are two built kernel images
``vmlinux.container`` and ``vmlinuz.container`` available in the directory
``/usr/share/kata-containers``. Save the two files for later use.

---------------------------------------------
How to build a container image with TSN stack
---------------------------------------------

Besides TSN support in the kernel, there are still some packages required to
build TSN stack. For example,
`LinuxPTP <http://linuxptp.sourceforge.net/>`_ is an implementation of
`the Precision Time Protocol (PTP)
<https://en.wikipedia.org/wiki/Precision_Time_Protocol>`_
according to IEEE standard 1588 for Linux.

Here is the dockerfile used to build the container image. ``Ubuntu 20.04`` was
chosen as the base image for packages with newer versions. ``python3-dateutil``,
``python3-numpy``, and ``python3-matplotlib`` were installed for performance
testing. Here the built container image was named as ``kata_tsn_image``.

::

  From ubuntu:20.04
  RUN apt-get update
  RUN apt-get install -y iproute2 net-tools pciutils ethtool \
      linuxptp vlan libjansson4 python3-dateutil python3-numpy \
      python3-matplotlib

-----------------------------------------
How to set up an experimental TSN network
-----------------------------------------

An experimental TSN network as shown in `Figure 1` was set up to verify the TSN
functionality in Kata containers. The network is composed of a switch with
TSN capability and four hosts.

.. figure:: ./figures/stx_tsn_network_diagram.png
    :width: 550px
    :height: 300px
    :align: center

    Figure 1: An Experimental TSN Network

#. The TSN switch is made by a generic PC with a TSN switch card
   `PCIe-0400-TSN <https://www.kontron.com/products/systems/tsn-switches/
   network-interfaces-tsn/pcie-0400-tsn-network-interface-card.html>`_ inserted.
   Please refer to
   `the User Guide of PCIe-0400-TSN
   <https://www.kontron.com/downloads/manuals/
   userguide_pcie-0400-tsn_v0.13.pdf?product=151637>`_
   for detailed configurations.

#. The hosts are four
   `Intel Hades Canyon NUC <https://simplynuc.com/hades-canyon/>`_
   which are equipped with two NICs each. One of the two NICs is
   `Intel I210 NIC <https://ark.intel.com/content/www/us/en/ark/products/series/
   64399/intel-ethernet-controller-i210-series.html>`_
   which has TSN support.

   * ``Node 1`` is the latest StarlingX built from the master branch which
     supports Kata containers. ``Node 1`` will be used as the data sender in the
     later test.

   * ``Node 2``, ``Node 3``, and ``Node 4`` were all installed with
     `Ubuntu 18.04`. ``Node 2`` additionally installed ``LinuxPTP`` which will be
     used as the data receiver. ``Node 3`` and ``Node 4`` will be used to
     send/receive best-effort traffic to stress the TSN network.

------------------------------------------
How to enable and verify TSN functionality
------------------------------------------

Till now, the preparation is done. It is time to enable and verify the TSN
functionality in Kata containers. The whole process can be summarized as three
steps:

#. Perform the time synchronization across the whole TSN network.

#. Create a Kata container with Intel I210 passed into.

#. Make necessary configurations on the Kata container and the TSN switch to
   enable TSN functionality. After that, run some tests to verify the TSN
   functionality.

***********************************************************
Step 1. Perform time synchronization across the TSN network
***********************************************************

Two programs, ``ptp4l`` and ``phc2sys`` coming from the project ``LinuxPTP``
were used to do the job. Here is how the time synchronization was performed on
the TSN network.

.. figure:: ./figures/time_sync_topology.png
    :width: 500px
    :height: 300px
    :align: center

    Figure 2: Time Synchronization Topology

#. Configure NTP servers on the TSN switch and ``Node 1 (StarlingX)`` to
   synchronize their system clocks with the external clock.

#. Launch ``phc2sys`` on the TSN switch to synchronize its PTP clock with its
   system clock.

#. Launch ``ptp4l`` on both the TSN switch and ``Node 2 (Ubuntu)`` to
   synchronize their PTP clocks. The TSN switch's PTP clock was set as the
   master clock by default.

#. Launch ``phc2sys`` on ``Node 2 (Ubuntu)`` to synchronize its system clock
   with its PTP clock.

The time synchronization on the Kata container will be deferred to ``Step 3``.

There is no need to do the time synchronization on ``Node 3`` and ``Node 4``
since they are only used to send/receive best-effort traffic in the experiment.

*****************************************************
Step 2. Launch a Kata container with I210 passed into
*****************************************************

Before creating a Kata container, the two kernel images ``vmlinux.container``
and ``vmlinuz.container`` should be copied to the directory
``/usr/share/kata-containers/`` of ``Node 1 (StarlingX)``.

The I210 NIC on the host needs to be passed into a Kata container. Here is
how to achieve it. More details can be found at
"`How To Pass a Physical NIC Into a Kata Container
<https://github.com/kata-containers/documentation/pull/619/files>`_"

::

  1. Find the pci address of the I210 NIC. Here the pci address is
     "0000:05:00.0" and the ID is "8086:157b" which are used in the
     following steps.
     lspci -nn -D | grep Ethernet
     0000:00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet Connection (2) I219-LM [8086:15b7] (rev 31)
     0000:05:00.0 Ethernet controller [0200]: Intel Corporation I210 Gigabit Network Connection [8086:157b] (rev 03)

  2. export BDF="0000:05:00.0"

  3. readlink -e /sys/bus/pci/devices/$BDF/iommu_group
     /sys/kernel/iommu_groups/16

  4. echo $BDF | sudo tee /sys/bus/pci/devices/$BDF/driver/unbind

  5. sudo modprobe vfio-pci

  6. echo 8086 157b | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id

  7. echo $BDF | sudo tee --append /sys/bus/pci/drivers/vfio-pci/bind

  8. ls -l /dev/vfio
     total 0
     crw------- 1 root root  241,  0 May 18 15:38 16
     crw-rw-rw- 1 root root  10, 196 May 18 15:37 vfio

  9. Edit "the file /usr/share/defaults/kata-containers/configuration.toml" to
     set "hotplug_vfio_on_root_bus" to true.

Once these configurations are done, a Kata container can be created with the
I210 NIC passed into. Assume the name of the container image is
``kata_tsn_image``.

::

  sudo docker run -it -d --runtime=kata-runtime --rm --device \
        /dev/vfio/16 -v /dev:/dev --privileged --name tsn \
        kata_tsn_image /bin/bash

Once it is done, the I210 NIC can be seen in the created container with the name
``eth1``.

***************************************
Step 3. Config and test TSN performance
***************************************

The sample application
`sample-app-taprio
<https://github.com/intel/iotg_tsn_ref_sw/tree/apollolake-i/sample-app-taprio>`_
was used in the test. Minor changes were made on the code to format the
output to adapt to the two tools (``nl-calc`` and ``nl-report``) provided by
the project
`netlatency <https://github.com/kontron/netlatency>`_ to plot the result.

Three test cases were defined in the experiment. Among the three test cases,
``sample-app-taprio`` was running in the Kata container as the data sender and
running on ``Node 2`` as the data receiver. Common configurations for
``sample-app-taprio`` are listed here.

.. csv-table:: Table 1: Common Configurations for sample-app-taprio
   :header: "Option", "Value"

   "Cycle Time", "2ms"
   "Packet Number", "1 packet/cycle"
   "VLAN ID", "3"
   "VLAN Priority code point", "6"
   "SO_PRIORITY", "6"

In the test, three performance indicators were measured.

.. csv-table:: Table 2: Performance Indicators
   :header: "Indicator", "Meaning"

   "Scheduled times", "the time from the beginning of a cycle to the NIC of the receiver receives the packet"
   "RT application latency", "the time from the beginning of a cycle to when calling the send function"
   "TSN Network jitter", "the jitter of scheduled times"

* Case 1, no TSN feature enabled. ``sample-app-taprio`` sends a packet at the
  beginning of each cycle.

  Need to perform time synchronization on the Kata container before executing
  ``sample-app-taprio``.

::

  # launch ptp programs, ptp4l and phc2sys, to synchronize the PTP clock and
  # the system clock.
  ptp4l -f /etc/ptp4l.cfg -m &
  phc2sys -s eth1 -c CLOCK_REALTIME -w -O 0 -m &

  # The content of ptp4l.cfg is shown below.
  [global]
  gmCapable               0
  priority1               128
  priority2               128
  logAnnounceInterval     1
  logSyncInterval         -3
  syncReceiptTimeout      3
  neighborPropDelayThresh 800
  min_neighbor_prop_delay -20000000
  assume_two_step         1
  path_trace_enabled      1
  follow_up_info          0
  ptp_dst_mac             01:1B:19:00:00:00
  network_transport       L2
  delay_mechanism         P2P
  tx_timestamp_timeout    100
  summary_interval        0

  [eth1]
  transportSpecific 0x1

.. figure:: ./figures/tsn_case1_noetf.png
    :width: 600px
    :height: 400px
    :align: center

    Figure 3: Performance Report of Case 1

As shown in `Figure 3`, the indicator of ``RT application latency`` ranged from
`28.184us` to `1259.387us`. There are two reasons for that:

#. Standard kernels instead of real-time kernels were used for both StarlingX
   platform and the Kata container (for now, Kata containers only supports
   standard kernel).

#. ``sample-app-taprio`` was running on the Kata container instead of the
   host.

Since TSN features were not enabled in this case, there are no any controls on
``Scheduled times``. It depended on the indicator of
``RT application latency`` and the behavior of the whole network. As shown in
the figure, it ranged from `69.824us` to `2487.357us`, and its jitter can reach
`1ms`.

* Case 2,
  enable two qdiscs,
  `TAPRIO <http://man7.org/linux/man-pages/man8/tc-taprio.8.html>`_  and
  `ETF <http://man7.org/linux/man-pages/man8/tc-etf.8.html>`_, on the Kata
  container. `sample-app-taprio` had additional configurations as shown
  in Table 3. Considering the big variance of ``RT application latency`` got in
  `Case 1`, the transmitting time was set at `1250us`.

.. csv-table:: Table 3: Additional Configurations for Case 2
   :header: "Option", "Value"

   "Transmit Window", "[1200us, 1300us]"
   "Offset in Window", "50us"

Make necessary configurations on the Kata container before executing
``sample-app-taprio``.

::

  # change the number of multi-purpose channels
  ethtool -L eth1 combined 4

  # delete existing qdiscs
  tc qdisc del dev eth1 root

  # enable taprio qdisc, SO_PRIORITY 6 was mapped to traffic class 1.
  tc -d qdisc replace dev eth1 parent root handle 100 taprio num_tc 4 \
        map 3 3 3 3 3 3 1 3 3 3 3 3 3 3 3 3 \
        queues 1@0 1@1 1@2 1@3 \
        base-time 1588076872000000000 \
        sched-entry S 01 200000 \
        sched-entry S 02 100000 \
        sched-entry S 04 100000 \
        sched-entry S 08 100000 \
        sched-entry S 01 200000 \
        sched-entry S 02 100000 \
        sched-entry S 04 100000 \
        sched-entry S 08 100000 \
        clockid CLOCK_TAI

  # enable etf qdisc on queue 1 which corresponds to traffic class 1
  tc qdisc replace dev eth1 parent 100:2 etf clockid CLOCK_TAI \
        delta 5000000 offload

  # create vlan interface and set egress map.
  ip link add link eth1 name eth1.3 type vlan id 3
  vconfig set_egress_map eth1.3 6 6
  ifconfig eth1 up
  ip link set eth1.3 up

  # launch ptp programs, ptp4l and phc2sys, to synchronize the PTP clock and
  # the system clock.
  ptp4l -f /etc/ptp4l.cfg -m &
  phc2sys -s eth1 -c CLOCK_REALTIME -w -O 0 -m &

.. figure:: ./figures/tsn_case2_etf.png
    :width: 600px
    :height: 400px
    :align: center

    Figure 4: Performance Report of Case 2

In this test, the indicator of ``RT Application latency`` got similar result
with that of `Case 1`. It is expected since there are no any optimizations done
on it. ``Scheduled times`` was well controlled (ranged from `1253.188us` to
`1253.343us`) which indicates the TSN feature is functional. The indicator of
``TSN Network jitter`` also proved it.

* Case 3, based on the setting of `Case 2`, enable
  `802.1qbv <http://www.ieee802.org/1/pages/802.1bv.html>`_ support on the TSN
  switch, and ``iperf3`` were running on ``Node 3`` and ``Node 4`` to transfer
  massive best-effort traffic to stress the overall network communication.

::

  # iperf3 -c 192.168.1.2 -b 0 -u -l 1448 -t 86400
  Connecting to host 192.168.1.2, port 5201
  [  5] local 192.168.1.3 port 43752 connected to 192.168.1.2 port 5201
  [ ID] Interval           Transfer     Bitrate         Total Datagrams
  [  5]   0.00-1.00   sec   114 MBytes   956 Mbits/sec  82570
  [  5]   1.00-2.00   sec   114 MBytes   956 Mbits/sec  82550
  [  5]   2.00-3.00   sec   114 MBytes   957 Mbits/sec  82580
  [  5]   3.00-4.00   sec   114 MBytes   956 Mbits/sec  82560
  [  5]   4.00-5.00   sec   114 MBytes   956 Mbits/sec  82560
  [  5]   5.00-6.00   sec   114 MBytes   956 Mbits/sec  82560
  [  5]   6.00-7.00   sec   114 MBytes   957 Mbits/sec  82570
  [  5]   7.00-8.00   sec   114 MBytes   956 Mbits/sec  82560

::

  # iperf3 -s
  -----------------------------------------------------------
  Server listening on 5201
  -----------------------------------------------------------
  Accepted connection from 192.168.1.3, port 48494
  [  5] local 192.168.1.2 port 5201 connected to 192.168.1.3 port 50593
  [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
  [  5]   0.00-1.00   sec  42.1 MBytes   353 Mbits/sec  0.055 ms  48060/78512 (61%)
  [  5]   1.00-2.00   sec  44.2 MBytes   371 Mbits/sec  0.066 ms  50532/82531 (61%)
  [  5]   2.00-3.00   sec  44.2 MBytes   371 Mbits/sec  0.063 ms  50593/82592 (61%)
  [  5]   3.00-4.00   sec  44.2 MBytes   371 Mbits/sec  0.059 ms  50534/82534 (61%)
  [  5]   4.00-5.00   sec  44.2 MBytes   371 Mbits/sec  0.060 ms  50619/82619 (61%)
  [  5]   5.00-6.00   sec  44.2 MBytes   371 Mbits/sec  0.062 ms  50506/82504 (61%)
  [  5]   6.00-7.00   sec  44.2 MBytes   371 Mbits/sec  0.059 ms  50563/82563 (61%)

.. figure:: ./figures/tsn_case3_etf_heavytraffic.png
    :width: 600px
    :height: 400px
    :align: center

    Figure 5: Performance Report of Case 3

The result was very similar with that of `Case 2`. It demonstrated that even a
great amount of best-effort traffic was sent to the TSN network, the
time-sensitive packets sent from ``sample-app-taprio`` was not impacted. The
determinism was still guaranteed.

-------
Summary
-------

In this guide, we introduced how to enable TSN support in Kata containers on
StarlingX platform. The experimental results demonstrated the capability of
TSN in Kata containers. The cycle time (2ms) is not small enough for
some critical use cases. In the future, some optimizations could be
done to achieve better performance, such as, replacing standard kernel
with real-time kernel.
