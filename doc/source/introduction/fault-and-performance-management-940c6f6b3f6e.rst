.. _fault-and-performance-management-940c6f6b3f6e:

=================================
 Performance and Fault Management
=================================

|prod| provides a number of tools to allow system administrators to manage
performance and troubleshoot system issues.

Performance Management
----------------------

|prod| utilizes collectd ( https://collectd.org/ ) to capture the following
platform statistics and to generate threshold events based on
these statistics:

-    CPU Usage of Platform Cores of |prod| hosts

-    Platform Memory Usage of |prod| hosts

-    Platform File Systems Usage 

-    Platform Interface Usage

-    PTP Clock Skew Monitor

Any collectd threshold events trigger |prod| fault management Set/Clear
Customer Alarms.

Fault Management
----------------

For an overview of |prod| fault management, see
:ref:`fault-management-overview`.

For a listing of all |prod| fault management resources, including alarm log
messages, see 'Alarm messages' and 'Log messages' in the :ref:`Fault Management
Contents <index-fault-kub-f45ef76b6f16>` page.