
.. uxo1579788086872
.. _alarm-messages-700s:

=====================
Alarm Messages - 700s
=====================

.. include:: ../../_includes/openstack-alarm-messages-xxxs.rest

.. _alarm-messages-700s-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.001**
     - Instance <instance\_name> owned by <tenant\_name> has failed on host
       <host\_name>

       Instance <instance\_name> owned by <tenant\_name> has failed to
       schedule
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - The system will attempt recovery; no repair action required.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.002**
     - Instance <instance\_name> owned by <tenant\_name> is paused on host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Unpause the instance.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.003**
     - Instance <instance\_name> owned by <tenant\_name> is suspended on host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Resume the instance.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.004**
     - Instance <instance\_name> owned by <tenant\_name> is stopped on host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Start the instance.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.005**
     - Instance <instance\_name> owned by <tenant\_name> is rebooting on host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for reboot to complete; if problem persists contact next level of
       support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.006**
     - Instance <instance\_name> owned by <tenant\_name> is rebuilding on host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for rebuild to complete; if problem persists contact next level of
       support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.007**
     - Instance <instance\_name> owned by <tenant\_name> is evacuating from host
       <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for evacuate to complete; if problem persists contact next level of
       support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.008**
     - Instance <instance\_name> owned by <tenant\_name> is live migrating from
       host <host\_name>
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - W\*
   * - Proposed Repair Action
     - Wait for live migration to complete; if problem persists contact next
       level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.009**
     - Instance <instance\_name> owned by <tenant\_name> is cold migrating from
       host <host\_name>
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for cold migration to complete; if problem persists contact next
       level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.010**
     - Instance <instance\_name> owned by <tenant\_name> has been cold-migrated
       to host <host\_name> waiting for confirmation.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Confirm or revert cold-migrate of instance.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.011**
     - Instance <instance\_name> owned by <tenant\_name> is reverting cold
       migrate to host <host\_name>
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for cold migration revert to complete; if problem persists contact
       next level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.012**
     - Instance <instance\_name> owned by <tenant\_name> is resizing on host
       <host\_name>
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for resize to complete; if problem persists contact next level of
       support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.013**
     - Instance <instance\_name> owned by <tenant\_name> has been resized on
       host <host\_name> waiting for confirmation.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Confirm or revert resize of instance.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.014**
     - Instance <instance\_name> owned by <tenant\_name> is reverting resize
       on host <host\_name>.
   * - Entity Instance
     - tenant=<tenant-uuid>.instance=<instance-uuid>
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for resize revert to complete; if problem persists contact next
       level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.016**
     - Multi-Node Recovery Mode
   * - Entity Instance
     - subsystem=vim
   * - Severity:
     - m\*
   * - Proposed Repair Action
     - Wait for the system to exit out of this mode.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 700.017**
     - Server group <server\_group\_name> <policy> policy was not satisfied.
   * - Entity Instance
     - server-group<server-group-uuid>
   * - Severity:
     - M
   * - Proposed Repair Action
     - Migrate instances in an attempt to satisfy the policy; if problem
       persists contact next level of support.