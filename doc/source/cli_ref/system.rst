======
system
======

:command:`system` is the command-line interface for System Inventory and
Maintenance.

This page documents the :command:`system` command in StarlingX R3.0.

.. contents::
   :local:
   :depth: 2

------------
system usage
------------

::

   system [--version] [--debug] [-v] [-k] [--cert-file CERT_FILE]
              [--key-file KEY_FILE] [--ca-file CA_FILE] [--timeout TIMEOUT]
              [--os-username OS_USERNAME] [--os-password OS_PASSWORD]
              [--os-tenant-id OS_TENANT_ID] [--os-tenant-name OS_TENANT_NAME]
              [--os-auth-url OS_AUTH_URL] [--os-region-name OS_REGION_NAME]
              [--os-auth-token OS_AUTH_TOKEN] [--system-url SYSTEM_URL]
              [--system-api-version SYSTEM_API_VERSION]
              [--os-service-type OS_SERVICE_TYPE]
              [--os-endpoint-type OS_ENDPOINT_TYPE]
              [--os-user-domain-id OS_USER_DOMAIN_ID]
              [--os-user-domain-name OS_USER_DOMAIN_NAME]
              [--os-project-id OS_PROJECT_ID]
              [--os-project-name OS_PROJECT_NAME]
              [--os-project-domain-id OS_PROJECT_DOMAIN_ID]
              [--os-project-domain-name OS_PROJECT_DOMAIN_NAME]
              <subcommand> ...

For a list of all :command:`system` subcommands and options, enter:

::

  system help

-----------
Subcommands
-----------

For a full description of usage and optional arguments for a specific
:command:`system` command, enter:

::

  system help COMMAND

**********************
Certificate management
**********************

Certificate management commands allow you to install custom certificates
for a variety of StarlingX use cases. For example:

* StarlingX REST APIs and StarlingX Horizon web server.
* StarlingX local Docker registry.
* OpenStack REST APIs and OpenStack Horizon web server.
* StarlingX trusted certificate authority(s).

``certificate-install``
    Install certificate.

``certificate-list``
    List certificates.

``certificate-show``
    Show certificate details.

********************************
Local Docker registry management
********************************

.. incl-cli-local-docker-reg-start:

Local Docker registry management commands enable you to remove images and
free disk resources consumed by the local Docker registry. This is required if
the local Docker registry's file system (`docker-distribution`) becomes full.

``registry-garbage-collect``
    Run the registry garbage collector.

    This frees up the space on the file system used by deleted images. In rare
    cases, the system may trigger a `swact` in the small time window when
    garbage-collect is running. This may cause the registry to get stuck in
    read-only mode. If this occurs, run garbage-collect again to take the
    registry out of read-only mode.

``registry-image-delete``
    Remove the specified Docker image from the local registry.

    The image should be specified in the form :command:`name:tag`. This command
    only removes the image from the local Docker registry. It does not free
    space on the file system.

    .. note::

       Any stx-openstack images in a system with stx-openstack applied should
       not be deleted. If space is needed, you can delete the older tags of
       stx-openstack images, but do not delete the most recent one. Deleting
       both the registry stx-openstack images and the one from the Docker
       cache will prevent failed pods from recovering. If this happens,
       manually download the deleted images from the same source as
       application-apply and push it to the local registry under the same
       name and tag.

``registry-image-list``
    List all images in local docker registry.

``registry-image-tags``
    List all tags for a Docker image from the local registry.

.. incl-cli-local-docker-reg-end:

*****************************************
Host/controller file system configuration
*****************************************

Host/controller file system configuration commands manage file systems on hosts.
These commands primarily support the ability to resize the file systems.

Use :command:`host-fs-*` commands to manage un-synchronized file systems on
controller and worker nodes.

Use :command:`controllerfs-*` commands to manage drbd-synchronized file systems
on controller
nodes.

``host-fs-list``
    Show list of host file systems.

``host-fs-modify``
    Modify the size of a file system.

``host-fs-show``
    Show details of a host file system.

``controllerfs-list``
    Show list of controller file systems.

``controllerfs-modify``
    Modify controller file system sizes.

``controllerfs-show``
    Show details of a controller file system.

``drbdsync-modify``
    Modify DRBD sync rate parameters.

``drbdsync-show``
    Show DRBD sync config details.

********************
System configuration
********************

The following set of commands enable configuration of:

* Basic system attributes
* OAM IP address(es), subnet, and gateway
* Remote DNS servers for StarlingX hosts
* Time synchronization protocols, for example: NPT and/or PTP

``modify``
    Modify system attributes.

``show``
    Show system attributes.

``dns-modify``
    Modify DNS attributes.

``dns-show``
    Show DNS (Domain Name Server) attributes.

