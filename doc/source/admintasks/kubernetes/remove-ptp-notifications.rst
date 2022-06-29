
.. nie1614092105640
.. _remove-ptp-notifications:

========================
Remove PTP Notifications
========================

You can remove all pods and Kubernetes resources created during the application
deployment.


Use the following procedure to remove |PTP| notifications.


.. rubric:: |proc|


.. _remove-ptp-notifications-steps-klx-gnf-t4b:

#.  Remove all pods and other Kubernetes resources created during the
    deployment, using the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove ptp-notification

#.  Delete the ptp-notification from sysinv.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete ptp-notification

#.  Remove labels applied to controller-0, using the following commands, for example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-label-remove controller-0 ptp-notification
        ~(keystone_admin)]$ system host-label-remove controller-0 ptp-registration


