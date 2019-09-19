===========================================
Additional Ansible bootstrap configurations
===========================================

.. _ansible_bootstrap_ipv6:

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
   management_multicast_subnet: ff08::1:1:0/124

For configurations with more than one node, additionally provide:

::

   external_oam_node_0_address: 2001:db8::3
   external_oam_node_1_address: 2001:db8::4
