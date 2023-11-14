.. _install-power-metrics-application-a12de3db7478:

======================================================
Technology Preview - Install Power Metrics Application
======================================================

The Power Metrics app deploys two containers, cAdvisor and Telegraf that
collect metrics about hardware usage. This document describes the technical
preview of the Power Metrics functionality.

.. rubric:: |prereq|

For running power-metrics, your system must have the following drivers:

cpufreq kernel module
    exposes per-CPU Frequency over sysfs
    (``/sys/devices/system/cpu/cpu%d/cpufreq/scaling_cur_freq``)

msr kernel module
    provides access to processor model specific registers over devfs
    (``/dev/cpu/cpu%d/msr``)

intel-rapl module
    exposes Intel Runtime Power Limiting metrics over sysfs
    (``/sys/devices/virtual/powercap/intel-rapl``)

intel-uncore-frequency module
    exposes Intel uncore frequency metrics over sysfs
    (``/sys/devices/system/cpu/intel_uncore_frequency``)


Uncore events can only be loaded from the following cpu models:

.. list-table::
    :widths: 6 25
    :header-rows: 1

    * - **Model number**
      - **Processor name**
    * - 0x55
      - Intel Skylake-X
    * - 0x6A
      - Intel IceLake-X
    * - 0x6C
      - Intel IceLake-D
    * - 0x47
      - Intel Broadwell-G
    * - 0x4F
      - Intel Broadwell-X
    * - 0x56
      - Intel Broadwell-D
    * - 0x8F
      - Intel Sapphire Rapids X
    * - 0xCF
      - Intel Emerald Rapids X

Source: https://github.com/influxdata/telegraf/issues/13098#issuecomment-1512585422

.. rubric:: |proc|

#.  Upload the application.

    .. code-block:: none

        [sysadmin@controller-0 (keystone_admin)]$ system application-upload /usr/local/share/applications/helm/power-metrics-[version].tgz

#.  Apply the application.

    .. code-block:: none

        [sysadmin@controller-0 (keystone_admin)]$ system application-apply power-metrics

#.  Wait until Power Metrics is in applied state.

    .. code-block:: none

        [sysadmin@controller-0 (keystone_admin)]$ system application-show power-metrics

#.  Assign a label to the node:

    .. note::

        A label must be assigned for the power-metrics to be enabled in a node.

    .. code-block:: none

        power-metrics:enabled

    .. code-block:: none

        [sysadmin@controller-0 (keystone_admin)]$ system host-label-assign <node-name> power-metrics=enabled

.. rubric:: |result|

The Power Metrics should be installed and both cAdvisor and Telegraf pods must
be up and running.

.. code-block:: none

    sysadmin@controller-0:~$ kubectl get pods -n power-metrics

    NAME                              READY   STATUS    RESTARTS   AGE
    cadvisor-v76zx                    1/1     Running   0          26h
    telegraf-mc6vd                    1/1     Running   0          4d7h

It is possible to change some configurations via override.

--------
Telegraf
--------

Enable and disable Intel PMU metrics
------------------------------------

You can activate the Intel PMU plugin with the following command:

.. code-block:: none

    [sysadmin@controller-0 ~(keystone_admin)]$ system helm-override-update power-metrics telegraf power-metrics --set pmu_enabled=true
  +----------------+-------------------+
  | Property       | Value             |
  +----------------+-------------------+
  | name           | telegraf          |
  | namespace      | power-metrics     |
  | user_overrides | pmu_enabled: true |
  |                |                   |
  +----------------+-------------------+


Override intel_powerstat plugin
-------------------------------

You can change the default ``intel_powerstat`` plugin parameters by override.

The plugin parameters include CPU and package metrics, and also the read method
of |MSR|.

The list of available options for both CPU and package metrics can be found on
the powerstat documentation:
https://github.com/influxdata/telegraf/blob/master/plugins/inputs/intel_powerstat/README.md#configuration

It is worth noting that when overriding, the user must inform both metrics
parameters (cpu and package), otherwise the plugin would stop collecting the
missing metrics.

The ``read_method`` parameter specifies the reading method of |MSR|. This
parameter accepts two values, concurrent or sequential. The default is
concurrent. Concurrent method uses goroutines to read each |MSR| value
concurrently.

The sequential method reads each value sequentially. This reduces latency
overhead when using preempt-rt kernel with isolated cores, but might cause loss
of precision on metrics calculation.

Example of overriding the powerstat plugin:

