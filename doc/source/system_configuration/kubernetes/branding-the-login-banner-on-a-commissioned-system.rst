
.. oth1559748376782
.. _branding-the-login-banner-on-a-commissioned-system:

===============================================
Brand the Login Banner on a Commissioned System
===============================================

You can customize the pre-login message \(issue\) and post-login
|MOTD| on an installed and commissioned |prod| cluster, simplifying propagation
of the customized files.

.. rubric:: |context|

The following files can be customized to use this feature:

.. _branding-the-login-banner-on-a-commissioned-system-d665e16:

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

issue and issue.net are free standing files. /etc/motd is generated from the
following sources in the order presented:

.. _branding-the-login-banner-on-a-commissioned-system-d665e97:

#.  /etc/motd.head

#.  /etc/sysinv/motd.system

#.  /etc/platform/motd.license

#.  /etc/motd.tail


Complete the following procedure to customize the login banner on a
commissioned system:

.. rubric:: |proc|

#.  Log in to the active controller.

#.  Switch to root user.

    .. code-block:: none

        $ sudo bash
        #

#.  Provide any of the customized banner files in a directory of your
    choosing. This example uses /opt/banner:

    -   /opt/banner/issue

    -   /opt/banner/issue.net

    -   /opt/banner/motd.head

    -   /opt/banner/motd.tail

    See the :command:`issue` and :command:`motd` man pages for details on file
    syntax.

#.  Apply the customization using :command:`apply\_banner\_customization`.

    .. code-block:: none

        # apply_banner_customization <pathToModifiedFiles>

    For example:

    .. code-block:: none

        # apply_banner_customization /opt/banner

    The default path, if no parameter is specified, is the current working
    directory.

    The banners are applied to the configuration and installed on the current
    node, active controller.

#.  Lock and unlock other nodes in the cluster, either from the CLI or the
    GUI, to install the customization on each node.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock worker-0
        ~(keystone_admin)]$ system host-unlock worker-0

.. rubric:: |result|

All subsequently added nodes will automatically inherit the banner
customizations.