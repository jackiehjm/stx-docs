
.. luo1591184217439
.. _deprovision-windows-active-directory-authentication:

===================================================
Deprovision Windows Active Directory Authentication
===================================================

You can remove Windows Active Directory authentication from |prod-long|.

.. rubric:: |proc|

#.  Remove the configuration of kube-apiserver to use oidc-auth-apps for
    authentication.


    #.  Determine the UUIDs of parameters used in the kubernetes **kube-apiserver** group.

        These include oidc-client-id, oidc-groups-claim,
        oidc-issuer-url and oidc-username-claim.

        .. code-block:: none

            ~(keystone_admin)]$ system service-parameter-list

    #.  Delete each parameter.

        .. code-block:: none

            ~(keystone_admin)]$ system service-parameter-delete <UUID>

    #.  Apply the changes.

        .. code-block:: none

            ~(keystone_admin)]$ system service-parameter-apply kubernetes


#.  Uninstall oidc-auth-apps.

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove oidc-auth-apps

#.  Clear the helm-override configuration.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update oidc-auth-apps dex kube-system --reset-values
        ~(keystone_admin)]$ system helm-override-show oidc-auth-apps dex kube-system

        ~(keystone_admin)]$ system helm-override-update oidc-auth-apps oidc-client kube-system --reset-values
        ~(keystone_admin)]$ system helm-override-show oidc-auth-apps oidc-client kube-system

#.  Remove secrets that contain certificate data.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl delete secret local-dex.tls -n kube-system
        ~(keystone_admin)]$ kubectl delete secret dex-client-secret -n kube-system
        ~(keystone_admin)]$ kubectl delete secret wadcert -n kube-system

#.  Remove any |RBAC| RoleBindings added for |OIDC| users and/or groups.

    For example:

    .. code-block:: none

        $ kubectl delete clusterrolebinding testuser-rolebinding
        $ kubectl delete clusterrolebinding billingdeptgroup-rolebinding



