
.. knu1588334826081
.. _security-cert-manager:

============
Cert Manager
============

|prod| integrates the open source project cert-manager (cert-manager.io).
Cert-manager is a native Kubernetes certificate management controller, that
supports certificate management with external |CAs|.

|prod| installs cert-manager and an nginx-ingress-controller in support of
http-01 challenges from |CAs|, at bootstrap time, so that cert-manager
services are available for hosted containerized applications by default.

For more information on the cert-manager project, see
`http://cert-manager.io <http://cert-manager.io>`__.

**Related Information**

-   :ref:`The cert-manager Bootstrap Process
    <the-cert-manager-bootstrap-process>`


