
.. myy1552681345265
.. _security-feature-configuration-for-spectre-and-meltdown:

=======================================================
Security Feature Configuration for Spectre and Meltdown
=======================================================

The system allows for the security features of the Linux kernel to be
configured to mitigate the variants of Meltdown and Spectre side-channel
vulnerabilities \(CVE-2017-5754, CVE-2017-5753, CVE-2017-5715\).


.. _security-feature-configuration-for-spectre-and-meltdown-section-N1001F-N1001C-N10001:

--------
Overview
--------

By default, mitigation is provided against Spectre v1 type attacks.
Additional mitigation can be enabled to cover Spectre v2 attacks and
Meltdown attacks. Enabling this mitigation may affect system performance.
The spectre\_v2 may also require firmware or BIOS updates from your
motherboard manufacturer to be effective.




.. _security-feature-configuration-for-spectre-and-meltdown-table-hpl-gqx-vdb:


.. table::
    :widths: auto

    +-----------------------------------+---------------------------------------------------------+
    | **Option name**                   | **Description**                                         |
    +-----------------------------------+---------------------------------------------------------+
    | spectre\_meltdown\_v1 \(default\) | Protect against Spectre v1 attacks, highest performance |
    +-----------------------------------+---------------------------------------------------------+
    | spectre\_meltdown\_all            | Protect against Spectre v1, v2 and Meltdown attacks     |
    +-----------------------------------+---------------------------------------------------------+

.. note::
    Applying these mitigations may result in some performance degradation
    for certain workloads. As the actual performance impacts are expected
    to vary considerably based on the customer workload, |org| recommends
    all our customers to test the performance impact of CVE mitigations on
    their actual workload in a sandbox environment before rolling out the
    mitigations to production.


.. _security-feature-configuration-for-spectre-and-meltdown-section-N1009C-N1001C-N10001:

.. rubric:: |proc|


.. _security-feature-configuration-for-spectre-and-meltdown-ol-i4m-byx-vdb:

#.  To view the existing kernel security configuration, use the following
    command to check the current value of security\_feature:

    .. code-block:: none

        $ system show
        +----------------------+--------------------------------------+
        | Property             | Value                                |
        --------------------------------------------------------------+
        | contact              | None                                 |
        | created_at           | 2020-02-27T15:47:23.102735+00:00     |
        | description          | None                                 |
        | https_enabled        | False                                |
        | location             | None                                 |
        | name                 | 468f57ef-34c1-4e00-bba0-fa1b3f134b2b |
        | region_name          | RegionOne                            |
        | sdn_enabled          | False                                |
        | security_feature     | spectre_meltdown_v1                  |
        | service_project_name | services                             |
        | software_version     | 20.06                                |
        | system_mode          | duplex                               |
        | system_type          | Standard                             |
        | timezone             | Canada/Eastern                       |
        | updated_at           | 2020-02-28T10:56:24.297774+00:00     |
        | uuid                 | c0e35924-e139-4dfc-945d-47f9a663d710 |
        | vswitch_type         | none                                 |
        +----------------------+--------------------------------------+

#.  To change the kernel security feature, use the following command syntax:

    .. code-block:: none

        system modify --security_feature [either spectre_meltdown_v1 or spectre_meltdown_all]

    After this command is executed, the kernel arguments will be updated on
    all hosts and on subsequently installed hosts. Rebooting the hosts by
    locking and unlocking each host is required to have the new kernel
    arguments take effect.

#.  Analysis of a system may be performed by using the open source
    spectre-meltdown-checker.sh script, which ships as
    /usr/sbin/spectre-meltdown-checker.sh. This tool requires root access to
    run. The tool will attempt to analyze your system to see if it is
    susceptible to Spectre or Meltdown attacks. Documentation for the tool can
    be found at `https://github.com/speed47/spectre-meltdown-checker
    <https://github.com/speed47/spectre-meltdown-checker>`__.


