
.. cpy1552680695138
.. _deleting-an-alarm-using-the-cli:

=============================
Delete an Alarm Using the CLI
=============================

You can manually delete an alarm that is not automatically cleared by the
system.

.. rubric:: |context|

Manually deleting an alarm should not be done unless it is absolutely
clear that there is no reason for the alarm to be active.

You can use the command :command:`fm alarm-delete` to manually delete an alarm
that remains active/set for no apparent reason, which may happen in rare
conditions. Alarms usually clear automatically when the related trigger or
fault condition is corrected.

.. rubric:: |proc|

.. _deleting-an-alarm-using-the-cli-steps-clp-fzw-nkb:

-   To delete an alarm, use the :command:`fm alarm-delete` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-delete 4ab5698a-19cb-4c17-bd63-302173fef62c

    Substitute the UUID of the alarm you wish to delete.