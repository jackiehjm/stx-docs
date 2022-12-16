
.. _single-physical-core-for-platform-function-in-all-in-one-deployments-bec61d5a13f4:

====================================================================
Single Physical Core for Platform Function in All-In-One Deployments
====================================================================

The platform core usage was optimized to operate on a single physical core with
two logical cores in Hyper-Threading enabled for All-In-One deployments.

During a fresh install of All-In-One systems (non-system-controller) the system
will be configured to operate with a single physical core for the platform
function when Hyper-Threading CPU functionality is enabled. In case of
Hyper-Threading is disabled the system will keep current behavior allocating
two physical cores for platform function.

The use of single physical core for platform function is only suitable for
Intel® 4th Generation Xeon® Scalable Processors or above and should not be
configured for previous Intel® Xeon® CPU families. For All-In-One systems with
older generation processors, two physical cores (or more) must be configured.

The System does not automatically configures the number of physical cores based
on the CPU type, the user should perform this configuration. The default is
Single Core when HT is enabled.

System recommendations and limitations will be available through the |org|
System Engineering Guidelines.

.. note::

    During an upgrade process, the CPU platform configuration will be retained.

The number of cores allocated to the platform function can be changed through
the system API and thru deployment manager.

System API:

#.  Lock hosts

.. code-block:: none

    system host-lock <host>

#.  Set cores reserved to platform

.. code-block:: none

    system host-cpu-modify -f platform -p<processor#> <#-of-physical-cores> <host>

#.  Unlock host

.. code-block:: none

    system host-unlock <host>

.. only:: partner

    .. include:: /_includes/single-physical-core-for-platform-function-in-all-in-one-deployments-bec61d5a13f4.rest
    :start-after: deploy-begin
    :end-before: deploy-end

