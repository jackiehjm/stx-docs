
.. fda1581955005891
.. _security-configure-container-backed-remote-clis-and-clients:

==================================================
Configure Container-backed Remote CLIs and Clients
==================================================

The |prod| command lines can be accessed from remote computers running Linux,
MacOS, and Windows.

.. rubric:: |context|

This functionality is made available using a docker container with
pre-installed CLIs and clients. The container's image is pulled as required by
the remote CLI/client configuration scripts.

.. rubric:: |prereq|

You must have Docker installed on the remote systems you connect from. For
more information on installing Docker, see
`https://docs.docker.com/install/ <https://docs.docker.com/install/>`__.
For Windows remote clients, Docker is only supported on Windows 10.

.. note::
    You must be able to run docker commands using one of the following options:

    .. _security-configure-container-backed-remote-clis-and-clients-d70e42:

    - Running the scripts using sudo

    - Adding the Linux user to the docker group


    For more information, see,
    `https://docs.docker.com/engine/install/linux-postinstall/
    <https://docs.docker.com/engine/install/linux-postinstall/>`__


For Windows remote clients, you must run the following commands from a
Cygwin terminal. See `https://www.cygwin.com/ <https://www.cygwin.com/>`__
for more information about the Cygwin project.

For Windows remote clients, you must also have :command:`winpty` installed.
Download the latest release tarball for Cygwin from
`https://github.com/rprichard/winpty/releases
<https://github.com/rprichard/winpty/releases>`__. After downloading the
tarball, extract it to any location and change the Windows <PATH> variable
to include its bin folder from the extracted winpty folder.

The following procedure shows how to configure the Container-backed Remote CLIs
and Clients for an admin user with cluster-admin clusterrole. If using a
non-admin user such as one with privileges only within a private namespace,
additional configuration is required in order to use :command:`helm`.
The following procedure shows how to configure the Container-backed Remote
CLIs and Clients for an admin user with cluster-admin clusterrole.

.. rubric:: |proc|


.. _security-configure-container-backed-remote-clis-and-clients-d70e93:

#.  On the Controller, configure a Kubernetes service account for users on the
    remote client.

    You must configure a Kubernetes service account on the target system
    and generate a configuration file based on that service account.

    Run the following commands logged in as **sysadmin** on the local console
    of the controller.


    #.  Source the platform environment

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$


    #.  Set environment variables.

        You can customize the service account name and the output
        configuration file by changing the <USER> and <OUTPUT\_FILE>
        variables shown in the following examples.

        .. code-block:: none

            ~(keystone_admin)]$ USER="admin-user"
            ~(keystone_admin)]$ OUTPUT_FILE="admin-kubeconfig"

    #.  Create an account definition file.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > admin-login.yaml
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

            ~(keystone_admin)]$ kubectl apply -f admin-login.yaml

    #.  Store the token value.

        .. code-block:: none

            ~(keystone_admin)]$ TOKEN_DATA=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep ${USER} | awk '{print $1}') | grep "token:" | awk '{print $2}')

    #.  Store the |OAM| IP address.


        #.  .. code-block:: none

			~(keystone_admin)]$ OAM_IP=$(system oam-show |grep oam_floating_ip| awk '{print $4}')

        #.  |AIO-SX| uses <oam\_ip> instead of <oam\_floating\_ip>. The
            following shell code ensures that <OAM\_IP> is assigned the correct
            IP address.

            .. code-block:: none

                ~(keystone_admin)]$ if [ -z "$OAM_IP" ]; then
                    OAM_IP=$(system oam-show |grep oam_ip| awk '{print $4}')
                fi


        #.  IPv6 addresses must be enclosed in square brackets. The following
            shell code does this for you.

            .. code-block:: none

                ~(keystone_admin)]$ if [[ $OAM_IP =~ .*:.* ]]; then
                    OAM_IP="[${OAM_IP}]"
                fi

    #.  Change the permission to be readable.

        .. code-block:: none

            ~(keystone_admin)]$ sudo chown sysadmin:sys_protected ${OUTPUT_FILE}
                sudo chmod 644 ${OUTPUT_FILE}

    #.  Generate the admin-kubeconfig file.

        .. code-block:: none

            ~(keystone_admin)]$ sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-cluster wrcp-cluster --server=https://${OAM_IP}:6443 --insecure-skip-tls-verify
            ~(keystone_admin)]$ sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-credentials ${USER} --token=$TOKEN_DATA
            ~(keystone_admin)]$ sudo kubectl config --kubeconfig ${OUTPUT_FILE} set-context ${USER}@wrcp-cluster --cluster=wrcp-cluster --user ${USER} --namespace=default
            ~(keystone_admin)]$ sudo kubectl config --kubeconfig ${OUTPUT_FILE} use-context ${USER}@wrcp-cluster

#.  Copy the remote client tarball file from the |prod| build servers
    to the remote workstation, and extract its content.


    -   The tarball is available from the |prod| area on the |prod| CENGEN build servers.

    -   You can extract the tarball's contents anywhere on your client system.


    .. parsed-literal::

        $ cd $HOME
        $ tar xvf |prefix|-remote-clients-<version>.tgz

