

.. vbb1579292724479
.. _installing-a-subcloud-using-redfish-platform-management-service:

============================================================
Install a Subcloud Using Redfish Platform Management Service
============================================================

For subclouds with servers that support Redfish Virtual Media Service (version
1.2 or higher), you can use the Central Cloud's CLI to install the ISO and
bootstrap the subclouds from the Central Cloud.


.. _installing-a-subcloud-using-redfish-platform-management-service-section-N10022-N1001F-N10001:

.. rubric:: |context|

After physically installing the hardware and network connectivity of a
subcloud, the subcloud installation has these phases:

-   Executing the :command:`dcmanager subcloud add` command in the Central Cloud:

    -   Uses Redfish Virtual Media Service to remote install the ISO on
        controller-0 in the subcloud

    -   Uses Ansible to bootstrap |prod-long| on controller-0 in
        the subcloud


.. note::

    After a successful remote installation of a subcloud in a Distributed Cloud
    system, a subsequent remote reinstallation fails because of an existing ssh
    key entry in the ``/root/.ssh/known_hosts`` on the System Controller. In this
    case, delete the host key entry, if present, from ``/root/.ssh/known_hosts``
    on the System Controller before doing reinstallations.

.. note::

    Remove all removable USB storage devices from subcloud servers before
    starting a Redfish remote subcloud install.

.. rubric:: |prereq|

.. _installing-a-subcloud-using-redfish-platform-management-service-ul-g5j-3f3-qjb:

-   The docker **rvmc** image needs to be added to the system controller
    bootstrap override file, docker.io/starlingx/rvmc:|v_starlingx-rvmc|.

-   A new system CLI option ``--active`` is added to the
    :command:`load-import` command to allow the import into the
    system controller ``/opt/dc-vault/loads``. The purpose of this is to allow
    Redfish install of subclouds referencing a single full copy of the
    ``bootimage.iso`` at ``/opt/dc-vault/loads``. (Previously, the full
    ``bootimage.iso`` was duplicated for each :command:`subcloud add`
    command).

    .. note::

        - This is required only once and does not have to be done for every
          subcloud install.

          :command:`dcmanager` recognizes bootimage names ending in ``.iso`` and
          ``.sig``.

          For example,

          .. parsed-literal::

              ~(keystone_admin)]$ system --os-region-name SystemController load-import --active |installer-image-name|.iso |installer-image-name|.sig

        - The ISO imported via ``load-import --active`` must be at the same
          patch level as the system controller. This ensures that the subcloud
          boot image aligns with the patch level of the load to be installed on
          the subcloud.
        
    .. warning::
        
        If the patch level of load-imported ISO does not match the system controller
        patch level, the subcloud patch state may not align with the system
        controller patch state.

-   Run the :command:`load-import` command on controller-0 to import
    the new release.

    You can specify either the full file path or relative paths to the ``*.iso``
    bootimage file and to the ``*.sig`` bootimage signature file.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$ system load-import [--local] /home/sysadmin/<bootimage>.iso <bootimage>.sig

        +--------------------+-----------+
        | Property           | Value     |
        +--------------------+-----------+
        | id                 | 2         |
        | state              | importing |
        | software_version   | nn.nn     |
        | compatible_version | nn.nn     |
        | required_patches   |           |
        +--------------------+-----------+

    The :command:`load-import` must be done on controller-0.

    (Optional) If ``--local`` is specified, the ISO and sig files are
    uploaded directly from the active controller, where `<local_iso_file_path>`
    and `<local_sig_file_path>` are paths on the active controller to load
    ISO files and sig files respectively.

    .. note::

        If ``--local`` is specified, the ISO and sig files are transferred
        directly from the active controller filesystem to the load directory,
        if it is not specified, the files are transferred via the API.

    .. note::
        This will take a few minutes to complete.

    In order to deploy subclouds from either controller, all local
    files that are referenced in the ``subcloud-bootstrap-values.yaml`` file must exist
    on both controllers (for example, ``/home/sysadmin/docker-registry-ca-cert.pem``).

.. Greg updates required for -High Security Vulnerability Document Updates

.. rubric:: |proc|

