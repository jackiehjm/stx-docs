
.. kss1491241946903
.. _internal-dns-resolution:

=======================
Internal DNS Resolution
=======================

|prod-os| supports internal DNS resolution for instances. When this feature
is enabled, instances are automatically assigned hostnames, and an internal
DNS server is maintained which associates the hostnames with IP addresses.

The ability to use hostnames is based on the OpenStack DNS integration
capability. For more about this capability, see
`https://docs.openstack.org/mitaka/networking-guide/config-dns-int.html
<https://docs.openstack.org/mitaka/networking-guide/config-dns-int.html>`__.

When internal DNS resolution is enabled on a |prod-os| system, the Neutron
service maintains an internal DNS server with a hostname-IP address pair for
each instance. The hostnames are derived automatically from the names assigned
to the instances when they are launched, providing |PQDNs|. They can be
concatenated with a domain name defined for the Neutron service to form fully
|FQDNs|.
