
.. noc1590162360081
.. _configure-firmware-update-orchestration:

=======================================
Configure Firmware Update Orchestration
=======================================

You can configure *Firmware Update Orchestration Strategy* using the
:command:`sw-manager` |CLI|.

.. note::
    Management-affecting alarms cannot be ignored using relaxed alarm rules
    during an orchestrated firmware update operation. For a list of
    management-affecting alarms, see |fault-doc|:
    :ref:`Alarm Messages <100-series-alarm-messages-starlingx>`. To display
    management-affecting active alarms, use the following command:

.. code-block:: none

    ~(keystone_admin)$ fm alarm-list --mgmt_affecting

During an orchestrated firmware update operation, the following alarms are
ignored even when the default strict restrictions are selected:

.. _noc1590162360081-ul-vhg-jxs-tlb:

-   200.001: Maintenance host lock alarm

-   280.002: Subcloud resource out-of-sync

-   700.004: VM stopped

-   900.301: Firmware update auto apply in progress

.. rubric:: |prereq|

.. _noc1590162360081-ul-ls2-pxs-tlb:

-   Hosts that need to be updated must be in the ``unlocked-enabled`` state.

-   The firmware update image must be in the ``applied`` state. For more
    information, see :ref:`Managing Software Updates <managing-software-updates>`.

.. rubric:: |proc|

#.  Create the strategy.

    The *Firmware Update Orchestration Strategy* :command:`create` command
    creates a series of stages with steps that apply the firmware update to the
    hardware.

    Firmware update requires a reboot. Therefore, the created strategy includes
    steps that automatically lock and unlock the host to bring the new image
    function into service.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager fw-update-strategy create
        Strategy Firmware Update Strategy:
          strategy-uuid:                          3e43c018-9c75-4ba8-a276-472c3bcbb268
          controller-apply-type:                  ignore
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          build
          current-phase-completion:               0%
          state:                                  building
          inprogress:                             true

#.  |Optional| Display the strategy in summary, if required. The firmware update
    strategy :command:`show` command displays the strategy in a summary.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager fw-update-strategy show
        Strategy Firmware Update Strategy:
          strategy-uuid:                          3e43c018-9c75-4ba8-a276-472c3bcbb268
          controller-apply-type:                  ignore
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          build
          current-phase-completion:               100%
          state:                                  ready-to-apply
          build-result:                           success

    The strategy steps and stages are displayed using the ``--details`` option.

#.  Apply the strategy.

    *Firmware Update Orchestration Strategy* :command:`apply` command executes
    the strategy stages and steps consecutively until the firmware update on
    all the hosts in the strategy is complete.


    -   Use the ``-stage-id`` option to specify a specific stage to apply; one
        at a time.

        .. note::
            When applying a single stage, only the next stage will be applied;
            you cannot skip stages.


    .. code-block:: none

        ~(keystone_admin)$ sw-manager fw-update-strategy apply
        Strategy Firmware Update Strategy:
          strategy-uuid:                          3e43c018-9c75-4ba8-a276-472c3bcbb268
          controller-apply-type:                  ignore
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          apply
          current-phase-completion:               0%
          state:                                  applying
          inprogress:                             true


    -   Use the :command:`show` command to monitor firmware update state and
        percentage completion.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager fw-update-strategy show
        Strategy Firmware Update Strategy:
          strategy-uuid:                          3e43c018-9c75-4ba8-a276-472c3bcbb268
          controller-apply-type:                  ignore
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          apply
          current-phase-completion:               50%
          state:                                  applying
          inprogress:                             true

#.  |optional| Abort the strategy, if required. This is only used to stop, and
    abort the entire strategy.

    The firmware update strategy :command:`abort` command can be used to abort
    the firmware update strategy after the current step of the currently
    applying stage is completed.

#.  Delete the strategy.

    .. note::
        After the *Firmware Update Orchestration Strategy* has been applied
        \(or aborted\) it must be deleted before another firmware update
        strategy can be created. If a firmware update strategy application
        fails, you must address the issue that caused the failure, then
        delete and re-create the strategy before attempting to apply it
        again.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager fw-update-strategy delete
        Strategy deleted.

For more information see :ref:`Firmware Update Orchestration Using the CLI
<firmware-update-orchestration-using-the-cli>`.
