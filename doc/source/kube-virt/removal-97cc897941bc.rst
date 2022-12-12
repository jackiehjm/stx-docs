.. _removal-97cc897941bc:

=======
Removal
=======

.. rubric:: |proc|

#. Remove all VirtualMachines, Virtual MachineInstances and Data Volumes

   .. code-block:: none

      $ kubectl get vm -A
      $ kubectl delete vm <vm-name> -n <namespace>
      
      $ kubectl get vmi -A
      $ kubectl delete vmi <vmi-name> -n <namespace>
      
      $ kubectl get dv -A
      $ kubectl delete dv <dv-name> -n <namespace>

#. Remove KubeVirt and CDI pods and resources, and the virtctl command:

   .. code-block:: none
      
      ~(keystone_admin)$ system application-remove kubevirt-app
      $ rm /home/sysadmin/bin/virtctl

#. Remove the KubeVirt and CDI helm charts and application:

   .. code-block:: none

      ~(keystone_admin)$ system application-delete kubevirt-app

.. rubric:: |result|

KubeVirt has been removed from the system.

