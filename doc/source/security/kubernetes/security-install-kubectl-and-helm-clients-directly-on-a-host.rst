
.. iqi1581955028595
.. _security-install-kubectl-and-helm-clients-directly-on-a-host:

===================================================
Install Kubectl and Helm Clients Directly on a Host
===================================================

You can use :command:`kubectl` and :command:`helm` to interact with a
controller from a remote system.

.. rubric:: |context|

Commands such as those that reference local files or commands that require
a shell are more easily used from clients running directly on a remote
workstation.

Complete the following steps to install :command:`kubectl` and
:command:`helm` on a remote system.

The following procedure shows how to configure the kubectl and helm clients
directly on remote host, for an admin user with **cluster-admin** cluster role.
If using a non-admin user such as one with only role privileges within a
private namespace, the procedure is the same, however, additional
configuration is required in order to use :command:`helm`.

.. rubric:: |proc|

.. _security-install-kubectl-and-helm-clients-directly-on-a-host-steps-f54-qqd-tkb:

.. include:: /shared/_includes/install-kubectl-and-helm-clients-directly-on-a-host-6383c5f2b484.rest
    :start-after: begin-install-proc
    :end-before: end-install-proc

.. seealso::

    :ref:`Configure Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-backed-remote-clis-and-clients>`

    :ref:`Configure Remote Helm v2 Client
    <configure-remote-helm-client-for-non-admin-users>`

