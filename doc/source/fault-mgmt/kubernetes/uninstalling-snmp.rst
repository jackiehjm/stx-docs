==============
Uninstall SNMP
==============

Use the following procedure to uninstall |SNMP|:

.. rubric:: |proc|

#.  Run the following command to check if the SNMP application is installed
    (status "applied").

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | application              | version | manifest name                             | manifest file    | status   | progress             |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | cert-manager             | 1.0-34  | cert-manager-fluxcd-manifests             | fluxcd-manifests | applied  | completed            |
       | nginx-ingress-controller | 1.1-35  | nginx-ingress-controller-fluxcd-manifests | fluxcd-manifests | applied  | completed            |
       | oidc-auth-apps           | 1.0-68  | oidc-auth-apps-fluxcd-manifests           | fluxcd-manifests | uploaded | completed            |
       | platform-integ-apps      | 1.0-52  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed            |
       | rook-ceph-apps           | 1.0-17  | rook-ceph-manifest                        | manifest.yaml    | uploaded | completed            |
       | snmp                     | 1.0-36  | snmp-fluxcd-manifests                     | fluxcd-manifests | applied  | completed            |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+

#.  Uninstall |SNMP|.

    .. code-block:: none

       ~(keystone_admin)]$ system application-remove snmp
       +---------------+----------------------------------+
       | Property      | Value                            |
       +---------------+----------------------------------+
       | active        | False                            |
       | app_version   | 1.0-36                           |
       | created_at    | 2022-06-27T10:45:42.733267+00:00 |
       | manifest_file | fluxcd-manifests                 |
       | manifest_name | snmp-fluxcd-manifests            |
       | name          | snmp                             |
       | progress      | None                             |
       | status        | removing                         |
       | updated_at    | 2022-06-27T10:45:51.253949+00:00 |
       +---------------+----------------------------------+

    The |SNMP| application is removed, but still shows as "Uploaded".

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | application              | version | manifest name                             | manifest file    | status   | progress             |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | cert-manager             | 1.0-34  | cert-manager-fluxcd-manifests             | fluxcd-manifests | applied  | completed            |
       | nginx-ingress-controller | 1.1-35  | nginx-ingress-controller-fluxcd-manifests | fluxcd-manifests | applied  | completed            |
       | oidc-auth-apps           | 1.0-68  | oidc-auth-apps-fluxcd-manifests           | fluxcd-manifests | uploaded | completed            |
       | platform-integ-apps      | 1.0-52  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed            |
       | rook-ceph-apps           | 1.0-17  | rook-ceph-manifest                        | manifest.yaml    | uploaded | completed            |
       | snmp                     | 1.0-36  | snmp-fluxcd-manifests                     | fluxcd-manifests | uploaded | completed            |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+

#.  Delete the uninstalled |SNMP| application definitions from the system.

    .. code-block:: none

       ~(keystone_admin)]$ system application-delete snmp

    The following message is displayed when the |SNMP| application is deleted
    "Application SNMP deleted".

#.  Run the following command to check if the |SNMP| application is deleted.

    .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | application              | version | manifest name                             | manifest file    | status   | progress             |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | cert-manager             | 1.0-34  | cert-manager-fluxcd-manifests             | fluxcd-manifests | applied  | completed            |
       | nginx-ingress-controller | 1.1-35  | nginx-ingress-controller-fluxcd-manifests | fluxcd-manifests | applied  | completed            |
       | oidc-auth-apps           | 1.0-68  | oidc-auth-apps-fluxcd-manifests           | fluxcd-manifests | uploaded | completed            |
       | platform-integ-apps      | 1.0-52  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed            |
       | rook-ceph-apps           | 1.0-17  | rook-ceph-manifest                        | manifest.yaml    | uploaded | completed            |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+