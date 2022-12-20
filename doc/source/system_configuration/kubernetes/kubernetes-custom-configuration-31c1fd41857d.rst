.. _kubernetes-custom-configuration-31c1fd41857d:

===============================
Kubernetes Custom Configuration
===============================

------------
Introduction
------------

Kubernetes configuration can be customized during deployment by specifying
bootstrap overrides in the ``localhost.yml`` file during the Ansible bootstrap
process.


Custom configuration includes:

-   Configuring options on ``kube-apiserver`` such as feature gates and admission
    controllers,

-   Configuring options on ``kube-controller-manager`` such as
-   ``node-monitor-period`` and ``pod-eviction-timeout``,

-   Configuring options on ``kube-scheduler`` such as feature gates,

-   Configuring options on kubelet such as maximum pods and enabling unsafe
    sysctls.

----------------------------
kube-apiserver configuration
----------------------------

The Kubernetes API server validates and configures data for the api objects
which include pods, services, replicationcontrollers, and others. The API
Server services REST operations and provides the frontend to the cluster's
shared state through which all other components interact.

For a list of all configurable options of kube-apiserver, see `kube-apiserver
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/>`__.

.. **Bootstrap configuration**

To set or override a ``kube-apiserver`` option, add the desired parameters to an
``apiserver_extra_args`` section in the ``localhost.yml``.

Example usage:

.. code-block::

   apiserver_extra_args:
    admission-control-config-file: "/etc/kubernetes/admission-control-config-file.yml"
    audit-policy-file: "/etc/kubernetes/audit-policy-file.yml"
    default-not-ready-toleration-seconds: "35"
    default-unreachable-toleration-seconds: "35"
    enable-admission-plugins: "NodeRestriction,PodNodeSelector"
    event-ttl: "20h"


.. **Runtime configuration**

   To set, modify or delete a ``kube-apiserver`` parameter use the
   service-parameter add, modify or delete |CLI| command.

   Example usage:

   - Add new parameter

     .. code-block:: none

        system service-parameter-add kubernetes kube_apiserver default-not-ready-toleration-seconds=31

        system service-parameter-apply kubernetes

    .. note::

      Parameter must not exists on service parameters, otherwise use :command:`modify`
      command.

    - Modify existing parameter

    .. code-block:: none

        system service-parameter-modify kubernetes kube_apiserver default-not-ready-toleration-seconds=33

        system service-parameter-apply kubernetes

    - Delete parameter

    #.  system service-parameter-list

    #.  copy parameter uuid to be deleted

    #.  system service-parameter-delete <uuid>


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


.. **Bootstrap configuration**

To set or override a ``kube-controller-manager`` option, add the desired
parameters to an ``controllermanager_extra_args`` section in the
``localhost.yml`` .


Example usage:

.. code-block::

   controllermanager_extra_args:
    node-monitor-period: "4s"
    node-monitor-grace-period: "25s"
    pod-eviction-timeout: '35s'
    feature-gates: "TTLAfterFinished=true,MemoryManager=true"


.. **Runtime configuration**

    To set, modify or delete a ``kube-controller-manager`` parameter use the
    service-parameter add, modify or delete |CLI| command.

    Example usage:

    - Add new parameter

    .. code-block:: none

        system service-parameter-add kubernetes kube_controller_manager node-monitor-period=5s

        system service-parameter-apply kubernetes

    .. note::

      Parameter must not exists on service parameters, otherwise use :command:`modify`
      command.

    - Modify existing parameter

    .. code-block:: none

        system service-parameter-modify kubernetes kube_controller_manager node-monitor-period=7s

        system service-parameter-apply kubernetes

    - Delete parameter

    #.  system service-parameter-list

    #.  copy parameter uuid to be deleted

    #.  system service-parameter-delete <uuid>


----------------------------
kube-scheduler configuration
----------------------------

The Kubernetes scheduler is a control plane process which assigns Pods to
Nodes. The scheduler determines which Nodes are valid placements for each Pod
in the scheduling queue according to constraints and available resources. The
scheduler then ranks each valid Node and binds the Pod to a suitable Node.
Multiple different schedulers may be used within a cluster; kube-scheduler is
the reference implementation.

For a list of all configurable options of ``kube-scheduler``, see `kube-scheduler
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/>`__.

.. **Bootstrap configuration**

To set or override a ``kube-scheduler`` option, add the desired parameters to an
``scheduler_extra_args`` section in the ``localhost.yml`` .

Example usage:

.. code-block::

   scheduler_extra_args:
     feature-gates: "TTLAfterFinished=false"

.. **Runtime configuration**

To set, modify or delete a ``kube-controller-manager`` parameter use the
service-parameter add, modify or delete |CLI| command.

.. Example usage:

  - Add new parameter

    .. code-block:: none

        system service-parameter-add kubernetes kube_scheduler leader-elect-lease-duration=16s

        system service-parameter-apply kubernetes

    .. note::

      Parameter must not exists on service parameters, otherwise use :command:`modify`
      command.

  - Modify existing parameter

    .. code-block:: none

        system service-parameter-modify kubernetes kube_scheduler leader-elect-lease-duration=14s

        system service-parameter-apply kubernetes

  - Delete parameter

    #.  system service-parameter-list

    #.  copy parameter uuid to be deleted

    #.  system service-parameter-delete <uuid>


----------------------
kubelet configurations
----------------------

The kubelet is the primary "node agent" that runs on each node.

For a list of all configurable  options, see `Kubelet Configuration (v1beta1)
<https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/>`__.

To set or override a kubelet option, add the desired parameters to an
``kubelet_configurations`` section in the ``localhost.yml`` .



..    Custom Kubelet configuration is not supported during runtime. This feature
    will be supported in the next release.

Example usage:

.. code-block::

   kubelet_configurations:
     featureGates:
       MemoryManager: true
       HugePageStorageMediumSize: true

---------------------------------------------------------------------------------
apiserver_extra_volumes, controllermanager_extra_volumes, scheduler_extra_volumes
---------------------------------------------------------------------------------

Some options/parameters specified in ``apiserver_extra_args``,
``controllermanager_extra_args`` and ``scheduler_extra_volumes`` refer to a
configuration file. The contents of these files are configured in the bootstrap
overrides (``localhost.yml``) with the ``apiserver_extra_volumes``,
``controllermanager_extra_volumes`` and ``scheduler_extra_volumes``
definitions.



..    Kubernetes custom configuration of extra-volumes for ``kube-apiserver``,
    ``kube-controller-manager`` and ``kube-scheduler`` are not supported during
    runtime. This feature will be supported in the next release.


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
audit-policy-file.yaml file to specify the details of what events should be
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

