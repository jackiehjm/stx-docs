
.. ecl1581955165616
.. _security-rest-api-access:

===============
REST API Access
===============

The REST APIs provide programmatic access to the |prod|.

The StarlingX Platform related public REST API Endpoints can be listed by
running the following command:

.. code-block:: none

    $ openstack endpoint list | grep public

Use these URLs as the prefix for the URL target of StarlingX Platform
services REST API messages documented here:


.. _security-rest-api-access-d18e40:

-   Starlingx – `https://docs.starlingx.io/api-ref/index.html
    <https://docs.starlingx.io/api-ref/index.html>`__

-   Keystone – `https://docs.openstack.org/api-ref/identity/v3/
    <https://docs.openstack.org/api-ref/identity/v3/>`__

-   Barbican – `https://docs.openstack.org/barbican/stein/api/
    <https://docs.openstack.org/barbican/stein/api/>`__



.. _security-rest-api-access-d18e67:

----------
Kubernetes
----------

Access the Kubernetes REST API with the URL prefix of
https://<oam-floating-ip-address>:6443 and using the API syntax described at
the following site:
`https://kubernetes.io/docs/concepts/overview/kubernetes-api/
<https://kubernetes.io/docs/concepts/overview/kubernetes-api/>`__.

