.. _configurable-power-manager-04c24b536696:

==========================
Configurable Power Manager
==========================

Configurable Power Manager focuses on containerized applications that use power
profiles individually by the core and/or the application.

|prod| has the capability to regulate the frequency of the entire processor.
However, this control is primarily directed towards the classification of the
core, distinguishing between application and platform cores. Consequently, if a
user requires to control over an individual core, such as Core 10 in a
24-core CPU, adjustments must be applied to all cores collectively. In the
context of containerized operations, it becomes imperative to establish
personalized configurations. This entails assigning each container the
requisite power configuration. In essence, this involves providing specific and
individualized power configurations to each core or group of cores.

With the introduction of Configurable Power Manager, it is possible to
highlight the control of acceptable frequency ranges (minimum and maximum
frequency) per core, the behavior of the core in this range (governor), which
power levels (c-states) a given core can access, as well as the behavior of the
system related to workloads with known intervals/demands.

To encapsulate the dependencies, images, profiles and configurations, Power
Manager is delivered as a |prod| Application.

.. rubric:: **System Requirements**

-   Support and enable the BIOS functionality to delegate ``c-states`` and
    ``p-states`` control to the operating system

-   intel_pstate and acpi_cpufreq drivers

-   intel_idle or acpi_idle module

.. rubric:: **Dependencies**

The installer will look for the |NFD| application on the cluster. In case the
|NFD| is not installed, as Intel recommends its use, the installation will fail
until you either install the |NFD| or create the ``user_override`` parameter
``nfd-required`` with value False to allow the installation of Power Manager
without the |NFD| application.

You can see an example below on how to override ``nfd-required`` parameter:

.. code-block:: none

    (keystone_admin)]$ system helm-override-update --set nfd-required=False kubernetes-power-manager kubernetes-power-manager intel-power


Power Manager Installation
--------------------------

The installation follows the standard procedure to install a |prod|
application.

#.  Go to the path for application tgz file:
    ``/usr/local/share/applications/helm/kubernetes-power-manager-<VERSION>.tgz``.

    .. code-block:: none

        (keystone_admin)]$ system application-upload /usr/local/share/applications/helm/kubernetes-power-manager-<VERSION>.tgz
        (keystone_admin)]$ system application-apply kubernetes-power-manager

#.  The namespace, service accounts, |RBAC| rules and |CRDs| in Kubernetes are
    all provided by the Power Manager project.

    .. list-table::
        :widths: 6 25
        :header-rows: 1

        * - **Resource Type**
          - **Resource Names**
        * - Namespace
          - intel-power
        * - Service Account
          - intel-power-node-agent

            intel-power-operator
        * - Role
          - operator-custom-resource-definitions-role
        * - Cluster Role
          - operator-nodes

            manager-role

            node-agent-cluster-resources
        * - Custom Resource Definition
          - cstates.power.intel.com

            powerconfigs.power.intel.com

            powernodes.power.intel.com

            powerpods.power.intel.com

            powerprofiles.power.intel.com

            powerworkloads.power.intel.com

            timeofdaycronjobs.power.intel.com

            timeofdays.power.intel.com

            uncores.power.intel.com

#.  The manager container (Kubernetes Operator) of Kubernetes Power Manager
    (monitors and starts the Power Manager agent on selected nodes) will be
    deployed. There will only be one instance of the operator in the cluster
    and it will preferably run on one of the control plane nodes.

#.  Publish the power configuration profile to the cluster (this resource is
    responsible for exposing the standard power profiles of Intel Power
    Optimization Library). The default power profiles are: performance,
    balance-performance, and balance-power.

#.  The Power Manager will create the available configurations. If you want to
    customize your application, apply those modifications via
    ``helm-override``. To see an example of a customization see
    :ref:`configurable-power-manager-04c24b536696-user-defined-settings`.


Label Assignment
----------------

A Kubernetes label will control which hosts the Power Manager agent should run.
The operator (manager) listens for changes in hosts and when detecting the
label it will start the agent container on that host.

The agent is responsible for monitoring and applying the power configurations
described by Custom Resources (c-state, Power Profiles, Power Workloads, etc)
or in the Pod specifications.

.. important::

    In the kubelet configuration file, the ``cpuManagerPolicy`` has to be set
    to "static", and the ``reservedSystemCPUs`` must be set to the desired
    value:

    .. code-block:: none

      (keystone_admin)]$ system host-label-assign --overwrite <HOSTNAME> kube-cpu-mgr-policy=static

To create the label, manually enter the command below to inform the host where
the agent must be deployed:

.. code-block:: none

    (keystone_admin)]$ system host-label-assign <HOSTNAME> power-management=enabled

.. note::

    This command will only be accepted if the ``max_cpu_mhz_configured``
    parameter is disabled. Do not have both activated simultaneously.

