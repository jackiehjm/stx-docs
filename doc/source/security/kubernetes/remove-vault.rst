
.. aif1596225477506
.. _remove-vault:

============
Remove Vault
============

You can remove Vault from your |prod-long|, if required, by using the
procedure described in this section.

.. rubric:: |context|

Run the following commands to remove Vault. This will remove pods and other
resources created by the Armada installation. For more information, see
:ref:`Install Vault <install-vault>`.

.. rubric:: |proc|

#.  Remove pods and other resources using the following command:

    .. code-block:: none

        $ system application-remove vault

#.  \(Optional\) If you want to reinstall Vault, and only retain Vault data
    stored in PVCs, use the following command:

    .. code-block:: none

        $ kubectl delete secrets -n vault vault-server-tls


    #.  Reinstall Vault, if required using the following command:

        .. code-block:: none

            $ system application-apply vault

        .. note::
            It is recommended to do a complete remove of all resources if you
            want to reinstall Vault.


#.  To completely remove Vault, including PVCs \(PVCs are intended to
    persist after :command:`system application-remove vault` in order to
    preserve Vault data\), use the following command.

    .. code-block:: none

        $ kubectl delete ns vault
        $ system application-delete vault


