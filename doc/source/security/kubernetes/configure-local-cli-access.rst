.. gub1581954935898
.. _configure-local-cli-access:

==========================
Configure Local CLI Access
==========================

You can access the system via a local CLI from the active controller
node's local console or by SSH-ing to the OAM floating IP Address.

.. rubric:: |context|

It is highly recommended that only 'sysadmin' and a small number of admin
level user accounts be allowed to SSH to the system. This procedure will
assume that only such an admin user is using the local CLI.

Using the **sysadmin** account and the Local CLI, you can perform all
required system maintenance, administration and troubleshooting tasks.

.. rubric:: |proc|


.. _configure-local-cli-access-steps-ewr-c33-gjb:

#.  Log in to controller-0 via the console or using SSH.

    Use the user name **sysadmin** and your <sysadmin-password>.

#.  Acquire Keystone Admin and Kubernetes Admin credentials.

    .. code-block:: none

        $ source /etc/platform/openrc
        [sysadmin@controller-0 ~(keystone_admin)]$

#.  If you plan on customizing the sysadmin's kubectl configuration on the
    |prod-long| Controller, (for example, :command:`kubectl config set-...` or
    :command:`or oidc-auth`), you should use a private KUBECONFIG file and NOT
    the system-managed KUBECONFIG file /etc/kubernetes/admin.conf, which can be
    changed and overwritten by the system.

    #.  Copy /etc/kubernetes/admin.conf to a private file under
        /home/sysadmin such as /home/sysadmin/.kube/config, and update
        /home/sysadmin/.profile to have the <KUBECONFIG> environment variable
        point to the private file.

        For example, the following commands set up a private KUBECONFIG file.

        .. code-block:: none

            # ssh sysadmin@<oamFloatingIpAddress>
            Password:
            % mkdir .kube
            % cp /etc/kubernetes/admin.conf .kube/config
            % echo "export KUBECONFIG=~/.kube/config" >> ~/.profile
            % exit


    #.  Confirm that the <KUBECONFIG> environment variable is set correctly
        and that :command:`kubectl` commands are functioning properly.

        .. code-block:: none

            # ssh sysadmin@<oamFloatingIpAddress>
            Password:
            % env | fgrep KUBE
            KUBECONFIG=/home/sysadmin/.kube/config
            % kubectl get pods

    .. rubric:: |result|

You can now access all |prod| commands.

**system commands**

StarlingX system and host management commands are executed with the
:command:`system` command.

For example:

.. code-block:: none

    ~(keystone_admin)]$ system host-list
    +----+--------------+-------------+----------------+-------------+--------------+
    | id | hostname     | personality | administrative | operational | availability |
    +----+--------------+-------------+----------------+-------------+--------------+
    | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
    +----+--------------+-------------+----------------+-------------+--------------+

Use :command:`system help` for a full list of :command:`system` subcommands.

**fm commands**

StarlingX fault management commands are executed with the :command:`fm` command.

For example:

.. code-block:: none

    ~(keystone_admin)]$ fm alarm-list

    +-------+---------------+---------------------+----------+---------------+
    | Alarm | Reason Text   | Entity ID           | Severity | Time Stamp    |
    | ID    |               |                     |          |               |
    +-------+---------------+---------------------+----------+---------------+
    | 750.  | Application   | k8s_application=    | major    | 2019-08-08T20 |
    | 002   | Apply Failure | platform-integ-apps |          | :17:58.223926 |
    |       |               |                     |          |               |
    +-------+---------------+---------------------+----------+---------------+

Use :command:`fm help` for a full list of :command:`fm` subcommands.

**kubectl commands**

Kubernetes commands are executed with the :command:`kubectl` command

For example:

.. code-block:: none

    ~(keystone_admin)]$ kubectl get nodes
    NAME           STATUS   ROLES    AGE     VERSION
    controller-0   Ready    master   5d19h   v1.13.5
    ~(keystone_admin)]$ kubectl get pods
    NAME                                              READY   STATUS    RESTARTS   AGE
    dashboard-kubernetes-dashboard-7749d97f95-bzp5w   1/1     Running   0          3d18h

**Helm commands**

Helm commands are executed with the :command:`helm` command

For example:

.. code-block:: none

    % helm repo add bitnami https://charts.bitnami.com/bitnami
    % helm repo update
    % helm repo list
    % helm search repo
    % helm install wordpress bitnami/wordpress
