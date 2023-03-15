
.. ngo1596216203295
.. _install-vault:

=============
Install Vault
=============

Vault is packaged as a system application and is managed using
:command:`system application`, and :command:`system helm-override` commands.

.. rubric:: |context|

.. note::
    Vault requires a storage backend with PVC enabled (for example, Ceph).

To install Vault, use the following procedure:

.. rubric:: |proc|

#.  Locate the Vault tarball in ``/usr/local/share/applications/helm``.

    For example, ``/usr/local/share/applications/helm/vault-1.0-30.tgz``.

#.  Upload Vault, using the following command:

    .. code-block:: none

        $ system application-upload ``/usr/local/share/applications/helm/vault-1.0-30.tgz``

#.  Verify the Vault tarball has been uploaded.

    .. code-block:: none

        $ system application-list

#.  Apply the Vault application.

    .. code-block:: none

        $ system application-apply vault

#.  Monitor the status.

    .. code-block:: none

        $ watch -n 5 system application-list

    or

    .. code-block:: none

        $ watch kubectl get pods -n vault

    It takes a few minutes for all the pods to start and for Vault-manager
    to initialize the cluster.

    The default configuration for the installed Vault application is:

    **Vault-manager**
        Runs as a statefulset, replica count of 1

    **Vault-agent-injector**
        Runs as a deployment, replica count of 1

    **Vault**
        Runs as statefulset, replica count is 1 on systems with fewer
        than 3 nodes, replica count is 3 on systems with 3 or more nodes


For more information, see :ref:`Configure Vault <configure-vault>`.


