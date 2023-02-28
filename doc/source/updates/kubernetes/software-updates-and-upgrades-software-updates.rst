
.. lei1552920487053
.. _software-updates-and-upgrades-software-updates:

================
Software Updates
================

|prod-long| software updates (also known as patches) must be applied to the
system in order to keep your system updated with feature enhancements, free of
known bugs, and security vulnerabilities.

|org| provides software updates that are cryptographically signed to ensure
integrity and authenticity. The |prod-long| REST APIs, CLIs and GUI validate
the signature of software updates before loading it into the system.

An update typically modifies a small portion of your system to address the
following items:

.. _software-updates-and-upgrades-software-updates-ul-gcd-smn-xw:

-   bugs

-   security vulnerabilities

-   feature enhancements

Software updates can be installed manually or by the Update Orchestrator, which
automates a rolling install of an update across all of the |prod-long| hosts.
For more information on manual updates, see :ref:`Manage Software Updates
<managing-software-updates>`. For more information on upgrade orchestration,
see :ref:`Orchestrated Software Update <update-orchestration-overview>`.

.. warning::
    Do NOT use the |updates-doc| guide for |prod-dc| orchestrated
    software updates. The |prod-dc| Update Orchestrator automates a
    recursive rolling install of an update across all subclouds and all hosts
    within the subclouds.

.. xbooklink    For more information, see, |distcloud-doc|: :ref:`Update Management for
    Distributed Cloud <update-management-for-distributed-cloud>`.

|prod| handles multiple updates being applied and removed at once. Software
updates can modify and update any area of |prod| software, including the kernel
itself. For information on populating, installing and removing software
updates, see :ref:`Manage Software Updates <managing-software-updates>`.

There are two different kinds of Software updates that you can use to update
the |prod| software:

.. _software-updates-and-upgrades-software-updates-ol-kxm-wgv-njb:

#.  **Software Updates**

    These software updates deliver |prod| software updates containing ostree
    commits for updating the |prod| software running directly on the hosts.

    Software updates can be installed manually or by the Update Orchestrator
    which automates a rolling install of an update across all of the
    |prod-long| hosts.

    The |prod| handles multiple updates being applied and removed at once.
    Software updates can modify and update any area of |prod| software,
    including the kernel itself.

    For information on populating, installing and removing software updates,
    see :ref:`Manage Software Updates <managing-software-updates>`.

    .. note::
        A 10 GB internal management network is required for reboot-required
        software update operations.

#.  **Application Software Updates**

    These software updates apply to software being managed through the
    StarlingX Application Package Manager, that is, :command:`system
    application-upload/apply/remove/delete`. |prod| delivers some software
    through this mechanism, for example, ``platform-integ-apps``.

    For software updates for these applications, download the updated
    application tarball, containing the updated FluxCD manifest, and updated
    Helm charts for the application, and apply the updates using the
    :command:`system application-update` command.

.. xbooklink    For more information, see,
    :ref:`Cloud Platform Kubernetes Admin Tutorials
    <about-the-admin-tutorials>`: :ref:`StarlingX Application Package Manager
    <kubernetes-admin-tutorials-tarlingx-application-package-manager>`.
