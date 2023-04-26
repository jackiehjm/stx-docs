.. _author-apparmor-profiles-b02de0a22771:

========================
Author AppArmor Profiles
========================

AppArmor profiles can be written using a variety of approaches:  AppArmor
policy language, Bane and/or aa-logprof.

Core Policy Reference
*********************

AppArmor wiki provides the guidelines and semantics for AppArmor policy
enforcement and reference profile language which can be found at below link.

https://gitlab.com/apparmor/apparmor/-/wikis/AppArmor_Core_Policy_Reference


Bane
****

`bane <https://github.com/genuinetools/bane>`__ is an AppArmor profile
generator for Docker that uses a simplified profile language. This could be
used for generating a profile using an easy-to-read configuration file.

https://www.padok.fr/en/blog/security-docker-apparmor#Generate_an_AppArmor_profile_for_a_docker_container_with_bane


Generate a profile using aa-logprof
***********************************

#.  Create a profile with name ``<appname>-profile`` under ``/etc/apparmor.d``,
    which denies everything.

    For example:

    .. code-block:: none

        #include <tunables/global>

        profile <appname>-profile flags=(attach_disconnected, complain) {
         #include <abstractions/base>
         }

#.  Use ``apparmor_parser`` to load the above created profile in complain mode:

    .. code-block:: none

        apparmor_parser -q /etc/apparmor.d/<profilename>

#.  Attach the profile to the pod, launch the pod and perform the pod's allowed
    operations.

#.  Below permission change needs to be done by a user with sudo capability
    (e.g. 'sysadmin' user) to allow a ``sys_protected`` group member (e.g.
    'sysadmin' user) to update the profile using :command:`aa-logprof`.

    .. code-block:: none

        sudo setfacl -m g:sys_protected:rwx /etc/apparmor.d/

#.  Use :command:`aa-logprof` to update the profile as follows:

    .. code-block:: none

        aa-logprof -f <(sed 's/kernel: notice/kernel:/' < /var/log/kern.log)

    This would update the profile under ``/etc/apparmor.d``.

#.  Add the updated profile in the policy section of the AppArmor |CRD| after
    changing complain to enforce and load it in enforced mode as specified in
    :ref:`Load a profile in enforce mode across all hosts using SPO
    <load-a-profile-in-enforce-mode-across-all-hosts-using-spo>`.


Example profiles 1
******************

Below is an example of a sample profile which adds Linux capabilities, network
access rule, process limit, and file access.

.. code-block:: none

    # This loads a file containing variable definitions.
    include <tunables/home>

    # profile name
    profile Sample_profile flags=(attach_disconnected, mediate_deleted) {
        # This keyword allows to include rules from other files -
        #include <abstractions/base>

        # enables POSIX.1e draft capabilitie. application can change process UIDs and GIDs s
        capability setuid,
        capability setgid,

        # network access IPv4 TCP and IPv4 UPD is allowed -
        network inet dgram,
        network inet stream,

        # rlimit stack size is limited to 5KB
        rlimit stack >= 5K,

        # file permissions application can read and write to ~/myfile and it can execute ~/app
        @{HOME}/myfile rw,
        @{HOME}/app    ix,
    }
    }


Example profiles 2
******************

Below is an example profile of tcpdump a packet analyzer application. The
rules are more focused on Linux capabilities and Network access.

.. code-block:: none

    #include <tunables/global>

    /usr/sbin/tcpdump {
      #include <abstractions/base>
      #include <abstractions/nameservice>
      #include <abstractions/user-tmp>

      capability net_raw,
      capability setuid,
      capability setgid,
      capability dac_override,
      network raw,
      network packet,

      # for -D
      capability sys_module,
      @{PROC}/bus/usb/ r,
      @{PROC}/bus/usb/** r,

      # for -F and -w
      audit deny @{HOME}/.* mrwkl,
      audit deny @{HOME}/.*/ rw,
      audit deny @{HOME}/.*/** mrwkl,
      audit deny @{HOME}/bin/ rw,
      audit deny @{HOME}/bin/** mrwkl,
      @{HOME}/ r,
      @{HOME}/** rw,

      /usr/sbin/tcpdump r,
    }

