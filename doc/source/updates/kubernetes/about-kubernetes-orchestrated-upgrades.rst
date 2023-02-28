
.. xkr1590157116928
.. _about-kubernetes-orchestrated-upgrades:

====================================================
About Kubernetes Version Upgrade Cloud Orchestration
====================================================

Kubernetes version upgrade cloud orchestration allows the Kubernetes version on
all hosts of an entire |prod-long| cloud to be updated with a single operation.

You can configure and run Kubernetes version upgrade cloud orchestration using
the CLI, or the stx-nfv VIM REST API.


.. _xkr1590157116928-section-phk-xls-tlb:

-----------------------------------------------------------
Kubernetes Version Upgrade Cloud Orchestration Requirements
-----------------------------------------------------------

Kubernetes version upgrade orchestration can only be done on a system that
meets the following conditions:


.. _xkr1590157116928-ul-frz-yls-tlb:

-   The system is clear of alarms (with the exception of alarms for locked
    hosts, stopped instances, and Kubernetes version upgrade cloud
    orchestration in progress).

    .. note::
        When configuring Kubernetes version upgrade cloud orchestration, you
        have the option to ignore alarms that are not management-affecting
        severity. For more information, see :ref:`Kubernetes Version Upgrade
        Cloud Orchestration <configuring-kubernetes-update-orchestration>`.

-   There are unlocked-enabled worker function hosts in the system that
    requires Kubernetes Version Upgrade Cloud Orchestration. The *Kubernetes
    Upgrade Orchestration Strategy* creation step will fail if there are no
    qualified hosts detected.

    A Kubernetes version upgrade is a reboot required operation. Therefore, in
    systems that have the |prefix|-openstack application applied with running
    instances, if the migrate option is selected there must be spare
    openstack-compute (worker) capacity to move instances off the
    openstack-compute (worker) host\(s) being upgraded.

-   If you are using NetApp Trident in |prod| |prod-ver| and have upgraded from
    the |prod| previous version, ensure that your NetApp backend version is
    compatible with Trident 22.01 and follow the steps in :ref:`Upgrade the
    NetApp Trident Software <upgrade-the-netapp-trident-software-c5ec64d213d3>`
    to upgrade the Trident drivers to 22.01 before upgrading Kubernetes to
    version |kube-ver|.

    .. note::
        Administrative controller ``swact`` operations should be avoided during
        Kubernetes version upgrade orchestration.
