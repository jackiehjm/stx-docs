
.. orh1571690363235
.. _kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host:

===================================================
Install Kubectl and Helm Clients Directly on a Host
===================================================


As an alternative to using the container-backed Remote :abbr:`CLIs (Command
Line Interfaces)` for kubectl and helm, you can install these commands
directly on your remote host.

.. rubric:: |context|

Kubectl and helm installed directly on the remote host provide the best CLI
behaviour, especially for CLI commands that reference local files or require a
shell.

The following procedure shows you how to configure the :command:`kubectl` and
:command:`kubectl` clients directly on a remote host, for an admin user with
**cluster-admin clusterrole**. If using a non-admin user with only role
privileges within a private namespace, additional configuration is required in
order to use :command:`helm`.

.. rubric:: |prereq|

You will need the following information from your |prod| administrator:


.. _kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host-ul-nlr-1pq-nlb:

-   the floating OAM IP address of the |prod|

-   login credential information; in this example, it is the "TOKEN" for a
    local Kubernetes ServiceAccount.

.. xreflink For a Windows Active Directory user, see,
    |sec-doc|: :ref:`Overview of Windows Active Directory
    <overview-of-windows-active-directory>`.

-   your kubernetes namespace

.. rubric:: |proc|

.. _kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host-steps-f54-qqd-tkb:

#.  On the workstation, install the :command:`kubectl` client on an Ubuntu
    host by performing the following actions on the remote Ubuntu system.

    #.  Install the :command:`kubectl` client CLI.

        .. code-block:: none

            % sudo apt-get update
            % sudo apt-get install -y apt-transport-https
            % curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
            % echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
            % sudo apt-get update
            % sudo apt-get install -y kubectl

	.. _security-installing-kubectl-and-helm-clients-directly-on-a-host-local-configuration-context:

    #.  Set up the local configuration and context.

        .. note::
            In order for your remote host to trust the certificate used by the
            |prod-long| K8s API, you must ensure that the
            **k8s\_root\_ca\_cert** provided by your |prod| administrator is a
            trusted CA certificate by your host. Follow the instructions for
            adding a trusted CA certificate for the operating system
            distribution of your particular host.

            If your administrator does not provide a **k8s\_root\_ca\_cert**
            at the time of installation, then specify
            –insecure-skip-tls-verify, as shown below.

        .. code-block:: none

            % kubectl config set-cluster mycluster --server=https://<$CLUSTEROAMIP>:6443 --insecure-skip-tls-verify
            % kubectl config set-credentials dave-user@mycluster --token=$MYTOKEN
            % kubectl config set-context dave-user@mycluster --cluster=mycluster --user admin-user admin-user@mycluster --namespace=$MYNAMESPACE
            % kubectl config use-context dave-user@mycluster

    #.  Test remote :command:`kubectl` access.

        .. code-block:: none

            % kubectl get pods -o wide
            NAME            READY STATUS RE-    AGE IP           NODE      NOMINA- READINESS
                                         STARTS                           TED NODE GATES
            nodeinfo-648f.. 1/1  Running   0    62d 172.16.38.83  worker-4 <none> <none>
            nodeinfo-648f.. 1/1  Running   0    62d 172.16.97.207 worker-3 <none> <none>
            nodeinfo-648f.. 1/1  Running   0    62d 172.16.203.14 worker-5 <none> <none>
            tiller-deploy.. 1/1  Running   0    27d 172.16.97.219 worker-3 <none> <none>

#.  On the workstation, install the :command:`helm` client on an Ubuntu host
    by performing the following actions on the remote Ubuntu system.

    #.  Install :command:`helm` client.

        .. code-block:: none

            % wget https://get.helm.sh/helm-v2.13.1-linux-amd64.tar.gz
            % tar xvf helm-v2.13.1-linux-amd64.tar.gz
            % sudo cp linux-amd64/helm /usr/local/bin

        In order to use :command:`helm`, additional configuration is required.
        For more information, see :ref:`Configuring Remote Helm Client
        <configuring-remote-helm-client>`.
