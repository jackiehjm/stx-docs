
.. bkh1558616177792
.. _update-management-for-distributed-cloud:

=======================================
Update Management for Distributed Cloud
=======================================

You can apply software updates (also known as 'patches') to the Central Cloud
and subclouds from the System Controller.

A central update repository on the Central Cloud is introduced for |prod-dc|.
This is used to store all updates (patches) so that unmanaged subclouds can
be synchronized with any required updates when they are brought into a managed
state.

To ensure the integrity of the |prod-dc| system, all updating must be done from
the Central Cloud.

.. caution::

    Any updates that were applied to the Central Cloud prior to running
    :command:`ansible bootstrap playbook`, including updates incorporated in
    the installation ISO file and updates installed using :command:`sw-patch`
    commands, must be uploaded to the System Controller. This ensures that the
    updates are in the central update repository and the subclouds can be
    updated with them.

You can use the Horizon Web interface or the command line interface to manage
updates. The workflow for patching is as follows:


.. _update-management-for-distributed-cloud-ul-pz2-gwd-rdb:

#.  Review the update status of the systems in the |prod-dc|.

    See :ref:`Reviewing Update Status for Distributed Cloud Using Horizon
    <reviewing-update-status-for-distributed-cloud-using-horizon>`.

#.  Upload and apply any required updates to the System Controller. This adds
    them to a Central Update Repository, making them available to the
    SystemController and all subclouds.

    See :ref:`Uploading and Applying Updates to SystemController Using Horizon
    <uploading-and-applying-updates-to-systemcontroller-using-horizon>`.

#.  Update the Central Cloud's RegionOne and all subclouds with the updates
    using update orchestration.

    See :ref:`Update Orchestration of Central Cloud's RegionOne and Subclouds
    <update-orchestration-of-central-clouds-regionone-and-subclouds>`.

    .. note::
        For |prod-dc|, manual updating of individual subclouds is not recommended.


