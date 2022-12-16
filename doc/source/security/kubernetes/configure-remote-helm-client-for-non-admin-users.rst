
.. oiz1581955060428
.. _configure-remote-helm-client-for-non-admin-users:

===============================
Configure Remote Helm v2 Client
===============================

Helm v3 is recommended for users to install and manage their
containerized applications. However, Helm v2 may be required, for example, if
the containerized application supports only a Helm v2 chart.

.. rubric:: |context|

Helm v2 is only supported remotely. Also, it is only supported with kubectl and
Helm v2 clients configured directly on the remote host workstation.  In
addition to installing the Helm v2 clients, users must also create their own
Tiller server, in a namespace that the user has access, with the required |RBAC|
capabilities and optionally |TLS| protection.

Complete the following steps to configure Helm v2 for managing containerized
applications with a Helm v2 chart.

.. rubric:: |proc|

.. _configure-remote-helm-client-for-non-admin-users-steps-isx-dsd-tkb:

#.  On the controller, create an admin-user service account if this is not
    already available.

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


#.  On the workstation, if it is not available, install the :command:`kubectl` client on an Ubuntu
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
            time, then specify ``--insecure-skip-tls-verify``, as shown below.

        .. code-block:: none

            % kubectl config set-cluster mycluster --server=https://<oam-floating-IP>:6443 \
            --insecure-skip-tls-verify
            % kubectl config set-credentials admin-user@mycluster --token=$TOKEN_DATA
            % kubectl config set-context admin-user@mycluster --cluster=mycluster \
            --user admin-user@mycluster --namespace=default
            % kubectl config use-context admin-user@mycluster

        ``$TOKEN_DATA``  is the token retrieved in step 1.

    #.  Test remote :command:`kubectl` access.

        .. code-block:: none

            % kubectl get nodes -o wide
            NAME           STATUS   ROLES                  AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
            compute-0      Ready    <none>                 9d    v1.24.4   192.168.204.69   <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-6-amd64   containerd://1.4.12
            compute-1      Ready    <none>                 9d    v1.24.4   192.168.204.7    <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-6-amd64   containerd://1.4.12
            controller-0   Ready    control-plane,master   9d    v1.24.4   192.168.204.3    <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-6-amd64   containerd://1.4.12
            controller-1   Ready    control-plane,master   9d    v1.24.4   192.168.204.4    <none>        Debian GNU/Linux 11 (bullseye)   5.10.0-6-amd64   containerd://1.4.12
            %

#.  Install the Helm v2 client on remote workstation.

    .. code-block:: none

        % wget https://get.helm.sh/helm-v2.13.1-linux-amd64.tar.gz
        % tar xvf helm-v2.13.1-linux-amd64.tar.gz
        % sudo cp linux-amd64/helm /usr/local/bin

    Verify that :command:`helm` is installed correctly.

    .. code-block:: none

        % helm version
        Client: &version.Version{SemVer:"v2.13.1", GitCommit:"618447cbf203d147601b4b9bd7f8c37a5d39fbb4", GitTreeState:"clean"}

        Server: &version.Version{SemVer:"v2.13.1", GitCommit:"618447cbf203d147601b4b9bd7f8c37a5d39fbb4", GitTreeState:"clean"}

#.  On the workstation, set the namespace for which you want Helm v2 access to.

    .. code-block:: none

        ~(keystone_admin)]$ NAMESPACE=default

#.  On the workstation, set up accounts, roles and bindings for Tiller (Helm v2 cluster access).


    #.  Execute the following commands.

        .. note::
            These commands could be run remotely by the non-admin user who
            has access to the default namespace.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > default-tiller-sa.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: tiller
              namespace: default
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: Role
            metadata:
              name: tiller
              namespace: default
            rules:
            - apiGroups: ["*"]
              resources: ["*"]
              verbs: ["*"]
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: RoleBinding
            metadata:
              name: tiller
              namespace: default
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: Role
              name: tiller
            subjects:
            - kind: ServiceAccount
              name: tiller
              namespace: default
            EOF
            ~(keystone_admin)]$ kubectl apply -f default-tiller-sa.yaml


    #.  Execute the following commands as an admin-level user.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl create clusterrole tiller --verb get --resource namespaces
            ~(keystone_admin)]$ kubectl create clusterrolebinding tiller --clusterrole tiller --serviceaccount ${NAMESPACE}:tiller


#.  On the workstation, initialize Helm v2 access with :command:`helm init`
    command to start Tiller in the specified NAMESPACE with the specified RBAC
    credentials.

    .. code-block:: none

        ~(keystone_admin)]$ helm init --service-account=tiller --tiller-namespace=$NAMESPACE --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | sed 's@ replicas: 1@ replicas: 1\n \ selector: {"matchLabels": {"app": "helm", "name": "tiller"}}@' > helm-init.yaml
        ~(keystone_admin)]$ kubectl apply -f helm-init.yaml
        ~(keystone_admin)]$ helm init --client-only --stable-repo-url https://charts.helm.sh/stable

    .. note::
        Ensure that each of the patterns between single quotes in the above
        :command:`sed` commands are on single lines when run from your
        command-line interface.

    .. note::
        Add the following options if you are enabling TLS for this Tiller:

        ``--tiller-tls``
            Enable TLS on Tiller.

        ``--tiller-tls-cert <certificate_file>``
            The public key/certificate for Tiller \(signed by ``--tls-ca-cert``\).

        ``--tiller-tls-key <key_file>``
            The private key for Tiller.

        ``--tiller-tls-verify``
            Enable authentication of client certificates \(i.e. validate
            they are signed by ``--tls-ca-cert``\).

        ``--tls-ca-cert <certificate_file>``
            The public certificate of the |CA| used for signing Tiller
            server and helm client certificates.

.. rubric:: |result|

You can now use the private Tiller server remotely by specifying
the ``--tiller-namespace`` default option on all helm CLI commands. For
example:

.. code-block:: none

    helm version --tiller-namespace default
    helm install --name wordpress stable/wordpress --tiller-namespace default

.. seealso::

    :ref:`Configure Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-backed-remote-clis-and-clients>`

    :ref:`Install Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