#.  At the subcloud location, physically install the servers and network
    connectivity required for the subcloud.

    .. note::

       Do not power off the servers. The host portion of the server can be
       powered off, but the |BMC| portion of the server must be powered and
       accessible from the system controller.

       There is no need to wipe the disks.

    .. note::

       The servers require connectivity to a gateway router that provides IP
       routing between the subcloud management or admin subnet and the system controller
       management subnet, and between the subcloud |OAM| subnet and the
       system controller subnet.

    .. include:: /_includes/installing-a-subcloud-using-redfish-platform-management-service.rest
       :start-after: begin-ref-1
       :end-before: end-ref-1

#.  Create the ``subcloud-install-values.yaml`` file and use the content to pass the file
    into the :command:`dcmanager subcloud add` command, using the
    ``--install-values`` command option.

    .. note::

        If your controller is on a ZTSystems Triton server that requires a
        longer timeout value, you can now use the ``rd.net.timeout.ipv6dad``
        dracut parameter to specify an increased timeout value for dracut to
        wait for the interface to have carrier, and complete IPv6 duplicate
        address detection |DAD|. For the ZTSystems server, this can take more
        than four minutes. It is recommended to set this value to 300 seconds,
        by specifying the following in the ``subcloud-install-values.yaml``
        file:

        .. code-block:: none

            rd.net.timeout.ipv6dad: 300

    .. note::

        The ``wait_for_timeout`` value must be chosen based on your network
        performance (bandwidth, latency, and quality) and should be increased
        if the network does not meet the minimum or timeout requirements.
        The default value of 3600 seconds is based on a network bandwidth
        of 100 Mbps with a 50 ms delay.

        .. include:: /_includes/installing-a-subcloud-using-redfish-platform-management-service.rest
           :start-after: begin-syslimit
           :end-before: end-syslimit

    For example, :command:`--install-values /home/sysadmin/subcloud-install-values.yaml`.

    .. parsed-literal::

        # Specify the |prod| software version, for example 'nn.nn' for the |prod| nn.nn release of software.
        software_version: <software_version>
        bootstrap_interface: <bootstrap_interface_name> # e.g. eno1
        bootstrap_address: <bootstrap_interface_ip_address> # e.g.128.224.151.183
        bootstrap_address_prefix: <bootstrap_netmask> # e.g. 23

        # Board Management Controller
        bmc_address: <BMCs_IPv4_or_IPv6_address> # e.g. 128.224.64.180
        bmc_username: <bmc_username> # e.g. root

        # If the subcloud's bootstrap IP interface and the system controller are not on the
        # same network then the customer must configure a default route or static route
        # so that the Central Cloud can login bootstrap the newly installed subcloud.

        # If nexthop_gateway is specified and the network_address is not specified then a
        # default route will be configured. Otherwise, if a network_address is specified then
        # a static route will be configured.

        nexthop_gateway: <default_route_address> for  # e.g. 128.224.150.1 (required)
        network_address: <static_route_address>   # e.g. 128.224.144.0
        network_mask: <static_route_mask>         # e.g. 255.255.254.0

        # Installation type codes
        #0 - Standard Controller, Serial Console
        #1 - Standard Controller, Graphical Console
        #2 - AIO, Serial Console
        #3 - AIO, Graphical Console
        #4 - AIO Low-latency, Serial Console
        #5 - AIO Low-latency, Graphical Console
        install_type: 3

        # Optional parameters defaults can be modified by uncommenting the option with a modified value.

        # This option can be set to extend the installing stage timeout value
        # wait_for_timeout: 3600

        # Set this options for https
        no_check_certificate: True

        # If the bootstrap interface is a vlan interface then configure the vlan ID.
        # bootstrap_vlan: <vlan_id>

        # Override default filesystem device.
        # rootfs_device: "/dev/disk/by-path/pci-0000:00:1f.2-ata-1.0"
        # boot_device: "/dev/disk/by-path/pci-0000:00:1f.2-ata-1.0"

        # Set the value for persistent file system (/opt/platform-backup).
        # The value must be whole number (in MB) that is greater than or equal
        # to 30000.
        persistent_size: 30000

        # Configure custom arguments applied at boot within the installed subcloud.
        # Multiple boot arguments can be provided by separating each argument by a
        # single comma. Spaces are not allowed.
        # Example: extra_boot_params: multi-drivers-switch=cvl-2.54
        # extra_boot_params:

    .. _increase-subcloud-platform-backup-size:

    .. note::

        By default, 30GB is allocated for ``/opt/platform-backup``. If additional
        persistent disk space is required, the partition can be increased in the next
        subcloud reinstall using the following commands:

        -   To increase ``/opt/platform-backup`` to 40GB, add the **persistent_size: 40000**
            parameter to the ``subcloud-install-values.yaml`` file.

        -   Use the :command:`dcmanager subcloud update` command to save the
            configuration change for the next subcloud reinstall.

            .. code-block:: none

                ~(keystone_admin)]$ dcmanager subcloud update --install-values <subcloud-install-values.yaml> <subcloud-name>

        For a new subcloud deployment, use the :command:`dcmanager subcloud add`
        command with the ``subcloud-install-values.yaml`` file containing the desired
        ``persistent_size`` value.

