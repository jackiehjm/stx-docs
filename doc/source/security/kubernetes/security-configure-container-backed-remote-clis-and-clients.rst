
.. fda1581955005891
.. _security-configure-container-backed-remote-clis-and-clients:

==================================================
Configure Container-backed Remote CLIs and Clients
==================================================

The command line can be accessed from remote computers running Linux, OSX,
and Windows.

.. rubric:: |context|

This functionality is made available using a docker image for connecting to
the |prod| remotely. This docker image is pulled as required by
configuration scripts.

.. rubric:: |prereq|

You must have Docker installed on the remote systems you connect from. For
more information on installing Docker, see
`https://docs.docker.com/install/ <https://docs.docker.com/install/>`__.
For Windows remote clients, Docker is only supported on Windows 10.

For Windows remote clients, you must run the following commands from a
Cygwin terminal. See `https://www.cygwin.com/ <https://www.cygwin.com/>`__
for more information about the Cygwin project.

For Windows remote clients, you must also have :command:`winpty` installed.
Download the latest release tarball for Cygwin from
`https://github.com/rprichard/winpty/releases
<https://github.com/rprichard/winpty/releases>`__. After downloading the
tarball, extract it to any location and change the Windows <PATH> variable
to include its bin folder from the extracted winpty folder.

The following procedure shows how to configure the Container-backed Remote
CLIs and Clients for an admin user with cluster-admin clusterrole. If using
a non-admin user such as one with role privileges only within a private
namespace, additional configuration is required in order to use
:command:`helm`.

.. rubric:: |proc|


.. _security-configure-container-backed-remote-clis-and-clients-d70e74:

#.  On the Controller, configure a Kubernetes service account for user on the remote client.

    You must configure a Kubernetes service account on the target system
    and generate a configuration file based on that service account.

    Run the following commands logged in as **root** on the local console of the controller.


    #.  Set environment variables.

        You can customize the service account name and the output
        configuration file by changing the <USER> and <OUTPUT\_FILE>
        variables shown in the following examples.

        .. code-block:: none

            % USER="admin-user"
            % OUTPUT_FILE="temp-kubeconfig"

    #.  Create an account definition file.

        .. code-block:: none

            % cat <<EOF > admin-login.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: ${USER}
              namespace: kube-system
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: ClusterRoleBinding
            metadata:
              name: admin-user
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: ClusterRole
              name: cluster-admin
            subjects:
            - kind: ServiceAccount
              name: ${USER}
              namespace: kube-system
            EOF

    #.  Apply the definition.

        .. code-block:: none

            % kubectl apply -f admin-login.yaml

    #.  Store the token value.

        .. code-block:: none

            % TOKEN_DATA=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep ${USER} | awk '{print $1}') | grep "token:" | awk '{print $2}')

    #.  Source the platform environment.

        .. code-block:: none

            % source /etc/platform/openrc

    #.  Store the OAM IP address.


        1.  .. code-block:: none

			% OAM_IP=$(system oam-show |grep oam_floating_ip| awk '{print $4}')

        2.  AIO-SX uses <oam\_ip> instead of <oam\_floating\_ip>. The
            following shell code ensures that <OAM\_IP> is assigned the correct
            IP address.

            .. code-block:: none

                % if [ -z "$OAM_IP" ]; then
                    OAM_IP=$(system oam-show |grep oam_ip| awk '{print $4}')
                fi


        3.  IPv6 addresses must be enclosed in square brackets. The following shell code does this for you.

            .. code-block:: none

                % if [[ $OAM_IP =~ .*:.* ]]; then
                    OAM_IP="[${OAM_IP}]"
                fi



    #.  Generate the temp-kubeconfig file.

        .. code-block:: none

            % sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-cluster wrcp-cluster --server=https://${OAM_IP}:6443 --insecure-skip-tls-verify
            % sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-credentials ${USER} --token=$TOKEN_DATA
            % sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-context ${USER}@wrcp-cluster --cluster=wrcp-cluster --user ${USER} --namespace=default
            % sudo kubectl config --kubeconfig ${OUTPUT_FILE} use-context ${USER}@wrcp-cluster

#.  On the remote client, install the remote client tarball file from the
    StarlingX CENGEN build servers..


    -   The tarball is available from the |prod| area on the StarlingX CENGEN build servers.

    -   You can extract the tarball's contents anywhere on your client system.


    While it is not strictly required to extract the tarball before other
    steps, subsequent steps in this example copy files to the extracted
    directories as a convenience when running configuration scripts.

#.  Download the openrc file from the Horizon Web interface to the remote client.


    #.  Log in to Horizon as the user and tenant that you want to configure remote access for.

    #.  Navigate to **Project** \> **API Access** \> **Download Openstack RC file**.

    #.  Select **Openstack RC file**.


#.  Copy the temp-kubeconfig file to the remote workstation.

    You can copy the file to any location on the remote workstation. For
    convenience, this example assumes that it is copied to the location of
    the extracted tarball.

    .. note::
        Ensure the temp-kubeconfig file has 666 permissions after copying
        the file to the remote workstation, otherwise, use the following
        command to change permissions, :command:`chmod 666 temp\_kubeconfig`.

