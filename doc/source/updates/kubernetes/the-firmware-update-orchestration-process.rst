
.. htb159043103329
.. _the-firmware-update-orchestration-process:

=========================================
The Firmware Update Orchestration Process
=========================================

For an orchestrated firmware update you need to first create a *Firmware Update
Orchestration Strategy*, or plan for the automated firmware update procedure.

You can customize the firmware update orchestration by specifying the following
parameters:

.. _htb1590431033292-ul-pdh-5ms-tlb:

-   the host types to be updated; only **worker-apply-type** is supported

-   the alarm restriction mode; **strict** or **relaxed** where the **relaxed**
    mode allows the strategy to be created while there are alarms present that are
    not management-affecting

-   the concurrency of the update process; whether to firmware update hosts
    **serially** or in **parallel**

-   the maximum number of worker hosts that can be updated together when
    **parallel** mode is selected


For hosts that have the stx-openstack application running with active instances
and since the firmware update is a reboot required operation for a host, the
strategy offers **stop/start** or **migrate** options for managing instances
over the **lock/unlock** \(reboot\) steps in the update process.

You must use the **sw-manager** |CLI| tool to **create**, and then **apply** the
update strategy. A created strategy can be monitored with the **show** command.
For more information, see :ref:`Firmware Update Orchestration Using the CLI
<firmware-update-orchestration-using-the-cli>`.

Firmware update orchestration automatically iterates through all
**unlocked-enabled** hosts on the system looking for hosts with the worker
function that need firmware update and then proceeds to update them on the
strategy :command:`apply` action.

.. note::
    Controllers in Storage or Standard systems are not subject to firmware
    updates. However, the controllers for an All-in-one \(|AIO|\)system can be
    updated because they contain the worker function. Whenever controllers are
    added to a strategy they are updated first; before the worker only hosts.

After creating the *Firmware Update Orchestration Strategy*, you can either
apply the entire strategy automatically, or manually apply individual stages to
control and monitor the firmware update progress one stage at a time.

When the firmware update strategy is **applied**, if the system is All-in-one,
the controllers are updated first, one after the other with a swact in between,
followed by the remaining worker hosts according to the selected worker apply
concurrency \(**serial** or **parallel**\) method.

The strategy creation default is to update the worker hosts serially unless the
**parallel** worker apply type option is specified which configures the
firmware update process for worker hosts to be in parallel \(up to a maximum
parallel number\) to reduce the overall firmware update installation time.

The firmware update strategy, with specified and default options is used to
create a reliable *Firmware Update Orchestration Strategy* that consists of a
number of execution stages. Each stage generally consists of installing the
firmware update while managing host instances, locking and then unlocking the
hosts for a subset of the worker function hosts on the system. The specific
steps involved in a firmware update for a single or group of hosts include:

.. _htb1590431033292-ol-a1b-v5s-tlb:

#.  Alarm Query – is an update pre-check.

#.  Firmware update – non-service affecting update that can take over 45 minutes.

#.  Lock Host.

#.  Unlock Host – reboots the host so the updated image is used.

Systems with stx-openstack application enabled could include additional
instance management steps. For more information, see :ref:`Firmware Update
Operations Requiring Manual Migration
<firmware-update-operations-requiring-manual-migration>`.

On systems with stx-openstack application, the *Firmware Update Orchestration
Strategy* considers any configured server groups and host aggregates when
creating the stages to reduce the impact to running instances. The *Firmware
Update Orchestration Strategy* automatically manages the instances during the
strategy application process. The instance management options include
**start-stop** or **migrate**.

.. _htb1590431033292-ul-vcp-dvs-tlb:

-   **start-stop**: where instances are stopped following the actual firmware
    update but before the lock operation and then automatically started again
    after the unlock completes. This is typically used for instances that do
    not support migration or for cases where migration takes too long. To
    ensure this does not impact the high-level service being provided by the
    instance, the instance\(s\) should be protected and grouped into an
    anti-affinity server group\(s\) with its standby instance.

-   **migrate**: where instances are moved off a host following the firmware
    update but before the host is locked. Instances with **Live Migration**
    support are **Live Migrated**. Otherwise, they are **Cold Migrated**.
