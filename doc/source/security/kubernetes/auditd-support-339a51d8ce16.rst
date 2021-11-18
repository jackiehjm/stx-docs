
.. _auditd-support-339a51d8ce16:

=====================
Linux Auditing System
=====================

This section describes the Linux Auditing System containerized solution for
|prod-long|. The container-based solution aligns with the modular
architecture approach of the |prod-p| product.

The Linux Auditing System helps system administrators track security violation
events based on preconfigured audit rules. The events are recorded in a log
file and the information in the log entries helps to detect misuse or
unauthorized activities. Some examples of auditable events are:

-  file or directory access (Such as files/directories that were accessed,
   modified, executed, or attributes changed)

-  system calls (For example, useradd, time-related system calls)

-  commands run by a user (For example, a rule can be defined for every
   executable in the /bin directory and tracked per user.)

-  security events, such as failed login attempts

-  network access (The iptables and ebtables utilities can be configured to
   trigger audit events.)

The Linux Audit daemon, **auditd**, is the main component of the Linux Auditing
System, and is responsible for writing the audit logs. For more information on
**auditd** daemon configuration, see https://man7.org/linux/man-pages/man8/auditd.8.html.

To run **auditd** on |prod-p|, you must enable **auditd** in the kernel of
|prod-p| hosts and then upload and apply the **auditd** system application.


---------------------------
Enable Auditd in the Kernel
---------------------------

The Linux Auditing System is disabled in the |prod-p| kernel by default.

To enable **auditd** in the kernel of all hosts in the system, set the system
service parameter **audit** to '1' and apply the service-parameter change,
using the following commands, executed on the active controller.

.. code-block:: none

    ~(keystone_admin)]$ system service-parameter-modify platform kernel audit=1
    ~(keystone_admin)]$ system service-parameter-apply platform

To persist the service parameter change, all hosts need to be locked and
unlocked, using the following commands on each host:

.. code-block:: none

    ~(keystone_admin)]$ system host-lock <hostname>
    ~(keystone_admin)]$ system host-unlock <hostname>

To verify if the grub kernel parameter **audit** was updated to '1', for a
particular host, ssh to the host, and check the cmdline parameters, for example:

.. code-block:: none

    ~(keystone_admin)]$ cat /proc/cmdline BOOT_IMAGE=/vmlinuz-5.10.57-200.185.tis.el7.x86_64 root=UUID=e11d78a2-7e1c-4613-84c7-002647b1cf8d ro security_profile=standard module_blacklist=integrity,ima tboot=false crashkernel=512M biosdevname=0 console=ttyS0,115200 iommu=pt usbcore.autosuspend=-1 selinux=0 enforcing=0 nmi_watchdog=panic,1 softlockup_panic=1 softdog.soft_panic=1 intel_iommu=on user_namespace.enable=1 nopti nospectre_v2 nospectre_v1 hugepagesz=2M hugepages=0 default_hugepagesz=2M irqaffinity=2-3 rcu_nocbs=2-3 kthread_cpus=0-1 audit=1 audit_backlog_limit=8192

.. note::
    Enabling **auditd** should only be done if the purpose is to start
    **auditd** in the container/pod using the process described in
    :ref:`Start Auditd System Application <start-auditd-system-application>`.
    Otherwise, there will be unnecessary performance impact and the backlog
    events queue limit will eventually exceed, causing ``audit: kauditd hold
    queue overflow`` messages to be displayed.

.. _start-auditd-system-application:

-------------------------------
Start Auditd System Application
-------------------------------

.. rubric:: |prereq|

-  Set the **audit** grub kernel parameter to '1'.

-  The **auditd** container that runs the **auditd** daemon must be started by
   uploading and applying the **audit-armada-app**.

The **auditd** system application is installed as part of the software install
or upgrade.

The **auditd** system application tarball can be found after installation
in the ``/usr/local/share/applications/helm`` directory. The name of the
tarball is **auditd-<version>.tgz**, for example, ``auditd-1.0-2.tgz``.

Use the following commands to upload and apply the **auditd** system application:

.. code-block:: none

    ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/auditd-1.0-2.tgz
    # check the app was uploaded

    ~(keystone_admin)]$ system application-show auditd
    # if status is "uploaded" proceed with app apply

    ~(keystone_admin)]$ system application-apply auditd
    # check the app was applied

    ~(keystone_admin)]$ system application-show auditd
    # if successful, status will be "applied"

To check that **auditd** container/pod is created and running on each master
and worker node, use the following command:

.. code-block:: none

    ~(keystone_admin)]$ kubectl get pods -n kube-system -o wide | grep auditd

    ns-auditd-9hgq5   1/1  Running 0 2m46s face::e95d:7b0:368d:55f8   compute-0     <none> <none>
    ns-auditd-btww5   1/1  Running 1 2m46s face::2d8f:b75d:d511:81ef  compute-1     <none> <none>
    ns-auditd-czsdf   1/1  Running 1 2m46s face::977:4894:111d:5bf0   compute-2     <none> <none>
    ns-auditd-hs62t   1/1  Running 0 2m46s face::3                    controller-1  <none> <none>
    ns-auditd-nn8jw   1/1  Running 0 2m46s face::2                    controller-0  <none> <none>


