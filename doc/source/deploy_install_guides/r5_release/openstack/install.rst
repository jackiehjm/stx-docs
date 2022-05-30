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

#. Modify the size of the docker_lv filesystem. By default, the size of the
   docker_lv filesystem is 30G, which is not enough for |prefix|-openstack
   installation. Use the ``host-fs-modify`` CLI to increase the filesystem size.

   The syntax is:

   ::

    system host-fs-modify <hostname or id> <fs name=size>


   Where:

   *   ``hostname or id`` is the location where the file system will be added.
   *   ``fs name`` is the file system name.
   *   ``size`` is an integer indicating the file system size in Gigabytes.

   For example:

   ::

    system host-fs-modify controller-0 docker=60

#. Get the latest StarlingX OpenStack application (|prefix|-openstack) manifest
   and helm charts. Use one of the following options:

   *  Private StarlingX build. See :ref:`Build-stx-openstack-app` for details.
   *  Public download from
      `CENGN StarlingX mirror <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`_.

      After you select a release, helm charts are located in ``centos/outputs/helm-charts``.

#. Load the |prefix|-openstack application's package into StarlingX. The tarball
   package contains |prefix|-openstack's Armada manifest and
   |prefix|-openstack's set of helm charts. For example:

   .. parsed-literal::

       system application-upload |prefix|-openstack-<version>-centos-stable-versioned.tgz

   This will:

   * Load the Armada manifest and helm charts.
   * Internally manage helm chart override values for each chart.
   * Automatically generate system helm chart overrides for each chart based on
     the current state of the underlying StarlingX Kubernetes platform and the
     recommended StarlingX configuration of OpenStack services.

#. Apply the |prefix|-openstack application in order to bring StarlingX
   OpenStack into service. If your environment is preconfigured with a proxy
   server, then make sure HTTPS proxy is set before applying
   |prefix|-openstack.

   .. parsed-literal::

        system application-apply |prefix|-openstack

   .. note::

        To set the HTTPS proxy at bootstrap time, refer to
        `Ansible Bootstrap Configurations <https://docs.starlingx.io/deploy_install_guides/r5_release/ansible_bootstrap_configs.html#docker-proxy>`_.

        To set the HTTPS proxy after installation, refer to
        `Docker Proxy Configuration <https://docs.starlingx.io/configuration/docker_proxy_config.html>`_.

#. Wait for the activation of |prefix|-openstack to complete.

   This can take 5-10 minutes depending on the performance of your host machine.

   Monitor progress with the command:

   ::

     watch -n 5 system application-list

----------
Next steps
----------

Your OpenStack cloud is now up and running.

See :doc:`access` for details on how to access StarlingX OpenStack.
