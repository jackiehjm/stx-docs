
.. htb1590431033292
.. _the-kubernetes-update-orchestration-process:

=======================================================
Kubernetes Version Upgrade Cloud Orchestration Overview
=======================================================

For an orchestrated Kubernetes version upgrade you need to first create a
*Kubernetes Upgrade Orchestration Strategy*, or plan for the automated
Kubernetes version upgrade procedure.

You can customize the Kubernetes version upgrade orchestration by specifying
the following parameters:


.. _htb1590431033292-ul-pdh-5ms-tlb:

-   The host types to be upgraded; only **worker-apply-type** is supported.

-   The alarm restriction mode; **strict** or **relaxed** where the **relaxed**
    mode allows the strategy to be created while there are alarms present that
    are not management-affecting.

-   The concurrency of the upgrade process; whether to Kubernetes version
    upgrade hosts **serially** or in **parallel**.

-   The maximum number of worker hosts that can be upgraded together when
    **parallel** mode is selected.


For hosts that have the |prefix|-openstack application running with active
instances and since the Kubernetes version upgrade is a reboot required
operation for a host, the strategy offers **stop/start** or **migrate** options
for managing instances over the **lock/unlock** (reboot) steps in the upgrade
process.

You must use the :command:`sw-manager`` CLI tool to create, and then apply the
upgrade strategy. A created strategy can be monitored with the **show** command.

Kubernetes version upgrade orchestration automatically iterates through all
*unlocked-enabled* hosts on the system looking for hosts with the worker
function that need Kubernetes version upgrades and then proceeds to upgrade them
on the strategy :command:`apply` action.

.. note::
    Controllers (including |AIO| controllers) are upgraded before worker-only
    hosts. Since storage hosts do not run Kubernetes, no upgrade is performed,
    although they may still be patched.

After creating the *Kubernetes Version Upgrade Orchestration Strategy*, you can
either apply the entire strategy automatically, or manually apply individual
stages to control and monitor the Kubernetes version upgrade progress one stage
at a time.

When the Kubernetes version upgrade strategy is applied, if the system is
All-in-one, the controllers are upgraded first, one after the other with a
swact in between, followed by the remaining worker hosts according to the
selected worker apply concurrency (**serial** or **parallel**) method.

By default, strategies upgrade the worker hosts serially unless the **parallel**
worker apply type option is specified, which configures the Kubernetes version
upgrade process for worker hosts to be in parallel (up to a maximum parallel
number). This reduces the overall Kubernetes version upgrade installation time.

The upgrade takes place in two phases.  The first phase upgrades the patches
(controllers, storage and then workers), and the second  phase upgrades
Kubernetes based on those patches (controllers, then hosts).

.. _htb1590431033292-ol-a1b-v5s-tlb:

#.  Alarm query. This step is an upgrade pre-check.

#.  Initiate the Kubernetes version upgrade.

#.  Download Kubernetes Images.

#.  Upgrade the first Control Plane.

#.  Upgrade Kubernetes networking.

#.  Upgrade the second control plane (on duplex environments only).

#.  Patch the hosts.

    #.  Patch controller nodes if they are not |AIO|.

    #.  Patch storage nodes.

    #.  Patch worker nodes (this includes |AIO| controllers).

#.  Upgrade Kubelets on the hosts (controllers then workers.  If controllers
    are |AIO| they are processed before regular workers).

    #.  Swact if the host is the active controller.

    #.  Lock the host.

    #.  Upgrade kubelet.

    #.  Unlock the host.

    #.  Restore |VMs| (if applicable).

#.  Complete the Kubernetes version upgrade.

Systems with |prefix|-openstack application enabled could include additional
instance management steps. For more information, see :ref:`Kubernetes Version
Upgrade Operations Requiring Manual Migration
<kubernetes-update-operations-requiring-manual-migration>`.

On systems with |prefix|-openstack application, the *Kubernetes Version Upgrade
Orchestration Strategy* considers any configured server groups and host
aggregates when creating the stages in order to reduce the impact to running
instances. The *Kubernetes Version Upgrade Orchestration Strategy* automatically
manages the instances during the strategy application process. The instance
management options include **start-stop** or **migrate**.


.. _htb1590431033292-ul-vcp-dvs-tlb:

-   **start-stop**: Instances are stopped following the actual Kubernetes
    upgrade but before the lock operation and then automatically started again
    after the unlock completes. This is typically used for instances that do not
    support migration or for cases where migration takes too long. To ensure
    this does not impact the high-level service being provided by the instance,
    the instance\(s) should be protected and grouped into an anti-affinity
    server group\(s) with its standby instance.

-   **migrate**: Instances are moved off a host following the Kubernetes upgrade
    but before the host is locked. Instances with **Live Migration** support are
    **Live Migrated**. Otherwise, they are **Cold Migrated**.


.. _kubernetes-update-operations-requiring-manual-migration:

----------------------------------------
Manually Migrating Application Instances
----------------------------------------

On systems with the |prefix|-openstack application there may be some instances
that cannot be migrated automatically by orchestration. In these cases the
instance migration must be managed manually.

Do the following to manage the instance re-location manually:


.. _rbp1590431075472-ul-mgr-kvs-tlb:

-   Manually perform a Kubernetes version upgrade of at least one
    openstack-compute worker host. This assumes that at least one
    openstack-compute worker host does not have any instances, or has instances
    that can be migrated. For more information on manually updating a host, see
    :ref:`Manual Kubernetes Version Upgrade
    <manual-kubernetes-components-upgrade>`.

-   If the migration is prevented by limitations in the VNF or virtual
    application, perform the following:


    #.  Create new instances on an already upgraded openstack-compute worker
        host.

    #.  Manually migrate the data from the old instances to the new instances.

        .. note::
            This is specific to your environment and depends on the virtual
            application running in the instance.

    #.  Terminate the old instances.


-   If the migration is prevented by the size of the instances local disks, then
    for each openstack-compute worker host that has instances that cannot
    be migrated, manually move the instances using the CLI.

Once all openstack-compute worker hosts containing instances that cannot be
migrated have been Kubernetes-version upgraded, Kubernetes version upgrade
orchestration can be used to upgrade the remaining worker hosts.
