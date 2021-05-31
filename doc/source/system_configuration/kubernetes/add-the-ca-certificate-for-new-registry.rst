
..
.. _add-the-ca-certificate-for-new-registry:

=======================================
Add the CA Certificate for New Registry
=======================================

.. rubric:: |proc|

#. Copy the certificate of the |CA| that signed the new registries' certificate to the active controller.

#. Install the |CA| certificate as a Trusted |CA| for StarlingX. This is an
   example with the filename **ca.crt** containing the |CA| certificate:

.. code-block:: none

    system certificate-install -m ssl_ca ca.crt
    WARNING: For security reasons, the original certificate,
    containing the private key, will be removed,
    once the private key is processed.
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | da397ac8-24c2-474c-98fd-5afade15aea2 |
    | certtype    | ssl_ca                               |
    | signature   | ssl_ca_10872957681153283553          |
    | start_date  | 2020-09-03 21:56:16+00:00            |
    | expiry_date | 2021-06-30 21:56:16+00:00            |
    +-------------+--------------------------------------+

To verify a new a registry and reapply the application, see :ref:`Check New
Registry and Reapply Application <check-new-registry-and-reapply-application>`.