Once the label is applied, the following tasks will be automatically performed:

.. rubric:: **Default CPU c-states**

During the installation process, default c-state levels are configured. By
default, platform cores can access the available levels up to C6, while
application cores can access levels up to C1.

This configuration is performed automatically on each node and is based on the
levels available in the processor. If the target levels do not exist, the
application will choose to maintain only C0 on the application cores, and the
lowest available level on the platform cores.

.. rubric:: **Default CPU Frequency (p-state)**

CPU p-state management can be controlled either through power profiles applied
to containers or through a shared profile that manages CPU cores individually
or in groups.

By default, all CPU cores will use the full frequency range available and CPU
governor in performance mode.

Two resources will be deployed on Kubernetes: Shared profile and Shared
workload profile.

If you want to create a custom profile use the parameters in the yaml file
below:

.. code-block:: none

    apiVersion: power.intel.com/v1
    kind: PowerProfile
    metadata:
      name: profile-name
      namespace: intel-power

    spec:
      name: profile-name
      max: <HOST-MAX-CPU-FREQ>      # Maximum core frequency supported
      min: <HOST-MIN-CPU-FREQ>      # Minimum core frequency supported
      epp: performance
      governor: performance

.. rubric:: **Shared Profile**

This resource specifies the minimum and maximum core frequencies and CPU
governor for each host in the cluster. When the label is assigned to a host, it
will trigger the creation of this profile applying the minimum and maximum
frequencies supported and the CPU governor will always be ``performance``.

.. note::

    In real-time systems the minimum and maximum frequency are the same in all
    cores (min = max). This is standard behavior for real time systems, and
    different configurations will affect the maximum frequency.

.. rubric:: **Shared Workload Profile**

This resource binds the Shared Profile to CPU cores on the host. Once the label
is created on the host, the created profile will point to the Shared Profile
and select all CPU cores available except the platform cores that use the
``reservedCPUs`` parameter.

.. note::

    The CPU p-state of the platform cores will not be managed by Power Manager
    and will continue to use the settings defined as tuned.

.. rubric:: **Node Agent Pod**

The Pod Controller watches for pods. When a pod comes along, the Pod Controller
checks if the pod is in the guaranteed quality of service class (using
exclusive cores, taking a core out of the shared pool - it is the only option
in Kubernetes that can do this operation. For more details see
https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/).
Then it examines the Pods to determine which Power Profile has been requested
and then creates or updates the appropriate Power Workload.

.. note::

    The request and the limits must have a matching number of cores on a
    container-by-container basis. Currently, Power Manager only supports a
    single Power Profile per pod. If two profiles are requested in different
    containers, the pod gets created, but the cores are not tuned.
    This will only work if the pods use ``isolcpus``.


Exclude kernel parameter
------------------------

When you apply the ``power-management`` label, the ``intel_idle.max_cstate``
parameter is removed from the kernel arguments.

.. note::

    This change will take effect after reboot, until then, it retains the
    current behavior and the Power Manager will manage the CPU c-states using
    the ``acpi_idle`` driver which may not expose all c-states supported by the
    processor. After reboot, ensure that all overrides are applied.


.. _configurable-power-manager-04c24b536696-user-defined-settings:

---------------------
User Defined Settings
---------------------

You can override the auto-generated settings using the ``user_override``
functionality of the Power Manager application. It allows you to customize the
settings on a per-host basis for:

.. rubric:: **Shared Profile [section sharedProfile]:**

governor:
  CPU governor

max:
  Maximum CPU frequency

min:
  Minimum CPU frequency

reservedCPUs:
  List of CPU cores to not apply the profile (platform cores)

.. rubric:: **c-states Profile [section cstatesProfile]:**

sharedPoolCStates:
  List of CPU c-states for all application cores and their status (on/off)

individualCoreCStates:
  List of all platform CPU cores:

  - setList of CPU c-states for each application core and their status (on/off)

See the example below to to configure host controller-0. This setting will
override the CPU governor and maximum CPU frequency in Shared Profile and
disable C2 state for the platform cores (0,32) and enable C2 state for all
application cores through the c-state Profile.

.. code-block:: none

    sharedProfile:
      controller-0:
        governor: powersave
        max: 2000

    cstatesProfile:
      controller-0:
        individualCoreCStates:
          "0":
            C2: false
          "32":
            C2: false
        sharedPoolCStates:
          C2: true

Applying these ``user_overrides`` will generate a new configuration
(``combined_overrides``) by merging and overriding the auto-generated
configuration with the user's definitions. Also, you can view both
configurations individually: the auto-generated configuration by Power Manager
in the ``system_overrides`` section and the user configuration in
``user_overrides`` section as below.

