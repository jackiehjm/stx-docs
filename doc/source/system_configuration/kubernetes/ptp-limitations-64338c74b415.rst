.. _ptp-limitations-64338c74b415:

===============
PTP Limitations
===============

NICs using the Intel ICE NIC driver may report the following in the `ptp4l``
logs, which might coincide with a |PTP| port switching to ``FAULTY`` before
re-initializing.

.. code-block:: none

    ptp4l[80330.489]: timed out while polling for tx timestamp
    ptp4l[80330.489]: increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug

This is due to a limitation of the Intel ICE driver. The recommended workaround
is to set the ``tx_timestamp_timeout`` parameter to 700 (ms) in the ``ptp4l``
config.

.. code-block:: none

    ~(keystone_admin)]$ system ptp-instance-parameter-add ptp-inst1 tx_timestamp_timeout=700