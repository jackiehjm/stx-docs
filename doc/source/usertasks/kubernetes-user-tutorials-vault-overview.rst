
.. myx1596548399062
.. _kubernetes-user-tutorials-vault-overview:

==============
Vault Overview
==============

You can optionally integrate open source Vault secret management into the
|prod| solution. The Vault integration requires :abbr:`PVC (Persistent Volume
Claims)` as a storage backend to be enabled.

There are two methods for using Vault secrets with hosted applications:

.. _kubernetes-user-tutorials-vault-overview-ul-ekx-y4m-4mb:

#.  Have the application be Vault Aware and retrieve secrets using the Vault
    REST API. This method is used to allow an application write secrets to
    Vault, provided the applicable policy gives write permission at the
    specified Vault path. For more information, see
    :ref:`Vault Aware <vault-aware>`.

#.  Have the application be Vault Unaware and use the Vault Agent Injector to
    make secrets available on the container filesystem. For more information,
    see, :ref:`Vault Unaware <vault-unaware>`.

Both methods require appropriate roles, policies and auth methods to be
configured in Vault.

.. xreflink For more information, see |sec-doc|: :ref:`Vault Secret
   and Data Management <security-vault-overview>`.
