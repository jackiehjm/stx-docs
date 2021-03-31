
.. gkr1591372948568
.. _adding-configuration-rpc-response-max-timeout-in-neutron-conf:

=============================================================
Add Configuration rpc\_response\_max\_timeout in neutron.conf
=============================================================

You can add the rpc\_response\_max\_timeout to neutron.conf using Helm
overrides.

.. rubric:: |context|

Maximum rpc timeout is now configurable by rpc\_response\_max\_timeout from
Neutron config instead of being calculated as 10 \* rpc\_response\_timeout.

This configuration can be used to change the maximum rpc timeout. If maximum
rpc timeout is too big, some requests which should fail will be held for a long
time before the server returns failure. If this value is too small and the
server is very busy, the requests may need more time than maximum rpc timeout
and the requests will fail though they can succeed with a bigger maximum rpc
timeout.

.. rubric:: |proc|

#.  create a yaml file to add configuration rpc\_response\_max\_timeout in
    neutron.conf.

    .. code-block:: none

        ~(keystone_admin)]$ cat > neutron-overrides.yaml <<EOF
        conf:
         neutron:
           DEFAULT:
             rpc_response_max_timeout: 600
        EOF

#.  Update the neutron overrides and apply to |prefix|-openstack.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack neutron openstack --values neutron-overrides.yaml
        ~(keystone_admin)]$ system application-apply |prefix|-openstack

#.  Verify that configuration rpc\_response\_max\_time has been added in
    neutron.conf.

    .. code-block:: none

        $ kubectl get pod -n openstack | grep neutron
        $ kubectl get pod -n openstack | grep neutron-server
        $ kubectl exec <neutron-server-id> -n openstack – cat /etc/neutron/neutron.conf | grep rpc_response_max_timeout
        rpc_response_max_timeout = 600
        $ cat /etc/neutron/neutron.conf | grep rpc_response_max_timeout