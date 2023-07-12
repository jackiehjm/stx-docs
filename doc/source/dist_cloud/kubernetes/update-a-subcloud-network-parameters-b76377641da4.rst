.. _update-a-subcloud-network-parameters-b76377641da4:

==================================
Manage Subcloud Network Parameters
==================================

Use the following procedures to manage an optional admin network on a subcloud
for IP connectivity to the system controller management network where the IP
addresses of the admin network can be changed.

.. rubric:: |prereq|

-   Ensure that the subcloud admin subnet does not overlap addresses already
    being used by the system controller or any of its subclouds.

-   Ensure that the subcloud has been backed up, in case a subcloud system
    recovery is required.

-   Ensure that the system time between system controllers and the
    subclouds are synchronized.

    .. code-block:: none

        ~(keystone_admin)]$ date -u

    If the time is not correct either on the system controllers or the subclouds,
    check the ``clock_synchronization`` configuration on the system.

    .. code-block:: none

        ~(keystone_admin)]$ system host-show controller-0

    Check the |NTP| server configuration or |PTP| server configuration sections
    to correct the system time based on the system's ``clock_synchronization``
    configuration (|NTP| or |PTP|).

---------------------------------
Add an admin interface or network
---------------------------------

.. rubric:: |context|

This task is required only if an admin network/interface does not exist on the
system, either via this procedure or at bootstrap time. The procedure is
performed only on the subcloud.

.. rubric:: |proc|   

#. For all the controller hosts of a subcloud, add the new admin interface as
   follows: 

   #. Lock the host.

      .. code-block:: none

          ~(keystone_admin)]$ system host-lock <controller-host>
    
   #. Add a new platform interface.

      .. code-block:: none

          ~(keystone_admin)]$ system host-if-modify <host> <admin-interface> -c platform

      For example:
   
      .. code-block:: none

          ~(keystone_admin)]$ system host-if-modify <controller-host> enp0s9 -c platform

      .. note::

          To see all the available interfaces, use the :command:`system host-if-list -a <host>` command.

   #. Unlock the host.

      .. code-block:: none

          ~(keystone_admin)]$ system host-unlock <host>
        
#. Create an admin network address pool.

   .. code-block:: none

       ~(keystone_admin)]$ system addrpool-add --floating-address <floating-address> --controller0-address <controller0-address> --controller1-address <controller1-address> --gateway-address <gateway-address> <address-pool-name> <subnet> <prefix length>

   For example:

   .. code-block:: none

       ~(keystone_admin)]$ system addrpool-add --floating-address 192.168.102.2 --controller0-address 192.168.102.3 --controller1-address 192.168.102.4 --gateway-address 192.168.102.1 admin 192.168.102.0 24

#. Create the admin network with the dynamic field set to false.

   .. code-block:: none

       ~(keystone_admin)]$ system network-add <network-name> admin false <admin-address-pool-uuid>

   For example:

   .. code-block:: none

       ~(keystone_admin)]$ system network-add admin admin false $(system addrpool-list | grep admin | awk '{print $2}')

#. Assign the admin network to the admin interface.

   .. code-block:: none

       ~(keystone_admin)]$ system interface-network-assign <controller-host> <interface-name> <network-name>

   For example:

   .. code-block:: none
    
       ~(keystone_admin)]$ system interface-network-assign <controller-host> enp0s9 admin

--------------------------------------------------
Change the network parameters of the admin network
--------------------------------------------------

.. rubric:: |context|

This task is required only if the parameters of an admin network need to be
changed, for example, to align with a new external network configuration. The
procedure is performed only on the subcloud.

.. rubric:: |proc|

#. Delete the admin address pool.

   .. code-block:: none

       ~(keystone_admin)]$ system addrpool-delete <admin-address-pool-uuid>

   .. note::

       This will automatically delete the admin network and unassign it from the
       admin interface.

#. Create a new admin network address pool.

   For example:

   .. code-block:: none

       ~(keystone_admin)]$ system addrpool-add --floating-address 192.168.103.2 --controller0-address 192.168.103.3 --controller1-address 192.168.103.4 --gateway-address 192.168.103.1 admin 192.168.103.0 24

#. Create a new admin network.

   For example:

   .. code-block:: none

       ~(keystone_admin)]$ system network-add admin admin false <admin-address-pool-uuid>

#. Assign the new admin network to the admin interface.

   .. code-block:: none

       ~(keystone_admin)]$ system interface-network-assign controller-0 enp0s9 admin

#. On the system controller, perform the following:
   
   #. Unmanage the subcloud.

      .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>

   #. Update the subcloud with the new subnet parameters.

      For example:

      .. code-block:: none

          ~(keystone_admin)]$ dcmanager subcloud update --management-subnet 192.168.103.0/24 --management-gateway-ip 192.168.103.1 --management-start-ip 192.168.103.2 --management-end-ip 192.168.103.5 --bootstrap-address 10.10.10.12 subcloud1

      .. note::

          The subcloud will go offline for a short period.

   #. Manage the subcloud.

      .. code-block:: none

          ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>

-------------------------------------
Switch back to the management network
-------------------------------------

.. rubric:: |context|

This task is required only if an operator wants to switch back to the subcloud
management network. This procedure can also be used to switch the subcloud back
to an already existing admin network.

.. rubric:: |proc|  

#. Unmanage the subcloud.

   .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>

#. Update the subcloud with the existing network parameters of the subcloud
   management network.

   For example:

   .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud update --management-subnet 192.168.104.0/24 --management-gateway-ip 192.168.104.1 --management-start-ip 192.168.104.2 --management-end-ip 192.168.104.5 --bootstrap-address 10.10.10.12 <subcloud-name>

   .. note::

       Obtain the existing management network parameters on the subcloud using
       the :command:`system addrpool-show <management network uuid>` command.

   .. note::

       The subcloud will go offline for a short period.

#. Manage the subcloud.

   .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>
        



