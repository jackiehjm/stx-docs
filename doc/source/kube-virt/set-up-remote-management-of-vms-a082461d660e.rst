.. _set-up-remote-management-of-vms-a082461d660e:

===============================
Set up remote management of VMs
===============================

.. rubric:: |context|

Configure the ``kubectl``, ``virtctl`` and ``virt-viewer`` clients on a remote
workstation, in order to manage KubeVirt |VMs| remotely. Note that the
graphical console of a VM can only be accessed remotely from a workstation with
X Windows (e.g. graphical ubuntu desktop), kubectl, ``virtctl`` and
``virt-viewer`` installed.

.. rubric:: |proc|

Configure kubectl and helm
==========================

.. include:: /shared/_includes/install-kubectl-and-helm-clients-directly-on-a-host-6383c5f2b484.rest
    :start-after: begin-install-proc
    :end-before: end-install-proc


Configure virtctl
=================

On the remote workstation, install virtctl client tool.

.. code-block::

    $ export VERSION=v0.53.1
    $ wget https://github.com/kubevirt/kubevirt/releases/download/
    $ ${VERSION}/virtctl-${VERSION}-linux-amd64 chmod a+x ./virtctl-${VERSION}-linux-amd64
    $ sudo cp ./virtctl-${VERSION}-linux-amd64 /usr/bin/virtctl


Configure virt-viewer
=====================

On the remote workstation, install virt-viewer in order to enable use of
graphical console.

.. code-block::

    $ sudo apt -y install virt-viewer


