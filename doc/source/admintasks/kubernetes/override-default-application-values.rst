
.. bdx1614099833159
.. _override-default-application-values:

===================================
Override Default Application Values
===================================

You can override default application values using the commands described in this section.



.. rubric:: |proc|


#.  View existing values.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show ptp-notification
        ptp-notification notification

#.  Create a yaml file and update the fields that require Helm overrides.

    .. code-block:: none

        cat ~/override.yaml
        ptptracking:
         device:
           holdover_seconds: 25
           poll_freq_seconds: 2

#.  Apply the values.

    Application values can be added by the user and applied, using the following commands.

    .. note::
        The application could be in the "uploaded" or "applied" state.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update ptp-notification ptp-notification notification -–values <override.yaml>

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply ptp-notification

    where the values are:

    **simulated**
        value must be 'false' for a normal operation \(used only for troubleshooting\).

    **holdover_seconds**
        value is the holdover time provided by the |NIC| specification. The default is 15 seconds.

    **poll_freq_seconds**
        is the frequency that the tracking function monitors the ``ptp4l`` to
        derive the |PTP| sync state. The default is 2 seconds.


