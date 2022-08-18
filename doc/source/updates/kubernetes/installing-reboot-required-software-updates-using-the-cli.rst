
.. ffh1552920650754
.. _installing-reboot-required-software-updates-using-the-cli:

======================================================
Install Reboot-Required Software Updates Using the CLI
======================================================

You can install reboot-required software updates using the CLI.

.. rubric:: |proc|


.. _installing-reboot-required-software-updates-using-the-cli-steps-v1q-vlv-vw:

#.  Log in as user **sysadmin** to the active controller and source the script
    ``/etc/platform/openrc`` to obtain administrative privileges.

#.  Verify that the updates are available using the :command:`sw-patch query`
    command.

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch query

        Patch ID                Patch State
        =====================   ===========
        |pn|-nn.nn_PATCH_0001   Available
        |pn|-nn.nn_PATCH_0002   Available
        |pn|-nn.nn_PATCH_0003   Available

    where *nn.nn* in the update \(patch\) filename is the |prod| release number.

#.  Ensure the original update files have been deleted from the root drive.

    After the updates are uploaded to the storage area, the original files are
    no longer required. You must use the command-line interface to delete them,
    in order to ensure enough disk space to complete the installation.

    .. code-block:: none

        $ rm </path/patchfile>

    .. caution::
        If the original files are not deleted before the updates are applied,
        the installation may fail due to a full disk.

#.  Apply the update.

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch apply |pn|-<nn>.<nn>_PATCH_0001
        |pn|-<nn>.<nn>_PATCH_0001 is now in the repo

    where <nn>.<nn> in the update filename is the |prod-long| release number.

    The update is now in the Partial-Apply state, ready for installation from
    the software updates repository on the impacted hosts.

#.  Apply all available updates in a single operation, for example:

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch apply --all
        |pn|-|pvr|-PATCH_0001 is now in the repo
        |pn|-|pvr|-PATCH_0002 is now in the repo
        |pn|-|pvr|-PATCH_0003 is now in the repo

    In this example, there are three updates ready for installation from the
    software updates repository.

#.  Query the updating status of all hosts in the cluster.

    You can query the updating status of all hosts at any time as illustrated
    below.

    .. note::
        The reported status is the accumulated result of all applied and
        removed updates in the software updates repository, and not just the
        status due to a particular update.

    .. code-block:: none

        ~(keystone_admin)]$ sudo sw-patch query-hosts

          Hostname      IP Address    Patch Current  Reboot Required  Release  State
        ============  ==============  =============  ===============  =======  =====
        worker-0      192.168.204.12       Yes              No          nn.nn   idle
        controller-0  192.168.204.3        Yes              Yes         nn.nn   idle
        controller-1  192.168.204.4        Yes              Yes         nn.nn   idle


    For each host in the cluster, the following status fields are displayed:

    **Patch Current**
        Indicates whether there are updates pending for installation or removal
        on the host or not. If *Yes*, then all relevant updates in the software
        updates repository have been installed on, or removed from, the host
        already. If *No*, then there is at least one update in either the
        Partial-Apply or Partial-Remove state that has not been applied to the
        host.

        The **Patch Current** field of the :command:`query-hosts` command will
        briefly report *Pending* after you apply or remove an update, until
        that host has checked against the repository to see if it is impacted
        by the patching operation.

    **Reboot Required**
        Indicates whether the host must be rebooted or not as a result of one
        or more updates that have been either applied or removed, or because it
        is not 'patch current'.

    **Release**
        Indicates the running software release version.

    **State**
        There are four possible states:

        **idle**
           In a wait state.

        **installing**
           Installing \(or removing\) updates.

        **install-failed**
           The operation failed, either due to an update error or something
           killed the process. Check the ``patching.log`` on the node in
           question.

        **install-rejected**
           The node is unlocked, therefore the request to install has been
           rejected. This state persists until there is another install
           request, or the node is reset.

        Once the state has gone back to idle, the install operation is complete
        and you can safely unlock the node.

    In this example, **worker-0** is up to date, no updates need to be
    installed and no reboot is required. By contrast, the controllers are not
    'patch current', and therefore a reboot is required as part of installing
    the update.

#.  Install all pending updates on **controller-0**.


    #.  Switch the active controller services.

        .. code-block:: none

            ~(keystone_admin)]$ system host-swact controller-0

        Before updating a controller node, you must transfer any active
        services running on the host to the other controller. Only then it is
        safe to lock the host.

    #.  Lock the host.

        You must lock the target host, controller, worker, or storage, before
        installing updates.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-0

    #.  Install the update.

        .. code-block:: none

            ~(keystone_admin)]$ sudo sw-patch host-install <controller-0>

        .. note::
            You can use the :command:`sudo sw-patch host-install-async <hostname>`
            command if you are launching multiple installs in
            parallel.

    #.  Unlock the host.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-0

        Unlocking the host forces a reset of the host followed by a reboot.
        This ensures that the host is restarted in a known state.

    All updates are now installed on controller-0. Querying the current
    update status displays the following information:

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

#.  Install all pending updates on controller-1.

    .. note::
        For |prod| Simplex systems, this step does not apply.

    Repeat the previous step targeting controller-1.

    All updates are now installed on controller-1 as well. Querying the
    current updating status displays the following information:

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

#.  Install any pending updates for the worker or storage hosts.

    .. note::
         This step does not apply for |prod| Simplex or Duplex systems.

    All hosted application pods currently running on a worker host are
    re-located to another host.

    If the **Patch Current** status for a worker or storage host is *No*,
    apply the pending updates using the following commands:

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <hostname>

    .. code-block:: none

        ~(keystone_admin)]$ sudo sw-patch host-install-async <hostname>

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostname>

    where <hostname> is the name of the host \(for example, ``worker-0``\).

    .. note::
        Update installations can be triggered in parallel.

        The :command:`sw-patch host-install-async` command \( cooresponding to
        **install patches** on the Horizon Web interface\) can be run on all
        locked nodes, without waiting for one node to complete the install
        before triggering the install on the next. If you can lock the nodes at
        the same time, without impacting hosted application services, you can
        update them at the same time.

        Likewise, you can install an update to the standby controller and a
        worker node at the same time. The only restrictions are those of the
        lock: 
        
        * You cannot lock both controllers.
        
        * You cannot lock a worker node if you do not have enough free resources
          to relocate the hosted applications from it. 
          
        Also, in a Ceph configuration \(with storage nodes\), you cannot lock
        more than one of controller-0/controller-1/storage-0 at the same time,
        as these nodes are running Ceph monitors and you must have at least two
        in service at all times.

#.  Confirm that all updates are installed and the |prod| is up-to-date.

    Use the :command:`sw-patch query` command to verify that all updates are
    *Applied*.

    .. parsed-literal::

        ~(keystone_admin)]$ sudo sw-patch query

        Patch ID                    Patch State
        =========================   ===========
        |pn|-<nn>.<nn>_PATCH_0001   Applied

    where <nn>.<nn> in the update filename is the |prod| release number.

    If the **Patch State** for any update is still shown as *Available* or
    *Partial-Apply*, use the :command:`sw-patch query-hosts`` command to identify
    which hosts are not *Patch Current*, and then apply updates to them as
    described in the preceding steps.


.. rubric:: |result|

The |prod| is up to date now. All updates are installed.
