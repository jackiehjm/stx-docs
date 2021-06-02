
.. yxg1614092306444
.. _integrate-the-application-with-notification-client-sidecar:

==========================================================
Integrate the Application with Notification Client Sidecar
==========================================================

.. only:: partner

   .. include:: /_includes/integrate-application-with-notification-client-sidecar.rest
      :start-after: shortdesc-begin
      :end-before: shortdesc-end

.. rubric:: |context|


The integration between the application is done with the use of a Sidecar. The
Sidecar runs as a container along with the application in the same pod. The
application and the Sidecar communicate via a REST API. See the figure below.

.. only:: partner

   .. include:: /_includes/integrate-application-with-notification-client-sidecar.rest
      :start-after: note-begin
      :end-before: note-end

.. rubric:: |prereq|


The following prerequisites are required before the integration:


.. _integrate-the-application-with-notification-client-sidecar-ul-iyd-mxf-t4b:

-   The cloud is configured with a node that supports the Subordinate mode \(Slave mode\).

-   The cloud is labeled with **ptp-registration=true**, and **ptp-notification=true**.

-   The **ptp-notification-armada-app** application is installed successfully.

-   The application supports the |PTP| Notifications API.


.. image:: figures/cak1614112389132.png
    :width: 800
