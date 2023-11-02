.. _kubernetes-pod-coredump-handler-54d27a0fd2ec:

================================
Kubernetes Pod Core Dump Handler
================================

------------
Introduction
------------

The default coredump handler (systemd-coredump) is not capable of limiting the
namespace access and has a global configuration for any application on the
system. To solve these issues a new Kubernetes aware core dump handler was created,
allowing the configuration of the coredump on a per pod basis and limiting the
namespace access. The Pod Core Dump Handler allows you to set the ``core_pattern``
on a per Pod basis. When applications running on pods generate core dumps, they
are sent to Kubernetes Coredump Handler for handling according to the pod
annotations configurations.

Individual Pods can control the core dump handling by specifying Kubernetes Pod
annotations that instruct the core dump handler for specific applications. In
this way, the core dump will have a specific size, will be saved at a
specific folder with a specific name, and you can allocate disk space on a
per-pod basis.

See below the Kubernetes Pod Annotations.

--------------------------
Kubernetes Pod Annotations
--------------------------

The following are application annotations available for core dump configuration:

``--starlingx.io/core_pattern``: <pattern>  (default “core.PID”)
    This annotation is used to determine the path in the pod namespace where the
    core dump file is saved and the name that the core dump should have. In the
    example below, the pattern is saving inside the pod on the ``/coredump-log``
    path (folder available in this specific pod). It is also possible to format
    the filename using arguments described in the core documentation. For
    more information see https://man7.org/linux/man-pages/man5/core.5.html. This
    annotation is required if you want to use the Kubernetes core dump handler.
    If this annotation is not used, the default core dump handler (systemd-coredump)
    will be used.

.. note:

    The ``starlingx.io/core_pattern`` parameter only accepts lower case
    characters for the path and file name where the core dump is saved.


``--starlingx.io/core_compression``: none|lz4 (default “none”)
    This annotation is used to determine whether the file will be compressed.
    Using the "lz4" option, the file will be compressed, decreasing the file
    size. Use "none" or don't configure this annotation to not compress the
    file.

``--starlingx.io/core_max_size``: <size> (defaults to 0 - unlimited).
    This annotation sets the maximum core dump file size. It can be set from bytes
    to gigabytes or as a percentage of total amount of disk space. If the file
    is larger than the defined size, the file will be truncated.

``--starlingx.io/core_max_used``: (defaults to 0 - unlimited)
    This annotation sets the maximum amount of disk space to be used when saving
    the core dump. If the file is larger than the remaining space, the file will
    be truncated.

``--starlingx.io/core_min_free``: <size> (defaults to 0 - unlimited)
    This annotation sets the minimum amount of disk space to keep free when saving
    the core dump. If the file is larger than the remaining space, the
    file will be truncated.

where:

``--pattern``
    supports the core_pattern defined by the core documentation. For
    more information see https://man7.org/linux/man-pages/man5/core.5.html.

``--size``
    supports standard size suffixes B, K, M, G or percentage (0 to disable)


YAML Example with all ``kubernetes-coredump-handler`` configuration annotations:

.. code-block::

   kind: Pod
   apiVersion: v1
   metadata:
     name: dummy-pod-with-annotation
     annotations: {
       starlingx.io/core_pattern: "/coredump-log/core.%P.%u.%g.%s.%t.%e",
       starlingx.io/core_compression: lz4,
       starlingx.io/core_max_size: 200k,
       starlingx.io/core_max_used: 50%,
       starlingx.io/core_min_free: 20%
       }
    spec:
      containers:
        - name: dummy-pod-with-annotation
        image: ubuntu
        command: ["/bin/bash", "-ec", "while :; do echo '.'; sleep 5 ; done"]
        volumeMounts:
          - name: hostpath-volume
            mountPath: /coredump-log
    volumes:
      - name: hostpath-volume
        hostPath:
          path: /var/lib/systemd/coredump/
    restartPolicy: Never




