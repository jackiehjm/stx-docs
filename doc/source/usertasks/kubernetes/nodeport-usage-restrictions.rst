
.. viy1592399797304
.. _nodeport-usage-restrictions:

===========================
NodePort Usage Restrictions
===========================

This sections lists the usage restrictions of NodePorts for your 
|prod-long| product.

The following usage restrictions apply when using NodePorts:

.. _nodeport-usage-restrictions-ul-erg-sgz-1mb:

-   Ports in the NodePort range 31,500 to 32,767 are reserved for applications
    that use Kubernetes NodePort service to expose the application externally.

-   Ports in the NodePort range 30,000 to 31,499 are reserved for |prod-long|.

.. only:: partner

    .. include:: ../../_includes/nodeport-usage-restrictions.rest
