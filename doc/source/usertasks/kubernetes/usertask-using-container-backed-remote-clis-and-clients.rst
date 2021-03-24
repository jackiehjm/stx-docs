
.. vja1605798752774
.. _usertask-using-container-backed-remote-clis-and-clients:

================================
Use Container-backed Remote CLIs
================================

Remote platform :abbr:`CLIs (Command Line Interfaces)` can be used in any shell
after sourcing the generated remote CLI/client RC file. This RC file sets up
the required environment variables and aliases for the remote CLI commands.

.. contents:: The following topics are discussed below:
   :local:
   :depth: 1

.. note::
    Consider adding this command to your .login or shell rc file, such that
    your shells will automatically be initialized with the environment
    variables and aliases for the remote CLI commands.

.. rubric:: |prereq|

You must have completed the configuration steps described in
:ref:`Configuring Container-backed Remote CLIs
<kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients>`
before proceeding.

.. rubric:: |proc|

*******************************
Kubernetes kubectl CLI commands
*******************************

.. note::
    The first usage of a remote CLI command will be slow as it requires
    that the docker image supporting the remote CLIs/clients be pulled from
    the remote registry.

.. code-block:: none

    root@myclient:/home/user/remote_wd# source remote_client_platform.sh
    Please enter your OpenStack Password for project tenant1 as user user1:

    root@myclient:/home/user/remote_wd# kubectl -n kube-system get pods
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
    root@myclient:/home/user/remote_wd#

.. note::
    Some CLI commands are designed to leave you in a shell prompt, for
    example:

    .. code-block:: none

        root@myclient:/home/user/remote_wd# openstack

    or

    .. code-block:: none

        root@myclient:/home/user/remote_wd# kubectl exec -ti <pod_name> -- /bin/bash

    In most cases, the remote CLI will detect and handle these commands
    correctly. If you encounter cases that are not handled correctly, you
    can force-enable or disable the shell options using the <FORCE\_SHELL>
    or <FORCE\_NO\_SHELL> variables before the command.

    For example:

    .. code-block:: none

        root@myclient:/home/user/remote_wd# FORCE_SHELL=true kubectl exec -ti <pod_name> -- /bin/bash
        root@myclient:/home/user/remote_wd# FORCE_NO_SHELL=true kubectl exec <pod_name> -- ls

    You cannot use both variables at the same time.

************************************
Remote CLI commands with local files
************************************

If you need to run a remote CLI command that references a local file, then
that file must be copied to or created in the working directory specified
in the ``-w`` option on the ./config\_client.sh command.

For example:

#.  If you have not already done so, source the remote\_client\_platform.sh
    file.

    .. code-block:: none

        root@myclient:/home/user/remote_wd# source remote_client_platform.sh

#.  Copy the file local file and run the remote command.

    .. code-block:: none

        root@myclient:/home/user# cp /<someDir>/test.yml $HOME/remote_cli_wd/test.yml
        root@myclient:/home/user# cd $HOME/remote_cli_wd
        root@myclient:/home/user/remote_cli_wd# kubectl -n kube-system  create -f test.yml
        pod/test-pod created
        root@myclient:/home/user/remote_cli_wd# kubectl -n kube-system  delete -f test.yml
        pod/test-pod deleted

****
Helm
****

Do the following to use helm.

..  xreflink   .. note::
        For non-admin users, additional configuration is required first as
        discussed in |sec-doc|: :ref:`Configuring Remote Helm Client for
        Non-Admin Users <configuring-remote-helm-client-for-non-admin-users>`.

.. note::
    When using helm, any command that requires access to a helm repository
    \(managed locally\) will require that you be in the
    $HOME/remote\_cli\_wd directory and use the ``--home "./.helm"`` option.

#.  Do the initial set-up of the helm client.

    #. If you have not already done so, source the remote\_client\_platform.sh
       file.

       .. code-block:: none

          % source remote_client_platform.sh

    #. Complete the initial set-up.

       .. code-block:: none

          % cd $HOME/remote_cli_wd
          % helm init --client-only --home "./.helm"

#.  Run a helm command.

    #. If you have not already done so, source the remote\_client\_platform.sh
       file.

       .. code-block:: none

          % source remote_client_platform.sh

    #. Run a helm command. This example installs WordPress.

       .. code-block:: none

          % cd $HOME/remote_cli_wd
          % helm list
          % helm install --name wordpress stable/wordpress  --home "./.helm"