#.  At the system controller, create a
    ``/home/sysadmin/subcloud-bootstrap-values.yaml`` overrides file for the
    subcloud.

    For example:

    .. code-block:: none

        system_mode: simplex
        name: "subcloud"

        description: "test"
        location: "loc"

        management_subnet: 192.168.101.0/24
        management_start_address: 192.168.101.2
        management_end_address: 192.168.101.50
        management_gateway_address: 192.168.101.1

        external_oam_subnet: 10.10.10.0/24
        external_oam_gateway_address: 10.10.10.1
        external_oam_floating_address: 10.10.10.12

        systemcontroller_gateway_address: 192.168.204.101

        docker_registries:
          k8s.gcr.io:
            url: registry.central:9001/k8s.gcr.io
          gcr.io:
            url: registry.central:9001/gcr.io
          ghcr.io:
            url: registry.central:9001/ghcr.io
          quay.io:
            url: registry.central:9001/quay.io
          docker.io:
            url: registry.central:9001/docker.io
          docker.elastic.co:
            url: registry.central:9001/docker.elastic.co
          registry.k8s.io:
            url: registry.central:9001/registry.k8s.io
          icr.io:
            url: registry.central:9001/icr.io
          defaults:
            username: sysinv
            password: <sysinv_password>
            type: docker

    Where <sysinv_password> can be found by running the following command as
    'sysadmin' on the Central Cloud:

    .. code-block:: none

        $ keyring get sysinv services

    In the above example, if the admin network is used for communication
    between the subcloud and system controller, then the
    ``management_gateway_address`` parameter should be replaced with admin
    subnet information.

    For example:

    .. code-block:: none

        management_subnet: 192.168.101.0/24
        management_start_address: 192.168.101.2
        management_end_address: 192.168.101.50
        admin_subnet: 192.168.102.0/24
        admin_start_address: 192.168.102.2
        admin_end_address: 192.168.102.50
        admin_gateway_address: 192.168.102.1

    This configuration will install container images from the local registry on
    your central cloud. The Central Cloud's local registry's HTTPS Certificate
    must have the Central Cloud's |OAM| IP, **registry.local** and
    **registry.central** in the certificate's |SAN| list. For example, a valid
    certificate contains a |SAN| list:

    .. code-block:: none

        "DNS.1: registry.local DNS.2: registry.central IP.1: floating_management IP.2: floating_OAM"

    If required, run the following command on the Central Cloud prior to
    bootstrapping the subcloud to install the new certificate for the Central
    Cloud with the updated |SAN| list:

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install -m docker_registry path_to_cert

    If you prefer to install container images from the default external
    registries, make the following substitutions for the **docker_registries**
    sections of the file.

    .. code-block:: none

        docker_registries:
          defaults:
           username: <your_default_registry_username>
           password: <your_default_registry_password>

    .. include:: /_includes/installing-a-subcloud-using-redfish-platform-management-service.rest
       :start-after: begin-subcloud-1
       :end-before: end-subcloud-1