#.  Download the  user/tenant openrc file from the Horizon Web interface to the
    remote workstation.


    #.  Log in to Horizon as the user and tenant that you want to configure remote access for.

        In this example, the 'admin' user in the 'admin' tenant.

    #.  Navigate to **Project** \> **API Access** \> **Download Openstack RC file**.

    #.  Select **Openstack RC file**.

        The file admin-openrc.sh downloads.

    .. note::

        For a Distributed Cloud system, navigate to **Project** \> **Central Cloud Regions** \> **RegionOne** \>
        and download the **Openstack RC file**.

#.  If HTTPS has been enabled for the |prod| RESTAPI Endpoints on your
    |prod| system, add the following line to the bottom of admin-openrc.sh:

    .. code-block:: none

        OS_CACERT=<path_to_ca_>

    where ``<path_to_ca>`` is the full filename of the PEM file for the CA
    Certificate that signed the |prod| REST APIs Endpoint Certificate.
    Copy the file ``admin-openrc.sh`` to the remote workstation. This example
    assumes it is copied to the location of the extracted tarball.

#.  Copy the admin-kubeconfig file to the remote workstation.

    You can copy the file to any location on the remote workstation. This
    example assumes that it is copied to the location of the extracted tarball.

#.  On the remote workstation, configure remote CLI/client access.

    This step will also generate a remote CLI/client RC file.

    #.  Change to the location of the extracted tarball.

        .. parsed-literal::

            $ cd $HOME/|prefix|-remote-clients-<version>/

    #.  Create a working directory that will be mounted by the container
        implementing the remote |CLIs|.

        See the description of the :command:`configure\_client.sh` -w option
        :ref:`below
        <security-configure-container-backed-remote-clis-and-clients>`
        for more details.

        .. code-block:: none

            $ mkdir -p $HOME/remote_cli_wd


    #.  Run the :command:`configure_client.sh` script.

        .. parsed-literal::

            $ ./configure_client.sh -t platform -r admin_openrc.sh -k admin-kubeconfig -w $HOME/remote_cli_wd -p <wind-river-registry-url>/docker.io/starlingx/stx-platformclients:stx.8.0-v1.5.9

        If you specify repositories that require authentication, as shown
        above, you must first perform a :command:`docker login` to that
        repository before using remote |CLIs|. WRS |AWS| ECR credentials or a
        |CA| certificate is required.

        The options for configure\_client.sh are:

    ``-t``
        The type of client configuration. The options are platform \(for
        |prod-long| |CLI| and clients\) and openstack \(for |prod-os| application
        |CLI| and clients\).

        The default value is platform.

    ``-r``
        The user/tenant RC file to use for :command:`openstack` CLI commands.

        The default value is admin-openrc.sh.

    ``-k``
        The kubernetes configuration file to use for :command:`kubectl` and :command:`helm` CLI commands.

        The default value is temp-kubeconfig.

    ``-o``
        The remote CLI/client RC file generated by this script.

        This RC file needs to be sourced in the shell, to setup required
        environment variables and aliases, before running any remote |CLI|
        commands.

        For the platform client setup, the default is
        remote\_client\_platform.sh. For the openstack application client
        setup, the default is remote\_client\_app.sh.

    ``-w``
        The working directory that will be mounted by the container
        implementing the remote |CLIs|. When using the remote |CLIs|, any files
        passed as arguments to the remote |CLI| commands need to be in this
        directory in order for the container to access the files. The default
        value is the directory from which the :command:`configure\_client.sh`
        command was run.

    ``-p``
        Override the container image for the platform |CLI| and clients.

        By default, the platform |CLIs| and clients container image is pulled
        from docker.io/starlingx/stx-platformclients.

        For example, to use the container images from the WRS AWS ECR:

        .. parsed-literal::

            $ ./configure_client.sh -t platform -r admin_openrc.sh -k admin-kubeconfig -w $HOME/remote_cli_wd -p <wind-river-registry-url>/docker.io/starlingx/stx-platformclients:stx.8.0-v1.5.9

        If you specify repositories that require authentication, you must first
        perform a :command:`docker login` to that repository before using
        remote |CLIs|.

    ``-a``
        Override the OpenStack application image.

        By default, the OpenStack |CLIs| and clients container image is pulled
        from docker.io/starlingx/stx-openstackclients.

    The :command:`configure-client.sh` command will generate a remote\_client\_platform.sh RC file. This RC file needs to be sourced in the shell to set up required environment variables and aliases before any remote CLI commands can be run.

#.  Copy the file remote\_client\_platform.sh to $HOME/remote\_cli\_wd

.. rubric:: |postreq|

After configuring the platform's container-backed remote CLIs/clients, the
remote platform CLIs can be used in any shell after sourcing the generated
remote CLI/client RC file. This RC file sets up the required environment
variables and aliases for the remote |CLI| commands.

.. note::
    Consider adding this command to your .login or shell rc file, such
    that your shells will automatically be initialized with the environment
    variables and aliases for the remote |CLI| commands.

See :ref:`Using Container-backed Remote CLIs and Clients <using-container-backed-remote-clis-and-clients>` for details.

**Related information**

.. seealso::

    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-backed-remote-clis-and-clients>`

    :ref:`Install Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

    :ref:`Configure Remote Helm v2 Client
    <configure-remote-helm-client-for-non-admin-users>`

