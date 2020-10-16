
.. swo1591098193543
.. _creating-optional-telemetry-services:

==================================
Enable Optional Telemetry Services
==================================

By default in |prod-os|, Telemetry services are disabled. These
services are optional and includes Ceilometer \(Data collection service\),
Panko \(Event storage service\), Gnocchi
\(Time series metric storage service\), and Aodh \(Alarming service\).

You can use the following procedure to enable these optional telemetry
services on the active controller.

.. rubric:: |proc|

#.  To enable telemetry services, use the following command:

    .. code-block:: none

        $ system help helm-chart-attribute-modify

        Usage: system helm-chart-attribute-modify
                         [--enabled <true/false>]
                         <app name> <chart name> <namespace>

        Modify helm chart attributes. This function is provided to modify system
        behavioral attributes related to a chart. This does not modify a chart, nor
        does it modify chart overrides which are managed through the helm-override-
        update command.

        Positional arguments:
          <app name>            Name of the application
          <chart name>          Name of the chart
          <namespace>           Namespace of the chart

        Optional arguments:
          --enabled <true/false>
          Chart enabled.

    #.  Run the following command to enable Ceilometer service.

        .. parsed-literal::

            ~(keystone_admin)]$ system helm-chart-attribute-modify |prefix|-openstack ceilometer openstack --enabled true
            +------------+--------------------+
            | Property   | Value              |
            +------------+--------------------+
            | attributes | {u'enabled': True} |
            | name       | ceilometer         |
            | namespace  | openstack          |
            +------------+--------------------+

    #.  Run the following command to enable Gnocchi service.

        .. parsed-literal::

            ~(keystone_admin)]$ system helm-chart-attribute-modify |prefix|-openstack gnocchi openstack --enabled true
            +------------+--------------------+
            | Property   | Value              |
            +------------+--------------------+
            | attributes | {u'enabled': True} |
            | name       | gnocchi            |
            | namespace  | openstack          |
            +------------+--------------------+

    #.  Run the following command to enable Aodh service.

        .. parsed-literal::

            ~(keystone_admin)]$ system helm-chart-attribute-modify |prefix|-openstack aodh openstack --enabled true
            +------------+--------------------+
            | Property   | Value              |
            +------------+--------------------+
            | attributes | {u'enabled': True} |
            | name       | aodh               |
            | namespace  | openstack          |
            +------------+--------------------+

    #.  Run the following command to enable Panko service.

        .. parsed-literal::

            ~(keystone_admin)]$ system helm-chart-attribute-modify |prefix|-openstack panko openstack --enabled true
            +------------+--------------------+
            | Property   | Value              |
            +------------+--------------------+
            | attributes | {u'enabled': True} |
            | name       | panko              |
            | namespace  | openstack          |
            +------------+--------------------+

#.  Run the following command to verify that all services are enabled.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-list |prefix|-openstack -l
        +---------------------+--------------------------------+---------------+
        | chart name          | overrides namespaces           | chart enabled |
        +---------------------+--------------------------------+---------------+
        | aodh                | [u'openstack']                 | [True]        |
        | barbican            | [u'openstack']                 | [False]       |
        | ceilometer          | [u'openstack']                 | [True]        |
        | ceph-rgw            | [u'openstack']                 | [False]       |
        | cinder              | [u'openstack']                 | [True]        |
        | dcdbsync            | [u'openstack']                 | [True]        |
        | fm-rest-api         | [u'openstack']                 | [True]        |
        | garbd               | [u'openstack']                 | [True]        |
        | glance              | [u'openstack']                 | [True]        |
        | gnocchi             | [u'openstack']                 | [True]        |
        | heat                | [u'openstack']                 | [True]        |
        | helm-toolkit        | []                             | []            |
        | horizon             | [u'openstack']                 | [True]        |
        | ingress             | [u'kube-system', u'openstack'] | [True, True]  |
        | ironic              | [u'openstack']                 | [False]       |
        | keystone            | [u'openstack']                 | [True]        |
        | keystone-api-proxy  | [u'openstack']                 | [True]        |
        | libvirt             | [u'openstack']                 | [True]        |
        | mariadb             | [u'openstack']                 | [True]        |
        | memcached           | [u'openstack']                 | [True]        |
        | networking-avs      | [u'openstack']                 | [True]        |
        | neutron             | [u'openstack']                 | [True]        |
        | nginx-ports-control | []                             | []            |
        | nova                | [u'openstack']                 | [True]        |
        | nova-api-proxy      | [u'openstack']                 | [True]        |
        | openvswitch         | [u'openstack']                 | [True]        |
        | panko               | [u'openstack']                 | [True]        |
        | placement           | [u'openstack']                 | [True]        |
        | rabbitmq            | [u'openstack']                 | [True]        |
        | version_check       | []                             | []            |
        +---------------------+--------------------------------+---------------+

#.  To reapply these changes to the |prefix|-openstack application, run
    the following command.

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

    Once |prefix|-openstack is applied successfully, telemetry services
    will be available.

#.  Run the following helm command to verify the updates.

    .. code-block:: none

        ~(keystone_admin)]$ helm list | grep -E ceilometer|gnocchi|panko|aodh
