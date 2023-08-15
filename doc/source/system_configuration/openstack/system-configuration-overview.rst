
.. eqg1590091622329
.. _system-configuration-overview:

===========================================
Overview of Configuring StarlingX OpenStack
===========================================

|prod-os| is installed and managed as a system application.

See |prod| System Configuration: :ref:`Application Management
<system-config-helm-package-manager>`, for a description of the application
lifecycle commands for managing a system application.

System Applications are a set of one or more interdependent Application Helm
Charts. In the case of |prod|, there is generally a Helm Chart for every
OpenStack service.

.. parsed-literal::

    ~(keystone_admin)]$ system helm-override-list |prefix|-openstack
    +---------------------------+--------------------------------+
    | chart name                | overrides namespaces           |
    +---------------------------+--------------------------------+
    | barbican                  | [u'openstack']                 |
    | ceph-rgw                  | [u'openstack']                 |
    | cinder                    | [u'openstack']                 |
    | dcdbsync                  | [u'openstack']                 |
    | fm-rest-api               | [u'openstack']                 |
    | garbd                     | [u'openstack']                 |
    | glance                    | [u'openstack']                 |
    | heat                      | [u'openstack']                 |
    | horizon                   | [u'openstack']                 |
    | ingress                   | [u'kube-system', u'openstack'] |
    | ironic                    | [u'openstack']                 |
    | keystone                  | [u'openstack']                 |
    | keystone-api-proxy        | [u'openstack']                 |
    | libvirt                   | [u'openstack']                 |
    | mariadb                   | [u'openstack']                 |
    | memcached                 | [u'openstack']                 |
    | neutron                   | [u'openstack']                 |
    | nginx-ports-control       | []                             |
    | nova                      | [u'openstack']                 |
    | nova-api-proxy            | [u'openstack']                 |
    | openstack-helm-toolkit    | []                             |
    | openstack-psp-rolebinding | [u'openstack']                 |
    | openvswitch               | [u'openstack']                 |
    | placement                 | [u'openstack']                 |
    | rabbitmq                  | [u'openstack']                 |
    +---------------------------+--------------------------------+

    ..  lines below will be temporarily removed from table:
        | aodh                      | [u'openstack']                 |
        | ceilometer                | [u'openstack']                 |
        | gnocchi                   | [u'openstack']                 |
        | panko                     | [u'openstack']                 |


The attribute values of an OpenStack Service's Helm chart represents the
configurable parameters of the OpenStack Service. The OpenStack Services' helm
charts are defined upstream
here: `https://opendev.org/openstack/openstack-helm <https://opendev.org/openstack/openstack-helm>`__.
The specific attribute values supported by a helm chart can be found in the
values.yaml file under the particular OpenStack Service,
e.g. `https://opendev.org/openstack/openstack-helm/src/branch/master/nova/values.yaml <https://opendev.org/openstack/openstack-helm/src/branch/master/nova/values.yaml>`__.

After uploading the |prod| application, |prod| applies 'system' overrides
to the OpenStack helm charts, to specify a default configuration of
containerized |prod| on |prod|. To display those 'system' overrides:

.. parsed-literal::

    ~(keystone_admin)]$ system helm-override-show |prefix|-openstack nova openstack

You can specify helm overrides to update additional helm chart values and/or
modify the overrides made by the system. The command syntax is:

.. code-block:: none

    system helm-override-update [--reuse-values] [--reset-values] [--values <file_name>] [--set <commandline_overrides>] app-name chart-name namespace

The optional arguments are:

``--reuse-values``
    Determines if we should reuse existing helm chart user override values.
    If ``--reset-values`` is set, then this argument is ignored.

``--reset-values``
    Replace any existing helm chart overrides with the ones specified.

``--values <file_name>``
    Specify a YAML file containing helm chart override values. Can specify
    multiple times.

``--set <commandline_overrides>``
    Set helm chart override values on the command line. Multiple override
    values can be specified with multiple ``--set`` arguments. These are
    processed after ``--values`` files.

The updated overridden helm chart values are applied to the OpenStack
Application the next time |prefix|-openstack is run.

As some examples of using helm chart overrides to configure OpenStack services
of |prod|, the following sections show a few examples of some
typical configurable changes to |prod|.
