
.. xjc1559744910969
.. _branding-the-login-banner-during-commissioning:

===========================================
Brand the Login Banner During Commissioning
===========================================

You can customize the pre-login message (issue) and post-login |MOTD| across
the entire |prod| cluster during system commissioning and installation.

The following files can be customized to use this feature:

.. _branding-the-login-banner-during-commissioning-d665e16:

.. table::
    :widths: auto

    +---------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------+
    | /etc/issue                                                                                  | console login banner                                                                        |
    +---------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------+
    | /etc/issue.net                                                                              | ssh login banner                                                                            |
    +---------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------+
    | /etc/motd.head                                                                              | message of the day header                                                                   |
    +---------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------+
    | /etc/motd.tail                                                                              | message of the day footer                                                                   |
    |                                                                                             |                                                                                             |
    |                                                                                             | This file is not present by default. You must first create it to apply your customizations. |
    +---------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------+

issue and issue.net are free standing files. /etc/motd is generated
from the following sources in the order presented:

.. _branding-the-login-banner-during-commissioning-d665e97:

#.  /etc/motd.head

#.  /etc/sysinv/motd.system

#.  /etc/platform/motd.license

#.  /etc/motd.tail

Complete the following procedure to customize the login banner during
installation and commissioning:

.. rubric:: |proc|

#.  Provide customization files.

    To customize any of the four customizable banner files listed above,
    provide the new files in the following locations:

    -   /opt/banner/issue

    -   /opt/banner/issue.net

    -   /opt/banner/motd.head

    -   /opt/banner/motd.tail

    See the :command:`issue` and :command:`motd` man pages for details on
    file syntax.

#.  Run Ansible Bootstrap playbook.

    When Ansible Bootstrap playbook is run, these files are moved from
    /opt/banner to configuration storage and are applied to the controller
    node as it is initialized. All nodes in the cluster which are
    subsequently configured will retrieve these custom banners as well.

    .. note::
        In the event that an error is reported for the banner customization,
        it can be repeated after running Ansible Bootstrap playbook and
        system deployment. Customization errors do not impact Ansible
        Bootstrap playbook.
        See :ref:`Brand the Login Banner on a Commissioned System <branding-the-login-banner-on-a-commissioned-system>`
        for more information.