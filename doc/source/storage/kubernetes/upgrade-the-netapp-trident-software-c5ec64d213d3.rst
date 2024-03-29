.. _upgrade-the-netapp-trident-software-c5ec64d213d3:

===================================
Upgrade the NetApp Trident Software
===================================

.. rubric:: |context|

|prod| |prod-ver| contains the installer for Trident 22.07, but installations
that have been upgraded from the previous |prod| version and were configured
to use a NetApp backend will still be running Trident 21.04 after the upgrade
to |prod| |prod-ver|.

.. code-block:: none

    [sysadmin@controller-0 trident(keystone_admin)]$ tridentctl -n trident version
    +----------------+----------------+
    | SERVER VERSION | CLIENT VERSION |
    +----------------+----------------+
    | 20.04.0        | 21.04.1        |
    +----------------+----------------+

.. note::

    In the table above, the client version refers to the binary
    (``tridentctl``) and the server version refers to the services installed in
    Kubernetes.

    This difference between versions only occurs during the upgrade, as the
    client version will be upgraded, but the server version will be the current
    version at this point.

.. rubric:: |proc|

Before upgrading Kubernetes to version |kube-ver|, the running version of Trident
must be updated to 22.07. This will not disrupt any containers that are already
running, but will cause a brief outage to the NetApp Trident control plane.

The steps are as follows:

#.  Locate the ``localhost.yaml`` file that was used originally to install
    Trident, as described in :ref:`Configure an External NetApp Deployment as
    the Storage Backend
    <configure-an-external-netapp-deployment-as-the-storage-backend>`.

#.  Add the line ``trident_force_reinstall: true`` to the file.

#.  Run the ``install_netapp_backend.yml`` playbook again as per Run Playbook
    step of section :ref:`Configure an External NetApp Deployment as the
    Storage Backend
    <configure-an-external-netapp-deployment-as-the-storage-backend>`.

#.  On completion, verify that the Trident server version has been updated:

    .. code-block:: none

        [sysadmin@controller-0 trident(keystone_admin)]$ tridentctl -n trident version
        +----------------+----------------+
        | SERVER VERSION | CLIENT VERSION |
        +----------------+----------------+
        | 21.01          | 22.07          |
        +----------------+----------------+
