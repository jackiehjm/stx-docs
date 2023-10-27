======================
Debug StarlingX Issues
======================

This guide contains some basic steps for debugging issues on StarlingX.

.. contents::
   :local:
   :depth: 1

----------------
Record the issue
----------------

Record information about the issue so it can be reproduced during debugging. The
items below describe some issue characteristics to capture.

*   Deployment issue type, such as bootstrap failure, provisioning failure, or
    functional failures.

*   Check the StarlingX version with the command:
    ::

      cat /etc/build.info


*   Check the StarlingX deployment configuration, such as: Simplex, Duplex,
    Multi-node, by viewing the platform configuration file:
    ::

      cat /etc/platform/platform.conf

*   Server type, such as bare metal server(s) or VMs.

*   Hardware device types and characteristics, such as NICs, PCI cards, # of
    hard disks, and RAM size.

*   Other aspects of the issue include: steps for reproducing, expected results,
    actual results, and so on.

*   Can the issue be reproduced regularly or occasionally?

*   Gather log files and configuration files using the ``collect`` command.


---------------------
Check status and logs
---------------------

*   Log in to the active controller.

*   Check services using the ``sm-dump`` command:
    ::

      sudo sm-dump

*   Check services using the ``systemctl`` command.

*   Apply the platform environment for ``sysadmin`` using:
    ::

      source /etc/platform/openrc

*   Check alarms from Fault-Manager using:
    ::

      fm alarm-list --uuid
      fm alarm-show <uuid>

*   Search for errors in ``/var/log``.

    *   You **must** check ``/var/log/sysinv.log`` for errors.
    *   You can get hints from ``sysinv.log`` for many deployment failures.
    *   Look into other log files based on the functional area.

*   If a functional area log file includes errors, check the associated
    configuration file, which is typically located under the ``/etc/``
    subdirectory.

*   You may need to enable the ``debug`` option in the configuration file.

----------------
Debug and triage
----------------

*   Check the Kubernetes status for: node, pod/job, endpoint, services, secret,
    configmap.

*   Check the two major namespaces: kube-system, openstack

*   If issues occur inside containerized components, you need to enter the
    service using the ``kubectl exec`` command.

---------------
Implement fixes
---------------

*   You can try to resolve the issue by manually making some online
    changes without rebooting Linux or even re-deploying StarlingX. For
    example, you can modify system config files or the StarlingX
    config/database. You can make the changes and restart the corresponding
    services using the ``systemctl`` command or the StarlingX ``sm`` (service
    management) command.

*   If the fixes must be put on certain nodes (controller, worker, storage),
    you can temporarily **lock** that node, make changes using StarlingX
    commands, and then **unlock** the lock, to make the changes take effect.

*   If the changes must be made in C/C++/Go code, you can:

    *   Make the changes in your *development workspace* with the StarlingX
        codebase.
    *   Build the related packages using ``build-pkgs <package_name>``.
    *   Create and apply the patch using the :ref:`starlingx_patching` guide.
    *   Restart the services using the ``systemctl`` command or the StarlingX
        ``sm`` (service management) command.

--------------------
Additional resources
--------------------

*   Review the `StarlingX Discuss list <https://lists.starlingx.io/archives/list/starlingx-discuss@lists.starlingx.io/>`_
    for similar questions and workarounds from the community.

*   Check the `StarlingX Launchpad <https://launchpad.net/starlingx>`_ for
    similar issues and potential workarounds.

*   Open a new `StarlingX Launchpad <https://launchpad.net/starlingx>`_ item to
    report a bug.


