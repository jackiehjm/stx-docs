
.. xqd1614091832213
.. _install-ptp-notifications:

=========================
Install PTP Notifications
=========================

|PTP| notification is packaged as an Armada system application and is managed
using the :command:`system application` and :command:`system-helm-override`
commands.


.. rubric:: |context|


|prod| provides the capability for application\(s\) to subscribe to
asynchronous |PTP| status notifications and pull for the |PTP| state on demand.

.. rubric:: |prereq|


.. _install-ptp-notifications-ul-ydy-ggf-t4b:

-   The |PTP| port must be configured as Subordinate mode \(Slave mode\). For
    more information, see,

.. xbooklink :ref:`|prod-long| System Configuration
    <system-configuration-management-overview>`:


-   :ref:`Configuring PTP Service Using Horizon <configuring-ptp-service-using-horizon>`

-   :ref:`Configuring PTP Service Using the CLI <configuring-ptp-service-using-the-cli>`


.. rubric:: |proc|


Use the following steps to install the **ptp-notification** application.


#.  Label the controller\(s\).


    #.  Source the platform environment.

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$

    #.  Assign the |PTP| registration label to the controller\(s\).

        .. code-block:: none

            ~(keystone_admin)]$ system host-label-assign controller-0 ptp-registration=true
            ~(keystone_admin)]$ system host-label-assign controller-1 ptp-registration=true

    #.  Assign the |PTP| notification label to the node that is configured with
        a Slave |PTP| port. For example:

        .. code-block:: none

            ~(keystone_admin)]$ system host-label-assign controller-0 ptp-notification=true


#.  Upload the |PTP| application using the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/ptp-notification-1.0-26.tgz

#.  Verify the |PTP| application has been uploaded.

    .. code-block:: none

        ~(keystone_admin)]$ system application-list

#.  Apply the |PTP| notification application.

    .. code-block:: none

        $ system application-apply ptp-notification

#.  Monitor the status.

    .. code-block:: none

        $ watch –n 5 system application-list

    and/or

    .. code-block:: none

        $ watch kubectl get pods –n notification

    The default configuration for |PTP| notification pod is:


    -   |PTP|-notification pod:


        -   Runs as a daemonset \(1 pod per node with label **ptp-notification=true**\)


    -   Three containers:


        -   ptp-notification-rabbitmq

        -   ptp-notification-location

        -   ptp-notification-ptptracking


    -   Registration pod:


        -   Runs as a deployment on nodes labeled with **ptp-registration=true**

        -   Replica count of 1

        -   One container: Rabbitmq




