
.. jme1561551450093
.. _installing-and-running-cpu-manager-for-kubernetes:

==========================================
Install and Run CPU Manager for Kubernetes
==========================================

You must install Helm charts and label worker nodes appropriately before using
CMK.

.. rubric:: |context|

Perform the following steps to enable CMK on a cluster.

.. rubric:: |proc|

#.  Apply the **cmk-node** label to each worker node to be managed using CMK.

    For example:

    .. code-block:: none

        ~(keystone)admin)$ system host-lock worker-0
        ~(keystone)admin)$ system host-label-assign worker-0 cmk-node=enabled
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | uuid        | 2909d775-cd6c-4bc1-8268-27499fe38d5e |
        | host_uuid   | 1f00d8a4-f520-41ee-b608-1b50054b1cd8 |
        | label_key   | cmk-node                             |
        | label_value | enabled                              |
        +-------------+--------------------------------------+
        ~(keystone)admin)$ system host-unlock worker-0

#.  Perform the following steps if you have not specified CMK at Ansible
    Bootstrap in the localhost.yml file:

    #.  On the active controller, run the following command to generate the
        username and password to be used for Docker login.

        This command generates the username and password to be used for Docker
        login.

        .. code-block:: none

            $ sudo python /usr/share/ansible/stx-ansible/playbooks/roles/common/push-docker-images/files/get_registry_auth.py 625619392498.dkr.ecr.us-west-2.amazonaws.com <Access_Key_ID_from_Wind_Share> <Secret_Access_Key_from_Wind_Share>

    #.  Run the Docker login command:

        .. code-block:: none

            ~(keystone)admin)$ sudo docker login 625619392498.dkr.ecr.us-west-2.amazonaws.com -u AWS -p <password_returned_from_first_cmd>

    #.  Pull the CMK image from the AWS registry.

        .. code-block:: none

            ~(keystone)admin)$ sudo docker pull 625619392498.dkr.ecr.us-west-2.amazonaws.com/docker.io/wind-river/cmk:WRCP.20.01-v1.3.1-15-ge3df769-1

    #.  Tag the image, by using the following command:

        .. code-block:: none

            ~(keystone)admin)$ sudo docker image tag 625619392498.dkr.ecr.us-west-2.amazonaws.com/docker.io/wind-river/cmk:WRCP.20.01-v1.3.1-15-ge3df769-1 registry.local:9001/docker.io/wind-river/cmk:WRCP.20.01-v1.3.1-15-ge3df769-1

    #.  Authenticate the local registry, by using the following command:

        .. code-block:: none

            ~(keystone)admin)$ sudo docker login registry.local:9001 -u admin -p <admin_passwd>

    #.  Push the image, by using the following command:

        .. code-block:: none

            ~(keystone)admin)$ sudo docker image push registry.local:9001/docker.io/wind-river/cmk:WRCP.20.01-v1.3.1-15-ge3df769-1


#.  On all configurations with two controllers, after the CMK Docker image has
    been pulled, tagged \(with the local registry\), and pushed \(to the local
    registry\), the admin user should log in to the inactive controller and run
    the following commands:

    For example:

    .. code-block:: none

        ~(keystone)admin)$ sudo docker login registry.local:9001 -u admin -p <admin_passwd>
        ~(keystone)admin)$ sudo docker image pull tis-lab-registry.cumulus.wrs.com:9001/wrcp-staging/docker.io/wind-river/cmk:WRCP.20.01-v1.3.1-15-ge3df769-1

#.  Configure any isolated CPUs on worker nodes in order to reduce host OS
    impacts on latency for tasks running on Isolated CPUs.

    Any container tasks running on isolated CPUs will have to explicitly manage
    their own affinity, the process scheduler will ignore them completely.

    .. note::
        The following commands are examples only, the admin user must specify
        the number of CPUs per processor based on the node CPU topology.

    .. code-block:: none

        ~(keystone)admin)$ system host-lock worker-1
        ~(keystone)admin)$ system host-cpu-modify  -f platform -p0 1 worker-1
        ~(keystone)admin)$ system host-cpu-modify  -f application-isolated -p0 15 worker-1
        ~(keystone)admin)$ system host-cpu-modify  -f application-isolated -p1 15 worker-1
        ~(keystone)admin)$ system host-unlock worker-1

    This sets one platform core and 15 application-isolated cores on NUMA node
    0, and 15 application-isolated cores on NUMA node 1. At least one CPU must
    be left unspecified, which will cause it to be an application CPU.

