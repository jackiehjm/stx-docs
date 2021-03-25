==============
Uninstall SNMP
==============

Use the following procedure to uninstall |SNMP|:

.. rubric:: |proc|

#.  Run the following command to check if the SNMP application is installed
    (status "applied").

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+-------------------------+-----------------------------------+------------------------+---------------+-----------+
       | application              | version                 | manifest name                     | manifest file          | status        | progress  |
       +--------------------------+-------------------------+-----------------------------------+------------------------+---------------+-----------+
       | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.  | applied       | completed |
       |                          |                         |                                   | yaml                   |               |           |
       |                          |                         |                                   |                        |               |           |
       | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controll | applied       | completed |
       |                          |                         |                                   | er_manifest.yaml       |               |           |
       |                          |                         |                                   |                        |               |           |
       | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml          | uploaded      | completed |
       | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml          | uploaded      | completed |
       | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder    | upload-failed | None      |
       | snmp                     | 1.0-2                   | snmp-manifest                     | snmp_manifest.yaml     | applied       | completed |
       +--------------------------+-------------------------+-----------------------------------+------------------------+---------------+-----------+

#.  Uninstall SNMP.

    .. code-block:: none

       ~(keystone_admin)]$ system application-remove snmp
       +---------------+----------------------------------+
       | Property      | Value                            |
       +---------------+----------------------------------+
       | active        | True                             |
       | app_version   | 1.0-2                            |
       | created_at    | 2020-11-12T06:26:21.526433+00:00 |
       | manifest_file | snmp_manifest.yaml               |
       | manifest_name | snmp-manifest                    |
       | name          | snmp                             |
       | progress      | None                             |
       | status        | removing                         |
       | updated_at    | 2020-11-12T06:51:34.987085+00:00 |
       +---------------+----------------------------------+

    The SNMP application is removed, but still shows as "Uploaded".

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+-------------------------+-----------------------------------+-------------------------+---------------+-----------+
       | application              | version                 | manifest name                     | manifest file           | status        | progress  |
       +--------------------------+-------------------------+-----------------------------------+-------------------------+---------------+-----------+
       | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.   | applied       | completed |
       |                          |                         |                                   | yaml                    |               |           |
       |                          |                         |                                   |                         |               |           |
       | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controlle | applied       | completed |
       |                          |                         |                                   | r_manifest.yaml         |               |           |
       |                          |                         |                                   |                         |               |           |
       | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml           | uploaded      | completed |
       | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml           | uploaded      | completed |
       | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder     | upload-failed | None      |
       | snmp                     | 1.0-2                   | snmp-manifest                     | snmp_manifest.yaml      | uploaded      | completed |
       +--------------------------+-------------------------+-----------------------------------+-------------------------+---------------+-----------+

#.  Delete the uninstalled SNMP application definitions from the system.

    .. code-block:: none

       ~(keystone_admin)]$ system application-delete snmp

    The following message is displayed when the SNMP application is deleted
    "Application SNMP deleted".

#.  Run the following command to check if the SNMP application is deleted.

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+-------------------------+-----------------------------------+--------------------------+---------------+-----------+
       | application              | version                 | manifest name                     | manifest file            | status        | progress  |
       +--------------------------+-------------------------+-----------------------------------+--------------------------+---------------+-----------+
       | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.    | applied       | completed |
       |                          |                         |                                   | yaml                     |               |           |
       |                          |                         |                                   |                          |               |           |
       | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controller | applied       | completed |
       |                          |                         |                                   | _manifest.yaml           |               |           |
       |                          |                         |                                   |                          |               |           |
       | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml            | uploaded      | completed |
       | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml            | uploaded      | completed |
       | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder      | upload-failed | None      |
       +--------------------------+-------------------------+-----------------------------------+--------------------------+---------------+-----------+