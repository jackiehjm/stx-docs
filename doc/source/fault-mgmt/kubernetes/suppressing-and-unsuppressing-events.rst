
.. sla1552680666298
.. _suppressing-and-unsuppressing-events:

==============================
Suppress and Unsuppress Events
==============================

You can set events to a suppressed state and toggle them back to unsuppressed.

.. rubric:: |proc|

#.  Open the Events Suppression page, available from **Admin** \>
    **Fault Management** \> **Events Suppression** in the left-hand pane.

    The Events Suppression page appears. It provides the suppression status of
    each event type and functionality for suppressing or unsuppressing each
    event, depending on the current status of the event.

#.  Locate the event ID that you want to suppress.

#.  Click the **Suppress Event** button for that event.

    You are prompted to confirm that you want to suppress the event.

    .. caution::
        Suppressing an Alarm will result in the system *not* notifying the
        operator of this particular fault.

#.  Click **Suppress Event** in the Confirm Suppress Event dialog box.

    The Events Suppression tab is refreshed to show the selected event ID with
    a status of Suppressed, as shown below. The **Suppress Event** button is
    replaced by **Unsuppress Event**, providing a way to toggle the event back
    to unsuppressed.

    .. image:: ../figures/nlc1463584178366.png