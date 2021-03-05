
.. mbd1576786954045
.. _uninstalling-cpu-manager-for-kubernetes-on-ipv6:

===============================================
Uninstalling CPU Manager for Kubernetes on IPv6
===============================================

You will have to run some additional uninstall steps for IPv6 configurations.

When uninstalling CMK on an IPv6 system, first follow the steps at
:ref:`Removing CPU Manager for Kubernetes <removing-cpu-manager-for-kubernetes>`,
then run the following commands:

.. code-block:: none

    ~(keystone_admin)]$ kubectl delete pod/cmk-uninstall-webhook -n kube-system
    ~(keystone_admin)]$ kubectl delete ds cmk-uninstall -n kube-system
    ~(keystone_admin)]$ kubectl delete pod delete-uninstall -n kube-system

