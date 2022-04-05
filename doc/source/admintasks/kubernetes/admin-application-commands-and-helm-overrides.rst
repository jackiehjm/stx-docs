
.. hby1568295041837
.. _admin-application-commands-and-helm-overrides:

=======================================
Application Commands and Helm Overrides
=======================================

Use |prod| :command:`system application` and :command:`system helm-override`
commands to manage containerized applications provided as part of |prod|.

.. note::
    Application commands and Helm overrides apply to **user overrides** only
    and take precedence over system overrides.

.. rubric:: |proc|

-   Use the following command to list all containerized applications provided
    as part of |prod|.

    .. code-block:: none

        ~(keystone_admin)]$ system application-list [--nowrap]

    where:

    **nowrap**
        Prevents line wrapping of the output.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-list --nowrap

        +--------------+---------+---------------+----------------+----------+-----------+
        | application  | version | manifest name | manifest file  | status   | progress  |
        +--------------+---------+---------------+----------------+----------+-----------+
        | platform-    | 1.0-7   | platform-     | manifest.yaml  | applied  | completed |
        | integ-apps   |         | integration-  |                |          |           |
        |              |         | manifest      |                |          |           |
        | |prefix|-|s|         | 1.0-18  | armada-       | |prefix|- |s|          | uploaded | completed |
        | openstack    |         | manifest      | openstack.yaml |          |           |
        +--------------+---------+---------------+----------------+----------+-----------+

-   Use the following command to show details for |prod|.

    .. code-block:: none

        ~(keystone_admin)]$ system application-show <app_name>

    where:

    **<app_name>**
        The name of the application to show details.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-show |prefix|-openstack

        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-18                           |
        | created_at    | 2019-09-06T15:34:03.194150+00:00 |
        | manifest_file | |prefix|-openstack.yaml   |s|            |
        | manifest_name | armada-manifest                  |
        | name          | |prefix|-openstack   |s|                 |
        | progress      | completed                        |
        | status        | uploaded                         |
        | updated_at    | 2019-09-06T15:34:46.995929+00:00 |
        +---------------+----------------------------------+

-   Use the following command to upload application Helm chart\(s\) and
    manifest.

    .. code-block:: none

        ~(keystone_admin)]$ system application-upload [-n | --app-name] <app_name> [-v | --version] <version> <tar_file>

    where the following are optional arguments:

    **<app_name>**
        Assigns a custom name for application. You can use this name to
        interact with the application in the future.

    **<version>**
        The version of the application.

    and the following is a positional argument:

    **<tar_file>**
        The path to the tar file containing the application to be uploaded.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-upload |prefix|-openstack-1.0-18.tgz
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-18                           |
        | created_at    | 2019-09-06T15:34:03.194150+00:00 |
        | manifest_file | |prefix|-openstack.yaml  |s|             |
        | manifest_name | armada-manifest                  |
        | name          | |prefix|-openstack       |s|             |
        | progress      | None                             |
        | status        | uploading                        |
        | updated_at    | None                             |
        +---------------+----------------------------------+
        Please use 'system application-list' or 'system application-show |prefix|-openstack'
        to view the current progress.

-   To list the Helm chart overrides for the |prod|, use the following
    command:

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-list
        usage: system helm-override-list [--nowrap] [-l | --long] <app_name>

    where the following is a positional argument:

    **<app_name>**
        The name of the application.

    and the following is an optional argument:

    **nowrap**
        No word-wrapping of output.

    **long**
        List additional fields in output.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-list |prefix|-openstack --long
        +---------------------+--------------------------------+---------------+
        | chart name          | overrides namespaces           | chart enabled |
        +---------------------+--------------------------------+---------------+
        | barbican            | [u'openstack']                 | [False]       |
        | ceph-rgw            | [u'openstack']                 | [False]       |
        | cinder              | [u'openstack']                 | [True]        |
        | garbd               | [u'openstack']                 | [True]        |
        | glance              | [u'openstack']                 | [True]        |
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
        | neutron             | [u'openstack']                 | [True]        |
        | nginx-ports-control | []                             | []            |
        | nova                | [u'openstack']                 | [True]        |
        | nova-api-proxy      | [u'openstack']                 | [True]        |
        | openvswitch         | [u'openstack']                 | [True]        |
        | placement           | [u'openstack']                 | [True]        |
        | rabbitmq            | [u'openstack']                 | [True]        |
        | version_check       | []                             | []            |
        +---------------------+--------------------------------+---------------+

    ..  lines below will be temporarily removed from table:
        | aodh                | [u'openstack']                 | [False]       |
        | ceilometer          | [u'openstack']                 | [False]       |
        | gnocchi             | [u'openstack']                 | [False]       |
        | panko               | [u'openstack']                 | [False]       |