``ntp-modify``
    Modify NTP attributes.

``ntp-show``
    Show NTP (Network Time Protocol) attributes.

``ptp-modify``
    Modify PTP attributes.

``ptp-show``
    Show PTP (Precision Time Protocol) attributes.

``oam-modify``
    Modify external OAM attributes.

``oam-show``
    Show external OAM attributes.

**************************************
System configuration service-parameter
**************************************

Service parameters provide a generic mechanism to configure a variety of
configurable parameters in StarlingX, including:

* HTTP and HTTPS ports
* StarlingX Horizon authentication lockout parameters
* StarlingX Keystone token expiration
* StarlingX host management parameters such as heartbeat intervals and host boot
  timeouts

``service-parameter-add``
    Add service parameter.

``service-parameter-apply``
    Apply the service parameters.

``service-parameter-delete``
    Delete a service parameter.

``service-parameter-list``
    List service parameters.

``service-parameter-modify``
    Modify service parameter attributes.

``service-parameter-show``
    Show service parameter.

**************************************
Host IPMI configuration and management
**************************************

The :command:`host-sensor*` commands provide the ability to:

* Display the sensors collected from hosts over IPMI.
* Define thresholds.
* Configure behavior when thresholds are crossed (for example ignore, log, or
  reset).

``host-sensor-list``
    List sensors.

``host-sensor-modify``
    Modify a sensor.

``host-sensor-show``
    Show host sensor details.

``host-sensorgroup-list``
    List sensor groups.

``host-sensorgroup-modify``
    Modify sensor group of a host.

``host-sensorgroup-relearn``
    Relearn sensor model.

``host-sensorgroup-show``
    Show host sensor group attributes.

.. _sys_app_management:

**********************
Application management
**********************

StarlingX provides an application package management that combines Airship
Armada and Kubernetes Helm. The StarlingX application management provides:

* System Helm overrides to automatically apply StarlingX applications according
  to the particular StarlingX configuration currently running.
* Management for user specified Helm overrides.

``helm-chart-attribute-modify``
    Modify Helm chart attributes.

``helm-override-delete``
    Delete overrides for a chart.

``helm-override-list``
    List system Helm charts.

``helm-override-show``
    Show overrides for chart.

``helm-override-update``
    Update Helm chart user overrides.

``application-abort``
    Abort the current application operation.

``application-apply``
    Apply/reapply the application manifest.

``application-delete``
    Remove the uninstalled application from the system.

``application-list``
    List all containerized applications.

``application-remove``
    Uninstall the application.

``application-show``
    Show application details.

``application-update``
    Update the deployed application to a different version.

``application-upload``
    Upload application Helm chart(s) and manifest.

******************
SNMP configuration
******************

StarlingX supports a simple SNMPv2c agent. All fault management alarms and events
are sent out as SNMP traps. SNMP GET requests are supported in an active alarm
table and a historical events table.

``snmp-comm-add``
    Add a new SNMP community.

``snmp-comm-delete``
    Delete an SNMP community.

``snmp-comm-list``
    List community strings.

``snmp-comm-show``
    Show SNMP community attributes.

``snmp-trapdest-add``
    Create a new SNMP trap destination.

``snmp-trapdest-delete``
    Delete an SNMP trap destination.

``snmp-trapdest-list``
    List SNMP trap destinations.

``snmp-trapdest-show``
    Show a SNMP trap destination.


******************
Host configuration
******************

Host commands manage the general configuration of a StarlingX host. This
includes assignment of CPU cores to platform or hosted applications, the
configuration of amount and size for memory huge pages, and the configuration of
Kubernetes node labels.

``host-list``
    List hosts.

``host-show``
    Show host attributes.

``host-add``
    Add a new host.

``host-bulk-add``
    Add multiple new hosts.

``host-bulk-export``
    Export host bulk configurations.

``host-cpu-list``
    List CPU cores.

``host-cpu-modify``
    Modify CPU core assignments.

``host-cpu-show``
    Show CPU core attributes.

``host-memory-list``
    List memory nodes.

``host-memory-modify``
    Modify platform reserved and/or application huge page memory attributes for
    worker nodes.

``host-memory-show``
    Show memory attributes.

``host-label-assign``
    Update the Kubernetes labels on a host.

``host-label-list``
    List Kubernetes labels assigned to a host.

``host-label-remove``
    Remove Kubernetes label(s) from a host

``host-delete``
    Delete a host.

*************************
Host operational commands
*************************

The following set of commands provides operational host commands, including
taking a host in and out of service (lock/unlock), resetting a host, rebooting a
host, and powering a host on and off.

``host-lock``
    Lock a host.

``host-unlock``
    Unlock a host.

``host-swact``
    Switch activity away from this active host.

``host-power-off``
    Power off a host.

