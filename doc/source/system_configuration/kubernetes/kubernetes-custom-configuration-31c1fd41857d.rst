.. _kubernetes-custom-configuration-31c1fd41857d:

===============================
Kubernetes Custom Configuration
===============================

------------
Introduction
------------

Kubernetes configuration can be customized during deployment by specifying
bootstrap overrides in the ``localhost.yml`` file during the Ansible bootstrap
process or during runtime via ``sysinv service-parameters`` |CLI|.


Custom configuration includes:

-   Configuring options on ``kube-apiserver`` such as feature gates and admission
    controllers,

-   Configuring options on ``kube-controller-manager`` such as
    ``node-monitor-period`` and ``pod-eviction-timeout``,

-   Configuring options on ``kube-scheduler`` such as feature gates,

-   Configuring options on kubelet such as maximum pods and enabling unsafe
    sysctls.

----------------------------
kube-apiserver configuration
----------------------------

The Kubernetes API server validates and configures data for the API objects
which include pods, services, replicationcontrollers, and others. The API
Server services REST operations and provides the frontend to the cluster's
shared state through which all other components interact.

For a list of all configurable options of kube-apiserver, see `kube-apiserver
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/>`__.

**Bootstrap configuration**

To set or override a ``kube-apiserver`` option, add the desired parameters to an
``apiserver_extra_args`` section in the ``localhost.yml``.

Example usage:

.. code-block::

   apiserver_extra_args:
     admission-control-config-file: "/etc/kubernetes/admission-control-config-file.yml"
     audit-policy-file: "/etc/kubernetes/audit-policy-file.yml"
     default-not-ready-toleration-seconds: "35"
     default-unreachable-toleration-seconds: "35"
     feature-gates: "SCTPSupport=true,TTLAfterFinished=true,HugePageStorageMediumSize=true,RemoveSelfLink=false,MemoryManager=true"
     enable-admission-plugins: "NodeRestriction,PodNodeSelector"
     event-ttl: "20h"


**Runtime configuration**

To set, modify or delete a ``kube-apiserver`` parameter use the
``service-parameter add``, ``modify`` or ``delete`` |CLI| command.

Example usage:

- Add new parameter

  .. code-block:: none

      system service-parameter-add kubernetes kube_apiserver default-not-ready-toleration-seconds=31

      system service-parameter-apply kubernetes

  .. note::

    Parameter must not exist on service parameters, otherwise use
    :command:`modify` command.

- Modify existing parameter

  .. code-block:: none

      system service-parameter-modify kubernetes kube_apiserver default-not-ready-toleration-seconds=33

      system service-parameter-apply kubernetes

- Delete parameter

  .. code-block:: none

      system service-parameter-list

  Copy parameter uuid to be deleted:

  .. code-block:: none

      system service-parameter-delete <uuid>


-------------------------------------
kube-controller-manager configuration
-------------------------------------

The Kubernetes controller manager is a daemon that embeds the core control
loops shipped with Kubernetes. A controller is a control loop that watches the
shared state of the cluster through the apiserver and makes changes attempting
to move the current state towards the desired state.

For a list of all configurable options of kube-controller-manager, see
`kube-controller-manager
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/>`__.


**Bootstrap configuration**

To set or override a ``kube-controller-manager`` option, add the desired
parameters to an ``controllermanager_extra_args`` section in the
``localhost.yml``.

Example usage:

.. code-block::

    controllermanager_extra_args:
      node-monitor-period: "4s"
      node-monitor-grace-period: "25s"
      pod-eviction-timeout: '35s'
      feature-gates: "TTLAfterFinished=true,MemoryManager=true"


**Runtime configuration**

To set, modify or delete a ``kube-controller-manager`` parameter use the
``service-parameter add``, ``modify`` or ``delete`` |CLI| command.

Example usage:

- Add new parameter

  .. code-block:: none

      system service-parameter-add kubernetes kube_controller_manager node-monitor-period=5s

      system service-parameter-apply kubernetes

  .. note::

    Parameter must not exist on service parameters, otherwise use
    :command:`modify` command.

