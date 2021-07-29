
.. qsc1589994634309
.. _update-the-domain-name:

======================
Update the Domain Name
======================

Containerized OpenStack services in |prod-os| are deployed behind an ingress
controller \(nginx\) that listens, by default, on either port 80 \(HTTP\) or
port 443 \(HTTPS\).

.. rubric:: |context|

The ingress controller routes packets to the specific OpenStack service, such
as the Cinder service, or the Neutron service, by parsing the |FQDN| in the
packet. For example, neutron.openstack.svc.cluster.local is for the Neutron
service, cinder‐api.openstack.svc.cluster.local is for the Cinder service.

This routing requires that access to OpenStack REST APIs \(directly or via
remote OpenStack |CLIs|\) must be via a |FQDN|. You cannot access OpenStack REST
APIs using an IP address.

|FQDNs| \(such as cinder‐api.openstack.svc.cluster.local\) must be in a |DNS|
server that is publicly accessible.

.. note::
    It is possible to wild‐card a set of |FQDNs| to the same IP address in a
    |DNS| server configuration so that you don't need to update the |DNS|
    server every time an OpenStack service is added. Check your particular
    |DNS| server for details on how to wild-card a set of |FQDNs|.

In a "real" deployment, that is, not a lab scenario, you cannot use the default
*openstack.svc.cluster.local* domain name externally. You must set a unique
domain name for your |prod-os| system. Use the :command:`system
service‐parameter-add` command to configure and set the OpenStack domain name:

.. rubric:: |prereq|

.. _update-the-domain-name-prereq-FQDNs:

-   You must have an external |DNS| Server for which you have authority to add
    new domain name to IP address mappings \(e.g. A, AAAA or CNAME records\).

-   The |DNS| server must be added to your|prod-long| |DNS| list.

-   Your |DNS| server must have A, AAAA or CNAME records for the following domain
    names, representing the corresponding openstack services, defined as the
    |OAM| Floating IP address. Refer to the configuration manual for the
    particular |DNS| server you are using on how to make these updates for the
    domain you are using for the |prod-os| system.

    .. note::

        |prod| recommends that you not define domain names for services you
        are not using.

    .. parsed-literal::

        # define A record for general domain for |prod| system
        <my-|prefix|-domain> IN A 10.10.10.10

        # define alias for general domain for horizon dashboard REST API URL
        horizon.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define alias for general domain for keystone identity service REST
        API URLs
        keystone.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        keystone-api.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define alias for general domain for neutron networking REST API URL
        neutron.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define alias for general domain for nova compute provisioning REST
        API URLs
        nova.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        nova-api-internal.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        placement.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        rest-api.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define no vnc proxy alias for VM console access through Horizon REST
        API URL
        novncproxy.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define alias for general domain for barbican secure storage REST API URL
        barbican.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com.

        # define alias for general domain for glance VM management REST API URL
        glance.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com.

        # define alias for general domain for cinder block storage REST API URL
        cinder.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        cinder2.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        cinder3.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

        # define alias for general domain for heat orchestration REST API URLs
        heat.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        cloudformation.<my-|prefix|-domain> IN CNAME my-|prefix|-domain.<my-company>.com

        # define alias for general domain for starlingx REST API URLs
        # ( for fault, patching, service management, system and VIM )
        fm.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        patching.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        smapi.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        sysinv.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com
        vim.<my-|prefix|-domain> IN CNAME <my-|prefix|-domain>.<my-company>.com

.. rubric:: |proc|

#.  Source the environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)$

#.  To set a unique domain name, use the :command:`system
    service‐parameter-add` command.

    The command has the following syntax.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-add openstack helm endpoint_domain=<domain_name>

    <domain\_name> should be a fully qualified domain name that you own, such
    that you can configure the |DNS| Server that owns <domain\_name> with the
    OpenStack service names underneath the domain.

    See the :ref:`prerequisites <update-the-domain-name-prereq-FQDNs>` for a
    complete list of |FQDNs|.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-add openstack helm endpoint_domain=my-|prefix|-domain.mycompany.com

    .. note::
        If an error occurs, remove the following ingress parameters, **nova-cluster-fqdn**
        and **nova-namespace-fqdn** and reapply OpenStack using :command:`system application-apply |prefix|-openstack`.

#.  Apply the |prefix|-openstack application.

    For example:

    .. parsed-literal::

        ~(keystone_admin)$ system application-apply |prefix|-openstack

.. rubric:: |result|

The helm charts of all OpenStack services are updated and restarted. For
example cinder‐api.openstack.svc.cluster.local would be changed to
cinder‐api.my-|prefix|-domain.mycompany.com, and so on for all OpenStack services.

.. note::
    OpenStack Horizon is also changed to listen on
    horizon.my-|prefix|-domain.mycompany.com:80 \(instead of the initial
    oam‐floating‐ip:31000\), for example,
    horizon.my-wr-domain.mycompany.com:80.

.. rubric:: |postreq|

After changing the |prod-os| Helm endpoint domain using the above procedure,
OpenStack will switch from Kubernetes **node_port controller** to the
**nginx ingress controller**, that adds a 2500 MiB size limit to all HTTP
requests done using |os-prod-hor-long| for security reasons.

.. note::
    For images that are larger than 2500 MiB in size, uploading the images
    using Horizon Web Interface will fail. Use the steps below to change the
    maximum image size supported by the Horizon ingress resource, by applying
    an override to the Horizon Helm chart.

#.  Create a horizon-overrides.yaml file using the following
    overrides, and change the value of the **proxy-body-size** to the new size.
    For example, to support uploads of images up to 3500 MiB in size using
    the Horizon Web Interface, update the following value:

    .. code-block:: none

        cat <<EOF > horizon-overrides.yaml
        network:
          dashboard:
            ingress:
              annotations:
                nginx.ingress.kubernetes.io/proxy-body-size: "3500m"
        EOF

#.  Use the :command:`system helm-override-update` command to update the
    overrides for the Horizon Helm chart.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack horizon openstack --values=horizon-overrides.yaml

#.  Apply the updated Horizon Helm chart overrides to the |prefix|-openstack application

    .. parsed-literal::

        ~(keystone_admin)$ system application-apply |prefix|-openstack


