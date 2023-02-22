
.. mab1596215747624
.. _security-vault-overview:

==============
Vault Overview
==============

|prod| integrates open source Vault containerized security application
\(Optional\) into the |prod| solution, that requires |PVCs| as a storage
backend to be enabled.

Vault is a containerized secrets management application that provides
encrypted storage with policy-based access control and supports multiple
secrets storage engines and auth methods.

|prod| includes a Vault-manager container to handle initialization of the
Vault servers. Vault-manager also provides the ability to automatically
unseal Vault servers in deployments where an external autounseal method
cannot be used. For more information, see, `https://www.vaultproject.io/
<https://www.vaultproject.io/>`__.

There are two methods for using Vault secrets with hosted applications:


.. _security-vault-overview-ul-ekx-y4m-4mb:

-   The first method is to have the application be Vault Aware and retrieve
    secrets using the Vault REST API. This method is used to allow an
    application to write secrets to Vault, provided the applicable policy gives
    write permission at the specified Vault path.

.. xbooklink

   For more information, see |usertasks-doc|: :ref:`Vault Aware <vault-aware>`.


-   The second method is to have the application be Vault Unaware and use
    the Vault Agent Injector to make secrets available on the container
    filesystem.

.. xbooklink

   For more information, see, |usertasks-doc|: :ref:`Vault Unaware <vault-unaware>`.

.. seealso::

    * `Vault Command References <https://developer.hashicorp.com/vault/docs/v1.9.x>`_

    * `Vault REST API reference <https://developer.hashicorp.com/vault/api-docs/v1.9.x>`_

    * `Vault Helm chart overrides <https://github.com/hashicorp/vault-helm/blob/v0.19.0/values.yaml>`_