- Modify existing parameter

  .. code-block:: none

      system service-parameter-modify kubernetes kube_controller_manager node-monitor-period=7s

      system service-parameter-apply kubernetes

- Delete parameter

  .. code-block:: none

      system service-parameter-list

  Copy parameter uuid to be deleted:

  .. code-block:: none

      system service-parameter-delete <uuid>


----------------------------
kube-scheduler configuration
----------------------------

The Kubernetes scheduler is a control plane process which assigns Pods to
Nodes. The scheduler determines which Nodes are valid placements for each Pod
in the scheduling queue according to constraints and available resources. The
scheduler then ranks each valid Node and binds the Pod to a suitable Node.
Multiple different schedulers may be used within a cluster; ``kube-scheduler``
is the reference implementation.

For a list of all configurable options of ``kube-scheduler``, see `kube-scheduler
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/>`__.

**Bootstrap configuration**

To set or override a ``kube-scheduler`` option, add the desired parameters to
an ``scheduler_extra_args`` section in the ``localhost.yml``.

Example usage:

.. code-block::

    scheduler_extra_args:
      feature-gates: "TTLAfterFinished=false"

**Runtime configuration**

To set, modify or delete a ``kube-controller-manager`` parameter use the
``service-parameter add``, ``modify`` or ``delete`` |CLI| command.

Example usage:

- Add new parameter

  .. code-block:: none

      system service-parameter-add kubernetes kube_scheduler leader-elect-lease-duration=16s

      system service-parameter-apply kubernetes

  .. note::

    Parameter must not exist on service parameters, otherwise use
    :command:`modify` command.

- Modify existing parameter

  .. code-block:: none

      system service-parameter-modify kubernetes kube_scheduler leader-elect-lease-duration=14s

      system service-parameter-apply kubernetes

- Delete parameter

  .. code-block:: none

      system service-parameter-list

  Copy parameter uuid to be deleted:

  .. code-block:: none

      system service-parameter-delete <uuid>


----------------------
kubelet configurations
----------------------

The kubelet is the primary "node agent" that runs on each node.

For a list of all configurable  options, see `Kubelet Configuration (v1beta1)
<https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/>`__.

**Bootstrap configuration**

To set or override a kubelet option, add the desired parameters to a
``kubelet_configurations`` section in the ``localhost.yml``.


Example usage:

.. code-block::

   kubelet_configurations:
     featureGates:
       MemoryManager: true
       HugePageStorageMediumSize: true

**Runtime configuration**

To set, modify or delete a kubelet parameter use the ``service-parameter add``,
``modify`` or ``delete`` |CLI| command.

The expected structure for existing field types are:

- String, bool, meta/v1.Duration:

  - No structure  defined, quotes may or may not be used.

  - Ex.: ``cgroupDriver=cgroupfs`` or ``cgroupDriver="cgroupfs"``

- int32,int64:

  - No structure defined, quotes may or may not be used.

  - Ex.: ``imageGCLowThresholdPercent=70`` or ``imageGCLowThresholdPercent="70"``

- Array of strings (``[]string``):

  - JSON-like format: ``'["string1","string2","stringN"]'``

  - Ex.: ``clusterDNS='["10.96.0.10"]'``

- ``map[string]string``:  json format.

  - JSON-like format: ``'{"key_string1":"string1","key_string2":"string2","key_stringN":"stringN"}'``

  - Ex: ``evictionHard='{"memory.available":"100Mi", "nodefs.available": "10%","nodefs.inodesFree": "6%", "imagefs.available": "2Gi"}'``

Example usage:

