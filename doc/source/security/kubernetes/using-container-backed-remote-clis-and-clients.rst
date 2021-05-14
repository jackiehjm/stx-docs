
.. sso1605707703320
.. _using-container-backed-remote-clis-and-clients:

============================================
Use Container-backed Remote CLIs and Clients
============================================

Remote platform |CLIs| can be used in any shell after sourcing the generated
remote CLI/client RC file. This RC file sets up the required environment
variables and aliases for the remote |CLI| commands.

.. rubric:: |prereq|

.. _using-container-backed-remote-clis-and-clients-ul-vcd-4rf-14b:

-   Consider adding the following command to your .login or shell rc file, such
    that your shells will automatically be initialized with the environment
    variables and aliases for the remote |CLI| commands. Otherwise, execute it
    before proceeding:

    .. code-block:: none

        root@myclient:/home/user/remote_cli_wd# source remote_client_platform.sh

-   You must have completed the configuration steps described in
    :ref:`Configuring Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`
    before proceeding.

-   If you specified repositories that require authentication when configuring
    the container-backed remote |CLIs|, you must perform a :command:`docker
    login` to that repository before using remote |CLIs| for the first time

.. rubric:: |proc|

-   For simple StarlingX :command:`system` |CLI| and Kubernetes
    :command:`kubectl` |CLI| commands:

    .. note::
        The first usage of a remote |CLI| command will be slow as it requires
        that the docker image supporting the remote CLIs/clients be pulled from
        the remote registry.

    .. code-block:: none

        Please enter your OpenStack Password for project admin as user admin:
        root@myclient:/home/user/remote_cli_wd# system host-list
        +----+--------------+-------------+----------------+-------------+--------------+
        | id | hostname     | personality | administrative | operational | availability |
        +----+--------------+-------------+----------------+-------------+--------------+
        | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
        | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
        | 3  | compute-0    | worker      | unlocked       | enabled     | available    |
        | 4  | compute-1    | worker      | unlocked       | enabled     | available    |
        +----+--------------+-------------+----------------+-------------+--------------+
        root@myclient:/home/user/remote_cli_wd# kubectl -n kube-system get pods
        NAME                                       READY   STATUS      RESTARTS   AGE
        calico-kube-controllers-767467f9cf-wtvmr   1/1     Running     1          3d2h
        calico-node-j544l                          1/1     Running     1          3d
        calico-node-ngmxt                          1/1     Running     1          3d1h
        calico-node-qtc99                          1/1     Running     1          3d
        calico-node-x7btl                          1/1     Running     4          3d2h
        ceph-pools-audit-1569848400-rrpjq          0/1     Completed   0          12m
        ceph-pools-audit-1569848700-jhv5n          0/1     Completed   0          7m26s
        ceph-pools-audit-1569849000-cb988          0/1     Completed   0          2m25s
        coredns-7cf476b5c8-5x724                   1/1     Running     1          3d2h
        ...
        root@myclient:/home/user/remote_cli_wd#

    .. note::
        Some |CLI| commands are designed to leave you in a shell prompt, for example:

        .. code-block:: none

            root@myclient:/home/user/remote_cli_wd# openstack

        or

        .. code-block:: none

            root@myclient:/home/user/remote_cli_wd# kubectl exec -ti <pod_name> -- /bin/bash

        In most cases, the remote |CLI| will detect and handle these commands
        correctly. If you encounter cases that are not handled correctly, you
        can force-enable or disable the shell options using the <FORCE\_SHELL>
        or <FORCE\_NO\_SHELL> variables before the command.

        For example:

        .. code-block:: none

            root@myclient:/home/user/remote_cli_wd# FORCE_SHELL=true kubectl exec -ti <pod_name> -- /bin/bash
            root@myclient:/home/user/remote_cli_wd# FORCE_NO_SHELL=true kubectl exec <pod_name> -- ls

        You cannot use both variables at the same time.

-   If you need to run a remote |CLI| command that references a local file,
    then that file must be copied to or created in the working directory
    specified in the -w option on the ./config\_client.sh command.

    For example:

    .. code-block:: none

        root@myclient:/home/user# cp /<someDir>/test.yml $HOME/remote_cli_wd/test.yml
        root@myclient:/home/user# cd $HOME/remote_cli_wd
        root@myclient:/home/user/remote_cli_wd# kubectl -n kube-system  create -f test.yml
        pod/test-pod created
        root@myclient:/home/user/remote_cli_wd# kubectl -n kube-system  delete -f test.yml
        pod/test-pod deleted

-   Do the following to use helm.

    .. note::
        For non-admin users, additional configuration is required first as
        discussed in :ref:`Configuring Remote Helm Client for Non-Admin Users
        <configure-remote-helm-client-for-non-admin-users>`.

    .. note::
        When using helm, any command that requires access to a helm repository
        \(managed locally\) will require that you be in the
        $HOME/remote\_cli\_wd directory and use the --home ./.helm option.


    #.  Do the initial setup of the helm client.

        .. note::
            This command assumes you are using Helm v2.

        .. code-block:: none

            % cd $HOME/remote_cli_wd
            % helm init --client-only --home "./.helm"

    #.  Run a helm command.

        .. code-block:: none

            % cd $HOME/remote_cli_wd
            % helm list
            % helm install --name wordpress stable/wordpress  --home "./.helm"



**Related information**

.. seealso::

    :ref:`Configuring Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Installing Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

    :ref:`Configuring Remote Helm Client for Non-Admin Users
    <configure-remote-helm-client-for-non-admin-users>`

