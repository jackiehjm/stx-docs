.. _pod-security-admission-controller-8e9e6994100f:

======================================================
Technology Preview - Pod Security Admission Controller
======================================================

Pod Security Admission (PSA) Controller is the |PSP| replacement, and this
document describes the technical preview of |PSA| functionality which is 'beta'
quality in K8S v1.23 .

The |PSA| admission controller acts on creation and modification of the pod and
determines if it should be admitted based on the requested security context and
the policies defined by Pod Security Standards.

-------------------
Pod Security levels
-------------------

Pod Security Admission levels refer to the 3 policies defined by the Pod
Security Standards: privileged, baseline, and restricted.

Privileged
    Unrestricted policy, providing the widest possible level of permissions.
    This policy allows for known privilege escalations. It aims at system- and
    infrastructure-level workloads managed by privileged, trusted users.

Baseline
    Minimally restrictive policy which prevents known privilege escalations. It
    aims at ease of adoption for common containerized workloads for
    non-critical applications.

Restricted
    Heavily restricted policy, following current Pod hardening best practices.
    It is targeted at operators and developers of security-critical
    applications, as well as lower-trust users.

--------------------------------------------
Pod Security Admission labels for namespaces
--------------------------------------------

Pod security restrictions are applied at the namespace level.

With |PSA| feature enabled, namespaces can be configured to define the
admission control mode to be used for pod security in each namespace.
Kubernetes defines a set of labels to set predefined Pod Security levels for a
namespace. The label will define what action the controller control plane takes
if a potential violation is detected.

A namespace can configure any or all modes, or set different levels for
different modes. The modes are:

enforce
    Policy violations will cause the pod to be rejected.

audit
    Policy violations will trigger the addition of an audit annotation to the
    event recorded in the K8S audit log but are otherwise allowed.

warn
    Policy violations will trigger a user-facing warning but are otherwise
    allowed.

For each mode, there are two labels that determine the policy used.

This is a generic namespace configuration using labels.

.. code-block:: none

    # label indicates which policy level to apply for the mode.
    #
    # MODE must be one of `enforce`, `audit`, or `warn`.
    # LEVEL must be one of `privileged`, `baseline`, or `restricted`.
    pod-security.kubernetes.io/<MODE>: <LEVEL>

    # Optional: per-mode version label can be used to pin the policy to the
    # version that shipped with a given Kubernetes minor version (e.g. v1.23).
    #
    # MODE must be one of `enforce`, `audit`, or `warn`.
    # VERSION must be a valid Kubernetes minor version, or `latest`.
    pod-security.kubernetes.io/<MODE>-version: <VERSION>

For more information refer to
`https://kubernetes.io/docs/concepts/security/pod-security-admission/
<https://kubernetes.io/docs/concepts/security/pod-security-admission/>`__.

-----------------------------
Enable Pod Security Admission
-----------------------------

To enable |PSA|, PodSecurity feature gate must be enabled.

Starting with Kubernetes 1.23 version, PodSecurity feature gate is enabled by
default.

For Kubernetes version 1.22, PodSecurity feature gate can be enabled using
option ``feature-gates`` in bootstrap overrides file, ``localhost.yml``. As the
example shown below:

.. code-block:: none

    apiserver_extra_args:
     feature-gates: "TTLAfterFinished=true,HugePageStorageMediumSize=true,RemoveSelfLink=false,MemoryManager=true,PodSecurity=true"

See :ref:`Kubernetes Custom Configuration
<kubernetes-custom-configuration-31c1fd41857d>` for more details on kubernetes
configuration, ``apiserver_extra_args`` and ``apiserver_extra_volumes``.

.. _configure-defaults-for-the-pod-security-admission-controller-525590d11815:

------------------------------------------------------------
Configure defaults for the Pod Security Admission Controller
------------------------------------------------------------

For the technology preview of the |PSA| controller, the |PSA| controller can be
configured with default security polices and exemptions at bootstrap time.

The Default |PSA| controller configuration will apply to namespaces that are
not configured with the ``pod-security.kubernetes.io`` labels to specify a
security level and mode. For example if you display the namespace description
using ``kubectl describe namespace <namespace>`` and the
``pod-security.kubernetes.io`` labels are not displayed, then the behavior of
the namespace will follow the default |PSA| labels' level, mode and version
configuration set with PodSecurity plugin of the AdmissionConfiguration
resource.

To configure ``cluster-wide`` default policies and/or exemptions, the
PodSecurity plugin of the AdmissionConfiguration resource can be used. The
AdmissionConfiguration resource is configurable at bootstrap time with the
``api-server_extra_args`` and ``apiserver_extra_volumes`` overrides in the
``localhost.yml`` file.

Any policy that is applied via namespace labels will take precedence.

Example of configuration added to ``localhost.yml``:

