
.. jgr1582125251290
.. _configure-kubectl-with-a-context-for-the-user:

=============================================
Configure Kubectl with a Context for the User
=============================================

You can set up the kubectl context for the Windows Active Directory
**testuser** to authenticate through the **oidc-auth-apps** |OIDC| Identity
Provider (dex).

.. rubric:: |context|

The steps below show this procedure completed on controller-0. You can also
do so from a remote workstation.

.. rubric:: |proc|

#.  Set up a cluster in kubectl if you have not done so already.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl config set-cluster mywrcpcluster --server=https://<oam-floating-ip>:6443


#.  Set up a context for **testuser** in this cluster in kubectl.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl config set-context testuser@mywrcpcluster --cluster=mywrcpcluster --user=testuser



