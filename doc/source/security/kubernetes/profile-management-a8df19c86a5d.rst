.. _profile-management-a8df19c86a5d:

==================
Profile Management
==================

AppArmor profiles can be managed using |SPO| |CRD| (``apparmorprofile``). A
user can load, update, and delete a profile.

.. _load-a-profile-in-enforce-mode-across-all-hosts-using-spo:

Load a profile in enforce mode across all hosts using SPO
---------------------------------------------------------

#.  Apply the profile.

    .. code-block:: none

        $ vi apparmorprofile.yaml
        ---
        apiVersion: security-profiles-operator.x-k8s.io/v1alpha1
        kind: AppArmorProfile
        metadata:
          name: test-profile
          annotations:
            description: Block writing to any files in the disk.
        spec:
          policy: |
            #include <tunables/global>
            profile test-profile flags=(attach_disconnected) {
              #include <abstractions/base>
              file,
              # Deny all file writes.
              deny /** w,
            }
        $ kubectl apply -f apparmorprofile.yaml

#.  Verify if ``apparmorprofile`` resource is created.

    .. code-block:: none

        $ kubectl get apparmorprofiles

        NAME           AGE
        test-profile   3d5h

#.  Verify if test-profile is loaded in enforce mode on a host.

    .. code-block:: none

        $ aa-status

        apparmor module is loaded.
        20 profiles are loaded.
        13 profiles are in enforce mode.
            /usr/bin/man
            /usr/lib/ipsec/charon
            /usr/lib/ipsec/stroke
            /usr/sbin/ntpd
            cri-containerd.apparmor.d
            docker-default
            lsb_release
            man_filter
            man_groff
            nvidia_modprobe
            nvidia_modprobe//kmod
            tcpdump
            test-profile
        7 profiles are in complain mode.
            /usr/bin/keystone-wsgi-public
            /usr/sbin/sssd
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_be
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_nss
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_pam


Load a profile in complain mode across all hosts using SPO
----------------------------------------------------------

#.  Apply the profile.

    .. code-block:: none

        $ vi apparmorprofile.yaml
        ---
        apiVersion: security-profiles-operator.x-k8s.io/v1alpha1
        kind: AppArmorProfile
        metadata:
          name: test-profile
          annotations:
            description: Block writing to any files in the disk.
        spec:
          policy: |
            #include <tunables/global>
            profile test-profile flags=(attach_disconnected, complain) {
              #include <abstractions/base>
              file,
              # Deny all file writes.
              deny /** w,
            }
        $ kubectl apply -f apparmorprofile.yaml

#.  Verify if apparmorprofile resource is created.

    .. code-block:: none

        $ kubectl get apparmorprofiles

        NAME           AGE
        test-profile   3d5h

#.  Verify if test-profile is loaded in complain mode on a host.

    .. code-block:: none

        aa-status
        apparmor module is loaded.
        20 profiles are loaded.
        12 profiles are in enforce mode.
            /usr/bin/man
            /usr/lib/ipsec/charon
            /usr/lib/ipsec/stroke
            /usr/sbin/ntpd
            cri-containerd.apparmor.d
            docker-default
            lsb_release
            man_filter
            man_groff
            nvidia_modprobe
            nvidia_modprobe//kmod
            tcpdump
        6 profiles are in complain mode.
            /usr/bin/keystone-wsgi-public
            /usr/sbin/sssd
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_be
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_nss
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_pam
            test-profile
        0 processes have profiles defined.
        0 processes are in enforce mode.
        0 processes are in complain mode.
        0 processes are unconfined but have a profile defined.


Update a profile across all hosts using SPO
-------------------------------------------

#.  Update the policy section of the ``.yaml`` used to create the profile.

    .. code-block:: none

        $ vi apparmorprofile.yaml
        ---
        apiVersion: security-profiles-operator.x-k8s.io/v1alpha1
        kind: AppArmorProfile
        metadata:
          name: test-profile
          annotations:
            description: Block writing to any files in the disk.
        spec:
          policy: |
            #include <tunables/global>
            profile test-profile flags=(attach_disconnected, complain) {
              #include <abstractions/base>
              file,
              # Deny all file writes.
              deny /** w,
              network inet tcp,
              network inet udp,
              capability chown,
            }

#.  Update the profile.

    .. code-block:: none

        $ kubectl apply -f apparmorprofile.yaml

#.  Verify if the test-profile is added. Check the test-profile content at
    ``/etc/apparmor.d`` on a host.

    .. code-block:: none

        $ cat test-profile
        #include <tunables/global>
        profile test-profile flags=(attach_disconnected, complain) {
          #include <abstractions/base>
          file,
          # Deny all file writes.
          deny /** w,
          network inet tcp,
          network inet udp,
          capability chown,
        }

.. _delete-a-profile-across-all-hosts-using-spo:

Delete a profile across all hosts using SPO
-------------------------------------------

#.  List the AppArmor profiles.

    .. code-block:: none

        $ kubectl get apparmorprofiles.security-profiles-operator.x-k8s.io

        NAME           AGE
        test-profile   4d1h

#.  Delete the AppArmor profiles using ``.yaml`` file as follows:

    .. code-block:: none

        $ kubectl delete -f apparmorprofile.yaml

    OR using imperative commands:

    .. code-block:: none

        $ kubectl delete apparmorprofiles.security-profiles-operator.x-k8s.io <profile-name>

#.  Verify if apparmorprofile resource is deleted.

    .. code-block:: none

        $ kubectl get apparmorprofiles.security-profiles-operator.x-k8s.io
        No resources found in default namespace.

#.  Verify if test-profile is removed from a host using ``aa-status``.

    .. code-block:: none

        $ aa-status
        apparmor module is loaded.
        20 profiles are loaded.
        13 profiles are in enforce mode.
            /usr/bin/man
            /usr/lib/ipsec/charon
            /usr/lib/ipsec/stroke
            /usr/sbin/ntpd
            cri-containerd.apparmor.d
            docker-default
            lsb_release
            man_filter
            man_groff
            nvidia_modprobe
            nvidia_modprobe//kmod
            tcpdump
        7 profiles are in complain mode.
            /usr/bin/keystone-wsgi-public
            /usr/sbin/sssd
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_be
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_nss
            /usr/sbin/sssd//null-/usr/libexec/sssd/sssd_pam