.. code-block:: none

    [sysadmin@controller-0 ~(keystone_admin)]$ cat telegraf-powerstat.yaml
    config:
      intel_powerstat:
        read_method: "sequential"
        cpu_metrics: ["cpu_frequency","cpu_busy_frequency","cpu_temperature","cpu_c0_state_residency","cpu_c1_state_residency","cpu_c6_state_residency","cpu_busy_cycles"]
        package_metrics: ["current_power_consumption","current_dram_power_consumption","thermal_design_power","cpu_base_frequency"]

    [sysadmin@controller-0 ~(keystone_admin)]$ system helm-override-update power-metrics telegraf power-metrics --values telegraf-powerstat.yaml
    +----------------+--------------------------------------+
    | Property       | Value                                |
    +----------------+--------------------------------------+
    | name           | telegraf                             |
    | namespace      | power-metrics                        |
    | user_overrides | config:                              |
    |                |   intel_powerstat:                   |
    |                |     cpu_metrics:                     |
    |                |     - cpu_frequency                  |
    |                |     - cpu_busy_frequency             |
    |                |     - cpu_temperature                |
    |                |     - cpu_c0_state_residency         |
    |                |     - cpu_c1_state_residency         |
    |                |     - cpu_c6_state_residency         |
    |                |     - cpu_busy_cycles                |
    |                |     package_metrics:                 |
    |                |     - current_power_consumption      |
    |                |     - current_dram_power_consumption |
    |                |     - thermal_design_power           |
    |                |     - cpu_base_frequency             |
    |                |     read_method: sequential          |
    |                |                                      |
    +----------------+--------------------------------------+

Then, you can re-apply the app:

.. code-block:: none

    [sysadmin@controller-0 ~(keystone_admin)]$ system application-apply power-metrics


Add input plugins
-----------------

You can add new plugins overriding the plugins column.

#.  Add the cgroups plugin:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ cat telegraf-cgroups.yaml
        config:
          inputs:
            - cgroup:
                paths: ["/sys/fs/cgroup/cpu","/sys/fs/cgroup/cpu/*","/sys/fs/cgroup/cpu/*/*",]
                files: ["cpuacct.usage", "cpuacct.usage_percpu", "cpu.cfs_period_us", "cpu.cfs_quota_us", "cpu.shares", "cpu.stat"]

#.  Then apply the override:

    .. code-block:: none

        system helm-override-update power-metrics telegraf power-metrics --values /path/to/file.yaml
        [sysadmin@controller-0 ~(keystone_admin)]$ system helm-override-update power-metrics telegraf power-metrics --values telegraf-cgroups.yaml
        +----------------+--------------------------------+
        | Property       | Value                          |
        +----------------+--------------------------------+
        | name           | telegraf                       |
        | namespace      | power-metrics                  |
        | user_overrides | config:                        |
        |                |   inputs:                      |
        |                |   - cgroup:                    |
        |                |       files:                   |
        |                |       - cpuacct.usage          |
        |                |       - cpuacct.usage_percpu   |
        |                |       - cpu.cfs_period_us      |
        |                |       - cpu.cfs_quota_us       |
        |                |       - cpu.shares             |
        |                |       - cpu.stat               |
        |                |       paths:                   |
        |                |       - /sys/fs/cgroup/cpu     |
        |                |       - /sys/fs/cgroup/cpu/*   |
        |                |       - /sys/fs/cgroup/cpu/*/* |
        |                |                                |
        +----------------+--------------------------------+

#.  After you can re-apply the app:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ system application-apply power-metrics

#.  If needed, add configmap and volumes via override:

    .. code-block:: none

        volumes:
        - name: telegraf-example
          configMap:
            name: telegraf-example
        mountPoints:
        - name: telegraf-example
          mountPath: /path/to/file.json
          subPath: file.json

    .. code-block:: none

        system helm-override-update power-metrics telegraf power-metrics --values /path/to/file.yaml

For more information on Telegraf plugins, see
https://github.com/influxdata/telegraf#documentation.


Modify Telegraf data collection interval
----------------------------------------

Telegraf report its metrics each 10 seconds, but you can modify this time
interval with the following command:

.. code-block:: none

    system helm-override-update power-metrics telegraf power-metrics --set config.agent.interval=<time-interval>

--------
cAdvisor
--------

Enable and disable Perf Events on cAdvisor
------------------------------------------

To enable or disable Perf Events on cAdvisor, use the following command:

.. code-block:: none

    [sysadmin@controller-0 ~(keystone_admin)]$ system helm-override-update power-metrics cadvisor power-metrics --set perf_events=true
    +----------------+-------------------+
    | Property       | Value             |
    +----------------+-------------------+
    | name           | cadvisor          |
    | namespace      | power-metrics     |
    | user_overrides | perf_events: true |
    |                |                   |
    +----------------+-------------------+

After that, reapply the power-metrics app, and wait until the pod restarts:

.. code-block:: none

    system application-apply power-metrics


----------------------------
Remove the Power Metrics App
----------------------------

To remove the Power metrics app use the following command:

.. code-block:: none

    system application-remove power-metrics

Then, use the following command to return the application to the uploaded state:

.. code-block:: none

    system application-delete power-metrics

-----------------
Available Metrics
-----------------

With Power Metrics application, we have access to system and hardware level raw
data, enabling to visualize the power  usage.

