
.. bbr1591372608382
.. _using-helm-overrides-to-enable-internal-dns:

==============================
Enable Internal DNS in Neutron
==============================

You can use Helm overrides to enable internal DNS support.

.. rubric:: |proc|

#.  Create a yaml file to enable internal dns resolution for neutron.

    .. code-block:: none

        ~(keystone_admin)]$ cat > neutron-overrides.yaml <<EOF
        conf:
         neutron:
           DEFAULT:
             dns_domain: example.ca
         plugins:
           ml2_conf:
             ml2:
               extension_drivers:
               - port_security
               - dns
        EOF

#.  Update the neutron overrides and apply to |prefix|-openstack.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack neutron openstack --values neutron-overrides.yaml
        ~(keystone_admin)]$ system application-apply |prefix|-openstack
