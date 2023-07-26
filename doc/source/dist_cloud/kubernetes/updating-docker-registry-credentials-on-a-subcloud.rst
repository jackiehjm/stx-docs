
.. qdu1595389242059
.. _updating-docker-registry-credentials-on-a-subcloud:

===========================================================================
Update Credentials Used by Subcloud for Install Registry (registry.central)
===========================================================================

On a subcloud that uses the System Controller's Docker registry
(registry.central) as its install registry, you should use the
System Controller's sysinv service credentials for accessing registry.central.
This makes access to registry.central independent of changes to the Distributed
Cloud's Keystone admin user password.

.. warning::

    If the following registry information/credentials are changed, a new subcloud
    backup must be taken to avoid having a backup that contains old registry
    credentials.

Use the following procedure to update credentials used by the Subcloud to access
its install registry (registry.central) to the ``sysinv`` service credentials of
the System Controller.

.. rubric:: |proc|

.. _updating-docker-registry-credentials-on-a-subcloud-steps-ywx-wyt-kmb:

#.  On the System Controller, get the password for the ``sysinv`` services.

    .. code-block:: none

        $ keyring get sysinv services

#.  On each subcloud, run the following script to update the Docker registry
    credentials to ``sysinv``:

    .. code-block:: none

        $ update_docker_registry_auth.sh sysinv <sysinv_password>


#.  Lock and Unlock the Controller.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

.. note::

    If the system is a |AIO-DX|, each controller will need to be locked and unlocked.
