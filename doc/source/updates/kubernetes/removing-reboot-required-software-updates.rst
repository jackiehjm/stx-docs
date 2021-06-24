
.. scm1552920603294
.. _removing-reboot-required-software-updates:

=======================================
Remove Reboot-Required Software Updates
=======================================

Updates in the *Applied* or *Partial-Apply* states can be removed if necessary,
for example, when they trigger undesired or unplanned effects on the cluster.

.. rubric:: |context|

Rolling back updates is conceptually identical to installing updates. A
roll-back operation can be commanded for an update in either the *Applied* or
the *Partial-Apply* states. As the update is removed, it goes through the
following state transitions:

**Applied or Partial-Apply to Partial-Remove**
    An update in the *Partial-Remove* state indicates that it has been removed
    from zero or more, but not from all, the applicable hosts.

    Use the command :command:`sw-patch remove` to trigger this transition.

**Partial-Remove to Available**
    Use the command :command:`sudo sw-patch host-install-async` <hostname>
    repeatedly targeting each one of the applicable hosts in the cluster. The
    transition to the *Available* state is complete when the update is removed
    from all target hosts. The update remains in the update storage area as if
    it had just been uploaded.

    .. note::
        The command :command:`sudo sw-patch host-install-async` <hostname> both
        installs and removes updates as necessary.

The following example describes removing an update that applies only to the
controllers. Removing updates can be done using the Horizon Web interface,
also, as discussed in :ref:`Install Reboot-Required Software Updates Using
Horizon <installing-reboot-required-software-updates-using-horizon>`.

.. rubric:: |proc|

#.  Log in as Keystone user **admin** to the active controller.

#.  Verify the state of the update.

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch query
        Patch ID                         Patch State
        =========================        ===========
        |pn|-|pvr|-PATCH_0001         Applied

    In this example the update is listed in the *Applied* state, but it could
    be in the *Partial-Apply* state as well.

#.  Remove the update.

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch remove |pn|-|pvr|-PATCH_0001
        |pn|-|pvr|-PATCH_0001 has been removed from the repo

    The update is now in the *Partial-Remove* state, ready to be removed from
    the impacted hosts where it was already installed.

#.  Query the updating status of all hosts in the cluster.

    .. code-block:: none

        ~(keystone_admin)]$ sudo sw-patch query-hosts

          Hostname      IP Address     Patch Current  Reboot Required  Release  State
        ============  ===============  =============  ===============  =======  =====
        compute-0     192.168.204.179       Yes             No          nn.nn   idle
        compute-1     192.168.204.173       Yes             No          nn.nn   idle
        controller-0  192.168.204.3         No              No          nn.nn   idle
        controller-1  192.168.204.4         No              No          nn.nn   idle
        storage-0     192.168.204.213       Yes             No          nn.nn   idle
        storage-1     192.168.204.181       Yes             No          nn.nn   idle


    In this example, the controllers have updates ready to be removed, and
    therefore must be rebooted.

#.  Remove all pending-for-removal updates from **controller-0**.

    #.  Swact controller services away from controller-0.

    #.  Lock controller-0.

    #.  Run the updating \(patching\) sequence.

        .. code-block:: none

            ~(keystone_admin)]$ sudo sw-patch host-install-async <controller-0>

    #.  Unlock controller-0.

#.  Remove all pending-for-removal updates from controller-1.

    #.  Swact controller services away from controller-1.

    #.  Lock controller-1.

    #.  Run the updating sequence.

    #.  Unlock controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ sudo sw-patch host-install-async <controller-1>

.. rubric:: |result|

The cluster is up to date now. All updates have been removed, and the update
|pn|-|pvr|-PATCH_0001 can be deleted from the storage area if necessary.
