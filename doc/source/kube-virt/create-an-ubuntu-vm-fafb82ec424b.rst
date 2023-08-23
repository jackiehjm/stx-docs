.. _create-an-ubuntu-vm-fafb82ec424b:

===================
Create an Ubuntu VM
===================

.. rubric:: |context|

This section provides a more complex, but likely more real-life, example of
deploying a linux-based |VM| with KubeVirt.

The example uses:

* An ubuntu 22.04 jammy cloud image
  https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

* The |CDI| Upload Proxy service to upload the ubuntu jammy image into a
  DataVolume/|PVC|, for the root disk. A production linux distribution and a
  DataVolume/|PVC| for persistent storage.

* A ``cloudInitNoCloud`` volume type.

  Used to pass in cloud init formatted 'userData' in order to create a user and
  password for initial login.

* Explicit resource request for 8x CPUs and 16G of Memory.

* Multus and |SRIOV| CNIs in order to add an additional |SRIOV|-based interface.
  This allows the |VM| to be assigned a unique IP Address from the IP Subnet
  attached to the |SRIOV|-based interface.

* Connection using the serial console interface via ``virtctl`` in order to
  configure the IP Interface on the SRIOV-based interface.

* SSH from a REMOTE WORKSTATION to the |VM|'s unique IP Address on the IP Subnet
  attached to the |SRIOV|-based interface.

.. rubric:: |proc|

#. Make the infrastructure changes to support |SRIOV|-based interfaces on
   containers (including KubeVirt |VM| containers):

   #. Create a new Data Network of type 'vlan' for SRIOV interfaces to be used
      by your KubeVirt |VMs|.

      .. code-block::

         ~(keystone_admin)$ system datanetwork-add kube-sriov vlan

   #. Create pci-sriov type interfaces.

      For every AIO-Controller and Worker/Compute, create a PCI-SRIOV type
      interface and attach the new data network to this interface. e.g. for
      compute-1's enp24s0f0 ethernet interface


      .. code-block::

         ~(keystone_admin)$ system host-if-modify -n sriov0 -c pci-sriov -N 64 --vf-driver vfio compute-1 enp24s0f0
         ~(keystone_admin)$ system interface-datanetwork-assign compute-1 sriov0 kube-sriov


   #. Create a ``NetworkAttachmentDefinition`` in Kubernetes to point to the new
      Data Network and specify a particular vlan-id to use within that Data
      Network.

      In the example below, a ``NetworkAttachmentDefinition`` is created in the
      stx-lab namespace for vlan-id=20 on interfaces attached to the kube-sriov
      data network. In this example, vlan-id=20 is attached to a router which
      has this interface configured as the 10.10.186.0/24 IP Subnet.

      Note that the ``k8s.v1.cni.cncf.io/resourceName`` annotation is used to
      reference the specific Data Network, and has a structure of
      ``intel.com/pci_sriov_net_<data_network_name>`` (with all dashes in the
      data network name, if any, converted to underscores).

      .. code-block:: yaml

         $ cat <<EOF > 186-subnet.yaml
         apiVersion: "k8s.cni.cncf.io/v1"
         kind: NetworkAttachmentDefinition
         metadata:
           name: 186-subnet
           namespace: stx-lab
           annotations:
             k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_kube_sriov
         spec:
           config: '{
             "cniVersion": "0.3.0",
             "type": "sriov",
             "vlan": 20
           }'
         EOF

   #. Apply the configuration.

      .. code-block::

         $ kubectl apply -f 186-subnet.yaml