-   To show the overrides for a particular chart, use the following command.
    System overrides are displayed in the **system_overrides** section of
    the **Property** column.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show
        usage: system helm-override-show <app_name> <chart_name> <namespace>

    where the following are positional arguments:

    **<app_name>**
        The name of the application.

    **<chart_name>**
        The name of the chart.

    **<namespace>**
        The namespace for chart overrides.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-show |prefix|-openstack glance openstack

-   To modify service configuration parameters using user-specified overrides,
    use the following command. To update a single configuration parameter, you
    can use :command:`--set`. To update multiple configuration parameters, use
    the :command:`--values` option with a **yaml** file.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update
        usage: system helm-override-update <app_name> <chart_name> <namespace> --reuse-values --reset-values --values <file_name> --set <commandline_overrides>

    where the following are positional arguments:

    **<app_name>**
        The name of the application.

    **<chart_name>**
        The name of the chart.

    **<namespace>**
        The namespace for chart overrides.

    and the following are optional arguments:

    **reuse-values**
        Reuse existing Helm chart user override values. This argument is
        ignored if **reset-values** is used.

    **reset-values**
        Replace any existing Helm chart overrides with the ones specified.

    **values**
        Specify a **yaml** file containing Helm chart override values. You can
        specify this value multiple times.

    **set**
        Set Helm chart override values using the command line. Multiple
        override values can be specified with multiple :command:`set`
        arguments. These are processed after files passed through the
        values argument.

    For example, to enable the glance debugging log, use the following
    command:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack
        glance openstack --set conf.glance.DEFAULT.DEBUG=true
        +----------------+-------------------+
        | Property       | Value             |
        +----------------+-------------------+
        | name           | glance            |
        | namespace      | openstack         |
        | user_overrides | conf:             |
        |                |   glance:         |
        |                |     DEFAULT:      |
        |                |       DEBUG: true |
        +----------------+-------------------+

    The user overrides are shown in the **user_overrides** section of the
    **Property** column.

    .. note::
        To apply the updated Helm chart overrides to the running application,
        use the :command:`system application-apply` command.

-   To enable or disable the installation of a particular Helm chart within an
    application manifest, use the :command:`helm-chart-attribute-modify`
    command. This command does not modify a chart or modify chart overrides,
    which are managed through the :command:`helm-override-update` command.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-chart-attribute-modify [--enabled <true/false>] <app_name> <chart_name> <namespace>

    where the following is an optional argument:

    **enabled**
        Determines whether the chart is enabled.

    and the following are positional arguments:

    **<app_name>**
        The name of the application.

    **<chart_name>**
        The name of the chart.

    **<namespace>**
        The namespace for chart overrides.

    .. note::
        To apply the updated Helm chart attribute to the running application,
        use the :command:`system application-apply` command.

-   To delete all the user overrides for a chart, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-delete
        usage: system helm-override-delete <app_name> <chart_name> <namespace>

    where the following are positional arguments:

    **<app_name>**
        The name of the application.

    **<chart_name>**
        The name of the chart.

    **<namespace>**
        The namespace for chart overrides.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-delete |prefix|-openstack glance openstack
        Deleted chart overrides glance:openstack for application |prefix|-openstack

