
.. qdu1595389242059
.. _updating-docker-registry-credentials-on-a-subcloud:

================================================
Update Docker Registry Credentials on a Subcloud
================================================

On a subcloud that uses the System Controller's Docker registry
(registry.central) as its install registry, you should use the
System Controller's sysinv service credentials for accessing registry.central.
This makes access to registry.central independent of changes to the Distributed
Cloud's Keystone admin user password.

Use the following procedure to update the install registry credentials on the
subcloud to the ``sysinv`` service credentials of the System Controller.

.. rubric:: |proc|

.. _updating-docker-registry-credentials-on-a-subcloud-steps-ywx-wyt-kmb:

#.  On the System Controller, get the password for the ``sysinv`` services.

    .. code-block:: none

        $ keyring get sysinv services

#.  On each subcloud, run the following script to update the Docker registry
    credentials to ``sysinv``:

    .. code-block:: none

        $ update_docker_registry_auth.sh sysinv <sysinv_password>

