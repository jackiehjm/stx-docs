.. _advanced-ptp-configuration-334a08dc50fb:

==========================
Advanced PTP Configuration
==========================

.. caution::

   Parameters are written to the ``ptp4l`` configuration file without error
   checking. Caution must be taken to ensure that parameter names and values
   are correct as errors will cause ``ptp4l`` launch failures.


Configure ITU-T G.8275.1 Grandmaster Settings Fields
----------------------------------------------------

Users can configure ``ptp4l`` instances to set the |PTP| Announce messages
fields in conformance with the ITU-T G.8275.1/Y.1369.1 |PTP| profile. This
configuration is recommended for nodes that are configured as a T-GM or T-BC
and using the G.8275.1 |PTP| profile.

.. rubric:: |prereq|

-  The system should be configured with at least one ``ptp4l`` instance. See
   :ref:`configuring-ptp-service-using-the-cli` for more information.

-  Any ``ptp4l`` instances using the G.8275.1 profile must be configured with
   the ``dataset_comparison=G.8275.x`` instance parameter. This parameter
   enables the G.8275.1 |PTP| profile for the ``ptp4l`` instance.

   .. code-block:: none

      ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> dataset_comparison=G.8275.x


.. rubric:: |context|

The following section provides additional details about the relevant Announce
message fields and how to configure their value.

.. code-block::

     507c6f.fffe.21bb24-0 seq 0 RESPONSE MANAGEMENT GRANDMASTER_SETTINGS_NP
             clockClass              6
             clockAccuracy           0x20
             offsetScaledLogVariance 0x4e5d
             currentUtcOffset        37
             leap61                  0
             leap59                  0
             currentUtcOffsetValid   1
             ptpTimescale            1
             timeTraceable           1
             frequencyTraceable      1
             timeSource              0x20


Each of the fields are explained below:

``clockClass``
   This field is dynamically set by |prod| based on the state of the Primary
   Reference Time Clock (PRTC) used by the ``ptp4l`` instance. No user
   configuration is required.


``clockAccuracy``
   Default value (not locked to |PRTC|): ``0xfe``

   Default value (locked to |PRTC|): ``0x20``

   When a ``ptp4l`` instance is locked to a |PRTC|, the value will be
   dynamically updated to 0x20.

   If the ``ptp4l`` instance is connected to an Enhanced Primary Reference Time
   Clock (ePRTC), the locked value can be changed by using a ``ptp4l`` instance
   parameter.

   .. code-block:: none
      
        ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> clockAccuracy=0x21


``offsetScaledLogVariance``
   Default value (not locked to |PRTC|): ``0xffff``

   Default value (locked to |PRTC|): ``0x4e5d``

   The ``offsetScaledLogVariance`` attribute characterizes the stability of the
   clock. If the ``ptp4l`` instance is connected to an |ePRTC|, the locked
   value can be changed by using a ``ptp4l`` instance parameter.

   .. code-block:: none

        ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> offsetScaledLogVariance=0x4b32


``currentUtcOffset``
   Default value: ``37``

   The current offset between TAI and UTC. This value does not need to be
   altered unless IERS introduces a new leapsecond into UTC. If necessary, the
   value can be altered for testing purposes using a ``ptp4l`` instance
   parameter.

   .. code-block:: none

        ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> utc_offset=37

``leap61``
   Default value: ``0``

   This attribute is used to handle the addition of a new leapsecond. |prod|
   does not currently support altering the **leap61** attribute.


``leap59``
   Default value: ``0``

   This attribute is used to handle the addition of a new leapsecond. |prod|
   does not currently support altering the **leap59** attribute.


``currentUtcOffsetValid``
   Default value: ``0``

   This value should be set to 1 in order to indicate that ``currentUtcOffset``
   value is correct and suitable for use by downstream nodes. The attribute can
   be altered using a ``ptp4l`` instance parameter.

   .. code-block:: none

        ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> currentUtcOffsetValid=1


``ptpTimescale``
   Default value: ``1``

   This attribute should always be set to 1 according to the G.8275.1 |PTP|
   profile.


``timeTraceable``
   Default value: ``0``

   This attribute is dynamically set by |prod| based on the ``ptp4l``
   instance's connection to a |PRTC|. When a |PRTC| is connected to the
   ``ptp4l`` instance, **timeTraceable** will be set to 1.


``frequencyTraceable``
   Default value: ``0``

   This attribute is dynamically set by |prod| based on the ``ptp4l``
   instance's connection to a |PRTC|. When a |PRTC| with frequency information
   is connected to the ``ptp4l`` instance, **frequencyTraceable** will be set
   to 1.


``timeSource``
   Default value: ``0xa0``

   This attribute describes the type of clock used for the |PRTC|. The default
   value of ``0xa0`` indicates the use of an internal oscillator on the PTP
   |NIC|. |prod| will automatically update this value to ``0x20`` (GPS) if it
   detects that the ``ptp4l`` instance is utilizing a GPS time source.

   Users can change this attribute using a ``ptp4l`` instance parameter. For a
   comprehensive list of time source types and their respective values, consult
   the G.8275.1 standard.

   .. code-block:: none

        ~(keystone_admin)]$ system ptp-instance-parameter-add <ptp4l instance> timeSource=0x20


Apply PTP configuration
~~~~~~~~~~~~~~~~~~~~~~~

After assigning ``ptp4l`` instance parameters, apply the new |PTP|
configuration using ``system ptp-instance-apply``.

Verify Announce Message Attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The |PTP| Announce Message Attributes can be viewed using the `pmc` tool.

.. code-block:: none

     sudo pmc -u -b 0 -f /etc/linuxptp/ptpinstance/<ptp4l instance config file> 'GET GRANDMASTER_SETTINGS_NP'

     sending: GET GRANDMASTER_SETTINGS_NP
       507c6f.fffe.21bb24-0 seq 0 RESPONSE MANAGEMENT GRANDMASTER_SETTINGS_NP
               clockClass              6
               clockAccuracy           0x20
               offsetScaledLogVariance 0x4e5d
               currentUtcOffset        37
               leap61                  0
               leap59                  0
               currentUtcOffsetValid   1
               ptpTimescale            1
               timeTraceable           1
               frequencyTraceable      1
               timeSource              0x20


The log output for dynamically updated values can be found in
``/var/log/collectd.log``.