``host-power-on``
    Power on a host.

``host-reboot``
    Reboot a host.

``host-reset``
    Reset a host.

``host-reinstall``
    Reinstall a host.

****************************
Host interface configuration
****************************

The following set of commands manages the display and configuration of host
interfaces.

``host-ethernet-port-list``
    List host Ethernet ports.

``host-ethernet-port-show``
    Show host Ethernet port attributes.

``host-port-list``
    List host ports. Displays the L1 host ports and their attributes.

``host-port-show``
    Show host port details. Displays the L1 host ports and their attributes.

``host-if-add``
    Add an interface. Adds L2 host interfaces (Ethernet, VLAN, and
    LAG type L2 host interfaces).

``host-if-delete``
    Delete an interface. Deletes L2 host interfaces (Ethernet, VLAN, and
    LAG type L2 host interfaces).

``host-if-list``
    List interfaces. Displays L2 host interfaces (Ethernet, VLAN, and
    LAG type L2 host interfaces).

``host-if-modify``
    Modify interface attributes. Modifies L2 host interfaces (Ethernet, VLAN, and
    LAG type L2 host interfaces).

``host-if-show``
    Show interface attributes. Displays L2 host interfaces (Ethernet, VLAN, and
    LAG type L2 host interfaces).

****************************************************
Host platform L2 network, IP addressing, and routing
****************************************************

The following set of commands defines types of L2 platform networks, assignment
of L2 platform networks to interfaces, and configuration of L3 IP interfaces and
routing.

``network-add``
    Add a network.

``network-delete``
    Delete a network.

``network-list``
    List IP networks on host.

``network-show``
    Show IP network details.

``host-addr-add``
    Add an IP address.

``host-addr-delete``
    Delete an IP address.

``host-addr-list``
    List IP addresses on host.

``host-addr-show``
    Show IP address attributes.

``addrpool-add``
    Add an IP address pool.

``addrpool-delete``
    Delete an IP address pool.

``addrpool-list``
    List IP address pools.

``addrpool-modify``
    Modify interface attributes.

``addrpool-show``
    Show IP address pool attributes.

``host-route-add``
    Add an IP route.

``host-route-delete``
    Delete an IP route.

``host-route-list``
    List IP routes on host.

``host-route-show``
    Show IP route attributes.

``interface-network-assign``
    Assign a network to an interface.

``interface-network-list``
    List network interfaces.

``interface-network-remove``
    Remove an assigned network from an interface.

``interface-network-show``
    Show interface network details.

******************
Host data networks
******************

The following set of commands defines types of L2 data networks and assignment of
L2 data networks to interfaces. Data networks represent the underlying L2
networks for Kubernetes SRIOV/PCIPASSTHROUGH network attachments or OpenStack
tenant networks.

``datanetwork-add``
    Add a data network.

``datanetwork-delete``
    Delete a data network.

``datanetwork-list``
    List data networks.

``datanetwork-modify``
    Modify a data network.

``datanetwork-show``
    Show data network details.

``interface-datanetwork-assign``
    Assign a data network to an interface.

``interface-datanetwork-list``
    List data network interfaces.

``interface-datanetwork-remove``
    Remove an assigned data network from an interface.

``interface-datanetwork-show``
    Show interface data network details.

***********************
Host disk configuration
***********************

The following set of commands enables the display and configuration of host disks,
volume groups, and disk partitions.

``host-disk-list``
    List disks.

``host-disk-show``
    Show disk attributes.

``host-disk-wipe``
    Wipe disk and GPT format it.

``host-lvg-add``
    Add a local volume group.

``host-lvg-delete``
    Delete a local volume group.

``host-lvg-list``
    List local volume groups.

``host-lvg-modify``
    Modify the attributes of a local volume group.

``host-lvg-show``
    Show local volume group attributes.

``host-pv-add``
    Add a physical volume.

``host-pv-delete``
    Delete a physical volume.

``host-pv-list``
    List physical volumes.

``host-pv-show``
    Show physical volume attributes.

``host-disk-partition-add``
    Add a disk partition to a disk of a specified host.

``host-disk-partition-delete``
    Delete a disk partition.

``host-disk-partition-list``
    List disk partitions.

``host-disk-partition-modify``
    Modify the attributes of a disk partition.

``host-disk-partition-show``
    Show disk partition attributes.

******************
Ceph configuration
******************

The following set of commands is used to configure and manage Ceph OSDs, Ceph
tiers, and Ceph storage cluster backends.

``ceph-mon-add``

``ceph-mon-delete``

``ceph-mon-list``
    List Ceph mons.

``ceph-mon-modify``

``ceph-mon-show``
    Show ceph_mon of a specific host.

``cluster-list``
    List clusters.

``cluster-show``
    Show cluster attributes.