Power Metrics, by default, exposes the data collected from both, cAdvisor and
Telegraf, in the OpenMetrics format.

.. rubric:: **Thermal Design Power**

The Thermal Design Power, or TDP, is the maximum energy available, in watts,
for the processor. The metric name for checking the TDP is:
``powerstat_package_thermal_design_power_watts``.

.. rubric:: **Current Power Consumption**

The current power usage of the system in watts. The metric name for checking
power consumption is ``powerstat_package_current_power_consumption_watts``.

.. rubric:: **Current DRAM Power Consumption**

The current power usage of dram in the system in watts. The metric name for
checking DRAM Consumption is:
``powerstat_package_current_dram_power_consumption_watts``.

.. rubric:: **Current CPU Frequency**

The current CPU frequency of the  of the processor. The metric name for
checking the CPU frequency is ``powerstat_core_cpu_frequency_mhz``.

.. rubric:: **CPU Base Frequency**

The base frequency (non-turbo) of the processor, it is the default speed of the
processor. The metric name for checking cpu base frequency is
``powerstat_package_cpu_base_frequency_mhz``.

.. rubric:: **Uncore Frequency**

The application reports the current, maximum, and minimum frequency. The uncore
frequency can be described as the frequency on a processor that is not actually
part of its processor core, like memory controller and cache controller.

You can check the current uncore frequency with the following metric name:
``powerstat_package_uncore_frequency_mhz_cur``, for maximum frequency metric
name is ``powerstat_package_uncore_frequency_limit_mhz_max``, and for minimum
the name ``powerstat_package_uncore_frequency_limit_mhz_min``.

.. rubric:: **Per-cpu minimum and maximum frequency**

The application reports the minimum and maximum frequency that each core of the
processor can achieve. It is possible to check the minimum frequency with the
metric name ``linux_cpu_cpuinfo_min_freq`` or ``linux_cpu_scaling_min_freq``,
and maximum with ``linux_cpu_cpuinfo_max_freq`` or
``linux_cpu_scaling_max_freq``.

.. rubric:: **Per-cpu busy frequency**

Busy frequency is the frequency of a core that has a high utilization. (confirm
this later). It is possible to see the busy frequency with the following metric
name ``powerstat_core_cpu_busy_frequency_mhz``.

.. rubric:: **Per-cpu percentage in C-State**

The application can report the time, in percent, that a core of the processor
spent in each c-state. c-State is the state of the core, in which it can reduce
its power consumption, the higher the c-state the higher the sleep state of
the core. We have in the power metrics the following c-states reports:

-   C0 state, in this state, the core is executing normally, it is exposed as
    ``powerstat_core_cpu_c0_state_residency_percent``.

-   C1 state, in this state, the core is active but it's not processing any
    instructions, it can quickly go back to the C0 state, it is exposed as
    ``powerstat_core_cpu_c1_state_residency_percent``.

-   C6 State, in this state the core is with its voltage reduced (or powered
    off). This is the highest state. It takes a longer time to go to C0 state,
    but the power saving is higher. It is exposed as
    ``powerstat_core_cpu_c6_state_residency_percent``.

.. rubric:: **Per-cpu current temperature**

The application reports the current temperature of each individual core from
the processor. The current temperature is exposed as the metric name
``powerstat_core_cpu_temperature_celsius``.

.. rubric:: **Container perf events total**

From cAdvisor it is reported the number of performance events that occurred in
a container, it is exposed as ``container_perf_events_total``.

.. rubric:: **Container perf events scaling ratio**

It also reports the scaling ratio, which calculates the ratio of performance
events in a container, it is exposed as
``container_perf_events_scaling_ration``.

.. rubric:: **Per Core CPU Power usage**

By considering the frequency of each core, gathered by
``powerstat_core_cpu_frequency_mhz`` metric with the amount of power usage of
the processor, gathered by
``powerstat_package_current_power_consumption_watts`` metric, it is possible to
estimate the total amount of power, in watts, that is being used by each core.

Example of formula:

per_cpu_consumption = ((0.6 * powerstat_core_cpu_frequency_mhz{cpu_id=x,
package_id=y})/ ∑ powerstat_core_cpu_frequency_mhz{package_id=y}) *
powerstat_package_current_power_consumption_watts{package_id=y}

.. rubric:: **Container CPU Power usage**

By gathering the number of instructions in each container running on the
cluster, gathered by the ``container_perf_events_total`` metric, with the
corresponding core that they are using, determined by the per core cpu power
usage described above, and the total number of instructions per core, also
available from ``container_perf_events_total metric``, it is possible to
estimate the power that is being consumed by each container.

Example of formula to calculate the power consumption of a container on a core:

container_per_cpu_consumption = (container_perf_events_total{cpu=x,
container=z} / container_perf_events_total {cpu=x}) *
per_cpu_consumption{cpu=x}

Where "X" is the core_id of the cpu, "Y" is the package_id or physical_id of
the processor, and "Z" is the container name.