- Add new parameter

  .. code-block:: none

      system service-parameter-add kubernetes kubelet clusterDNS='["10.96.0.10"]'

      system service-parameter-apply kubernetes

  .. note::

      Parameter must not exist on service parameters, otherwise use
      :command:`modify`` command.

- Modify existent parameter

  .. code-block:: none

      system service-parameter-modify kubernetes kubelet nodeStatusUpdateFrequency="5s"

      system service-parameter-apply kubernetes

- Delete parameter

  .. code-block:: none

      system service-parameter-list

  Copy parameter uuid to be deleted:

  .. code-block:: none

      system service-parameter-delete <uuid>

--------------------------------------------------------------------------------------
kube-apiserver, kube-controller-manager and kube-scheduler extra-volumes configuration
--------------------------------------------------------------------------------------

Some options/parameters specified in ``apiserver_extra_args``,
``controller-manager_extra_args`` and ``scheduler extra-args`` refer to
configuration files or directories. Those referenced files or directories must
be mounted as volumes on the corresponding control plane pod using the
``extra-volume`` parameters.

**Bootstrap configuration**

To set or override an ``extra-volumes`` option, add the desired parameters to
the corresponding ``extra-args`` section in the ``localhost.yml``, add the
desired ``extra-volume`` including the volume details and file contents (if
corresponds).

For instance, if admission plugins are configured and need additional
configuration, that configuration should be set in a specific file referenced
by the ``admission-control-config-file`` parameter.

See the example below where the ``admission-control-config-file`` option and
the ``PodNodeSelector`` admission plugin is specified for ``kube-apiserver``.
Both of these options require the specification of a yaml file.

Example usage:

.. code-block::

   apiserver_extra_args:
     admission-control-config-file: "/etc/kubernetes/admission-control-config-file.yaml"
     enable-admission-plugins: "PodNodeSelector"

   apiserver_extra_volumes:
     - name: admission-control-config-file
       mountPath: "/etc/kubernetes/admission-control-config-file.yaml"
       readOnly: true
       pathType: "File"
       content: |
         apiVersion: apiserver.config.k8s.io/v1
         kind: AdmissionConfiguration
         plugins:
         - name: PodSecurity
           configuration:
             apiVersion: pod-security.admission.config.k8s.io/v1beta1
             kind: PodSecurityConfiguration
             # Defaults applied when a mode label is not set.
             #
             # Level label values must be one of:
             # - "privileged" (default)
             # - "baseline"
             # - "restricted"
             #
             # Version label values must be one of:
             # - "latest" (default)
             # - specific version like "v1.24"
             defaults:
               enforce: "privileged"
               enforce-version: "latest"
               audit: "privileged"
               audit-version: "latest"
               warn: "privileged"
               warn-version: "latest"
             exemptions:
               # Array of authenticated usernames to exempt.
               usernames: []
               # Array of runtime class names to exempt.
               runtimeClasses: []
               # Array of namespaces to exempt.
               namespaces: []
         - name: pod-node-selector
           mountPath: "/etc/kubernetes/pod-node-selector.yaml"
           readOnly: true
           pathType: "File"
           content: |
             podNodeSelectorPluginConfig:
             clusterDefaultNodeSelector: name-of-node-selector
             namespace1: name-of-node-selector
             namespace2: name-of-node-selector

The example below enables kubernetes auditing which requires an
``audit-policy-file.yaml`` file to specify the details of what events should be
audited.

Example usage:

.. code-block::

   apiserver_extra_args:
     audit-policy-file: /etc/kubernetes/audit-policy-file.yaml
     audit-log-path: /var/log/kubernetes/audit/audit.log

   apiserver_extra_volumes:
     - name: audit-policy-file
       mountPath: "/etc/kubernetes/audit-policy-file.yaml"
       readOnly: true
       pathType: "File"
       content: |
         # Log all requests at the Metadata level.
         apiVersion: audit.k8s.io/v1
         kind: Policy
         rules:
         - level: Metadata
     - name: audit-log-path
       mountPath: "/var/log/kubernetes/audit/"
       readOnly: false
       pathType: "DirectoryOrCreate"


**Runtime configuration**

To set, modify or delete an extra-volume parameter use the ``service-parameter
add``, ``modify`` or ``delete`` |CLI| command.

Valid extra-volume sections:

- ``kube_apiserver_volumes``

- ``kube_controller_manager_volumes``

- ``kube_scheduler_volumes``

Valid extra-volume parameter fields:

- ``name``:

  - Volume name.

- ``hostPath``:

  - Absolute path in node file system where the file or directory to mount is located.

- ``mounthPath (opc)``:

  - Absolute path in pod file system used to mount the file or directory.

  - Default value: same as hostPath.

- ``pathType (opc)``:

  - The supported values are:

    - DirectoryOrCreate: If nothing exists at the given path, an empty
      directory will be created there as needed with permission set to 0755,
      having the same group and ownership with Kubelet.

    - File: A file must exist at the given path.

  - Default value: File.

- ``readOnly (opc)``:

  - The supported values are: true or false.

  - Default value: true.

Valid input formats:

- Pairs of strings separated by commas:

  - Ex.: ``audit-log-dir=hostPath:/var/log/kubernetes/audit,readOnly:false,pathType:DirectoryOrCreate``

- JSON format:

  - Ex.: ``encryption-config='{"name": "encryption-config", "hostPath": "/etc/kubernetes/encryption-provider.yaml", "mountPath": "/etc/kubernetes/encryption-provider.yaml", "readOnly": true, "pathType":"File"}'``

Example usage with two linked configuration files:

An admission controller could be added to mitigates the problem when the API
server gets flooded by requests to store new Events. The cluster admin can
specify event rate limits by enabling the EventRateLimit admission controller
and referencing an EventRateLimit configuration file.

- Add new extra-args parameters

  .. code-block:: none

      system service-parameter-add kubernetes kube_apiserver admission-control-config-file=/etc/kubernetes/admission-control-config-file.yaml

      system service-parameter-add kubernetes kube_apiserver enable-admission-plugins=EventRateLimit

  .. note::

      Parameter must not exist on service parameters, otherwise use
      :command:`modify` command.

- Add new extra-volume parameters

  .. code-block:: none

      system service-parameter-add kubernetes kube_apiserver_volumes admission-control-config-file=hostPath:/etc/kubernetes/admission-control-config-file.yaml

      system service-parameter-add kubernetes kube_apiserver_volumes eventconfig=hostPath:/etc/kubernetes/eventconfig.yaml

      system service-parameter-apply kubernetes

  .. note::

      Parameter must not exist on service parameters, otherwise use
      :command:`modify` command.

- Modify existent parameter

  The configuration file name, for example, can be changed. During this
  operation, the preloaded configuration file will be replaced.

  .. code-block:: none

      system service-parameter-modify kubernetes kube_apiserver_volumes admission-control-config-file=hostPath:/etc/kubernetes/new-admission-control-config-file.yaml

      system service-parameter-apply kubernetes

- Delete parameters

  .. code-block:: none

      system service-parameter-list

  Copy parameter uuid to be deleted:

  .. code-block:: none

      system service-parameter-delete <uuid>

  In the current example, if EventRateLimit is no longer needed, it should be
  removed from the ``kube_apiserver enable-admission-plugins`` parameter,
  either by changing its value or by removing the parameter. Then the
  extra-volume ``kube_apiserver_volumes eventconfig`` parameter can be deleted.
  If the configuration file is no longer needed, the ``kube_apserver
  admission-control-config-file`` parameter can also be removed. Then the-extra
  volume ``kube_apiserver_volumes connections-control-config-file`` can be
  deleted.

- Configuration Files Examples:

  - ``admission-control-config-file.yaml``

    .. code-block:: none

        apiVersion: apiserver.config.k8s.io/v1
        kind: AdmissionConfiguration
        plugins:
          - name: EventRateLimit
            path: /etc/kubernetes/eventconfig.yaml

  - ``eventconfig.yaml``

    .. code-block:: none

        apiVersion: eventratelimit.admission.k8s.io/v1alpha1
        kind: Configuration
        limits:
          - type: Namespace
            qps: 50
            burst: 100
            cacheSize: 2000
          - type: User
            qps: 10
            burst: 50


-----------------------------
Complex Example configuration
-----------------------------

.. code-block::

   apiserver_extra_args:
     admission-control-config-file: "/etc/kubernetes/admission-control-config-file.yml"
     audit-policy-file: "/etc/kubernetes/audit-policy-file.yml"
     default-not-ready-toleration-seconds: "35"
     default-unreachable-toleration-seconds: "35"
     feature-gates: "SCTPSupport=true,TTLAfterFinished=true,HugePageStorageMediumSize=true,RemoveSelfLink=false,MemoryManager=true"
     enable-admission-plugins: "NodeRestriction,PodNodeSelector"
     event-ttl: "20h"
     audit-log-path: "/var/log/kubernetes/audit/audit.log"
     audit-log-maxage: "1"
     audit-log-maxbackup: "2"
     audit-log-maxsize: "1"

   scheduler_extra_args:
     feature-gates: "TTLAfterFinished=false"

   controllermanager_extra_args:
     node-monitor-period: "4s"
     node-monitor-grace-period: "25s"
     pod-eviction-timeout: '35s'
     feature-gates: "TTLAfterFinished=true,MemoryManager=true"

   kubelet_configurations:
     featureGates:
       MemoryManager: true
       HugePageStorageMediumSize: true

   apiserver_extra_volumes:
     - name: admission-control-config-file
       mountPath: "/etc/kubernetes/admission-control-config-file.yml"
       pathType: "File"
       readOnly: true
       content: |
         apiVersion: apiserver.config.k8s.io/v1
         kind: AdmissionConfiguration
         plugins:
         - name: PodNodeSelector
           path: /etc/kubernetes/podnodeselector.yaml
     - name: pod-nodes-selector-plugin-config
       mountPath: "/etc/kubernetes/podnodeselector.yaml"
       pathType: "File"
       readOnly: true
       content: |
         podNodeSelecto+rPluginConfig:
         clusterDefaultNodeSelector: name-of-node-selector
         namespace1: name-of-node-selector
         namespace2: name-of-node-selector
     - name: audit-policy-file
       mountPath: "/etc/kubernetes/audit-policy-file.yml"
       pathType: "File"
       readOnly: true
       content: |
         # Log all requests at the Metadata level.
         apiVersion: audit.k8s.io/v1
         kind: Policy
         rules:
         - level: Metadata
     - name: audit-log-path
       mountPath: "/var/log/kubernetes/audit/"
       readOnly: false
       pathType: 'DirectoryOrCreate'

   scheduler_extra_volumes:
     - name: sch-admission-control-config-file
       mountPath: "/etc/kubernetes/admission-control-config-file.yml"
       pathType: "File"
       readOnly: true
       content: |
         apiVersion:
         kind: AdmissionConfiguration
         plugins:
         - name: PodNodeSelector
           path: /etc/kubernetes/podnodeselector.yaml
     - name: sch-pod-nodes-selector-plugin-config
       mountPath: "/etc/kubernetes/podnodeselector.yaml"
       pathType: "File"
       readOnly: true
       content: |
         podNodeSelectorPluginConfig:
         clusterDefaultNodeSelector: name-of-node-selector
         namespace1: name-of-node-selector
         namespace2: name-of-node-selector
     - name: sch-audit-policy-file
       mountPath: "/etc/kubernetes/audit-policy-file.yml"
       pathType: "File"
       readOnly: true
       content: |
         # Log all requests at the Metadata level.
         apiVersion: audit.k8s.io/v1
         kind: Policy
         rules:
         - level: Metadata

   controllermanager_extra_volumes:
      - name: cm-admission-control-config-file
        mountPath: "/etc/kubernetes/admission-control-config-file.yml"
        pathType: "File"
        readOnly: true
        content: |
          apiVersion: apiserver.config.k8s.io/v1
          kind: AdmissionConfiguration
          plugins:
          - name: PodNodeSelector
            path: /etc/kubernetes/podnodeselector.yaml
      - name: cm-pod-nodes-selector-plugin-config
        mountPath: "/etc/kubernetes/podnodeselector.yaml"
        pathType: "File"
        readOnly: true
        content: |
          podNodeSelectorPluginConfig:
          clusterDefaultNodeSelector: name-of-node-selector
          namespace1: name-of-node-selector
          namespace2: name-of-node-selector
      - name: cm-audit-policy-file
        mountPath: "/etc/kubernetes/audit-policy-file.yml"
        pathType: "File"
        readOnly: true
        content: |
          # Log all requests at the Metadata level.
          apiVersion: audit.k8s.io/v1
          kind: Policy
          rules:
          - level: Metadata

