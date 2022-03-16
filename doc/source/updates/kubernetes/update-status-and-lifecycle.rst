
.. utq1552920689344
.. _update-status-and-lifecycle:

===========================
Update Status and Lifecycle
===========================

|prod| software updates move through different status levels as the updates are
being applied.

.. rubric:: |context|

After adding an update \(patch\) to the storage area you must move it to the
repository, which manages distribution for the cluster. From there, you can
install the updates to the hosts that require them.

Some of the available updates may be required on controller hosts only, while
others may be required on worker or storage hosts. Use :command:`sw-patch
query-hosts` to see which hosts are impacted by the newly applied \(or
removed\) updates. You can then use :command:`sw-patch host-install` to update
the software on individual hosts.

To keep track of software update installation, you can use the
:command:`sw-patch query` command.

.. parsed-literal::

    ~(keystone_admin)]$ sudo sw-patch query
    Patch ID	            Patch State
    ===========             ============
    |pvr|-nn.nn_PATCH_0001  Applied

where *nn.nn* in the update filename is the |prod| release number.

This shows the **Patch State** for each of the updates in the storage area:

**Available**
    An update in the *Available* state has been added to the storage area, but
    is not currently in the repository or installed on the hosts.

**Partial-Apply**
    An update in the *Partial-Apply* state has been added to the software
    updates repository using the :command:`sw-patch apply` command, but has not
    been installed on all hosts that require it. It may have been installed on
    some but not others, or it may not have been installed on any hosts. If any
    reboot-required update is in a partial state \(Partial-Apply or
    Partial-Remove\), you cannot update the software on any given host without
    first locking it. If, for example, you had one reboot-required update and
    one in-service update, both in a Partial-Apply state and both applicable to
    node X, you cannot just install the non-reboot-required update to the
    unlocked node X.

**Applied**
    An update in the *Applied* state has been installed on all hosts that
    require it.

You can use the :command:`sw-patch query-hosts` command to see which hosts are
fully updated \(**Patch Current**\). This also shows which hosts require
reboot, either because they are not fully updated, or because they are fully
updated but not yet rebooted.

.. code-block:: none

    ~(keystone_admin)]$ sudo sw-patch query-hosts

     Hostname      IP Address    Patch Current  Reboot Required  Release  State
    ============  ==============  =============  ===============  =======  =====
    worker-0      192.168.204.95       Yes             No          nn.nn   idle
    worker-1      192.168.204.63       Yes             No          nn.nn   idle
    worker-2      192.168.204.99       Yes             No          nn.nn   idle
    worker-3      192.168.204.49       Yes             No          nn.nn   idle
    controller-0  192.168.204.3        Yes             No          nn.nn   idle
    controller-1  192.168.204.4        Yes             No          nn.nn   idle
    storage-0     192.168.204.37       Yes             No          nn.nn   idle
    storage-1     192.168.204.90       Yes             No          nn.nn   idle
