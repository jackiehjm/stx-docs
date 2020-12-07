
.. mlb1573055521142
.. _kubernetes-cpu-manager-policies:

===============================
Kubernetes CPU Manager Policies
===============================

You can apply the kube-cpu-mgr-policy host label from the Horizon Web interface
or the CLI to set the Kubernetes CPU Manager policy.

The **kube-cpu-mgr-policy** host label supports the values ``none`` and
``static``.

Setting either of these values results in kubelet on the host being configured
with the policy of the same name as described at `https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies <https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies>`__,
but with the following differences:

----------------------------
Static policy customizations
----------------------------

-   Pods in the **kube-system** namespace are affined to platform cores
    only. Other pod containers \(hosted applications\) are restricted to
    running on either the application or isolated cores. CFS quota
    throttling for Guaranteed QoS pods is disabled.

-   When using the static policy, improved performance can be achieved if
    one also uses the Isolated CPU behavior as described at :ref:`Isolating CPU Cores to Enhance Application Performance <isolating-cpu-cores-to-enhance-application-performance>`.

-   For Kubernetes pods with a **Guaranteed** QoS \(see `https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/ <https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/>`__
    for background information\), CFS quota throttling is disabled as it
    causes performance degradation.

-   Kubernetes pods are prevented by default from running on CPUs with an
    assigned function of **Platform**. In contrast, pods in the
    **kube-system** namespace are affined to run on **Platform** CPUs by
    default. This assumes that the number of platform CPUs is sufficiently
    large to handle the workload. These two changes further ensure that
    low-latency applications are not interrupted by housekeeping tasks.


.. xreflink For information about adding labels, see |node-doc|: :ref:`Configuring Node Labels Using Horizon <configuring-node-labels-using-horizon>`

.. xreflink and |node-doc|: :ref:`Configuring Node Labels from the CLI <assigning-node-labels-from-the-cli>`.


-----------
Limitations
-----------

|org| recommends using the static policy.

