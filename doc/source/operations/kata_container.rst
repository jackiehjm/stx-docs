===============
Kata Containers
===============

This guide describes how to run Kata Containers with Kubernetes on StarlingX.

.. contents::
   :local:
   :depth: 1

--------
Overview
--------

StarlingX has supported Kata Containers in master since January 2020, and coming
Release 4.0 will include it. Release 3.0 and before will not support it.

To support Kata Containers, pods are created by containerd instead of Docker.
Also containerd is configured to support both runc and Kata Containers, while the
default runtime is still runc. If you want to launch a pod with Kata Containers,
you must declare it explicitly.

---------------------------------
Run Kata Containers in Kubernetes
---------------------------------

There are two methods to run Kata Containers in Kubernetes: by runtime class or
by annotation. Runtime class is supported in Kubernetes since v1.12.0, and it is
the recommended method for running Kata Containers.

To run by runtime class, create a RuntimeClass with ``handler`` set to ``kata``.
Then reference this class in the pod spec, as shown in the following example:

::

    kind: RuntimeClass
    apiVersion: node.k8s.io/v1beta1
    metadata:
      name: kata-containers
    handler: kata
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox-runtime
    spec:
      runtimeClassName: kata-containers
      containers:
      - name: busybox
        command:
          - sleep
          - "3600"
        image: busybox

To run a pod with Kata Containers by annotation, set ``io.kubernetes.cri.untrusted-workload``
to ``true`` in the annotations section of a pod spec.

.. note::

          This method is deprecated and may not be supported in future
          Kubernetes releases. We recommend using the RuntimeClass method.

Example of using annotation:

::

    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox-untrusted
      annotations:
        io.kubernetes.cri.untrusted-workload: "true"
    spec:
      containers:
      - name: busybox
        command:
          - sleep
          - "3600"
        image: busybox

--------------------------------
Kata configuration in containerd
--------------------------------
.. note::

          No action is required for end user. This section just shows the
          configuration in containerd to support Kata Containers.

Containerd's configuration file ``/etc/containerd/config.toml`` is customized
to support Kata Containers.

For RuntimeClass, here is the configuration in config.toml:

::

    [plugins.cri.containerd.runtimes.kata]
      runtime_type = "io.containerd.kata.v2"

For annotation, here is the configuration in config.toml:

::

    [plugins.cri.containerd.runtimes.untrusted]
      runtime_type = "io.containerd.kata.v2"

In this example, ``kata.v2`` means ``shimv2(containerd-shim-kata-v2)``, which
helps Kubernetes to launch pods and OCI-compatible containers with one shim per
pod.

-------------------------
Check Kata Containers use
-------------------------

Here are two methods to check whether the pod is running with Kata Containers
or not:

#.  Run ``uname -a`` in both container and host. The host kernel version should
    be 4.18.0, while the container kernel version should be 4.19 or higher.
    For normal container, the host kernel version is the same as the container.

#.  Run ``ps aux`` in the host. A normal container is triggered by
    containerd-shim-runc-v1, while Kata Containers is triggered by
    containerd-shim-kata-v2.

----------
References
----------

*   For technical details about how Kata Containers is implemented on StarlingX,
    refer to:

    *   Spec file: https://opendev.org/starlingx/specs/src/branch/master/doc/source/specs/stx-3.0/approved/containerization-2006145-kata-containers-integration.rst
    *   Story: https://storyboard.openstack.org/#!/story/2006145
    *   Patches: https://review.opendev.org/#/q/topic:kata+projects:starlingx

*   Kata Containers is supported for Kubernetes only, since Kubernetes is the
    only supported container orchestration tool in StarlingX. Kata Container
    support for Docker is not implemented in StarlingX. The Docker runtime also
    may be removed in future releases of StarlingX, since all containers in
    StarlingX are run by Kubernetes at this time.

    To try Kata Containers with Docker in StarlingX, refer to this link:
    https://github.com/kata-containers/documentation/blob/master/install/docker/centos-docker-install.md

*   To support Kata Containers, the CRI runtime in Kubernetes was switched from
    ``dockershim`` to ``containerd``. This means you cannot view/operate a
    Kubernetes container with the Docker client. You must use ``crictl``
    instead, which supports commands that are similar to Docker commands. There
    is no difference in kubectl commands before and after the switch to
    containerd.

*   More information is available at:

    *   Kata Containers: https://katacontainers.io/
    *   containerd: https://containerd.io/
    *   Kubernetes RuntimeClass: https://kubernetes.io/docs/concepts/containers/runtime-class/
