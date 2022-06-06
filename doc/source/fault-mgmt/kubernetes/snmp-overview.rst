
.. gzl1552680561274
.. _snmp-overview:

=============
SNMP Overview
=============

|prod| provides a containerized |SNMP| solution using Net-SNMP, supporting both
SNMPv2c and SNMPv3.

|prod| can generate SNMP traps for Alarm Events and Customer Log Events.

|prod| also supports SNMP GETs and WALKs of an Active Alarm table and a
historical Event (alarm SET/CLEAR and log) table.

SNMP functionality is integrated into |prod| as an optionally configurable
system application.

.. contents::
   :local:
   :depth: 1

.. _snmp-overview-section-N10027-N1001F-N10001:

------------------
About SNMP Support
------------------

Support for Simple Network Management Protocol \(SNMP\) is implemented as follows:

.. _snmp-overview-ul-bjv-cjd-cp:

-   available using the controller's node floating OAM IP address, over the
    standard SNMP UDP port 161, by default

-   SNMPv2c and SNMPv3 are supported versions

-   read-only access for all SNMP communities or all SNMPv3 users

-   supported SNMP operations are GET, GETNEXT, GETBULK, SNMPv2C-TRAP2,
    SNMPv3-TRAP

    .. note::
       SNMPv3 INFORM, and SNMP SET operations are not supported.

-   the SNMPv3 security levels that are supported are:
    NoAuthNoPriv, authNoPriv, authPriv

-   support for MD5 for auth, and DES for priv, see
    `http://www.net-snmp.org/ <http://www.net-snmp.org/>`__

For information on enabling SNMP support, see
:ref:`Enabling SNMP Support <enabling-snmp-support>`.

.. _snmp-overview-section-N10099-N1001F-N10001:

-----------------------
SNMPv2-MIB \(RFC 3418\)
-----------------------

Support for the basic standard MIB for SNMP entities is limited to the System
and SNMP groups, as follows:

.. _snmp-overview-ul-ulb-ypl-hp:

-   System Group: **.iso.org.dod.internet.mgmt.mib-2.system**

-   SNMP Group: **.iso.org.dod.internet.mgmt.mib-2.snmp**

-   coldStart and warmStart Traps

-   support for Enterprise Registration and Alarm MIBs, see
    `https://opendev.org/starlingx/snmp-armada-app/src/branch/master/stx-snmp-helm/centos/docker/stx-snmp/mibs <https://opendev.org/starlingx/snmp-armada-app/src/branch/master/stx-snmp-helm/centos/docker/stx-snmp/mibs>`__

.. _snmp-overview-section-N100C9-N1001F-N10001:

--------------------------
Wind River Enterprise MIBs
--------------------------

.. note::
    There are no product specific MIBs for ``wrsEnterpriseReg.mib`` and it will
    be supported in a future release.

|prod| supports the Wind River Enterprise Registration and Alarm MIBs.

**Enterprise Registration MIB, wrsEnterpriseReg.mib**
    Defines the Wind River Systems \(WRS\) hierarchy underneath the
    **iso\(1\).org\(3\).dod\(6\).internet\(1\).private\(4\).enterprise\(1\)**.
    This hierarchy is administered as follows:

    -   **.wrs\(731\)**, the IANA-registered enterprise code for Wind River
        Systems

    -   **.wrs\(731\).wrsCommon\(1\).wrs<Module\>\(1-...\)**,
        defined in wrsCommon<Module\>.mib.

    -   **.wrs\(731\).wrsProduct\(2-...\)**, defined in wrs<Product\>.mib.

**Alarm MIB, wrsAlarmMib.mib**
    Defines the common TRAP and ALARM MIBs for |org| products.
    The definition includes textual conventions, an active alarm table, a
    historical alarm table, a customer log table, and traps.

    **Textual Conventions**
        Semantic statements used to simplify definitions in the active alarm
        table and traps components of the MIB.

    **Tables**
        See :ref:`SNMP Event Table <snmp-event-table>` for detailed
        descriptions.

    **Traps**
        See :ref:`Traps <traps>` for detailed descriptions.

