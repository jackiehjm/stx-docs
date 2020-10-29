
.. gzl1552680561274
.. _snmp-overview:

=============
SNMP Overview
=============

|prod| can generate SNMP traps for |prod| Alarm Events and Customer Log Events.

This includes alarms based on hardware sensors monitored by board management
controllers.

.. xreflink For more information, see |node-doc|: :ref:`Sensors Tab <sensors-tab>`.

.. contents::
   :local:
   :depth: 1

.. _snmp-overview-section-N10027-N1001F-N10001:

------------------
About SNMP Support
------------------

Support for Simple Network Management Protocol \(SNMP\) is implemented as follows:

.. _snmp-overview-ul-bjv-cjd-cp:

-   access is disabled by default, must be enabled manually from the command
    line interface

-   available using the controller's node floating OAM IP address, over the
    standard SNMP UDP port 161

-   supported version is SNMPv2c

-   access is read-only for all SNMP communities

-   all SNMP communities have access to the entire OID tree, there is no
    support for VIEWS

-   supported SNMP operations are GET, GETNEXT, GETBULK, and SNMPv2C-TRAP2

-   the SNMP SET operation is not supported

For information on enabling SNMP support, see
:ref:`Enabling SNMP Support <enabling-snmp-support>`.

.. _snmp-overview-section-N10099-N1001F-N10001:

-----------------------
SNMPv2-MIB \(RFC 3418\)
-----------------------

Support for the basic standard MIB for SNMP entities is limited to the System
and SNMP groups, as follows:

.. _snmp-overview-ul-ulb-ypl-hp:

-   System Group, **.iso.org.dod.internet.mgmt.mib-2.system**

-   SNMP Group, **.iso.org.dod.internet.mgmt.mib-2.snmp**

-   coldStart and warmStart Traps

The following system attributes are used in support of the SNMP implementation.
They can be displayed using the :command:`system show` command.

**contact**
    A read-write system attribute used to populate the **sysContact** attribute
    of the SNMP System group.

**location**
    A read-write system attribute used to populate the **sysLocation** attribute
    of the SNMP System group.

**name**
    A read-write system attribute used to populate the **sysName** attribute of
    the SNMP System group.

**software\_version**
    A read-only system attribute set automatically by the system. Its value is
    used to populate the **sysDescr** attribute of the SNMP System group.

For information on setting the **sysContact**, **sysLocation**, and **sysName**
attributes, see
:ref:`Setting SNMP Identifying Information <setting-snmp-identifying-information>`.

The following SNMP attributes are used as follows:

**sysObjectId**
    Set to **iso.org.dod.internet.private.enterprise.wrs.titanium** \(1.3.6.1.4.1.1.2\).

**sysUpTime**
    Set to the up time of the active controller.

**sysServices**
    Set to the nominal value of 72 to indicate that the host provides services at layers 1 to 7.

.. _snmp-overview-section-N100C9-N1001F-N10001:

--------------------------
Wind River Enterprise MIBs
--------------------------

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