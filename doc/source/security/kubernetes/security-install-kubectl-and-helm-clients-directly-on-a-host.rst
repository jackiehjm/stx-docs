
.. iqi1581955028595
.. _security-install-kubectl-and-helm-clients-directly-on-a-host:

===================================================
Install Kubectl and Helm Clients Directly on a Host
===================================================

You can use :command:`kubectl` and :command:`helm` to interact with a
controller from a remote system.

.. rubric:: |context|

Commands such as those that reference local files or commands that require
a shell are more easily used from clients running directly on a remote
workstation.

Complete the following steps to install :command:`kubectl` and
:command:`helm` on a remote system.

The following procedure shows how to configure the kubectl and helm clients
directly on remote host, for an admin user with cluster-admin clusterrole.
If using a non-admin user such as one with only role privileges within a
private namespace, the procedure is the same, however, additional
configuration is required in order to use :command:`helm`.

.. rubric:: |proc|

.. _security-install-kubectl-and-helm-clients-directly-on-a-host-steps-f54-qqd-tkb:

#.  On the controller, if an **admin-user** service account is not already available, create one.

    #.  Create the **admin-user** service account in **kube-system**
        namespace and bind the **cluster-admin** ClusterRoleBinding to this user.

        .. code-block:: none

            % cat <<EOF > admin-login.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: admin-user
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
              name: admin-user
              namespace: kube-system
            EOF
            % kubectl apply -f admin-login.yaml

    #.  Retrieve the secret token.

        .. code-block:: none

            % kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')


#.  On the workstation, install the :command:`kubectl` client on an Ubuntu
    host by taking the following actions on the remote Ubuntu system.

    #.  Install the :command:`kubectl` client CLI.

        .. code-block:: none

            % sudo apt-get update
            % sudo apt-get install -y apt-transport-https
            % curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
            sudo apt-key add
            % echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
            sudo tee -a /etc/apt/sources.list.d/kubernetes.list
            % sudo apt-get update
            % sudo apt-get install -y kubectl

    #.  Set up the local configuration and context.

        .. note::
            In order for your remote host to trust the certificate used by
            the |prod-long| K8S API, you must ensure that the
            **k8s\_root\_ca\_cert** specified at install time is a trusted
            CA certificate by your host. Follow the instructions for adding
            a trusted CA certificate for the operating system distribution
            of your particular host.

            If you did not specify a **k8s\_root\_ca\_cert** at install
            time, then specify –insecure-skip-tls-verify, as shown below.

        .. code-block:: none

            % kubectl config set-cluster mycluster --server=https://<oam-floating-IP>:6443 \
            --insecure-skip-tls-verify
            % kubectl config set-credentials admin-user@mycluster --token=$TOKEN_DATA
            % kubectl config set-context admin-user@mycluster --cluster=mycluster \
            --user admin-user@mycluster --namespace=default
            % kubectl config use-context admin-user@mycluster

        <$TOKEN\_DATA> is the token retrieved in step 1.

    #.  Test remote :command:`kubectl` access.

        .. code-block:: none

            % kubectl get nodes -o wide
            NAME           STATUS   ROLES    AGE    VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE ...
            controller-0   Ready    master   15h    v1.12.3   192.168.204.3     <none>        CentOS L ...
            controller-1   Ready    master   129m   v1.12.3   192.168.204.4     <none>        CentOS L ...
            worker-0       Ready    <none>   99m    v1.12.3   192.168.204.201   <none>        CentOS L ...
            worker-1       Ready    <none>   99m    v1.12.3   192.168.204.202   <none>        CentOS L ...
            %

#.  On the workstation, install the :command:`helm` client on an Ubuntu
    host by taking the following actions on the remote Ubuntu system.

    #.  Install :command:`helm`.

        .. code-block:: none

            % wget https://get.helm.sh/helm-v2.13.1-linux-amd64.tar.gz
            % tar xvf helm-v2.13.1-linux-amd64.tar.gz
            % sudo cp linux-amd64/helm /usr/local/bin


    #.  Verify that :command:`helm` installed correctly.

        .. code-block:: none

            % helm version
            Client: &version.Version{SemVer:"v2.13.1", GitCommit:"618447cbf203d147601b4b9bd7f8c37a5d39fbb4", GitTreeState:"clean"}
            Server: &version.Version{SemVer:"v2.13.1", GitCommit:"618447cbf203d147601b4b9bd7f8c37a5d39fbb4", GitTreeState:"clean"}

.. seealso::

    :ref:`Configure Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-backed-remote-clis-and-clients>`

    :ref:`Configure Remote Helm Client for Non-Admin Users
    <configure-remote-helm-client-for-non-admin-users>`

