.. _install-security-profiles-operator-1b2f9a0f0108:

========================================
Install Security Profiles Operator (SPO)
========================================

In order to apply the profiles to a particular pod, the profiles need to be
available to the host machine where the pod is launched. Security Profile
Operator (SPO, https://github.com/kubernetes-sigs/security-profiles-operator)
provides AppArmor profile management (i.e. loading/unloading) across Kubernetes
nodes. |SPO| defines an AppArmor Profile |CRD|, such that end users' can define
AppArmor profiles for |SPO| to manage.

|SPO| is packaged as a system application and is managed using system
application commands. To install |SPO|, use the following procedure.

.. rubric:: |prereq|

AppArmor should be enabled on the host(s) (described in :ref:`Enable/Disable
AppArmor on a Host <enable-disable-apparmor-on-a-host-63a7a184d310>`), where
workloads need to be protected using AppArmor.

.. rubric:: |proc|

#.  Locate the |SPO| tarball in ``/usr/local/share/applications/helm``.

    For example:

    .. code-block:: none

        /usr/local/share/applications/helm/security-profiles-operator-<version>.tgz

#.  Upload the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/security-profiles-operator-<version>.tgz

#.  Verify the |SPO| tarball has been uploaded.

    .. code-block:: none

        ~(keystone_admin)]$ system application-list

#.  Apply the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply security-profiles-operator

#.  Monitor the status.

    .. code-block:: none

        ~(keystone_admin)]$ watch -n 5 system application-list

        OR

        ~(keystone_admin)]$ watch kubectl get pods -n security-profiles-operator

The configuration of the installed ``security-profiles-operator`` application
is as follows:

``security-profiles-operator``
    Runs as a deployment, replica count of 3 on the controller(s).

``security-profiles-operator-webhook``
    Runs as a deployment, replica count of 3.

``spod``
    Runs as a daemonset on every Kubernetes host (i.e., controller(s) and
    worker(s)), where application pods can be scheduled.

.. _remove-security-profiles-operator-spo:

Remove Security Profiles Operator (SPO)
---------------------------------------

Run the following commands to remove |SPO|. This will remove pods and other
resources created by the application installation.

.. note::

    This procedure does not remove the apparmor profiles created using |SPO|,
    You can delete the profiles previously created by following the procedure
    described in :ref:`Delete a profile across all hosts using SPO
    <delete-a-profile-across-all-hosts-using-spo>`.

    If an AppArmor profile is deleted, all pods with that AppArmor profile
    annotation should be either removed or updated to remove the annotation.

#.  Remove the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove security-profiles-operator

#.  Delete the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete security-profiles-operator

.. note::

    To remove AppArmor from a |prod| deployment requires removing |SPO| as
    specified in this section and then disabling AppArmor on all the host(s).
    For more details, see :ref:`Enable/Disable AppArmor on a Host
    <enable-disable-apparmor-on-a-host-63a7a184d310>`.


Disable AppArmor from a StarlingX deployment
--------------------------------------------

To disable AppArmor from a deployment, need to follow below steps:

#.  Remove |SPO| system app (refer to :ref:`Remove Security Profiles Operator
    (SPO) <remove-security-profiles-operator-spo>`).

#.  Disable AppArmor on host(s) (refer to :ref:`Enable/Disable AppArmor on a
    Host <enable-disable-apparmor-on-a-host-63a7a184d310>`).
