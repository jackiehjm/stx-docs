===========================
Install StarlingX OpenStack
===========================

These instructions assume that you have completed the following
OpenStack-specific configuration tasks that are required by the underlying
StarlingX Kubernetes platform:

* All nodes have been labeled appropriately for their OpenStack role(s).
* The vSwitch type has been configured.
* The nova-local volume group has been configured on any node's host, if running
  the compute function.

--------------------------------------------
Install application manifest and helm-charts
--------------------------------------------

#. Get the latest StarlingX OpenStack application (stx-openstack) manifest and
   helm-charts. This can be from a private StarlingX build or from the public
   `CENGN StarlingX mirror <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`_.

#. Load the stx-openstack application's package into StarlingX. The tarball
   package contains stx-openstack's Airship Armada manifest and stx-openstack's
   set of helm charts. For example:

   ::

        system application-upload stx-openstack-<version>-centos-stable-latest.tgz

   This will:

   * Load the Armada manifest and helm charts.
   * Internally manage helm chart override values for each chart.
   * Automatically generate system helm chart overrides for each chart based on
     the current state of the underlying StarlingX Kubernetes platform and the
     recommended StarlingX configuration of OpenStack services.

#. Apply the stx-openstack application in order to bring StarlingX OpenStack
   into service. If your environment is preconfigured with a proxy server, then
   make sure HTTPS proxy is set before applying stx-openstack.

   ::

        system application-apply stx-openstack

   .. note::

        To set the HTTPS proxy at bootstrap time, refer to
        `Ansible Bootstrap Configurations <https://docs.starlingx.io/deploy_install_guides/r3_release/ansible_bootstrap_configs.html#docker-proxy>`_.

        To set the HTTPS proxy after installation, refer to
        `Docker Proxy Configuration <https://docs.starlingx.io/configuration/docker_proxy_config.html>`_.

#. Wait for the activation of stx-openstack to complete.

   This can take 5-10 minutes depending on the performance of your host machine.

   Monitor progress with the command:

   ::

        watch -n 5 system application-list

----------
Next steps
----------

Your OpenStack cloud is now up and running.

See :doc:`access` for details on how to access StarlingX OpenStack.
