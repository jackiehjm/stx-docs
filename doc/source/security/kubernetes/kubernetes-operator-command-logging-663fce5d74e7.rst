.. _kubernetes-operator-command-logging-663fce5d74e7:

===================================
Kubernetes Operator Command Logging
===================================

The Kubernetes auditing provides a set of records that document the sequence of
actions in a cluster. For more details, see
`https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/
<https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/>`__.

You can configure which events should be logged through a set of rules written
in a YAML file, see
`https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#audit-policy
<https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#audit-policy>`__.
A default policy file is provided in |prod| at
``/etc/kubernetes/default-audit-policy.yaml``. This default policy file is a
version of the audit profile for Google Container-Optimized OS.

Kubernetes API Logging can be enabled and configured in |prod|, and can be
fully configured and enabled at bootstrap time. Post-bootstrap, Kubernetes API
Logging can only be enabled or disabled.

The default policy file provided, present at
``/etc/kubernetes/default-audit-policy.yaml``, is a version of the audit
profile for Google Container-Optimized OS extracted from
`https://github.com/kubernetes/kubernetes/blob/75e49ec824b183288e1dbaccfd7dbe77d89db381/cluster/gce/gci/configure-helper.sh#L1129
<https://github.com/kubernetes/kubernetes/blob/75e49ec824b183288e1dbaccfd7dbe77d89db381/cluster/gce/gci/configure-helper.sh#L1129>`__.
Different log levels are used for different Kubernetes components.

The reference for the ``kube-apiserver`` parameters associated with Kubernetes
API Logging can be found at
`https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/
<https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/>`__.

``audit-policy-file``
    This parameter contains the full path of the audit policy configuration
    file to be used (e.g. ``/etc/kubernetes/default-audit-policy.yaml``).
    When this parameter is present, the feature is enabled. In |prod|
    |prod-ver|, by default, this parameter is absent and the feature is
    disabled.

``audit-log-path``
    This parameter points to the log file where the logs will be written. In
    |prod| |prod-ver|, by default, this parameter is present with the value
    ``/var/log/kubernetes/audit/audit.log``. It is recommended to use the
    default value.

``audit-log-maxsize``
    This parameter indicates the maximum size in megabytes of the audit log
    file before it gets rotated. In |prod| |prod-ver|, by default, this
    parameter is present with the value "100", that means 100MB.

``audit-log-maxage``
    This parameter indicates the maximum number of days to retain old audit log
    files. In |prod| |prod-ver|, by default, this parameter is present with the
    value "3", that means 3 days.

``audit-log-maxbackup``
    This parameter indicates the maximum number of old audit log files to
    retain. In |prod| |prod-ver|, by default, this parameter is present with
    the value "10", that means that 10 old files are kept.

-------------------------------------------
Bootstrap configuration of audit parameters
-------------------------------------------

At bootstrap, all five parameters are configurable. When the value of these
parameters are not overridden, the deployed environment will have the feature
disabled, as the parameter ``audit-policy-file`` will be absent, and the other
parameters will be present with the default values.

You can see below a YAML example that configures, at bootstrap in
``/home/sysadmin/localhost.yml``, all parameters and defines the contents of a
custom policy file to be used with the ``apiserver_extra_volumes: {name:
my-audit-policy-file ...}`` parameter. By configuring the parameter
``audit-policy-file`` the feature will be enabled.

.. code-block:: none

    apiserver_extra_args:
      audit-log-maxage: '2'
      audit-log-maxbackup: '3'
      audit-log-maxsize: '40'
      audit-log-path: '/var/log/kubernetes/audit/audit.log'
      audit-policy-file: '/etc/kubernetes/my-audit-policy-file.yml'
    apiserver_extra_volumes:
      - name: my-audit-policy-file
        mountPath: '/etc/kubernetes/my-audit-policy-file.yml'
        pathType: File
        readOnly: true
        content: |
          # Log all requests at the Metadata level.
          apiVersion: audit.k8s.io/v1
          kind: Policy
          rules:
          - level: Metadata


-----------------------------------------
Runtime Configuration of audit parameters
-----------------------------------------

After deploy, only the parameter ``audit-policy-file`` is configurable as a
system service parameter, allowing the user to enable/disable the feature.

You can find below an example of how to add this parameter. The feature is
disabled when the parameter is removed  (i.e. ``system service-parameter-delete``).

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-add kubernetes kube_apiserver audit-policy-file=/etc/kubernetes/default-audit-policy.yaml
    ~(keystone_admin)$ system service-parameter-apply kubernetes


-----------
Limitations
-----------

In |prod| |prod-ver|, a custom policy file can only be created at bootstrap
time in ``apiserver_extra_volumes`` section. If a custom policy file was
configured at bootstrap, then after bootstrap the user has the option to
configure the parameter ``audit-policy-file`` to either this custom policy file
(``/etc/kubernetes/my-audit-policy-file.yml`` in the example above) or the
default policy file ``/etc/kubernetes/default-audit-policy.yaml``. If no custom
policy file was configured at bootstrap, then the user can only configure the
parameter ``audit-policy-file`` to the default policy file.

Only the parameter ``audit-policy-file`` is configurable after bootstrap, so
the others (``audit-log-path``, ``audit-log-maxsize``, ``audit-log-maxage`` and
``audit-log-maxbackup``) cannot be changed at runtime.