#.  Add the subcloud using dcmanager.

    When calling the :command:`subcloud add` command, specify the install
    values, bootstrap values and the subcloud's sysadmin password.

    .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud add \
       --bootstrap-address <oam_ip_address_of_subclouds_controller-0> \
       --bootstrap-values /home/sysadmin/subcloud1-bootstrap-values.yaml \
       --sysadmin-password <sysadmin_password> \
       --deploy-config /home/sysadmin/subcloud1-deploy-config.yaml \
       --install-values /home/sysadmin/install-values.yaml \
       --bmc-password <bmc_password>

    If the ``--sysadmin-password`` is not specified, you are prompted to
    enter it once the full command is invoked. The password is masked
    when it is entered.

    .. code-block:: none

       Enter the sysadmin password for the subcloud:

    The ``--deploy-config`` option must reference the deployment configuration
    file mentioned above. In the deployment configurations, static routes from
    the management or admin interface of a subcloud to the system controller's
    management subnet must be explicitly listed. This ensures that the subcloud
    comes online after deployment. If the admin network is used for
    communication between the system controller and subcloud, the deployment
    configuration file must include both an admin network type and a management
    network type interface.

    (Optional) The ``--bmc-password <password>`` option is used for subcloud
    installation, and only required if the ``--install- values`` option is
    specified.

    If the ``--bmc-password <password>`` option is omitted and the
    ``--install-values`` option is specified the system administrator will be
    prompted to enter it, following the :command:`dcmanager subcloud add`
    command. This option is ignored if the ``--install-values`` option is not
    specified. The password is masked when it is entered.

    .. code-block:: none

       Enter the bmc password for the subcloud:

    The :command:`dcmanager subcloud show` or :command:`dcmanager subcloud list`
    command can be used to view subcloud add progress.



#.  At the Central Cloud / System Controller, monitor the progress of the
    subcloud install, bootstrapping, and deployment by using the deploy status
    field of the :command:`dcmanager subcloud list` command.

    .. include:: /shared/_includes/installing-a-subcloud.rest
        :start-after: begin-monitor-progress
        :end-before: end-monitor-progress

    .. caution::

        If there is an installation failure, or a failure during bootstrapping,
        you must delete the subcloud before re-adding it, using the
        :command:`dcmanager subcloud add` command. For more information on
        deleting, managing or unmanaging a subcloud, see :ref:`Managing
        Subclouds Using the CLI <managing-subclouds-using-the-cli>`.

        If there is a deployment failure, do not delete the subcloud, use the
        :command:`subcloud reconfig` command, to reconfigure the subcloud. For
        more information, see :ref:`Managing Subclouds Using the CLI
        <managing-subclouds-using-the-cli>`.


#.  If ``deploy_status`` shows an installation, bootstrap or deployment failure
    state, you can use the ``dcmanager subcloud errors`` command in order to get
    more detailed information about failure.

    For example:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ dcmanager subcloud errors 1
        FAILED bootstrapping playbook of (subcloud).
         detail: fatal: [subcloud]: FAILED! => changed=true
          failed_when_result: true
          msg: non-zero return code
            500 Server Error: Internal Server Error ("manifest unknown: manifest unknown")
             Image download failed: admin-2.cumulus.mss.com: 30093/wind-river/cloud-platform-deployment-manager: WRCP_22.06 500 Server Error: Internal Server Error ("Get https://admin-2.cumulus .mss.com: 30093/v2/: dial tcp: lookup admin-2.cumulus.mss.com on 10.41.0.1:53: read udp 10.41.1.3:40251->10.41.0.1:53: i/o timeout")
             Image download failed: gcd.io/kubebuilder/kube-rdac-proxy:v0.11.0 500 Server Error: Internal Server Error ("Get https://gcd.io/v2/: dial tcp: lookup gcd.io on 10.41.0.1:53: read udp 10.41.1.3:52485->10.41.0.1:53: i/o timeout")
            raise Exception("Failed to download images %s" % failed_downloads)
             Exception: Failed to download images ["admin-2.cumulus.mss.com: 30093/wind-river/cloud-platform-deployment-manager: WRCP_22.06", "gcd.io kubebuilder/kube-rdac-proxy:v0.11.0"]
        FAILED TASK: TASK [common/push-docker-images Download images and push to local registry] Wednesday 12 October 2022 12:27:31 +0000 (0:00:00.042)
        0:16:34.495