-   Use the following command to apply or reapply an application, making it
    available for service.

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply [-m | --mode] <mode> <app_name>

    where the following is an optional argument:

    **mode**
        An application-specific mode controlling how the manifest is
        applied. This option is used to delete and restore the
        |prefix|-openstack application.

    and the following is a positional argument:

    **<app_name>**
        The name of the application to apply.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-18                           |
        | created_at    | 2019-09-06T15:34:03.194150+00:00 |
        | manifest_file | |prefix|-openstack.yaml  |s|             |
        | manifest_name | armada-manifest                  |
        | name          | |prefix|-openstack       |s|             |
        | progress      | None                             |
        | status        | applying                         |
        | updated_at    | 2019-09-06T15:34:46.995929+00:00 |
        +---------------+----------------------------------+
        Please use 'system application-list' or 'system application-show |prefix|-openstack'
        to view the current progress.

-   Use the following command to abort the current application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-abort <app_name>

    where:

    **<app_name>**
        The name of the application to abort.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-abort |prefix|-openstack
        Application abort request has been accepted. If the previous operation has not
        completed/failed, it will be cancelled shortly.

    Use :command:`application-list` to confirm that the application has been
    aborted.

-   Use the following command to update the deployed application to a different
    version.

    .. code-block:: none

        ~(keystone_admin)]$ system application-update [-n | --app-name] <app_name> [-v | --app-version] <version> <tar_file>

    where the following are optional arguments:

    **<app_name>**
        The name of the application to update.

        You can look up the name of an application using the
        :command:`application-list` command:

        .. code-block:: none

            ~(keystone_admin)]$ system application-list
            +--------------------------+----------+-------------------------------+---------------------------+----------+-----------+
            | application              | version  | manifest name                 | manifest file             | status   | progress  |
            +--------------------------+----------+-------------------------------+---------------------------+----------+-----------+
            | cert-manager             | 20.06-4  | cert-manager-manifest         | certmanager-manifest.yaml | applied  | completed |
            | nginx-ingress-controller | 20.06-1  | nginx-ingress-controller-     | nginx_ingress_controller  | applied  | completed |
            |                          |          | -manifest                     | _manifest.yaml            |          |           |
            | oidc-auth-apps           | 20.06-26 | oidc-auth-manifest            | manifest.yaml             | uploaded | completed |
            | platform-integ-apps      | 20.06-9  | platform-integration-manifest | manifest.yaml             | applied  | completed |
            | wr-analytics             | 20.06-2  | analytics-armada-manifest     | wr-analytics.yaml         | applied  | completed |
            +--------------------------+----------+-------------------------------+---------------------------+----------+-----------+

        The output indicates that the currently installed version of
        **cert-manager** is 20.06-4.

    **<version>**
        The version to update the application to.

    and the following is a positional argument which must come last:

    **<tar_file>**
        The tar file containing the application manifest, Helm charts and
        configuration file.

-   Use the following command to remove an application from service. Removing
    an application will clean up related Kubernetes resources and delete all
    of its installed Helm charts.

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove <app_name>

    where:

    **<app_name>**
        The name of the application to remove.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-remove |prefix|-openstack
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-18                           |
        | created_at    | 2019-09-06T15:34:03.194150+00:00 |
        | manifest_file | |prefix|-openstack.yaml   |s|            |
        | manifest_name | armada-manifest                  |
        | name          | |prefix|-openstack       |s|             |
        | progress      | None                             |
        | status        | removing                         |
        | updated_at    | 2019-09-06T17:39:19.813754+00:00 |
        +---------------+----------------------------------+
        Please use 'system application-list' or 'system application-show |prefix|-openstack'
        to view the current progress.

    This command places the application in the uploaded state.

-   Use the following command to completely delete an application from the
    system.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete <app_name>

    where:

    **<app_name>**
        The name of the application to delete.

    You must run :command:`application-remove` before deleting an application.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-delete |prefix|-openstack
        Application |prefix|-openstack deleted.