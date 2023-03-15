
.. oej1591381096383
.. _connecting-to-container-registries-through-a-firewall-or-proxy:

===========================================================
Connect to Container Registries through a Firewall or Proxy
===========================================================

You can use service parameters to connect to container registries that are
otherwise inaccessible behind a firewall or proxy.

.. rubric:: |proc|

#.  Do one of the following to allow access to a specified URL.


    -   To allow access over HTTP:

        .. code-block:: none

            ~(keystone_user)$ system service-parameter-modify platform docker http_proxy http://<my.proxy.com>:1080
            ~(keystone_user)$ system service-parameter-apply platform

    -   To allow access over HTTPS:

        .. code-block:: none

            ~(keystone_user)$ system service-parameter-modify platform docker https_proxy https://<my.proxy.com>:1443
            ~(keystone_user)$ system service-parameter-apply platform


    Substitute the correct value for <my.proxy.com>.

#.  If you access registries that are not on the other side of the
    firewall/proxy, you can specify their IP addresses in the no_proxy service
    parameter as a comma separated list.

    .. note::
        Addresses must not be in subnet format and cannot contain wildcards.

    For example:

    .. code-block:: none

        ~(keystone_user)$ system service-parameter-modify platform docker no_proxy: 1.2.3.4, 5.6.7.8
        ~(keystone_user)$ system service-parameter-apply platform


