
.. _limit-number-of-processes-per-pod:

=================================
Limit Number of Processes per Pod
=================================

Kubernetes supports limiting the number of processes per pod. By default,
|prod| configures Kubernetes with a limit of 10000 pids per pod. Users can
change this setting to suit their deployment.

For general use case of |prod| it is recommended not to use a limit lower
than 500 pids per pod.

If deploying |prod-os| application it is recommended not to use a limit
lower than 2000 pids per pod.

For extended flexibility |prod| allows values between 100 and 65535. Setting
the value to a smaller number helps protect against a larger number of rogue
pods. For example using a value of 10000 limits 1 rogue pods to 10000 pids,
while a value of 500 limits 20 rogue pods to 10000 pids.

If an application needs to create more processes than currently allowed this
limit should be increased. Note that running multiple containers inside the
same pod consumes the pids of the same pod.

|CLI| can be used to query and modify the value.

.. rubric:: |proc|

-   Current value can be retrieved using 'system service-parameter-list
    --service kubernetes' and looking at the 'config' section, parameter named
    'pod_max_pids'.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-list --service kubernetes

        +--------------------------------------+------------+---------+--------------+-------+-------------+----------+
        | uuid                                 | service    | section |  name        | value | personality | resource |
        +--------------------------------------+------------+---------+--------------+-------+-------------+----------+
        | 32751084-d29b-436d-9ffb-4b153e10f5c5 | kubernetes | config  | pod_max_pids | 750   | None        | None     |
        +--------------------------------------+------------+---------+--------------+-------+-------------+----------+

-   Value can be modified using: 'system service-parameter-modify kubernetes
    config pod_pids_limit=<new_value>'.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-modify kubernetes config pod_max_pids=800

        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 32751084-d29b-436d-9ffb-4b153e10f5c5 |
        | service      | kubernetes                           |
        | section      | config                               |
        | name         | pod_max_pids                         |
        | value        | 800                                  |
        | personality  | None                                 |
        | resource     | None                                 |
        +--------------+--------------------------------------+

-   If the value was deleted by mistake, it can be readded using system
    service-parameter-add kubernetes config pod_max_pids=<new_value>.

-   After modifying, controller and worker nodes need to be locked
    and unlocked for the new setting to be applied.