------------------------------
Auditd Configuration Overrides
------------------------------

The **Auditd** daemon specific configuration is available in the ``/etc/audit/auditd.conf``
file. For more information, see, https://man7.org/linux/man-pages/man5/auditd.conf.5.html.

Besides the **auditd** main configuration file ``auditd.conf``, **auditd** uses
audit rules configuration that is available in the ``/etc/audit/audit.rules``
file which defines what audit events are logged. For more information on how
audit rules are configured, see https://linux.die.net/man/7/audit.rules.

In the |prod-p| containerized **auditd** solution, both configuration files
have default settings that can be overwritten using Helm chart overrides.

The Helm chart overrides are applied using the following command:

.. code-block:: none

    ~(keystone_admin)]$ system helm-override-update auditd auditd kube-system --reuse-values --values /home/sysadmin/<user_specific_config>.yaml

The ``<user_specific_config>.yaml`` defines the overrides that will apply either
to the ``auditd.conf`` and/or to the ``audit.rules`` files.

.. note::
    The default values for ``auditd.conf`` should be sufficient and you do not
    need to update them.

In rare cases, the following example describes how to update the default value
with the desired value.

Example of user defined overrides file for ``auditd.conf``:

.. code-block:: none

    auditdconf: |-
      ##########################################################################
      #
      # auditd.conf
      #
      ##########################################################################
      local_events = yes
      write_logs = yes
      log_file = /var/log/audit/audit.log
      log_group = root
      log_format = RAW
      flush = INCREMENTAL_ASYNC
      freq = 50
      max_log_file = 8
      num_logs = **8**
      priority_boost = 4
      disp_qos = lossy
      dispatcher = /sbin/audispd
      name_format = NONE
      ##name = mydomain
      max_log_file_action = IGNORE
      space_left = 75
      space_left_action = SYSLOG
      ##verify_email = yes
      ##action_mail_acct = root
      admin_space_left = 50
      admin_space_left_action = SYSLOG
      disk_full_action = SYSLOG
      disk_error_action = SYSLOG
      use_libwrap = yes
      ##tcp_listen_port = 60
      ##tcp_listen_queue = 5
      ##tcp_max_per_addr = 1
      ##tcp_client_ports = 1024-65535
      ##tcp_client_max_idle = 0
      enable_krb5 = no
      krb5_principal = auditd
      distribute_network = no

Example of user defined overrides file for ``audit.rules``:

.. code-block:: none

    auditdrules: |-
      ## First rule - delete all
      -D

      ## Increase the buffers to survive stress events.
      ## Make this bigger for busy systems
      -b 8192

      ## Set failure mode to syslog
      -f 1

      -a always,exit -F arch=b32 -S init_module,finit_module,delete_module -F key=modules
      -a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F key=modules

.. note::
    The log rotation configuration in ``auditd.conf`` file must not be updated,
    and must use the default value, **max_log_file_action = IGNORE**, since
    the logrotate linux utility is used to manage **auditd** log rotation.

Apply the **audit** rules overrides using the following command:

.. code-block:: none

    ~(keystone_admin)]$ system application-apply auditd

Check that application apply has completed successfully:

.. code-block:: none

    ~(keystone_admin)]$ system application-show auditd

The Helm chart overrides :command:`system helm-override-update` command,
automatically applies the additional rules from the user provided yaml file to
the ``audit.rules`` in the **auditd** container.

Similarly, configuration overrides can be applied to update the default
configuration of ``auditd.conf`` using the :command:`system helm-override-update`
command.

-----------
Auditd logs
-----------

**auditd** logs can be viewed on the host in the ``/var/log/audit`` directory.
Logs are generated by the **auditd** daemon running in the container and the
logs record auditable events configured using the ``audit.rules`` file. Log
rotation is automatically configured by the system.

--------------
Disable Auditd
--------------

You may decide to disable **auditd** for performance reasons. First, you must
remove the **auditd** application. Then, you must set the kernel service
parameter **audit** to '0'. These steps removes the **auditd** containers on
all hosts and the **auditd** application.

Use the following system commands to disable **auditd**:

To remove the **auditd** application:

.. code-block:: none

    ~(keystone_admin)]$ system application-remove auditd
    ~(keystone_admin)]$ system application-delete auditd

To verify that the application does not exist in the system:

.. code-block:: none

    ~(keystone_admin)]$ system application-list |grep auditd

To set the kernel service parameter **audit** to '0':

.. code-block:: none

    ~(keystone_admin)]$ system service-parameter-modify platform kernel audit=0
    ~(keystone_admin)]$ system service-parameter-apply platform

To persist the kernel parameter change, all hosts need to be locked and
unlocked:

.. code-block:: none

    ~(keystone_admin)]$ system host-lock controller-0
    ~(keystone_admin)]$ system host-unlock controller-0

