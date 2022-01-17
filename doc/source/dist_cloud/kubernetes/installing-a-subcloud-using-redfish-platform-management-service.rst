
.. vbb1579292724479
.. _installing-a-subcloud-using-redfish-platform-management-service:

============================================================
Install a Subcloud Using Redfish Platform Management Service
============================================================

For subclouds with servers that support Redfish Virtual Media Service \(version
1.2 or higher\), you can use the Central Cloud's CLI to install the ISO and
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
    key entry in the /root/.ssh/known_hosts on the System Controller. In this
    case, delete the host key entry, if present, from /root/.ssh/known_hosts
    on the System Controller before doing reinstallations.

.. rubric:: |prereq|

.. _installing-a-subcloud-using-redfish-platform-management-service-ul-g5j-3f3-qjb:

-   The docker **rvmc** image needs to be added to the System Controller
    bootstrap override file, docker.io/starlingx/rvmc:stx.5.0-v1.0.0.

-   A new system CLI option ``--active`` is added to the
    :command:`load-import` command to allow the import into the
    System Controller /opt/dc-vault/loads. The purpose of this is to allow
    Redfish install of subclouds referencing a single full copy of the
    **bootimage.iso** at /opt/dc-vault/loads. \(Previously, the full
    **bootimage.iso** was duplicated for each :command:`subcloud add`
    command\).

    .. note::

        This is required only once and does not have to be done for every
        subcloud install.

        :command:`dcmanager` recognizes bootimage names ending in <.iso> and
        <.sig>

        For example,

        .. parsed-literal::

            ~(keystone_admin)]$ system --os-region-name SystemController load-import --active |installer-image-name|.iso |installer-image-name|.sig

    In order to be able to deploy subclouds from either controller, all local
    files that are referenced in the **bootstrap.yml** file must exist on both
    controllers \(for example, /home/sysadmin/docker-registry-ca-cert.pem\).


.. rubric:: |proc|

#.  At the subcloud location, physically install the servers and network
    connectivity required for the subcloud.

    .. note::

       Do not power off the servers. The host portion of the server can be
       powered off, but the |BMC| portion of the server must be powered and
       accessible from the System Controller.

       There is no need to wipe the disks.

    .. note::

       The servers require connectivity to a gateway router that provides IP
       routing between the subcloud management subnet and the System Controller
       management subnet, and between the subcloud |OAM| subnet and the
       System Controller subnet.

    .. include:: /_includes/installing-a-subcloud-using-redfish-platform-management-service.rest
       :start-after: begin-ref-1
       :end-before: end-ref-1

#.  Create the install-values.yaml file and use the content to pass the file
    into the :command:`dcmanager subcloud add` command, using the
    ``--install-values`` command option.

    .. note::

        If your controller is on a ZTSystems Triton server that requires a
        longer timeout value, you can now use the ``rd.net.timeout.ipv6dad``
        dracut parameter to specify an increased timeout value for dracut to
        wait for the interface to have carrier, and complete IPv6 duplicate
        address detection |DAD|. For the ZTSystems server, this can take more
        than four minutes. It is recommended to set this value to 300 seconds,
        by specifying the following in the ``subcloud install-values.yaml``
        file:

        .. code-block:: none

            rd.net.timeout.ipv6dad: 300

    For example, :command:`--install-values /home/sysadmin/install-values.yaml`.

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


#.  At the System Controller, create a
    ``/home/sysadmin/subcloud1-bootstrap-values.yaml`` overrides file for the
    subcloud.

    For example:

    .. code-block:: none

        system_mode: simplex
        name: "subcloud1"

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
          quay.io:
            url: registry.central:9001/quay.io
          docker.io:
            url: registry.central:9001/docker.io
          docker.elastic.co:
            url: registry.central:9001/docker.elastic.co
          defaults:
            username: sysinv
            password: <sysinv_password>
            type: docker

    Where <sysinv_password> can be found by running the following command as
    'sysadmin' on the Central Cloud:

    .. code-block:: none

        $ keyring get sysinv services

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

    .. only:: partner

        .. include:: /_includes/installing-a-subcloud-using-redfish-platform-management-service.rest
            :start-after: begin-prepare-files-to-copy-deployment-config
            :end-before: end-prepare-files-to-copy-deployment-config

#.  At the Central Cloud / System Controller, monitor the progress of the
    subcloud install, bootstrapping, and deployment by using the deploy status
    field of the :command:`dcmanager subcloud list` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list
        +----+-----------+------------+--------------+---------------+---------+
        | id | name      | management | availability | deploy status | sync    |
        +----+-----------+------------+--------------+---------------+---------+
        |  1 | subcloud1 | unmanaged  | online       | installing    | unknown |
        +----+-----------+------------+--------------+---------------+---------+

    The **deploy status** field has the following values:

    **Pre-Install**
        This status indicates that the ISO for the subcloud is being updated by
        the Central Cloud with the boot menu parameters, and kickstart
        configuration as specified in the install-values.yaml file.

    **Installing**
        This status indicates that the subcloud's ISO is being installed from
        the Central Cloud to the subcloud using the Redfish Virtual Media
        service on the subcloud's |BMC|.

    **Bootstrapping**
        This status indicates that the Ansible bootstrap of |prod-long|
        software on the subcloud's controller-0 is in progress.

    **Complete**
        This status indicates that subcloud deployment is complete.

    The subcloud install, bootstrapping and deployment can take up to 30
    minutes.

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

#.  You can also monitor detailed logging of the subcloud installation,
    bootstrapping and deployment by monitoring the following log files on the
    active controller in the Central Cloud.

    /var/log/dcmanager/<subcloud_name>_install_<date_stamp>.log.

    /var/log/dcmanager/<subcloud_name>_bootstrap_<date_stamp>.log.


    For example:

    .. code-block:: none

        controller-0:/home/sysadmin# tail /var/log/dcmanager/subcloud1_install_2019-09-23-19-19-42.log
        TASK [wait_for] ****************************************************************
        ok: [subcloud1]

        controller-0:/home/sysadmin# tail /var/log/dcmanager/subcloud1_bootstrap_2019-09-23-19-03-44.log
        k8s.gcr.io: {password: secret, url: null}
        quay.io: {password: secret, url: null}
        )

        TASK [bootstrap/bringup-essential-services : Mark the bootstrap as completed] ***
        changed: [subcloud1]

        PLAY RECAP *********************************************************************
        subcloud1                  : ok=230  changed=137  unreachable=0    failed=0


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

    The secret payload should be, "username: sysinv password:<password>". If
    the secret payload is, "username: admin password:<password>", see,
    :ref:`Updating Docker Registry Credentials on a Subcloud
    <updating-docker-registry-credentials-on-a-subcloud>` for more information.

-   For more information on bootstrapping and deploying, see the procedure
    `Install a subcloud
    <https://docs.starlingx.io/deploy_install_guides/r5_release/distributed_cloud/index.html#install-a-subcloud>`__,
    step 4.

