
.. ygm1607361314876
.. _certificate-management-for-admin-rest-api-endpoints:

===================================================
Certificate Management for Admin REST API Endpoints
===================================================

All messaging between System Controllers and Subclouds in the |prod-dc|
system uses the admin REST API service endpoints, which are all configured for
secure HTTPS.

|prod| supports automated HTTPS certificate renewal for |prod-dc| admin
endpoints.

.. contents:: |minitoc|
   :local:
   :depth: 1

.. certificate-management-for-admin-rest--api-endpoints-section-lkn-ypk-xnb:

-------------------------------------
Certificates on the System Controller
-------------------------------------

In a |prod-dc| system, the HTTPS certificates for admin endpoints are
managed by |prod| internally.

.. note::
    All renewal operations are automatic, and no user operation is required.

For admin endpoints, the System Controllers in a |prod-dc| system
manages the following certificates:


.. certificate-management-for-admin-rest--api-endpoints-ul-zdc-pmk-xnb:

-   **DC-AdminEp-Root-CA certificate**: This certificate expires in 1825 days
    (approximately 5 years). Renewal of this certificate starts 30 days prior
    to expiry.

    The Root |CA| certificate is renewed on the System Controller. When the
    certificate is renewed, |prod| renews the intermediate |CA|
    certificates for all subclouds.

-   **DC-AdminEp-Intermediate-CA certificate for 'each' subcloud**: This
    certificate expires in 365 days. Renewal of this certificate starts 30 days
    prior to expiry. This certificate is used for all subclouds that are
    unmanaged.

-   **DC-AdminEp-endpoint**: This certificate expires in 180 days. Renewal of
    this certificate starts 30 days prior to expiry.



.. certificate-management-for-admin-rest--api-endpoints-section-qdd-xpk-xnb:

----------------------------
Certificates on the Subcloud
----------------------------

For admin endpoints, the subcloud controllers manage the following
certificates:


.. certificate-management-for-admin-rest--api-endpoints-ul-x51-3qk-xnb:

-   **DC-AdminEp-Intermediate-CA certificate**: The intermediate CA certificate
    for a subcloud is renewed on the System Controller. It is sent to the
    subcloud using a Rest API. Therefore, a subcloud needs to be online to
    receive the renewed certificate.

    If the subcloud is offline at the time when the subcloud intermediate |CA|
    certificate is renewed, the subcloud status **dc-cert** displays
    "out-of-sync". Certificate renewal continues once the subcloud is online.
    When renewal completes, the status changes to "in-sync". Subclouds start
    admin endpoint certificate renewal once subcloud intermediate |CA|
    certificate renewal is complete.

-   **DC-AdminEp certificate for the Subcloud**: This certificate expires in
    180 days. Renewal of this certificate starts 30 days prior to expiry.

    When the admin endpoint certificate is renewed, a new |TLS| certificate is
    generated. The new |TLS| certificate is used to provide |TLS| termination.


The System Controller audits subcloud AdminEp certificates daily. It also audits
subcloud admin endpoints when a subcloud becomes online or managed. If the
subcloud admin endpoint is "out-of-sync", the System Controller initiates
intermediate |CA| certificate renewal, to force subcloud renewal of the admin
endpoint certificate.



