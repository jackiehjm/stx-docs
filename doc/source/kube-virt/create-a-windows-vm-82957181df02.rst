.. _create-a-windows-vm-82957181df02:

===================
Create a Windows VM
===================

.. rubric:: |context|

This section provides an example of deploying a WindowsServer-based |VM| with
KubeVirt.

The example uses:

* A Windows Server 2019 image pre-installed in a qcow2 type image

  - See
    https://superuser.openstack.org/articles/how-to-deploy-windows-on-openstack/
    for information on how to create such an image using VirtualBox and
    starting with a Windows Server 2019 ISO image and Fedora VirtIO drivers.

  * In order to make things easier, as part of making this image be sure to:

    - configure a well-known Administrator password,
    - enable Remote Desktop, and
    - enable Cloud-Init.

* The |CDI| Upload Proxy service to upload the Windows Server 2019 pre-installed
  qcow2 image into a DataVolume/|PVC|, for the root disk,

  Note that this image will be larger than previous ubuntu image so will take
  longer to load.

* Explicit resource request for 4x CPUs and 8G of Memory

* Multus and |SRIOV| CNIs in order to add an additional |SRIOV|-based interface.

  These allow the |VM| to be assigned a unique IP Address from the IP Subnet
  attached to the |SRIOV|-based interface.

* Connect with the graphical console interface via Virtctl in order to extend
  the root disk and configure the IP Interface on the SRIOV-based interface.

* Remote Desktop (RDP) from a remote workstation to the Windows |VM|'s unique IP
  Address on the IP Subnet attached to the |SRIOV|-based interface.


This example assumes the same infrastructure changes as in the previous Ubuntu
VM example have been done here. i.e., |SRIOV| interfaces connecting to a
10.10.186.0/24 network on vlan-id=20 have been configured on all hosts, and a
``NetworkAttachmentDefinition``, ``186-subnet``, has been created to this
network.

From a remote workstation that you have configured kubectl, virtctl and
virt-viewer, follow the procedure below to create the Windows |VM|, login to the
graphical console and configure the |VM|'s interface on the 10.10.186.0/24
network. Finally, RDP to the |VM| from a remote workstation.


.. rubric:: |proc|

#. Use ``virtctl`` and the CDI Upload Proxy service to load the Windows Server
   2019 qcow2 image into a new DataVolume of size 500G, in the stx-lab
   namespace.

   .. code-block::

      $ virtctl image-upload dv stx-lab-winserv-test-disk --namespace stx-lab --insecure \
         --access-mode ReadWriteOnce --size 100Gi --image-path \
         /home/sysadmin/admin/kubevirt/images/winserv2019.qcow2 \
         --uploadproxy-url https://admin.starlingx.abc.com:32111

#. Create the ``yaml`` file defining the ``VirtualMachine`` |CRD| instance

   .. code-block::

      $ cat <<EOF > stx-lab-winserv-test-vm.yaml
      apiVersion: kubevirt.io/v1alpha3
      kind: VirtualMachine
      metadata
        labels:
          kubevirt.io/vm: stx-lab-winserv-test
        name: stx-lab-winserv-test
        namespace: stx-lab
      spec:
        running: true
          template:
            metadata:
              labels:
                kubevirt.io/vm: stx-lab-winserv-test
            spec:
              domain:
                devices:
                  disks:
                  - disk:
                      bus: virtio
                    name: myrootdisk
                  interfaces:
                  - masquerade: {}
                    name: default
                  - name: 186-subnet
                    sriov: {}
                machine:
                  type: q35
                resources:
                  requests:
                    cpu: 4
                    memory: 8G
              terminationGracePeriodSeconds: 0 
              networks:
              - name: default
                pod: {}
              - multus:
                  networkName: stx-lab/186-subnet
                name: 186-subnet
              volumes:
             - name: myrootdisk
               dataVolume:
                 name: stx-lab-winserv-test-disk
      EOF

#. Apply the configuration.

   .. code-block::

     $ kubectl apply -f stx-lab-winserv-test-vm.yaml

      
#. Connect to the graphical console, extend the root disk, and configure the
   |VM|'s interface on the 10.10.186.0/24 network.

   .. code-block::

      $ virtctl -n stx-lab vnc --kubeconfig="/home/jdoe/.kube/config" stx-lab-winserv

   This command launches Windows graphical console.

   #. Login with well-known Administrator password set when the Windows Server
      2019 qcow2 image was created.

   #. Extend the root disk to fully use the space on the root disk.

      **Computer Management** > **Storage** > **Disk Management** > **Extend
      Volume** (on the C: drive)

   #. Configure the second ethernet adapter (SRIOV-based Interface).

      For example:
      
      - with static ip address in 10.10.186.0/24 subnet
      
      - with the gateway ip address and

      - with DNS address (10.10.186.130)

   #. Logout of graphical console.


.. rubric:: |result|

You can now RDP to the Windows |VM| using the 10.10.186.<nnn> IP Address.

