
.. nie1614092105640
.. _remove-ptp-notifications:

========================
Remove PTP Notifications
========================

You can remove all pods and Kubernetes resources created during the application
deployment.

Use the following procedure to remove |PTP| notifications.

.. rubric:: |proc|

#.  Remove the ``ptp-notification`` application and verify the application
    status move backs to "uploaded" using the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove ptp-notification
        ~(keystone_admin)]$ system application-list

#.  Delete the ``ptp-notification`` and verify the application is removed from
    the application list.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete ptp-notification
        ~(keystone_admin)]$ system application-list

#.  Remove labels applied to controller-0, (repeat for each labelled host)
    using the following commands, for example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-label-remove <host name> ptp-notification
        ~(keystone_admin)]$ system host-label-remove <host name> ptp-registration