#.  Run the /opt/extracharts/cpu-manager-k8s-setup.sh helper script to install
    the CMK Helm charts used to configure the system for CMK.

    #.  Before running this command, untar files listed in /opt/extracharts.

        .. code-block:: none

            ~(keystone)admin)$ cd /opt/extracharts
            ~(keystone)admin)$ sudo tar -xvf cpu-manager-k8s-init-1.3.1.tgz
            ~(keystone)admin)$ sudo tar -xvf cpu-manager-k8s-webhook-1.3.1.tgz
            ~(keystone)admin)$ sudo tar -xvf cpu-manager-k8s-1.3.1.tgz

    #.  Run the script.

        The script is located in the /opt/extracharts directory of the active
        controller.

        For example:

        .. code-block:: none

            ~(keystone)admin)$ cd /opt/extracharts
            ~(keystone)admin)$ ./cpu-manager-k8s-setup.sh

        The following actions are performed:

        -   The **cpu-manager-k8s-init** chart is installed. This will create a
            service account and set up rules-based access control.

        -   A webhook is created to insert the appropriate resources into pods
            that request CMK resources. \(This will result in one pod running.\)

        -   A daemonset is created for the per-CMK-node pod that will handle
            all CMK operations on that node.

        -   **cmk-webhook-deployment** is launched on the controller and
            **cpu-manager-k8s-cmk-default** is launched on the worker.

        By default, each node will have one available CPU allocated to the
        shared pool, and all the rest allocated to the exclusive pool. The
        platform CPUs will be ignored.

#.  Add more CPUs to the shared pool.

    #.  Override the allocation via per-node Helm chart overrides on the
        **cpu-manager-k8s** Helm chart.

        .. code-block:: none

            $ cat <<EOF > /home/sysadmin/worker-0-cmk-overrides.yml
            # For NUM_EXCLUSIVE_CORES a value of -1 means
            # "all available cores after infra and shared
            # cores have been allocated".
            # NUM_SHARED_CORES must be at least 1.
            conf:
              cmk:
                NUM_EXCLUSIVE_CORES: -1
                NUM_SHARED_CORES: 1
              overrides:
                cpu-manager-k8s_cmk:
                  hosts:
                  - name: worker-0
                    conf:
                      cmk:
                        NUM_SHARED_CORES: 2
            EOF

    #.  Apply the override.

        .. code-block:: none

            $ helm upgrade cpu-manager cpu-manager-k8s --reuse-values -f /home/sysadmin/worker-0-cmk-overrides.yml

#.  After CMK has been installed, run the following command to patch the
    webhook to pull the image, if required for future use:

    .. code-block:: none

        ~(keystone)admin)$ kubectl -n kube-system patch deploy cmk-webhook-deployment \
        -p '{"spec":{"template":{"spec":{"containers":[{"name":"cmk-webhook",\
        "imagePullPolicy":"IfNotPresent"}]}}}}'

.. rubric:: |postreq|

Once CMK is set up, you can run workloads as described at `https://github.com/intel/CPU-Manager-for-Kubernetes <https://github.com/intel/CPU-Manager-for-Kubernetes>`__,
with the following caveats:

-   When using CMK, the application pods should not specify requests or limits
    for the **cpu** resource.

    When running a container with :command:`cmk isolate --pool=exclusive`, the
    **cpu** resource should be superseded by the
    :command:`cmk.intel.com/exclusive-cores` resource.

    When running a container with :command:`cmk isolate --pool=shared` or
    :command:`cmk isolate --pool=infra`, the **cpu** resource has no meaning as
    Kubelet assumes it has access to all the CPUs rather than just the
    **infra** or **shared** ones and this confuses the resource tracking.

-   There is a known issue with resource tracking if a node with running
    CMK-isolated applications suffers an uncontrolled reboot. The suggested
    workaround is to wait for it to come back up, then lock/unlock the node.

-   When using the :command:`cmk isolate --socket-id` command to run an
    application on a particular socket, there can be complications with
    scheduling because the Kubernetes scheduler isn't NUMA-aware. A pod can be
    scheduled to a kubernetes node that has enough resources across all NUMA
    nodes, but then a container trying to run :command:`cmk isolate --socket-id=<X>`
    can lead to a run-time error if there are not enough resources on that
    particular NUMA node:

    .. code-block:: none

        ~(keystone)admin)$ kubectl logs cmk-isolate-pod
        [6] Failed to execute script cmk
        Traceback (most recent call last):
          File "cmk.py", line 162, in <module>     main()
          File "cmk.py", line 127, in main     args["--socket-id"])
          File "intel/isolate.py", line 57, in isolate.format(pool_name))
        SystemError: Not enough free cpu lists in pool

.. From step 1
.. xbooklink For more information on node labeling, see |node-doc|: :ref:`Configure Node Labels from the CLI <assigning-node-labels-from-the-cli>`.

.. From step 2
.. xreflink For more information, see |inst-doc|: :ref:`Bootstrap and Deploy Cloud Platform <bootstrapping-and-deploying-starlingx>`.