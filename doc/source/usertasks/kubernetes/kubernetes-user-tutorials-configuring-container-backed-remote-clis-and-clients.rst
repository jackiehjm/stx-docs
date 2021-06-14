
.. dyp1581949325894
.. _kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients:

======================================
Configure Container-backed Remote CLIs
======================================

The |prod| command lines can be accessed from remote computers running
Linux, MacOS, and Windows.

.. rubric:: |context|

This functionality is made available using a docker container with
pre-installed |CLIs| and clients. The container's image is pulled as required
by the remote CLI/client configuration scripts.

.. rubric:: |prereq|

.. _kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients-ul-ev3-bfq-nlb:

-   You must have Docker installed on the remote systems you connect from. For
    more information on installing Docker, see
    `https://docs.docker.com/install/ <https://docs.docker.com/install/>`__.
    For Windows remote workstations, Docker is only supported on Windows 10.

    .. note::
        You must be able to run docker commands using one of the following
        options:

        -   Running the scripts using sudo

        -   Adding the Linux user to the docker group

        For more information, see,
        `https://docs.docker.com/engine/install/linux-postinstall/
        <https://docs.docker.com/engine/install/linux-postinstall/>`__

-   For Windows remote workstations, you must run the following commands from a
    Cygwin terminal. See `https://www.cygwin.com/ <https://www.cygwin.com/>`__
    for more information about the Cygwin project.

-   For Windows remote workstations, you must also have :command:`winpty`
    installed. Download the latest release tarball for Cygwin from
    `https://github.com/rprichard/winpty/releases
    <https://github.com/rprichard/winpty/releases>`__. After downloading the
    tarball, extract it to any location and change the Windows <PATH> variable
    to include its bin folder from the extracted winpty folder.

-   You will need a kubectl config file containing your user account and login
    credentials from your |prod| administrator.

The following procedure helps you configure the Container-backed remote |CLIs|
and clients for a non-admin user.

.. rubric:: |proc|

.. _kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients-steps-fvl-n4d-tkb:

#.  Copy the remote client tarball file from |dnload-loc| to the remote
    workstation, and extract its content.

    -   The tarball is available from the |prod| area on |dnload-loc|.

    -   You can extract the tarball contents anywhere on your client system.

    .. parsed-literal::

        $ cd $HOME
        $ tar xvf |prefix|-remote-clients-<version>.tgz

#.  Download the user/tenant **openrc** file from the Horizon Web interface to
    the remote workstation.

    #.  Log in to Horizon as the user and tenant that you want to configure
        remote access for.

        In this example, we use 'user1' user in the 'tenant1' tenant.

    #.  Navigate to **Project** \> **API Access** \> **Download Openstack RC
        file**.

    #.  Select **Openstack RC file**.

        The file my-openrc.sh downloads.

    .. note::

        For a Distributed Cloud system, navigate to **Project** \> **Central Cloud Regions** \> **RegionOne** \>
        and download the **Openstack RC file**.

#.  Copy the user-kubeconfig file \(received from your administrator containing
    your user account and credentials\) to the remote workstation.

    You can copy the file to any location on the remote workstation. For
    convenience, this example assumes that it is copied to the location of the
    extracted tarball.

    .. note::
        Ensure that the user-kubeconfig file has 666 permissions after copying
        the file to the remote workstation, otherwise, use the following
        command to change permissions, :command:`chmod 666 user-kubeconfig`.

#.  On the remote workstation, configure the client access.

    #.  Change to the location of the extracted tarball.

        .. parsed-literal::

            $ cd $HOME/|prefix|-remote-clients-<version>/

    #.  Create a working directory that will be mounted by the container
        implementing the remote |CLIs|.

        See the description of the :command:`configure\_client.sh` ``-w`` option
        :ref:`below <kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients-w-option>` for more details.

        .. code-block:: none

            $ mkdir -p $HOME/remote_cli_wd

    #.  Run the :command:`configure\_client.sh` script.

        .. only:: starlingx

            .. code-block:: none

                $ ./configure_client.sh -t platform -r my_openrc.sh -k user-kubeconfig -w $HOME/remote_cli_wd

        .. only:: partner

            .. include:: ../../_includes/kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients.rest

        If you specify repositories that require authentication, as shown
        above, you must remember to perform a :command:`docker login` to
        that repository before using remote |CLIs| for the first time.

        The options for configure\_client.sh are:

        **-t**
            The type of client configuration. The options are platform \(for
            |prod-long| |CLI| and clients\) and openstack \(for |prod-os|
            application |CLI| and clients\).

            The default value is platform.

        **-r**
            The user/tenant RC file to use for :command:`openstack` |CLI|
            commands.

            The default value is admin-openrc.sh.

        **-k**
            The kubernetes configuration file to use for :command:`kubectl` and
            :command:`helm` |CLI| commands.

            The default value is temp-kubeconfig.

        **-o**
            The remote CLI/client RC file generated by this script.

            This RC file needs to be sourced in the shell to set up required
            environment variables and aliases before running any remote |CLI|
            commands.

            For the platform client setup, the default is
            remote\_client\_platform.sh. For the openstack application client
            setup, the default is remote\_client\_app.sh.

        .. _kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients-w-option:

        **-w**
            The working directory that will be mounted by the container
            implementing the remote |CLIs|. When using the remote |CLIs|, any files
            passed as arguments to the remote |CLI| commands need to be in this
            directory in order for the container to access the files. The
            default value is the directory from which the
            :command:`configure\_client.sh` command was run.

        **-p**
            Override the container image for the platform |CLI| and clients.

            By default, the platform |CLIs| and clients container image is
            pulled from docker.io/starlingx/stx-platformclients.

            For example, to use the container images from the WRS AWS ECR:

            .. code-block:: none

                $ ./configure_client.sh -t platform -r my-openrc.sh -k user-kubeconfig -w $HOME/remote_cli_wd -p 625619392498.dkr.ecr.us-west-2.amazonaws.com/docker.io/starlingx/stx-platformclients:stx.5.0-v1.4.3

            If you specify repositories that require authentication, you must
            perform a :command:`docker login` to that repository before using
            remote |CLIs|.

        **-a**
            Override the OpenStack application image.

            By default, the OpenStack |CLIs| and clients container image is
            pulled from docker.io/starlingx/stx-openstackclients.

        The :command:`configure-client.sh` command will generate a
        remote\_client\_platform.sh RC file. This RC file needs to be sourced
        in the shell to set up required environment variables and aliases
        before any remote |CLI| commands can be run.

.. rubric:: |postreq|

After configuring the platform's container-backed remote CLIs/clients, the
remote platform |CLIs| can be used in any shell after sourcing the generated
remote CLI/client RC file. This RC file sets up the required environment
variables and aliases for the remote |CLI| commands.

.. note::
    Consider adding this command to your .login or shell rc file, such that
    your shells will automatically be initialized with the environment
    variables and aliases for the remote |CLI| commands.

See :ref:`Using Container-backed Remote CLIs and Clients <using-container-based-remote-clis-and-clients>` for details.

**Related information**

.. seealso::
    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-based-remote-clis-and-clients>`

    :ref:`Installing Kubectl and Helm Clients Directly on a Host
    <kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host>`

    :ref:`Configuring Remote Helm Client <configuring-remote-helm-client>`