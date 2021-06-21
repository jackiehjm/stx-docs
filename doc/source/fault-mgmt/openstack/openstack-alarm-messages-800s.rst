
.. tsh1579788106505
.. _alarm-messages-800s:

=====================
Alarm Messages - 800s
=====================

.. include:: /_includes/openstack-alarm-messages-xxxs.rest

.. _alarm-messages-800s-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 800.002**
     - Image storage media is full: There is not enough disk space on the image storage media.

       or

       Instance <instance name\> snapshot failed: There is not enough disk space on the image storage media.

       or

       Supplied <attrs\> \(<supplied\>\) and <attrs\> generated from uploaded image \(<actual\>\) did not match. Setting image status to 'killed'.

       or

       Error in store configuration. Adding images to store is disabled.

       or

       Forbidden upload attempt: <exception\>

       or

       Insufficient permissions on image storage media: <exception\>

       or

       Denying attempt to upload image larger than <size\> bytes.

       or

       Denying attempt to upload image because it exceeds the quota: <exception\>

       or

       Received HTTP error while uploading image <image\_id\>

       or

       Client disconnected before sending all data to backend

       or

       Failed to upload image <image\_id\>
   * - Entity Instance
     - image=<image-uuid>, instance=<instance-uuid>

       or

       image=<tenant-uuid>, instance=<instance-uuid>
   * - Severity:
     - W\*
   * - Proposed Repair Action
     - If problem persists, contact next level of support.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 800.100**
     - Storage Alarm Condition:

       Cinder I/O Congestion is above normal range and is building
   * - Entity Instance
     - cinder\_io\_monitor
   * - Severity:
     - M
   * - Proposed Repair Action
     - Reduce the I/O load on the Cinder LVM backend. Use Cinder QoS mechanisms on high usage volumes.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 800.101**
     - Storage Alarm Condition:

       Cinder I/O Congestion is high and impacting guest performance
   * - Entity Instance
     - cinder\_io\_monitor
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Reduce the I/O load on the Cinder LVM backend. Cinder actions may fail until congestion is reduced. Use Cinder QoS mechanisms on high usage volumes.
