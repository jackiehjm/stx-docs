.. _apply-a-profile-to-a-pod-c2fa4d958dec:

========================
Apply a Profile to a Pod
========================

AppArmor profiles are specified per-container.

.. rubric:: |prereq|

-   AppArmor should be enabled on the host(s) (described in
    :ref:`Enable/Disable AppArmor on a Host
    <enable-disable-apparmor-on-a-host-63a7a184d310>`), where workloads need to
    be protected using AppArmor.

-   Security Profiles Operator (SPO) should be installed. As described in
    :ref:`Install Security Profiles Operator (SPO)
    <install-security-profiles-operator-1b2f9a0f0108>`.

-   A profile should be loaded using |SPO| (described in :ref:`Profile
    Management <profile-management-a8df19c86a5d>`).


To specify the AppArmor profile to run a Pod container with, add an annotation
to the Pod's metadata:

.. code-block:: none

    container.apparmor.security.beta.kubernetes.io/<container_name>: <profile_ref>


.. rubric:: |eg|

#.  Attach a profile to a container in the Pod.

    .. code-block:: none

        $ vi test-apparmor.yaml
        apiVersion: v1
        kind: Pod
        metadata:
          name: test-apparmor
          annotations:
            # Tell Kubernetes to apply the AppArmor profile "test-profile".
            container.apparmor.security.beta.kubernetes.io/test-apparmor: localhost/test-profile
        spec:
          containers:
          - name: test-apparmor
            image: busybox:1.28
            command: [ "sh", "-c", "echo 'Hello Test AppArmor!' && sleep 1h" ]

        $ kubectl apply -f test-apparmor.yaml

#.  Verify that the container is actually running with that profile by checking
    its proc attr.

    .. code-block:: none

        $ kubectl exec test-apparmor -- cat /proc/1/attr/current
        test-profile (complain)

#.  Verify if violations are blocked by writing to a file.

    .. code-block:: none

        $ kubectl exec test-apparmor -- touch /tmp/test
                touch: /tmp/test: Permission denied
                command terminated with exit code 1

.. note::

    If a profile is not created/loaded on a host, ``kubelet`` will reject the
    pod.

    .. code-block:: none

        $ kubectl get pods
        NAME               READY   STATUS                 RESTARTS      AGE
        hello-apparmor     0/1     CreateContainerError   0 (49m ago)   113m

    Running ``kubectl describe pod hello-apparmor`` or
    ``kubect get event | grep hello-apparmor`` will show the following error:

    .. code-block:: none

        Error: : failed to generate apparmor spec opts: apparmor profile not found test-profile

    Any profile rules updates are reflected to the running pods.

    Any profile deletion while it is attached to a pod will not have any impact
    on the pod state (It will show in running state). The application in the
    pod may not behave correctly as it might try to access
    ``/proc/self/attr/apparmor/exec`` which throw error as profile is not
    loaded.

For more details, refer to `Restrict a Container's Access to Resources with
AppArmor: Example
<https://kubernetes.io/docs/tutorials/security/apparmor/#example>`__.

