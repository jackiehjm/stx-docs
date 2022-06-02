.. _add-a-horizon-keystone-user-to-distributed-cloud-29655b0f0eb9:

================================================
Add a Horizon/Keystone User to Distributed Cloud
================================================

You can add a new keystone user on the system controller, when you do that the
new user is considered a shared identity resource and will be synced to all
online and managed subclouds, for more details see :ref:`Shared Configurations
<shared-configurations>`. But, if you add a new user on the subcloud, it will
be local to that subcloud.

-   To create a shared/synced user, do the following:

    From the system controller, add a new user:

    .. code-block:: none

        ~(keystone_admin)]$ openstack --os-region-name SystemController user create  test_shared_user --domain default --project admin --password Test#123
        ~(keystone_admin)]$ openstack --os-region-name SystemController role add --user test_shared_user --project admin admin

    To verify the new user is created on the system controller and propagated
    to the subclouds, create a test rc file with the following content:

    .. code-block:: none

        unset OS_SERVICE_TOKEN

        export OS_ENDPOINT_TYPE=internalURL
        export CINDER_ENDPOINT_TYPE=internalURL

        export OS_USERNAME=test_shared_user
        export OS_PASSWORD=Test#123
        export OS_AUTH_TYPE=password
        export OS_AUTH_URL=http://192.168.221.2:5000/v3

        export OS_PROJECT_NAME=admin
        export OS_USER_DOMAIN_NAME=Default
        export OS_PROJECT_DOMAIN_NAME=Default
        export OS_IDENTITY_API_VERSION=3
        export OS_REGION_NAME=RegionOne
        export OS_INTERFACE=internal

        if [ ! -z "${OS_PASSWORD}" ]; then
            export PS1='[\u@\h \W(keystone_$OS_USERNAME)]\$ '
        else
            echo 'Openstack Admin credentials can only be loaded from the active controller.'
            export PS1='\h:\w\$ '
        fi

    .. note::

        Replace the ``OS_AUTH_URL`` value with the URL corresponding to the
        RegionOne keystone identity endpoint.

    Then, on both the system controller and any/all subclouds, source the test
    rc file (e.g. ``source ./test_rc``), and run the openstack command to get
    the list of users:

    .. code-block:: none

        ~(keystone_admin)]$ openstack user list

-   To create a local user on a particular subcloud, do the following:

    From the subcloud, add a new user:

    .. code-block:: none

        ~(keystone_admin)]$ openstack user create  test_local_user --domain default --project admin --password Test#123
        ~(keystone_admin)]$ openstack role add --user test_local_user --project admin admin


    To verify the new user is created only on this subcloud, create a test rc
    file with the following content:

    .. code-block:: none

        unset OS_SERVICE_TOKEN

        export OS_ENDPOINT_TYPE=internalURL
        export CINDER_ENDPOINT_TYPE=internalURL

        export OS_USERNAME=test_shared_user
        export OS_PASSWORD=Test#123
        export OS_AUTH_TYPE=password
        export OS_AUTH_URL=http://192.168.220.2:5000/v3

        export OS_PROJECT_NAME=admin
        export OS_USER_DOMAIN_NAME=Default
        export OS_PROJECT_DOMAIN_NAME=Default
        export OS_IDENTITY_API_VERSION=3
        export OS_REGION_NAME=dell0-subcloud
        export OS_INTERFACE=internal

        if [ ! -z "${OS_PASSWORD}" ]; then
            export PS1='[\u@\h \W(keystone_$OS_USERNAME)]\$ '
        else
            echo 'Openstack Admin credentials can only be loaded from the active controller.'
            export PS1='\h:\w\$ '
        fi

    .. note::

        Replace the ``OS_REGION_NAME`` value in this example
        (``dell0-subcloud``) with your subcloud name, and the ``OS_AUTH_URL``
        value with the URL corresponding to the subcloud endpoint.

    Then, on both this subcloud and another subcloud, source the test rc file
    (e.g. ``source ./test_rc``), and run the openstack command to get the list
    of users:

    .. code-block:: none

        ~(keystone_admin)]$ openstack user list

    The ``test_local_user`` should only exist on the subcloud where you locally
    added the user.
