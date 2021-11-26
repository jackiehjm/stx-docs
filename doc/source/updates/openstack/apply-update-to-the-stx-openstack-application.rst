
.. uqi1590003050708
.. _apply-update-to-the-stx-openstack-application:

=========================================
Apply Update to the OpenStack Application
=========================================

|prod-os| is managed using the StarlingX Application Package Manager.

.. rubric:: |context|

Use the StarlingX Application Package Manager :command:`application-update`
command to perform an update.

.. code-block:: none

    ~(keystone_admin)$ system application-update [-n | --app-name] <app_name>
    [-v | --app-version] <version> <tar_file>

where the following are optional arguments:

**<app\_name>**
    The name of the application to update.

    You can look up the name of an application using the
    :command:`application-list` command:

    .. parsed-literal::

        ~(keystone_admin)$ system application-list
        +--------------------------+-----------+-------------------------------+---------------------------+----------+-----------+
        | application              | version   | manifest name                 | manifest file             | status   | progress  |
        +--------------------------+-----------+-------------------------------+---------------------------+----------+-----------+
        | cert-manager             | 20.06-5   | cert-manager-manifest         | certmanager-manifest.yaml | applied  | completed |
        | nginx-ingress-controller | 20.06-0   | nginx-ingress-controller-     | nginx_ingress_controller  | applied  | completed |
        |                          |           | -manifest                     | _manifest.yaml            |          |           |
        | oidc-auth-apps           | 20.06-28  | oidc-auth-manifest            | manifest.yaml             | uploaded | completed |
        | platform-integ-apps      | 20.06-11  | platform-integration-manifest | manifest.yaml             | applied  | completed |
        | |prefix|-openstack |s|           | 21.07-0-  | armada-manifest               | |prefix|-openstack.yaml |s|       | applied  | completed |
        |                          | centos-   |                               |                           |          |           |
        |                          | stable-   |                               |                           |          |           |
        |                          | versioned |                               |                           |          |           |
        +--------------------------+-----------+-------------------------------+---------------------------+----------+-----------+


        The output indicates that the currently installed version of
        |prefix|-openstack is 20.10-0.

**<version>**
    The version to update the application to.

and the following is a positional argument which must come last:

**<tar\_file>**
    The tar file containing the application manifest, Helm charts and
    configuration file.

.. note::

    In a |prod-dc| configuration the |prod-dc| System Controllers should be
    upgrade before the subclouds.

.. rubric:: |proc|


.. _apply-update-to-the-stx-openstack-application-steps-inn-llt-kmb:

#.  Retrieve the latest |prod-os| application tarball,
    |prefix|-openstack-<major>.<minor>-patch.tgz, from |dnload-loc|.

    .. note::
        The major-minor version is based on the current product release
        version. The patch version will change within the release based on
        incremental updates.

#.  Source the environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)$

#.  Update the application.

    This will upload the software version and automatically apply it to the
    system.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system application-update |prefix|-openstack-20.10-1.tgz

#.  Monitor the status of the application-apply operation until it has
    completed successfully.

    .. code-block:: none

        ~(keystone_admin)$ system application-show |prefix|-openstack
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | True                             |
        | app_version   | 20.06-1                          |
        | created_at    | 2020-05-02T17:11:48.718963+00:00 |
        | manifest_file | |prefix|-openstack.yaml |s|              |
        | manifest_name | openstack-armada-manifest        |
        | name          | |prefix|-openstack |s|                   |
        | progress      | completed                        |
        | status        | applied                          |
        | updated_at    | 2020-05-02T17:44:40.152201+00:00 |
        +---------------+----------------------------------+



