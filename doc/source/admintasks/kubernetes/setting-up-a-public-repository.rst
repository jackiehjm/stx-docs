
.. qay1588350945997
.. _setting-up-a-public-repository:

===================================================
Set up a Public Repository in Local Docker Registry
===================================================

There will likely be scenarios where you need to make images publicly available
to all users.

.. rubric:: |context|

The suggested method to do that is to create a
keystone tenant/user = 'registry'/'public', which will therefore have access to
images in the registry.local:9001/public/ repository. Then share access to
those images by sharing the registry/public user's credentials with other users.

.. rubric:: |proc|

#.  Create the keystone tenant/user of registry/public.

    .. code-block:: none

        ~(keystone_admin)]$ openstack project create registry
        ~(keystone_admin)]$ TENANTNAME="registry"
        ~(keystone_admin)]$ TENANTID=`openstack project list | grep ${TENANTNAME} | awk '{print $2}'`
        ~(keystone_admin)]$ USERNAME="public"
        ~(keystone_admin)]$ USERPASSWORD="${USERNAME}K8*"
        ~(keystone_admin)]$ openstack user create --password ${USERPASSWORD} --project ${TENANTID} ${USERNAME}
        ~(keystone_admin)]$ openstack role add --project ${TENANTNAME} --user ${USERNAME} _member

#.  Create a secret containing the credentials of the public repository in
    kube-system namespace.

    .. code-block:: none

        % kubectl create secret docker-registry registry-local-public-key --docker-server=registry.local:9001 --docker-username=public --docker-password=public --docker-email=noreply@windriver.com -n kube-system

#.  Share the credentials of the public repository with other namespaces.

    Copy the secret to the other namespace and add it as an ImagePullSecret to
    the namespace's **default** serviceAccount.

    .. code-block:: none

        % kubectl get secret registry-local-public-key -n kube-system -o yaml | grep -v '^\s*namespace:\s'  | kubectl apply --namespace=<USERNAMESPACE> -f -
        % kubectl patch serviceaccount default  -p "{\"imagePullSecrets\": [{\"name\": \"registry-local-public-key\"}]}" -n <USERNAMESPACE>


