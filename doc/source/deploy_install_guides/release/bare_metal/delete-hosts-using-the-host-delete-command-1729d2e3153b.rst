.. _delete-hosts-using-the-host-delete-command-1729d2e3153b:

===================================
Delete Hosts Using the Command Line
===================================

You can delete hosts from the system inventory using the :command:`host-delete` command.

.. rubric:: |proc|

#.  Check for alarms related to the host.

    Use the :command:`fm alarm-list` command to check for any alarms (major
    or critical events). You can also type :command:`fm event-list` to see a log
    of events. For more information on alarms, see :ref:`Fault Management
    Overview <fault-management-overview>`.

#.  Lock the host that will be deleted.

    Use the :command:`system host-lock` command. Only locked hosts can be deleted.

#.  Delete the host from the system inventory.

    Use the command :command:`system host-delete`. This command accepts one 
    parameter: the hostname or ID. Make sure that the remaining hosts have 
    sufficient capacity and workload to account for the deleted host.

#.  Verify that the host has been deleted successfully.

    Use the :command:`fm alarm-list` command to check for any alarms (major
    or critical events). You can also type :command:`fm event-list` to see a log
    of events. For more information on alarms, see :ref:`Fault Management
    Overview <fault-management-overview>`.
