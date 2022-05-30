
.. aif1596225477506
.. _remove-vault:

============
Remove Vault
============

You can remove Vault from your |prod-long|, if required, by using the
procedure described in this section.

.. rubric:: |context|

Run the following commands to remove Vault. This will remove pods and other
resources created by the application installation. For more information, see
:ref:`Install Vault <install-vault>`.

.. rubric:: |proc|

#.  Remove pods and other resources using the following command:

    .. code-block:: none

        $ system application-remove vault


#.  Reinstall Vault, if required using the following command:

    .. code-block:: none

        $ system application-apply vault

    .. note::
        It is recommended to do a complete remove of all resources if you want
        to reinstall Vault.

        .. code-block:: none

            $ kubectl delete ns vault


#.  To completely remove Vault, including PVCs \(PVCs are intended to
    persist after :command:`system application-remove vault` in order to
    preserve Vault data\), use the following command.

    .. code-block:: none

        $ kubectl delete ns vault
        $ system application-delete vault