``host-stor-add``
    Add a storage to a host.

``host-stor-delete``
    Delete a stor.

``host-stor-list``
    List host storage.

``host-stor-show``
    Show storage attributes.

``host-stor-update``
    Modify journal attributes for OSD.

``storage-backend-add``
    Add a storage backend.

``storage-backend-delete``
    Delete a storage backend.

``storage-backend-list``
    List storage backends.

``storage-backend-modify``
    Modify a storage backend.

``storage-backend-show``
    Show a storage backend.

``storage-tier-add``
    Add a storage tier to a disk of a specified cluster.

``storage-tier-delete``
    Delete a storage tier.

``storage-tier-list``
    List storage tiers.

``storage-tier-modify``
    Modify the attributes of a storage tier.

``storage-tier-show``
    Show storage tier attributes.

**************************
Host PCI device management
**************************

The following set of commands provides host PCI device management (not including
NICs).

``host-device-list``
    List devices.

``host-device-modify``
    Modify device availability for worker nodes.

``host-device-show``
    Show device attributes.

******************************
Host LLDP operational commands
******************************

The following set of commands displays neighbor information learned from the
Link Layer Discovery Protocol (LLDP), which runs on all host interfaces.

``host-lldp-agent-list``
    List host LLDP agents.

``lldp-agent-show``
    Show LLDP agent attributes.

``host-lldp-neighbor-list``
    List host LLDP neighbors.

``lldp-neighbor-show``
    Show LLDP neighbor attributes.

******************************
Controller services management
******************************

The following set of commands enables display of services running on the StarlingX
controllers/masters. Optional services can be enabled or disabled using these
commands.

``servicenode-list``
    List service nodes.

``servicenode-show``
    Show a service node's attributes.

``servicegroup-list``
    List service groups.

``servicegroup-show``
    Show a service group.

``service-disable``
    Disable optional service

``service-enable``
    Enable optional service

``service-list``
    List services.

``service-show``
    Show a service.

********************
Unsupported commands
********************

.. important::

   The following commands are no longer supported.

``host-apply-cpuprofile``
    Apply a CPU profile to a host.

``host-apply-ifprofile``
    Apply an interface profile to a host.

``host-apply-memprofile``
    Apply a memory profile to a host.

``host-apply-profile``
    Apply a profile to a host.

``host-apply-storprofile``
    Apply a storage profile to a host.

``cpuprofile-add``
    Add a CPU profile.

``cpuprofile-delete``
    Delete a CPU profile.

``cpuprofile-list``
    List CPU profiles.

``cpuprofile-show``
    Show CPU profile attributes.

``ifprofile-add``
    Add an interface profile.

``ifprofile-delete``
    Delete an interface profile.

``ifprofile-list``
    List interface profiles.

``ifprofile-show``
    Show interface profile attributes.

``memprofile-add``
    Add a memory profile.

``memprofile-delete``
    Delete a memory profile.

``memprofile-list``
    List memory profiles.

``memprofile-show``
    Show memory profile attributes.

``profile-import``
    Import a profile file.

``storprofile-add``
    Add a storage profile

``storprofile-delete``
    Delete a storage profile.

``storprofile-list``
    List storage profiles.

``storprofile-show``
    Show storage profile attributes.

``remotelogging-modify``
    Modify remote logging attributes.

``remotelogging-show``
    Show remote logging attributes.

``sdn-controller-add``
    Add an SDN controller.

``sdn-controller-delete``
    Delete an SDN controller.

``sdn-controller-list``
    List all SDN controllers.

``sdn-controller-modify``
    Modify SDN controller attributes.

``sdn-controller-show``
    Show SDN controller details and attributes.

******************
Licensing commands
******************

.. important::

   The following commands are not supported upstream.

``license-install``
    Install license file.

``license-show``
    Show license file content.

*************************
Software upgrade commands
*************************

.. important::

   The following commands are not yet supported.

``host-downgrade``
    Perform software downgrade for the specified host.

``host-patch-reboot``
    Command has been deprecated.

``host-update``
    Update host attributes.

``host-upgrade``
    Perform software upgrade for a host.

``host-upgrade-list``
    List software upgrade info for hosts.

``load-delete``
    Delete a load.

``load-import``
    Import a load.

``load-list``
    List all loads.

``load-show``
    Show load attributes.

``upgrade-abort``
    Abort a software upgrade.

``upgrade-abort-complete``
    Complete a software upgrade.

``upgrade-activate``
    Activate a software upgrade.

``upgrade-complete``
    Complete a software upgrade.

``upgrade-show``
    Show software upgrade details and attributes.

``upgrade-start``
    Start a software upgrade.

``health-query``
    Run the health check.

``health-query-upgrade``
    Run the health check for an upgrade.
