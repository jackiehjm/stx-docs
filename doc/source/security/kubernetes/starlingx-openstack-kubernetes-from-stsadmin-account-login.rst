
.. fqa1607640080245
.. _starlingx-openstack-kubernetes-from-stsadmin-account-login:

=============================================================================================
For StarlingX, Platform OpenStack and Kubernetes CLIs from the 'sysadmin' Linux Account Login
=============================================================================================

You can establish credentials for StarlingX, Platform OpenStack and Kubernetes
|CLIs| from the 'sysadmin' Linux account login.

.. rubric:: |context|

For the 'sysadmin' account, you can acquire both Keystone admin credentials for
StarlingX and Platform |CLIs|, and Kubernetes admin credentials for Kubernetes
|CLIs| by executing the following command:

.. code-block:: none

    user1@controller-0:~$ source /etc/platform/openrc

