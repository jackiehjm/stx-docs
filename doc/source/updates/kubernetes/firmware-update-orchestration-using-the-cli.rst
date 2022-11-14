
.. tsr1590164474201
.. _firmware-update-orchestration-using-the-cli:

===========================================
Firmware Update Orchestration Using the CLI
===========================================

You can configure the *Firmware Update Orchestration Strategy* using the
:command:`sw-manager`` |CLI| commands.

---------------
About this task
---------------

.. note::

    You require administrator privileges to use :command:`sw-manager` commands.
    You must log in to the active controller as **user sysadmin** and source the
    script by using the command, source ``/etc/platform/openrc`` to obtain
    administrator privileges. Do not use sudo.

.. note::
    Management-affecting alarms cannot be ignored at the indicated severity
    level or higher by using relaxed alarm rules during an orchestrated
    firmware update operation. For a list of management-affecting alarms, see
    |fault-doc|: :ref:`Alarm Messages
    <100-series-alarm-messages-starlingx>`. To display management-affecting active
    alarms, use the following command:

    .. code-block:: none

       ~(keystone_admin)$ fm alarm-list --mgmt_affecting

During an orchestrated firmware update operation, the following alarms are
ignored even when strict restrictions are selected:

.. _tsr1590164474201-ul-hq4-nkt-tlb:

-   200.001: Maintenance host lock alarm

-   280.002: Subcloud resource out-of-sync

-   700.004: VM stopped

-   900.301: Firmware update auto apply in progress

You can use ``help`` for the overall commands and also for each sub-command. For
example:

.. code-block:: none

    ~(keystone_admin)$ sw-manager fw-update-strategy –help
    usage: sw-manager fw-update-strategy [-h]  ...
    optional arguments:
    -h, --help  show this help message and exit
    Firmware Update Commands:
        create    Create a strategy
        delete    Delete a strategy
        apply     Apply a strategy
        abort     Abort a strategy
        show      Show a strategy

.. _tsr1590164474201-section-edz-4p5-tlb:

---------------------------------------------
Firmware update orchestration strategy create
---------------------------------------------

The :command:`create` strategy subcommand with no options specified creates a
firmware update strategy with default settings. A firmware update strategy can
be created with override worker apply type concurrency with a max host
parallelism, instance action, and alarm restrictions.

``--controller-apply-type`` and ``--storage-apply-type``
   These options cannot be changed from ``ignore`` because firmware update is
   only supported for worker hosts.

   .. note::
       Firmware update is currently only supported for hosts with worker
       function. Any attempt to modify the controller or storage apply type is
       rejected.

``--worker-apply-type``
   This option specifies the host concurrency of the firmware update strategy:

   -   ``serial`` \(default\): worker hosts will be patched one at a time
   
   -   ``parallel``: worker hosts will be updated in parallel
   
       -   At most, ``parallel`` will be updated at the same time
   
       -   At most, half of the hosts in a host aggregate will be updated at the
           same time
   
   -   ``ignore``: worker hosts will not be updated; strategy create will fail

   Worker hosts with no instances are updated before worker hosts with
   instances.

``--max-parallel-worker-hosts``
   This option applies to the parallel worker apply type selection to specify
   the maximum worker hosts to update in parallel \(minimum: 2, maximum: 10\).

``-–instance-action``
   This option only has significance when the |prefix|-openstack application is
   loaded and there are instances running on worker hosts. It specifies how the
   strategy deals with worker host instances over the strategy execution.

   -   ``stop-start`` (default)
   
       Instances will be stopped before the host lock operation following the
       update and then started again following the host unlock.
   
       .. warning::
           Using the ``stop-start`` option will result in an outage for each
           instance, as it is stopped while the worker host is locked/unlocked. In
           order to ensure this does not impact service, instances MUST be grouped
           into anti-affinity \(or anti-affinity best effort\) server groups,
           which will ensure that only a single instance in each server group is
           stopped at a time.
   
   -   ``migrate``
   
       Instances will be migrated off a host before it is patched \(this applies
       to reboot patching only\).

``--alarm-restrictions``
   This option sets how the how the firmware update orchestration behaves when
   alarms are present.

   To display management-affecting active alarms, use the following command:
   
   .. code-block:: none
   
       ~(keystone_admin)$ fm alarm-list --mgmt_affecting
   
   -   ``strict`` (default)
   
       The default strict option will result in patch orchestration failing if
       there are any alarms present in the system \(except for a small list of
       alarms\).
   
   -   ``relaxed``
   
       This option allows orchestration to proceed if alarms are present, as long
       as none of these alarms are management affecting.

   .. code-block:: none
   
       ~(keystone_admin)]$ sw-manager fw-update-strategy create --help
       usage:sw-manager fw-update-strategy create  [-h]
                                                   [--controller-apply-type {ignore}]
                                                   [--storage-apply-type {ignore}]
                                                   [--worker-apply-type
                                                   {serial,parallel,ignore}]
                                                   [--max-parallel-worker-hosts
                                                   {2,3,4,5,6,7,8,9,10}]
                                                   [--instance-action {migrate,stop-start}]
                                                   [--alarm-restrictions {strict,relaxed}]
   
       optional arguments:
       -h, --help            show this help message and exit
       --controller-apply-type {ignore}
                               defaults to ignore
       --storage-apply-type {ignore}
                               defaults to ignore
       --worker-apply-type {serial,parallel,ignore}
                               defaults to serial
       --max-parallel-worker-hosts {2,3,4,5,6,7,8,9,10}
                               maximum worker hosts to update in parallel
       --instance-action {migrate,stop-start}
                               defaults to stop-start
       --alarm-restrictions {strict,relaxed}
                               defaults to strict
   
   
.. _tsr1590164474201-section-l3x-wr5-tlb:

-------------------------------------------
Firmware update orchestration strategy show
-------------------------------------------

The ``show`` strategy subcommand displays a summary of the current state
of the strategy. A complete view of the strategy can be shown using the
``--details`` option.

.. code-block:: none

    ~(keystone_admin)]$ sw-manager fw-update-strategy show --help
    usage: sw-manager fw-update-strategy show [-h] [--details]

    optional arguments:
    -h, --help  show this help message and exit
    --details   show strategy details

.. _tsr1590164474201-section-ecp-2s5-tlb:

--------------------------------------------
Firmware update orchestration strategy apply
--------------------------------------------

The ``apply`` strategy subcommand with no options executes the firmware update
strategy from current state to the end. The apply strategy operation can be
called with the ``stage-id`` option to execute the next stage of the strategy.
The ``stage-id`` option cannot be used to execute the strategy out of order.

.. code-block:: none

    ~(keystone_admin)]$ sw-manager fw-update-strategy apply --help
    usage: sw-manager fw-update-strategy apply [-h] [--stage-id STAGE_ID]

    optional arguments:
    -h, --help           show this help message and exit
    --stage-id STAGE_ID  stage identifier to apply

.. _tsr1590164474201-section-lmp-ks5-tlb:

--------------------------------------------
Firmware update orchestration strategy abort
--------------------------------------------

The ``abort`` strategy subcommand with no options sets the strategy to abort
after the current applying stage is complete. The abort strategy operation can
be called with the ``stage-id`` option to specify that the strategy abort before
executing the next stage of the strategy. The ``stage-id`` option cannot be used
to execute the strategy out of order.

.. code-block:: none

    ~(keystone_admin)]$ sw-manager fw-update-strategy abort --help
    usage: sw-manager fw-update-strategy abort [-h] [--stage-id STAGE_ID]

    optional arguments:
    -h, --help           show this help message and exit
    --stage-id STAGE_ID  stage identifier to abort

.. _tsr1590164474201-section-z5b-qs5-tlb:

---------------------------------------------
Firmware update orchestration strategy delete
---------------------------------------------

The ``delete`` strategy subcommand with no options deletes a strategy.

.. code-block:: none

    ~(keystone_admin)]$sw-manager fw-update-strategy delete --help
    usage: sw-manager fw-update-strategy delete [-h]

    optional arguments:
    -h, --help  show this help message and exit

