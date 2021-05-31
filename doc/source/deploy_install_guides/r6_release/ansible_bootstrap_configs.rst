
.. _ansible_bootstrap_configs_r6:

================================
Ansible Bootstrap Configurations
================================

This section describes Ansible bootstrap configuration options.

.. contents::
   :local:
   :depth: 1


.. _install-time-only-params-r6:

----------------------------
Install-time-only parameters
----------------------------

Some Ansible bootstrap parameters can not be changed or are very difficult to
change after installation is complete.

Review the set of install-time-only parameters before installation and confirm
that your values for these parameters are correct for the desired installation.

.. note::

   If you notice an incorrect install-time-only parameter value *before you
   unlock controller-0 for the first time*, you can re-run the Ansible bootstrap
   playbook with updated override values and the updated values will take effect.

****************************
Install-time-only parameters
****************************

**System Properties**

* ``system_mode``
* ``distributed_cloud_role``

**Network Properties**

* ``pxeboot_subnet``
* ``pxeboot_start_address``
* ``pxeboot_end_address``
* ``management_subnet``
* ``management_start_address``
* ``management_end_address``
* ``cluster_host_subnet``
* ``cluster_host_start_address``
* ``cluster_host_end_address``
* ``cluster_pod_subnet``
* ``cluster_pod_start_address``
* ``cluster_pod_end_address``
* ``cluster_service_subnet``
* ``cluster_service_start_address``
* ``cluster_service_end_address``
* ``management_multicast_subnet``
* ``management_multicast_start_address``
* ``management_multicast_end_address``

**Docker Proxies**

* ``docker_http_proxy``
* ``docker_https_proxy``
* ``docker_no_proxy``

**Docker Registry Overrides**

* ``docker_registries``

  * ``k8s.gcr.io``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

  * ``gcr.io``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

  * ``quay.io``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

  * ``docker.io``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

  * ``docker.elastic.co``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

  * ``defaults``

    * ``url``
    * ``username``
    * ``password``
    * ``secure``

**Certificates**

* ``k8s_root_ca_cert``
* ``k8s_root_ca_key``

**Kubernetes Parameters**

* ``apiserver_oidc``

----
IPv6
----

If you are using IPv6, provide IPv6 configuration overrides for the Ansible
bootstrap playbook. Note that all addressing, except pxeboot_subnet, should be
updated to IPv6 addressing.

Example IPv6 override values are shown below:

::

   dns_servers:
   ‐ 2001:4860:4860::8888
   ‐ 2001:4860:4860::8844
   pxeboot_subnet: 169.254.202.0/24
   management_subnet: 2001:db8:2::/64
   cluster_host_subnet: 2001:db8:3::/64
   cluster_pod_subnet: 2001:db8:4::/64
   cluster_service_subnet: 2001:db8:4::/112
   external_oam_subnet: 2001:db8:1::/64
   external_oam_gateway_address: 2001:db8::1
   external_oam_floating_address: 2001:db8::2
   external_oam_node_0_address: 2001:db8::3
   external_oam_node_1_address: 2001:db8::4
   management_multicast_subnet: ff08::1:1:0/124

.. note::

   The `external_oam_node_0_address`, and `external_oam_node_1_address` parameters
   are not required for the AIO‐SX installation.

----------------
Private registry
----------------

To bootstrap StarlingX you must pull container images for multiple system
services. By default these container images are pulled from public registries:
k8s.gcr.io, gcr.io, quay.io, and docker.io.

It may be required (or desired) to copy the container images to a private
registry and pull the images from the private registry (instead of the public
registries) as part of the StarlingX bootstrap. For example, a private registry
would be required if a StarlingX system was deployed in an air-gapped network
environment.

Use the `docker_registries` structure in the bootstrap overrides file to specify
alternate registry(s) for the public registries from which container images are
pulled. These alternate registries are used during the bootstrapping of
controller-0, and on :command:`system application-apply` of application packages.

The `docker_registries` structure is a map of public registries and the
alternate registry values for each public registry. For each public registry the
key is a fully scoped registry name of a public registry (for example "k8s.gcr.io")
and the alternate registry URL and username/password (if authenticated).

url
   The fully scoped registry name (and optionally namespace/) for the alternate
   registry location where the images associated with this public registry
   should now be pulled from.

   Valid formats for the `url` value are:

   * Domain. For example:

     ::

       example.domain

   * Domain with port. For example:

     ::

       example.domain:5000

   * IPv4 address. For example:

     ::

       1.2.3.4

   * IPv4 address with port. For example:

     ::

       1.2.3.4:5000

   * IPv6 address. For example:

     ::

       FD01::0100

   * IPv6 address with port. For example:

     ::

       [FD01::0100]:5000

username
   The username for logging into the alternate registry, if authenticated.

password
   The password for logging into the alternate registry, if authenticated.


Additional configuration options in the `docker_registries` structure are:

defaults
   A special public registry key which defines common values to be applied to
   all overrideable public registries. If only the `defaults` registry
   is defined, it will apply `url`, `username`, and `password` for all
   registries.

   If values under specific registries are defined, they will override the
   values defined in the defaults registry.

   .. note::

      The `defaults` key was formerly called `unified`. It was renamed
      in StarlingX R3.0 and updated semantics were applied.

      This change affects anyone with a StarlingX installation prior to R3.0 that
      specifies alternate Docker registries using the `unified` key.

