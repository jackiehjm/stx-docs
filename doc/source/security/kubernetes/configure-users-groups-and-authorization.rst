
.. rzl1582124533847
.. _configure-users-groups-and-authorization:

==========================================
Configure Users, Groups, and Authorization
==========================================

You can create a **user**, and optionally one or more **groups** that the
**user** is a member of, in your Windows Active Directory server.

.. rubric:: |context|

The example below is for a **testuser** user who is a member of the,
**billingDeptGroup**, and **managerGroup** groups. See `Microsoft
documentation on Windows Active Directory
<https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/vi
rtual-dc/active-directory-domain-services-overview>`__ for additional
information on adding users and groups to Windows Active Directory.

Use the following procedure to configure the desired authorization on
|prod-long| for the user or the user's group\(s):

.. rubric:: |proc|


.. _configure-users-groups-and-authorization-steps-b2f-ck4-dlb:

#.  In |prod-long|, bind Kubernetes |RBAC| role\(s) for the **testuser**.

    For example, give **testuser** admin privileges, by creating the
    following deployment file, and deploy the file with :command:`kubectl
    apply -f` <filename>.

    .. code-block:: none

        kind: ClusterRoleBinding
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
         name: testuser-rolebinding
        roleRef:
         apiGroup: rbac.authorization.k8s.io
         kind: ClusterRole
         name: cluster-admin
        subjects:
        - apiGroup: rbac.authorization.k8s.io
          kind: User
          name: testuser


    Alternatively, you can bind Kubernetes |RBAC| role\(s) for the group\(s)
    of the **testuser**.

    For example, give all members of the **billingDeptGroup** admin
    privileges, by creating the following deployment file, and deploy the
    file with :command:`kubectl apply -f` <filename>.

    .. code-block:: none

        kind: ClusterRoleBinding
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
         name: testuser-rolebinding
        roleRef:
         apiGroup: rbac.authorization.k8s.io
         kind: ClusterRole
         name: cluster-admin
        subjects:
        - apiGroup: rbac.authorization.k8s.io
          kind: Group
          name: billingDeptGroup


