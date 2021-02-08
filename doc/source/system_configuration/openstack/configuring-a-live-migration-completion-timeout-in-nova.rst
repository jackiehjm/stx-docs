
.. err1590511228224
.. _configuring-a-live-migration-completion-timeout-in-nova:

=====================================================
Configure a Live Migration Completion Timeout in Nova
=====================================================

You can configure how long to allow for a compute live migration to
complete before the operation is aborted.

The following example applies a timeout of 300 seconds to all hosts.

The same basic workflow of *creating an overrides file*, then
*using it to update helm overrides for the application*, and finally
*reapplying the application to make your changes effective* can be used
to apply other Nova overrides globally.

.. rubric:: |proc|

#.  Create a yaml configuration file containing the configuration update.

    .. code-block:: none

        ~(keystone_admin)]$ cat << EOF > ./nova_override.yaml
        conf:
          nova:
            libvirt:
              live_migration_completion_timeout: 300
        EOF

#.  Update the Helm overrides using the new configuration file.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update --values ./nova_override.yaml |prefix|-openstack nova openstack --reuse-values

#.  Apply the changes.

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack