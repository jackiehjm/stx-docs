
.. lob1552920716157
.. _identifying-the-software-version-and-update-level-using-the-cli:

============================================================
Identify the Software Version and Update Level Using the CLI
============================================================

You can view the current software version and update level from the CLI. The
system type is also shown.

.. rubric:: |context|

For more about working with software updates, see :ref:`Manage Software Updates
<managing-software-updates>`

.. rubric:: |proc|

.. _identifying-the-software-version-and-update-level-using-the-cli-steps-smg-b4r-hkb:

-   To find the software version from the CLI, use the :command:`system show`
    command.

    .. code-block:: none

        ~(keystone_admin)]$ system show
        +----------------------+----------------------------------------------------+
        | Property             | Value                                              |
        +----------------------+----------------------------------------------------+
        | contact              | None                                               |
        | created_at           | 2020-02-27T15:29:26.140606+00:00                   |
        | description          | yow-cgcs-ironpass-1_4                              |
        | https_enabled        | False                                              |
        | location             | None                                               |
        | name                 | yow-cgcs-ironpass-1-4                              |
        | region_name          | RegionOne                                          |
        | sdn_enabled          | False                                              |
        | security_feature     | spectre_meltdown_v1                                |
        | service_project_name | services                                           |
        | software_version     | nn.nn                                              |
        | system_mode          | duplex                                             |
        | system_type          | Standard                                           |
        | timezone             | UTC                                                |
        | updated_at           | 2020-02-28T16:19:56.987581+00:00                   |
        | uuid                 | 90212c98-7e27-4a14-8981-b8f5b777b26b               |
        | vswitch_type         | none                                               |
        +----------------------+----------------------------------------------------+

    .. note::
        The **system\_mode** field is shown only for a |prod| Simplex or Duplex
        system.

-   To list applied software updates from the CLI, use the :command:`sw-patch
    query` command.

    .. code-block:: none

        ~(keystone_admin)]$ sudo sw-patch query
