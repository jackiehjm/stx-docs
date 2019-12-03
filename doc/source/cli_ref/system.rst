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

``certificate-install``
    Install certificate.

``certificate-list``
    List certificates.

``certificate-show``
    Show certificate details.

********************************
Local Docker registry management
********************************

``registry-garbage-collect``
    Run the registry garbage collector.

``registry-image-delete``
    Remove the specified Docker image from the local registry.

``registry-image-list``
    List all images in local docker registry.

``registry-image-tags``
    List all tags for a Docker image from the local registry.

*****************************************
Host/controller file system configuration
*****************************************

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

**********************
Application management
**********************

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

``host-ethernet-port-list``
    List host Ethernet ports.

``host-ethernet-port-show``
    Show host Ethernet port attributes.

``host-port-list``
    List host ports.

``host-port-show``
    Show host port details.

``host-if-add``
    Add an interface.

``host-if-delete``
    Delete an interface.

``host-if-list``
    List interfaces.

``host-if-modify``
    Modify interface attributes.

``host-if-show``
    Show interface attributes.


****************************************************
Host platform L2 network, IP addressing, and routing
****************************************************

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

``host-disk-list``
    List disks.

``host-disk-show``
    Show disk attributes.

``host-disk-wipe``
    Wipe disk and GPT format it.

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

``cluster-list``
    List clusters.

``cluster-show``
    Show cluster attributes.

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

******************
CEPH configuration
******************

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

``ceph-mon-add``

``ceph-mon-delete``

``ceph-mon-list``
    List ceph mons.

``ceph-mon-modify``

``ceph-mon-show``
    Show ceph_mon of a specific host.

**************************
Host PCI device management
**************************

Host PCI device management commands (not including NICs).

``host-device-list``
    List devices.

``host-device-modify``
    Modify device availability for worker nodes.

``host-device-show``
    Show device attributes.

******************************
Host LLDP operational commands
******************************

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
