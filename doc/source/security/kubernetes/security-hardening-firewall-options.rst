
.. zhw1595963351894
.. _security-hardening-firewall-options:

================
Firewall Options
================

|prod| applies default firewall rules on the |OAM| network.

The default rules are recommended for most applications. See :ref:`Default
Firewall Rules <security-default-firewall-rules>` for details. You can
configure an additional file in order to augment or override the default
rules.

A minimal set of rules is always applied before any custom rules, as follows:


.. _firewall-options-ul-gjq-k1g-mmb:

-   Non-|OAM| traffic is always accepted.

-   Egress traffic is always accepted.

-   |SM| traffic is always accepted.

-   |SSH| traffic is always accepted.

.. note::
    It is recommended to disable port 80 when HTTPS is enabled for external
    connection.

Operational complexity:


.. _firewall-options-ul-hjq-k1g-mmb:

-   |prod| provides |OAM| firewall rules through Kubernetes Network Policies.
    For more information, see :ref:`Firewall Options
    <security-firewall-options>`.

-   The custom rules are applied using iptables-restore or ip6tables-restore.

.. _firewall-options-section-csl-41d-cnb:

----------------------
Default Firewall Rules
----------------------

|prod| applies these default firewall rules on the |OAM| network. The default
rules are recommended for most applications.

For a complete listings, see :ref:`Default Firewall Rules
<security-default-firewall-rules>`.

