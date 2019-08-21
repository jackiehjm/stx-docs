==========================
Access StarlingX OpenStack
==========================

.. contents::
   :local:
   :depth: 1

----------
Local CLIs
----------

#. Log in to controller-0 via the console or SSH with a sysadmin/<sysadmin-password>.
   *Do not use* source /etc/platform/openrc .

#. Set the CLI context to the StarlingX OpenStack Cloud Application and set up
   OpenStack admin credentials:

   ::

   	sudo su -
	mkdir -p /etc/openstack
	tee /etc/openstack/clouds.yaml << EOF
	clouds:
	  openstack_helm:
	    region_name: RegionOne
	    identity_api_version: 3
	    endpoint_type: internalURL
	    auth:
	      username: 'admin'
	      password: '<sysadmin-password>'
	      project_name: 'admin'
	      project_domain_name: 'default'
	      user_domain_name: 'default'
	      auth_url: 'http://keystone.openstack.svc.cluster.local/v3'
	EOF
	exit

	export OS_CLOUD=openstack_helm

**********************
OpenStack CLI commands
**********************

Access OpenStack CLI commands for the StarlingX OpenStack Cloud Application using the 
:command:`openstack` command, for example:

::

	[sysadmin@controller-0 ~(keystone_admin)]$ openstack flavor list
	[sysadmin@controller-0 ~(keystone_admin)]$ openstack image list

-----------
Remote CLIs
-----------

Documentation coming soon.

---
GUI
---

Access the StarlingX Containerized OpenStack Horizon GUI in your browser at the following address:

::

	http://<oam-floating-ip-address>:31000

Log in to the Containerized OpenStack Horizon GUI with an admin/<sysadmin-password>.

---------
REST APIs
---------

Documentation coming soon.