.. code-block:: none

    (keystone_admin)]$ system helm-override-show kubernetes-power-manager kubernetes-power-manager intel-power

    +--------------------+--------------------------------------------------------------------+
    | Property           | Value                                                              |
    +--------------------+--------------------------------------------------------------------+
    | attributes         | enabled: true                                                      |
    |                    |                                                                    |
    | combined_overrides | cstatesProfile:                                                    |
    |                    |   controller-0:                                                    |
    |                    |     individualCoreCStates:                                         |
    |                    |       "0":                                                         |
    |                    |         C1: true                                                   |
    |                    |         C2: false                                                  |
    |                    |       "32":                                                        |
    |                    |         C1: true                                                   |
    |                    |         C2: false                                                  |
    |                    |     sharedPoolCStates:                                             |
    |                    |       C1: true                                                     |
    |                    |       C2: true                                                     |
    |                    | sharedProfile:                                                     |
    |                    |   controller-0:                                                    |
    |                    |     governor: powersave                                            |
    |                    |     max: 2000                                                      |
    |                    |     min: 800                                                       |
    |                    |     reservedCPUs:                                                  |
    |                    |     - 0                                                            |
    |                    |     - 32                                                           |
    |                    |                                                                    |
    | name               | kubernetes-power-manager                                           |
    | namespace          | intel-power                                                        |
    | system_overrides   | cstatesProfile:                                                    |
    |                    |   controller-0:                                                    |
    |                    |     individualCoreCStates:                                         |
    |                    |       '0': {C1: true, C2: true}                                    |
    |                    |       '32': {C1: true, C2: true}                                   |
    |                    |     sharedPoolCStates: {C1: true, C2: false}                       |
    |                    | sharedProfile:                                                     |
    |                    |   controller-0:                                                    |
    |                    |     governor: performance                                          |
    |                    |     max: 3000                                                      |
    |                    |     min: 800                                                       |
    |                    |     reservedCPUs: [0, 96]                                          |
    |                    |                                                                    |
    | user_overrides     | cstatesProfile:                                                    |
    |                    |   controller-0:                                                    |
    |                    |     individualCoreCStates:                                         |
    |                    |       "0":                                                         |
    |                    |         C2: false                                                  |
    |                    |       "32":                                                        |
    |                    |         C2: false                                                  |
    |                    |     sharedPoolCStates:                                             |
    |                    |       C2: true                                                     |
    |                    | sharedProfile:                                                     |
    |                    |   controller-0:                                                    |
    |                    |     governor: powersave                                            |
    |                    |     max: 2000                                                      |
    |                    |                                                                    |
    +--------------------+--------------------------------------------------------------------+

This final configuration will be published into Kubernetes as a Shared Profile
and c-state Profile when you reapply the application.

.. code-block:: none

    (keystone_admin)]$ system application-apply kubernetes-power-manager

It is also possible (and optional) to add a c-state for a specific profile. To
do this, you need to add ``exclusivePoolCstates`` tag. See the example below
including c-states for performance profile:

.. code-block:: none

    sharedProfile:
      controller-0:
        governor: powersave
          max: 2000

    cstatesProfile:
     controller-0:
       individualCoreCStates:
         "0":
           C2: false
         "32":
           C2: false
       sharedPoolCStates:
         C2: true
       exclusivePoolCstates:
         performance:
           C2: true


There are other features available in the Power Manager, such as Uncore
Frequency, and Time of Day that can be used, but their settings should be
deployed directly to the cluster using the procedures described in Power
Manager documentation in https://github.com/intel/kubernetes-power-manager.


---------------------
Inconsistent Settings
---------------------

It is important to consider that when using the application, you will have to
configure frequency and power profiles with caution. However, such
settings, if inconsistent, may result in an undesired power state of the pods,
whether due to the partial application of settings (only c-states or only
p-states) or the non-application of settings in general (pod deployed without
power settings).

-----------------------
Power Manager Uninstall
-----------------------

To uninstall the application you must use the following commands to remove any
|prod| application.

.. code-block:: none

    (keystone_admin)]$ system application-remove kubernetes-power-manager
    (keystone_admin)]$ system application-delete kubernetes-power-manager

The uninstall process will shut down the containers (manager and all agents)
and remove all configurations deployed to Kubernetes related to Power Manager,
including the ``namespace intel-power``. The |NFD| application will not be
unistalled even if it had been installed as dependency on Power Manager, this
will avoid the disruption of other applications that use it. The
``power-management`` label should be manually removed.

.. code-block:: none

    (keystone_admin)]$ system host-label-remove <HOSTNAME> power-management

.. note::

    While the label is assigned to a host, the ``intel_idle.max_cstate`` kernel
    parameter will not be restored on that host and the
    ``max_cpu_mhz_configured`` parameter will remain disabled.
