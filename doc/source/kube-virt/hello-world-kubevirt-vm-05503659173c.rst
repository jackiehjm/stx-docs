.. _hello-world-kubevirt-vm-05503659173c:

=======================
Hello World KubeVirt VM
=======================

.. rubric:: |context|

This section provides a 'hello world' example of creating, running and attaching
to a |VM| with KubeVirt. The example uses

* A CirrOS image packaged as a Container Image and available from
  docker.io:kubevirt/cirros-container-disk-demo:latest

* A 'containerDisk' volume type

  - The containerDisk feature provides the ability to store and distribute |VM|
    disks in a container image registry.

  - containerDisks can be assigned to |VMs| in the disks section of the
    VirtualMachine spec.

  - containerDisks are ephemeral storage devices; so can they only be used by
    applications that do NOT require persistent data.

* A ``cloudInitNoCloud`` volume type, which allows attaching
  ``cloudInitNoCloud`` data-sources to the |VM|. If the |VM| contains a proper
  cloud-init setup, it will pick up the disk as a user-data source.

* No additional network interfaces other than the default |CNI| interface of the
  container running the |VM|.

* Connect with either the serial console interface via ``virtctl``, or through a
  NodePort service on the |prod| Floating OAM IP Address.

.. rubric:: |proc|

Complete the procedure below to create the |VM|, start the |VM| and login into
the |VM| via the console:

#. Create the ``yaml`` file defining the ``VirtualMachine`` |CRD| instance.

   .. code-block:: yaml

      $ cat <<EOF > vm-cirros-containerdisk.yaml
      apiVersion: kubevirt.io/v1alpha3
      kind: VirtualMachine
      metadata:
      labels:
        kubevirt.io/vm: vm-cirros
      name: vm-cirros
      spec:
      running: false template:
      metadata:
        labels:
          kubevirt.io/vm: vm-cirros
      spec:
        running: false
        template:
          metadata:
            labels:
              kubevirt.io/vm: vm-cirros 
          spec:
            domain:
              devices:
                disks:
                - disk:
                    bus: virtio
                   name: containerdisk
                - disk:
                    bus: virtio
                   name: cloudinitdisk
            machine:
              type: ""
            resources:
              requests:
                memory: 64M
          terminationGracePeriodSeconds: 0
          volumes:
          - name: containerdisk
            containerDisk:
              image: kubevirt/cirros-container-disk-demo:latest
          - cloudInitNoCloud:
              userDataBase64: IyEvYmluL3NoCgplY2hvICdwcmludGVkIGZyb20gY2xvdWQtaW5pdCB1c2VyZGF0YScK
            name: cloudinitdisk
      EOF

#. Apply the ``yaml`` file to create the |VM| in a stopped state.


   .. code-block:: none

      $ kubectl apply -f cdi-uploadproxy-nodeport-service.yaml virtualmachine.kubevirt.io/vm-cirros created

      $ kubectl get vm
      NAME      AGE STATUS  READY
      vm-cirros 17s Stopped False

      $ kubectl get vmi
      No resources found in default namespace.

#. Start the |VM| with the ``virtctl`` tool.

   .. code-block:: none

       $ virtctl start vm-cirros
       VM vm-cirros was scheduled to start
       
       $ kubectl get vm
       NAME         AGE  STATUS   READY
       vm-cirro     87s  Running  True
       
       $ kubectl get vmi
       NAME         AGE PHASE   IP               NODENAME    READY
       vm-cirros    17s Running 172.16.225.72	 compute-2   True

#. Connect to and login into the |VM| console using the ``virtctl`` tool.

   .. code-block:: bash

       $ virtctl console vm-cirros
       Successfully connected to vm-cirros console. The escape sequence is ^]

       # login as 'cirros' user. default password: 'gocubsgo'. Use 'sudo' for root. 
       # vm-cirros login: cirros
       Password:
       
       $ hostname vm-cirros
       
       $ ls /
         bin       home           lib64          mnt         root        tmp 
         boot      init           linuxrc        old-root    run         usr 
         dev       initrd.img     lost+found     opt         sbin        var
         etc       lib            media          proc        sys         vmlinuz

       $ ip link
       1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000 link/ether a6:77:37:4c:ee:10 brd ff:ff:ff:ff:ff:ff
       
       # List Interfaces
       # Notice how the VM has a single eth0 interface, the default CNI interface.

       $ ip addr
       1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever inet6 ::1/128 scope host
        
       valid_lft forever preferred_lft forever
       2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000 link/ether a6:77:37:4c:ee:10 brd ff:ff:ff:ff:ff:ff
       inet 172.16.225.72/32 brd 172.16.255.255 scope global eth0
       valid_lft forever preferred_lft forever inet6 fe80::a477:37ff:fe4c:ee10/64 scope link valid_lft forever preferred_lft forever
       # Exit/escape from the VM Console with ctrl+']'
       $ ^]

#. Expose the SSH port of vm-cirros via a NodePort.

   .. code-block:: bash

      $ virtctl expose vmi vm-cirros --port=22 --name vm-cirros-ssh --type=NodePort
      Service vm-cirros-ssh successfully exposed for vmi vm-cirros
      
      $ kubectl get service
      NAME            TYPE      CLUSTER-IP     EXTERNAL-IP PORT(S)       AGE
      kuard-nodeport NodePort	10.96.155.165 <none>       80:31118/TCP 92d
      kubernetes      ClusterIP 10.96.0.1      <none>       443/TCP       188d
      nodeinfo        ClusterIP	10.96.189.47   <none>       1080/TCP      92d
      vm-cirros-ssh   NodePort	10.99.91.228   <none>       22:31562/TCP 9s

#. Connect from a remote workstation.

   .. parsed-literal::

      $ ssh -p 31562 cirros@<Floating-OAM-IP-Address-of-|prod|>
      password:

      $ hostname vm-cirros

      # List Interfaces
      # Notice how the VM has a single eth0 interface, the default CNI interface.
     
      $ ip addr
      1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
          link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
          inet 127.0.0.1/8 scope host lo
            valid_lft forever preferred_lft forever
          inet6 ::1/128 scope host
            valid_lft forever preferred_lft forever
      2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
          link/ether a6:77:37:4c:ee:10 brd ff:ff:ff:ff:ff:ff
          inet 172.16.225.72/32 brd 172.16.255.255 scope global eth0
            valid_lft forever preferred_lft forever
          inet6 fe80::a477:37ff:fe4c:ee10/64 scope link
            valid_lft forever preferred_lft forever

      $ exit


