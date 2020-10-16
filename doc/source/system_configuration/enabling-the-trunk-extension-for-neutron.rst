
.. jvu1591371696823
.. _enabling-the-trunk-extension-for-neutron:

======================================
Enable the Trunk Extension for Neutron
======================================

You can use Helm overrides to enable the Trunk Neutron extension.

.. rubric:: |proc|

#.  Create a yaml file to enable the trunk extension for neutron.

    .. code-block:: none

        ~(keystone_admin)]$ cat > neutron-overrides.yaml <<EOF
        conf:
         neutron:
           DEFAULT:
             service_plugins:
             - router
             - network_segment_range
             - trunk
        EOF

#.  Update the neutron overrides and apply to |prefix|-openstack.

    .. parsed-literal::

        $ source /etc/platform/openrc
        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack neutron openstack --values neutron-overrides.yaml
        ~(keystone_admin)]$ system helm-override-show |prefix|-openstack neutron openstack
        ~(keystone_admin)]$ system application-apply |prefix|-openstack

#.  In a separate shell, verify that the Trunk Extension and Trunk port details extensions are enabled.

    .. code-block:: none

        $ source /etc/platform/openrc
        $ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
        $ openstack extension list --network | grep -i trunk