.. code-block:: none

    apiserver_extra_args:
      admission-control-config-file: "/etc/kubernetes/admission-control-config-file.yaml"

    apiserver_extra_volumes:
      - name: admission-control-config-file
        mountPath: "/etc/kubernetes/admission-control-config-file.yaml"
        pathType: "File"
        readOnly: true
        content: |
          apiVersion: apiserver.config.k8s.io/v1
          kind: AdmissionConfiguration
          plugins:
          - name: PodSecurity
            configuration:
              apiVersion: pod-security.admission.config.k8s.io/v1beta1
              kind: PodSecurityConfiguration
              defaults:
                enforce: "privileged"
                enforce-version: "latest"
                audit: "privileged"
                audit-version: "latest"
                warn: "privileged"
                warn-version: "latest"

See :ref:`Kubernetes Custom Configuration
<kubernetes-custom-configuration-31c1fd41857d>` for more details on kubernetes
configuration, ``apiserver_extra_args`` and ``apiserver_extra_volumes``.

The generic definition of the ``AdmissionConfiguration`` resource can be found
at
`https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-admission-controller/
<https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-admission-controller/>`__.


---------------------------------
Platform namespaces configuration
---------------------------------

In preparation for |PSA| controller full support, namespace labels have been
added to all the namespaces used by the platform. System namespaces, such as
``kube-system``, ``deployment``, as well as application namespaces such as,
``cert-manager`` have been created by default with privileged label levels.

The following labels configuration is applied by default to Platform
namespaces:

.. code-block:: none

    controller-0:~$ kubectl describe namespace kube-system
    Name:         kube-system
    Labels:       kubernetes.io/metadata.name=kube-system
                  pod-security.kubernetes.io/audit=privileged
                  pod-security.kubernetes.io/audit-version=latest
                  pod-security.kubernetes.io/enforce=privileged
                  pod-security.kubernetes.io/enforce-version=latest
                  pod-security.kubernetes.io/warn=privileged
                  pod-security.kubernetes.io/warn-version=latest

    Annotations:  <none>
    Status:       Active

    No resource quota.

    No LimitRange resource

-------------------------------------------------
Pod Security Admission Controller - Usage Example
-------------------------------------------------

This page walks through a usage example of |PSA| where you will:

-   Create a namespace for each of the 3 security policies levels: privileged,
    baseline and restricted.

-   Create a yaml file with a privileged pod configuration.

-   Create a privileged pod in all 3 namespaces.

-   The pod creation will only be successful in the privileged namespace.

.. code-block:: none

    controller-0:~$ vi baseline-ns.yaml
    apiVersion: v1
    kind: Namespace
    metadata:
     name: baseline-ns
     labels:
      pod-security.kubernetes.io/enforce: baseline
      pod-security.kubernetes.io/enforce-version: v1.23
      pod-security.kubernetes.io/warn: baseline
      pod-security.kubernetes.io/warn-version: v1.23
      pod-security.kubernetes.io/audit: baseline
      pod-security.kubernetes.io/audit-version: v1.23

    controller-0:~$ kubectl apply -f baseline-ns.yaml

    controller-0:~$ vi privileged-ns.yaml
    apiVersion: v1
    kind: Namespace
    metadata:
     name: privileged-ns
     labels:
      pod-security.kubernetes.io/enforce: privileged
      pod-security.kubernetes.io/enforce-version: v1.23
      pod-security.kubernetes.io/warn: privileged
      pod-security.kubernetes.io/warn-version: v1.23
      pod-security.kubernetes.io/audit: privileged
      pod-security.kubernetes.io/audit-version: v1.23

    controller-0:~$ kubectl apply -f privileged-ns.yaml

    controller-0:~$ vi restricted-ns.yaml
    apiVersion: v1
    kind: Namespace
    metadata:
     name: restricted-ns
     labels:
      pod-security.kubernetes.io/enforce: restricted
      pod-security.kubernetes.io/enforce-version: v1.23
      pod-security.kubernetes.io/warn: restricted
      pod-security.kubernetes.io/warn-version: v1.23
      pod-security.kubernetes.io/audit: restricted
      pod-security.kubernetes.io/audit-version: v1.23

    controller-0:~$ kubectl apply -f restricted-ns.yaml

    controller-0:~$ vi privileged-pod.yaml
    apiVersion: v1
    kind: Pod
    metadata:
     name: privileged
    spec:
     containers:
      - name: pause
        image: k8s.gcr.io/pause
        securityContext:
         privileged: true

    controller-0:~$ kubectl -n privileged-ns apply -f privileged-pod.yaml
    pod/privileged created

    controller-0:~$ kubectl -n baseline-ns apply -f privileged-pod.yaml
    Error from server (Failure): error when creating "privileged-pod.yaml": privileged (container "pause" must not set securityContext.privileged=true)

    controller-0:~$ kubectl -n restricted-ns apply -f privileged-pod.yaml
    Error from server (Failure): error when creating "privileged-pod.yaml": privileged (container "pause" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "pause" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "pause" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "pause" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "pause" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
    controller-0:~$

For more information refer to
`https://kubernetes.io/docs/concepts/security/pod-security-admission/
<https://kubernetes.io/docs/concepts/security/pod-security-admission/>`__.