secure
   Specifies whether the registry(s) supports HTTPS (secure) or HTTP (not secure).
   Applies to all alternate registries. A boolean value. The default value is
   True (secure, HTTPS).

.. note::

   The ``secure`` parameter was formerly called ``is_secure_registry``. It was
   renamed in StarlingX R3.0.

If an alternate registry is specified to be secure (using HTTPS), the certificate
used by the registry may not be signed by a well-known Certificate Authority (CA).
This results in the :command:`docker pull` of images from this registry to fail.
Use the `ssl_ca_cert` override to specify the public certificate of the CA that
signed the alternate registry’s certificate. This will add the CA as a trusted
CA to the StarlingX system.

ssl_ca_cert
   The `ssl_ca_cert` value is the absolute path of the certificate file. The
   certificate must be in PEM format and the file may contain a single CA
   certificate or multiple CA certificates in a bundle.

The following example will apply `url`, `username`, and `password` to all
registries.

::

   docker_registries:
     defaults:
       url: my.registry.io
       username: myreguser
       password: myregP@ssw0rd

The next example applies `username` and `password` from the defaults registry
to all public registries. `url` is different for each public registry. It
additionally specifies an alternate CA certificate.

::

  docker_registries:
     k8s.gcr.io:
       url: my.k8sregistry.io
     gcr.io:
       url: my.gcrregistry.io
     quay.io:
       url: my.quayregistry.io
     docker.io:
       url: my.dockerregistry.io
     defaults:
       url: my.registry.io
       username: myreguser
       password: myregP@ssw0rd

  ssl_ca_cert: /path/to/ssl_ca_cert_file

------------
Docker proxy
------------

If the StarlingX OAM interface or network is behind a http/https proxy, relative
to the Docker registries used by StarlingX or applications running on StarlingX,
then Docker within StarlingX must be configured to use these http/https proxies.

Use the following configuration overrides to configure your Docker proxy settings.

docker_http_proxy
   Specify the HTTP proxy URL to use. For example:

   ::

      docker_http_proxy: http://my.proxy.com:1080

docker_https_proxy
   Specify the HTTPS proxy URL to use. For example:

   ::

      docker_https_proxy: https://my.proxy.com:1443

docker_no_proxy
   A no-proxy address list can be provided for registries not on the other side
   of the proxies. This list will be added to the default no-proxy list derived
   from localhost, loopback, management, and OAM floating addresses at run time.
   Each address in the no-proxy list must neither contain a wildcard nor have
   subnet format. For example:

   ::

      docker_no_proxy:
        - 1.2.3.4
        - 5.6.7.8

.. _k8s-root-ca-cert-key-r6:

--------------------------------------
Kubernetes root CA certificate and key
--------------------------------------

By default the Kubernetes Root CA Certificate and Key are auto-generated and
result in the use of self-signed certificates for the Kubernetes API server. In
the case where self-signed certificates are not acceptable, use the bootstrap
override values `k8s_root_ca_cert` and `k8s_root_ca_key` to specify the
certificate and key for the Kubernetes root CA.

k8s_root_ca_cert
   Specifies the certificate for the Kubernetes root CA. The `k8s_root_ca_cert`
   value is the absolute path of the certificate file. The certificate must be
   in PEM format and the value must be provided as part of a pair with
   `k8s_root_ca_key`. The playbook will not proceed if only one value is provided.

k8s_root_ca_key
   Specifies the key for the Kubernetes root CA. The `k8s_root_ca_key`
   value is the absolute path of the certificate file. The certificate must be
   in PEM format and the value must be provided as part of a pair with
   `k8s_root_ca_cert`. The playbook will not proceed if only one value is provided.

.. important::

   The default length for the generated Kubernetes root CA certificate is 10
   years. Replacing the root CA certificate is an involved process so the custom
   certificate expiry should be as long as possible. We recommend ensuring root
   CA certificate has an expiry of at least 5-10 years.

The administrator can also provide values to add to the Kubernetes API server
certificate Subject Alternative Name list using the `apiserver_cert_sans`
override parameter.

apiserver_cert_sans
   Specifies a list of Subject Alternative Name entries that will be added to the
   Kubernetes API server certificate. Each entry in the list must be an IP address
   or domain name. For example:

   ::

      apiserver_cert_sans:
        - hostname.domain
        - 198.51.100.75

StarlingX automatically updates this parameter to include IP records for the OAM
floating IP and both OAM unit IP addresses.

----------------------------------------------------
OpenID Connect authentication for Kubernetes cluster
----------------------------------------------------

The Kubernetes cluster can be configured to use an external OpenID Connect
:abbr:`IDP (identity provider)`, such as Azure Active Directory, Salesforce, or
Google, for Kubernetes API authentication.

By default, OpenID Connect authentication is disabled. To enable OpenID Connect,
use the following configuration values in the Ansible bootstrap overrides file
to specify the IDP for OpenID Connect:

::

    apiserver_oidc:
      client_id:
      issuer_url:
      username_claim:

When the three required fields of the `apiserver_oidc` parameter are defined,
OpenID Connect is considered active. The values will be used to configure the
Kubernetes cluster to use the specified external OpenID Connect IDP for
Kubernetes API authentication.

In addition, you will need to configure the external OpenID Connect IDP and any
required OpenID client application according to the specific IDP's documentation.

If not configuring OpenID Connect, all values should be absent from the
configuration file.

.. note::

   Default authentication via service account tokens is always supported,
   even when OpenID Connect authentication is configured.