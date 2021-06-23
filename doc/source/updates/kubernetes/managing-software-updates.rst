
.. kol1552920779041
.. _managing-software-updates:

=======================
Manage Software Updates
=======================

Updates \(also known as patches\) to the system software become available as
needed to address issues associated with a current |prod-long| software
release. Software updates must be uploaded to the active controller and applied
to all required hosts in the cluster.

.. note::
    Updating |prod-dc| is distinct from updating other |prod| configurations.
    
.. xbooklink    For information on updating |prod-dc|, see |distcloud-doc|: :ref:`Update
    Management for Distributed Cloud
    <update-management-for-distributed-cloud>`.

The following elements form part of the software update environment:

**Reboot-Required Software Updates**
    Reboot-required updates are typically major updates that require hosts to
    be locked during the update process and rebooted to complete the process.

    .. note::
        When a |prod| host is locked and rebooted for updates, the hosted
        application pods are re-located to an alternate host in order to
        minimize the impact to the hosted application service.

**In-Service Software Updates**
    In-service \(reboot-not-required\), software updates are updates that do
    not require the locking and rebooting of hosts. The required |prod|
    software is updated and any required |prod| processes are re-started.
    Hosted applications pods and services are completely unaffected.

**Software Update Commands**
    The :command:`sw-patch` command is available on both active controllers. It
    must be run as root using :command:`sudo`. It provides the user interface
    to process the updates, including querying the state of an update, listing
    affected hosts, and applying, installing, and removing updates.

**Software Update Storage Area**
    A central storage area maintained by the update controller. Software
    updates are initially uploaded to the storage area and remains there until
    they are deleted.

**Software Update Repository**
    A central repository of software updates associated with any updates
    applied to the system. This repository is used by all hosts in the cluster
    to identify the software updates and rollbacks required on each host.

**Software Update Logs**
    The following logs are used to record software update activity:

    **patching.log**
        This records software update agent activity on each host.

    **patching-api.log**
        This records user actions that involve software updates, performed
        using either the CLI or the REST API.

The overall flow for installing a software update from the command line
interface on a working |prod| cluster is the following:

.. _managing-software-updates-ol-vgf-yzz-jp:

#.  Consult the |org| support personnel for details on the availability of new
    software updates.

#.  Download the software update from the |org| servers to a workstation that
    can reach the active controller through the |OAM| network.

#.  Copy the software update to the active controller using the cluster's |OAM|
    floating IP address as the destination point.

    You can use a command such as :command:`scp` to copy the software update.
    The software update workflows presented in this document assume that this
    step is complete already, that is, they assume that the software update is
    already available on the file system of the active controller.

#.  Upload the new software update to the storage area.

    This step makes the new software update available within the system, but
    does not install it to the cluster yet. For all purposes, the software
    update is dormant.

#.  Apply the software update.

    This step adds the updates to the repository, making it visible to all
    hosts in the cluster.

#.  Install the software updates on each of the affected hosts in the cluster.
    This can be done manually or by using upgrade orchestration. For more
    information, see :ref:`Update Orchestration Overview
    <update-orchestration-overview>`.

Updating software in the system can be done using the Horizon Web interface or
the command line interface on the active controller. When using Horizon you
upload the software update directly from your workstation using a file browser
window provided by the software update upload facility.

A special case occurs during the initial provisioning of a cluster when you
want to update **controller-0** before the system software is configured. This
can only be done from the command line interface. See :ref:`Install Software
Updates Before Initial Commissioning
<installing-software-updates-before-initial-commissioning>` for details.