#. Create the |VM|, login to the console and configure the |VM|'s interface on
   the 10.10.186.0/24 network. Then SSH to the |VM| from a remote workstation.

   #. Use ``virtctl`` and the |CDI| Upload Proxy service to load the ubuntu jammy
      cloud image into a new DataVolume of size 500G, in the stx-lab namespace.

      .. code-block::

         $ virtctl image-upload dv stx-lab-ubuntu-test-disk -n stx-lab --insecure \
           --access-mode ReadWriteOnce --size 500Gi \
           --image-path /home/sysadmin/admin/kubevirt/images/jammy-server-cloudimg-amd64.img \
           --uploadproxy-url https://admin.starlingx.abc.com:32111

   #. Create the ``yaml`` file defining the ``VirtualMachine`` |CRD| instance.

      .. code-block:: yaml

         $ cat <<EOF > stx-lab-ubuntu-test.yaml
         apiVersion: kubevirt.io/v1alpha3
         kind: VirtualMachine
         metadata:
           labels:
             kubevirt.io/vm: stx-lab-ubuntu-test
           name: stx-lab-ubuntu-test
           namespace: stx-lab
         spec:
           running: true
           template:
             metadata:
               labels:
                 kubevirt.io/vm: stx-lab-ubuntu-test
             spec:
               domain:
                 devices:
                   disks:
                   - disk:
                       bus: virtio
                     name: myrootdisk
                   - disk:
                       bus: virtio
                     name: cloudinitdisk
                   interfaces:
                   - masquerade: {}
                     name: default
                   - name: 186-subnet
                     sriov: {}
                 machine:
                   type: ""
                 resources:
                   requests:
                     cpu: 8
                     memory: 16Gi
               networks:
               - name: default
                 pod: {}
               - multus:
                   networkName: stx-lab/186-subnet
                 name: 186-subnet
               terminationGracePeriodSeconds: 0
               volumes:
               - name: myrootdisk
                 dataVolume:
                   name: stx-lab-ubuntu-test-disk
               - cloudInitNoCloud:
                   userData: |-
                     #cloud-config
                     user: jenkins
                     password: myP@ssw0rd
                     chpasswd: { expire: False }
                     ssh_pwauth: True
                 name: cloudinitdisk
         EOF

   #. Apply the configuration.

      .. code-block::

         $ kubectl apply -f stx-lab-ubuntu-test.yaml

   #. Connect to console and configure |VM| and the |VM|'s interface on the
      10.10.186.0/24 network.

      .. code-block::

         $ virtctl -n stx-lab console stx-lab-ubuntu-test
         Successfully connected to stx-lab-ubuntu-test console. The escape sequence is ^]4

         stx-lab-ubuntu-test login: jenkins
         Password:
         Welcome to Ubuntu 22.04 LTS (GNU/Linux 5.15.0-39-generic x86_64)

         * Documentation: https://help.ubuntu.com
         * Management:    https://landscape.canonical.com
         * Support:       https://ubuntu.com/advantage

          System information as of Thu Dec 8 16:55:12 UTC 2022

          System information as of Thu   Dec     8 16:55:12 UTC 2022

          System load:    0.2587890625        Processes:               178
          Usage of /:	  0.3% of 476.62GB    Users logged in:	       0
          Memory usage:   1%	              IPv4 address for enp1s0: 10.0.2.2
          Swap usage:	  0%

          0 updates can be applied immediately.

          ...

   #. Still in the |VM| console, list the interfaces.

      Note that this |VM| has 2x interfaces.

      * enp1s0 is the default container |CNI| interface
      * enp6s0 is the |SRIOV| interface

      .. code-block::

         jenkins@stx-lab-ubuntu-test:~$ ip link

         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
           link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
         2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group
         default qlen 1000
           link/ether 52:54:00:41:84:a0 brd ff:ff:ff:ff:ff:ff
         3: enp6s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
           link/ether 46:c5:53:3b:b3:b3 brd ff:ff:ff:ff:ff:ff

         jenkins@stx-lab-ubuntu-test:~$ ip addr

         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
              valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host
              valid_lft forever preferred_lft forever
         2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
            link/ether 52:54:00:41:84:a0 brd ff:ff:ff:ff:ff:ff
            inet 10.0.2.2/24 metric 100 brd 10.0.2.255 scope global dynamic enp1s0
              valid_lft 86313505sec preferred_lft 86313505sec
            inet6 fe80::5054:ff:fe41:84a0/64 scope link
              valid_lft forever preferred_lft forever
         3: enp6s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
            link/ether 46:c5:53:3b:b3:b3 brd ff:ff:ff:ff:ff:ff cumulus@stx-lab-ubuntu-test:~$


   #. Still in the |VM| console, using the default |CNI| interface (which has
      connectivity out the |OAM| interface), update and upgrade the ubuntu
      deployment in the |VM|.

      .. code-block:: none

         jenkins@stx-lab-ubuntu-test:~$ sudo apt-get update
         jenkins@stx-lab-ubuntu-test:~$ sudo apt-get -y upgrade

   #. Still in the |VM| console, configure Networking persistently with netplan
      and reboot

      Specifically disable default CNI interface (enp1s0), and configure the
      |SRIOV| interface (enp6s0).

      .. code-block:: bash

         $ sudo su -

         $ cat <<EOF > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
         network: {config: disabled}
         EOF

         # Update /etc/netplan/50-cloud-init.yaml as shown below.

         $ vi /etc/netplan/50-cloud-init.yaml

         network:
            ethernets:
              # enp1s0:
                # dhcp4: true
              enp6s0:
                dhcp4: no
                addresses:
                  - 10.10.186.97/24
                nameservers:
                  addresses: [10.10.186.130]
                routes:
                  - to: default
                    via: 10.10.186.1
                    version: 2

         # Apply the updates
         $ netplan apply

         # Restart the system
         $ /sbin/reboot

         < LOGS FROM BOOTING ON CONSOLE >

         [ OK   ] Finished Execute cloud user/final scripts.
         [ OK   ] Reached target Cloud-init target.
         Ubuntu 22.04.1 LTS stx-lab-ubuntu-test ttyS0
         stx-lab-ubuntu-test login: jenkins
         Password:

         Last login: Thu   Dec     8 16:55:13 UTC 2022 on   ttyS0

         jenkins@stx-lab-ubuntu-test:~$ ip link
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
         2: enp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
            link/ether 52:54:00:41:84:a0 brd ff:ff:ff:ff:ff:ff
         3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
            link/ether 46:c5:53:3b:b3:b3 brd ff:ff:ff:ff:ff:ff

         jenkins@stx-lab-ubuntu-test:~$ ip addr
         1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
              valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host
              valid_lft forever preferred_lft forever
         2: enp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
            link/ether 52:54:00:41:84:a0 brd ff:ff:ff:ff:ff:ff
         3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
            link/ether 46:c5:53:3b:b3:b3 brd ff:ff:ff:ff:ff:ff
            inet 10.10.186.97/24 brd 10.10.186.255 scope global enp6s0
              valid_lft forever preferred_lft forever
            inet6 2620:10a:a001:a106:44c5:53ff:fe3b:b3b3/64 scope global dynamic mngtmpaddr noprefixroute
              valid_lft 2591972sec preferred_lft 604772sec
            inet6 fe80::44c5:53ff:fe3b:b3b3/64 scope link
              valid_lft forever preferred_lft forever

         jenkins@stx-lab-ubuntu-test:~$ ip route
         default via 10.10.186.1 dev enp6s0 proto static
         10.10.186.0/24 dev enp6s0 proto kernel scope link src 10.10.186.97

#. Connect from a remote workstation.

   .. code-block:: bash

      $ ssh jenkins@10.10.186.97
      password:

      Last login: Thu Dec 8 18:14:18 2022

      jenkins@stx-lab-ubuntu-test:~$ ip link

      1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
      2: enp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
         link/ether 52:54:00:41:84:a0 brd ff:ff:ff:ff:ff:ff
      3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
         link/ether 46:c5:53:3b:b3:b3 brd ff:ff:ff:ff:ff:ff


.. rubric:: |result|

.. procedure results here

