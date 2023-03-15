
.. zmz1607701719511
.. _kubernetes-cli-from-local-ldap-linux-account-login:

========================================================
For Kubernetes CLI from a Local LDAP Linux Account Login
========================================================

You can establish credentials for executing Kubernetes |CLIs| (kubectl and
helm) for a Local |LDAP| user, if required; this is not setup by default.

.. rubric:: |context|

For more information about :command:`ldapusersetup`, see :ref:`Creating LDAP
Linux Accounts <create-ldap-linux-accounts>`.

.. rubric:: |prereq|

.. _kubernetes-cli-from-local-ldap-linux-account-login-ul-afg-rcn-ynb:

-   You must have a Kubernetes Service Account.

-   See :ref:`Creating an Admin Type Service Account
    <create-an-admin-type-service-account>` for details on how to create an admin
    level service account. For more clarifications, ask your 'sysadmin'.

.. rubric:: |context|

It is recommended to use the same username for both your Local |LDAP| user and
your Kubernetes Service Account.

.. rubric:: |proc|

#.  Add your Local |LDAP| user account to the 'root' group in order to get
    access to execute :command:`kubectl`.

    If you have sudo permissions, run the following command first, and then
    re-ssh to your local |LDAP| user account, otherwise the 'sysadmin' will have
    to execute this step.

    .. code-block:: none

        $sudo usermod -a -G root <ldapusername>

#.  Configure :command:`kubectl` access.

    .. note::
        Your 'sysadmin' should have given you a TOKEN while setting up your
        Kubernetes Service Account.

    Execute the following commands:

    .. code-block:: none

        $ kubectl config set-cluster mycluster --server=https://192.168.206.1:6443 --insecure-skip-tls-verify
        $ kubectl config set-credentials joe-admin@mycluster --token=$TOKEN
        $ kubectl config set-context joe-admin@mycluster --cluster=mycluster  --user joe-admin@mycluster
        $ kubectl config use-context joe-admin@mycluster

    You now have admin access to |prod| Kubernetes cluster.