#.  You can also monitor detailed logging of the subcloud installation,
    bootstrapping and deployment by monitoring the following log files on the
    active controller in the Central Cloud.

    ``/var/log/dcmanager/ansible/<subcloud_name>_playbook_output.log``

    For example:

    .. code-block:: none

        controller-0:/home/sysadmin# tail /var/log/dcmanager/ansible/subcloud_playbook_output.log
        k8s.gcr.io: {password: secret, url: null}
        quay.io: {password: secret, url: null}
        )

        TASK [bootstrap/bringup-essential-services : Mark the bootstrap as completed] ***
        changed: [subcloud]

        PLAY RECAP *********************************************************************
        subcloud                  : ok=230  changed=137  unreachable=0    failed=0


    .. note::

        The subcloud_playbook_output.log can rotate, the previous log file will
        be subcloud_playbook_output.log.1.

.. rubric:: |postreq|

.. _installing-a-subcloud-using-redfish-platform-management-service-ul-ixy-lpv-kmb:

-   Provision the newly installed and bootstrapped subcloud.  For detailed
    |prod| deployment procedures for the desired deployment configuration of
    the subcloud, see the post-bootstrap steps of |inst-doc|.

-   Check and update docker registry credentials on the subcloud:

    .. code-block:: none

        REGISTRY="docker-registry"
        SECRET_UUID='system service-parameter-list | fgrep
        $REGISTRY | fgrep auth-secret | awk '{print $10}''
        SECRET_REF='openstack secret list | fgrep $
        {SECRET_UUID} | awk '{print $2}''
        openstack secret get ${SECRET_REF} --payload -f value

    The secret payload should be, ``username: sysinv password:<password>``. If
    the secret payload is, "username: admin password:<password>", see,
    :ref:`Updating Docker Registry Credentials on a Subcloud
    <updating-docker-registry-credentials-on-a-subcloud>` for more information.

-   For more information on bootstrapping and deploying, see the procedures
    listed under :ref:`install-a-subcloud`.

-   Add static route for nodes in subcloud to access openldap service.

    In DC system, openldap service is running on Central Cloud. In order for the nodes
    in the subclouds to access openldap service, such as ssh to the nodes as openldap
    users, a static route to the System Controller is required to be added in these
    nodes. This applies to controller nodes, worker nodes and storage nodes (nodes
    that have sssd running).

    The static route can be added on each of the nodes in the subcloud using system
    CLI.

    The following examples show how to add the static route in controller node and
    worker node:

    .. code-block:: none

        system host-route-add controller-0 mgmt0 <Central Cloud mgmt subnet> 64 <Gateway IP address>
        system host-route-add compute-0 mgmt0 <Central Cloud mgmt subnet> 64 <Gateway IP address>

    The static route can also be added using Deployment Manager by adding the route
    in its configuration file.

    The following examples show adding the route configuration in controller and
    worker host profiles of the deployment manager's configuration file:

    .. code-block:: none

        Controller node:
        ---
        apiVersion: starlingx.windriver.com/v1
        kind: HostProfile
        metadata:
          labels:
            controller-tools.k8s.io: "1.0"
          name: controller-0-profile
          namespace: deployment
        spec:
          administrativeState: unlocked
          bootDevice: /dev/disk/by-path/pci-0000:c3:00.0-nvme-1
          console: ttyS0,115200n8
          installOutput: text
          ......
          routes:
              - gateway: <Gateway IP address>
            activeinterface: mgmt0
            metric: 1
            prefix: 64
            subnet: <Central Cloud mgmt subnet>

        Worker node:
        ---
        apiVersion: starlingx.windriver.com/v1
        kind: HostProfile
        metadata:
          labels:
            controller-tools.k8s.io: "1.0"
          name: compute-0-profile
          namespace: deployment
        spec:
          administrativeState: unlocked
          boardManagement:
            credentials:
              password:
                secret: bmc-secret
            type: dynamic
          bootDevice: /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0
          clockSynchronization: ntp
          console: ttyS0,115200n8
          installOutput: text
          ......
          routes:
              - gateway: <Gateway IP address>
            interface: mgmt0
            metric: 1
            prefix: 64
            subnet: <Central Cloud mgmt subnet>