#.  On the remote client, configure the client access.


    #.  Change to the location of the extracted tarball.

    #.  Run the :command:`configure\_client.sh` script to generate a client access file for the platform.

        .. note::
            For remote CLI commands that require local filesystem access,
            you can specify a working directory when running
            :command:`configure\_client.sh` using the -w option. If no
            directory is specified, the location from which the
            :command:`configure\_client.sh` was run is used for local file
            access by remote cli commands. This working directory is
            mounted at /wd in the docker container. If remote CLI commands
            need access to local files, copy the files to your configured
            work directory and then provide the command with the path to
            the mounted folder inside the container.

        .. code-block:: none

            $ mkdir -p $HOME/remote_wd
            $ ./configure_client.sh -t platform -r admin_openrc.sh -k temp-kubeconfig \
            -w HOME/remote_wd
            $ cd $HOME/remote_wd

        By default, configure\_client.sh will use container images from
        docker.io for both platform clients and openstack clients. You can
        optionally use the -p and -a options to override the default docker
        with one or two others from a custom registry. For example, to use
        the container images from the WRS AWS ECR

        .. code-block:: none

            $ ./configure_client.sh -t platform -r admin_openrc.sh -k
            temp-kubeconfig -w HOME/remote_wd -p
            625619392498.dkr.ecr.us-west-2.amazonaws.com/starlingx/stx-platfo
            rmclients:stx.4.0-v1.3.0  -a
            625619392498.dkr.ecr.us-west-2.amazonaws.com/starlingx/stx-openst
            ackclients:master-centos-stable-latest

        If you are working with repositories that require authentication,
        you must first perform a :command:`docker login` to that repository
        before using remote clients.

        A remote\_client\_platform.sh file is generated for use accessing the platform CLI.


#.  Test workstation access to the remote platform CLI.

    Enter your platform password when prompted.

    .. note::
        The first usage of a command will be slow as it requires that the
        docker image supporting the remote clients be pulled from the
        remote registry.

    .. code-block:: none

        root@myclient:/home/user/remote_wd# source remote_client_platform.sh
        Please enter your OpenStack Password for project admin as user admin:
        root@myclient:/home/user/remote_wd# system host-list
        +----+--------------+-------------+----------------+-------------+--------------+
        | id | hostname     | personality | administrative | operational | availability |
        +----+--------------+-------------+----------------+-------------+--------------+
        | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
        | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
        | 3  | compute-0    | worker      | unlocked       | enabled     | available    |
        | 4  | compute-1    | worker      | unlocked       | enabled     | available    |
        +----+--------------+-------------+----------------+-------------+--------------+
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
        Some commands used by remote CLI are designed to leave you in a shell prompt, for example:

        .. code-block:: none

            root@myclient:/home/user/remote_wd# openstack

        or

        .. code-block:: none

            root@myclient:/home/user/remote_wd# kubectl exec -ti <pod_name> -- /bin/bash

        In some cases the mechanism for identifying commands that should
        leave you at a shell prompt does not identify them correctly. If
        you encounter such scenarios, you can force-enable or disable the
        shell options using the <FORCE\_SHELL> or <FORCE\_NO\_SHELL>
        variables before the command.

        For example:

        .. code-block:: none

            root@myclient:/home/user/remote_wd# FORCE_SHELL=true kubectl exec -ti <pod_name> -- /bin/bash
            root@myclient:/home/user/remote_wd# FORCE_NO_SHELL=true kubectl exec <pod_name> -- ls

        You cannot use both variables at the same time.

#.  If you need to run a remote CLI command that references a local file,
    then that file must be copied to or created in the working directory
    specified on the ./config\_client.sh command and referenced as under /wd/
    in the actual command.

    For example:

    .. code-block:: none

        root@myclient:/home/user# cd $HOME/remote_wd
        root@myclient:/home/user/remote_wd# kubectl -n kube-system  create -f test/test.yml
        pod/test-pod created
        root@myclient:/home/user/remote_wd# kubectl -n kube-system  delete -f test/test.yml
        pod/test-pod deleted

#.  Do the following to use helm.

    .. note::
        For non-admin users, additional configuration is required first as
        discussed in *Configure Remote Helm Client for Non-Admin Users*.

    .. note::
        When using helm, any command that requires access to a helm
        repository \(managed locally\) will require that you be in the
        $HOME/remote\_wd directory and use the --home ./helm option.


    #.  Do the initial setup of the helm client.

        .. code-block:: none

            % helm init --client-only --home "./.helm"

    #.  Run a helm command.

        .. code-block:: none

            $ helm list
            $ helm install --name wordpress stable/wordpress  --home "./helm"



.. seealso::

    :ref:`Install Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

    :ref:`Configure Remote Helm Client for Non-Admin Users
    <configure-remote-helm-client-for-non-admin-users>`

