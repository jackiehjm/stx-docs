
.. pja1558616715987
.. _installing-a-subcloud-without-redfish-platform-management-service:

==============================================================
Install a Subcloud Without Redfish Platform Management Service
==============================================================

For subclouds with servers that do not support Redfish Virtual Media Service,
the ISO is installed locally at the subcloud. You can use the Central Cloud's
CLI to bootstrap subclouds from the Central Cloud.


.. _installing-a-subcloud-without-redfish-platform-management-service-section-N10027-N10024-N10001:

.. rubric:: |context|

After physically installing the hardware and network connectivity of a
subcloud, the subcloud installation process has two phases:


.. _installing-a-subcloud-without-redfish-platform-management-service-ul-fmx-jpl-mkb:

-   Installing the ISO on controller-0; this is done locally at the subcloud by
    using either, a bootable USB device, or a local PXE boot server

-   Executing the :command:`dcmanager subcloud add` command in the Central
    Cloud that uses Ansible to bootstrap |prod-long| on controller-0 in
    the subcloud


.. note::

    After a successful remote installation of a subcloud in a Distributed Cloud
    system, a subsequent remote reinstallation fails because of an existing ssh
    key entry in the /root/.ssh/known\_hosts on the System Controller. In this
    case, delete the host key entry, if present, from /root/.ssh/known\_hosts
    on the System Controller before doing reinstallations.

.. rubric:: |prereq|

.. _installing-a-subcloud-without-redfish-platform-management-service-ul-g5j-3f3-qjb:

.. only:: partner

    .. include:: /_includes/installing-a-subcloud-without-redfish-platform-management-service.rest
       :start-after: prereq-begin
       :end-before:  prereq-end

-   You must have downloaded ``update-iso.sh`` from |dnload-loc|.

-   In order to be able to deploy subclouds from either controller, all local
    files that are referenced in the **bootstrap.yml** file must exist on both
    controllers \(for example, ``/home/sysadmin/docker-registry-ca-cert.pem``\).

.. rubric:: |proc|

#.  At the subcloud location, physically install the servers and network
    connectivity required for the subcloud.

    .. note::

        The servers require connectivity to a gateway router that provides IP
        routing between the subcloud management subnet and the System
        Controller management subnet, and between the subcloud OAM subnet and
        the System Controller subnet.

    .. include:: /_includes/installing-a-subcloud-without-redfish-platform-management-service.rest
       :start-after: begin-ref-1
       :end-before: end-ref-1

#.  Update the ISO image to modify installation boot parameters \(if
    required\), automatically select boot menu options and add a kickstart file
    to automatically perform configurations such as configuring the initial IP
    Interface for bootstrapping.

    For subclouds, the initial IP Interface should be the planned |OAM| IP
    Interface for the subcloud.

    Use the ``update-iso.sh`` script from |dnload-loc|. The script is used as
    follows:

    .. code-block:: none

        update-iso.sh -i <input bootimage.iso> -o <output bootimage.iso>
                        [ -a <ks-addon.cfg> ] [ -p param=value ]
                        [ -d <default menu option> ] [ -t <menu timeout> ]
             -i <file>: Specify input ISO file
             -o <file>: Specify output ISO file
             -a <file>: Specify ks-addon.cfg file

             -p <p=v>:  Specify boot parameter
                        Examples:
                        -p rootfs_device=nvme0n1
                        -p boot_device=nvme0n1

                        -p rootfs_device=/dev/disk/by-path/pci-0000:00:0d.0-ata-1.0
                        -p boot_device=/dev/disk/by-path/pci-0000:00:0d.0-ata-1.0

             -d <default menu option>:
                        Specify default boot menu option:
                        0 - Standard Controller, Serial Console
                        1 - Standard Controller, Graphical Console
                        2 - AIO, Serial Console
                        3 - AIO, Graphical Console
                        4 - AIO Low-latency, Serial Console
                        5 - AIO Low-latency, Graphical Console
                        NULL - Clear default selection
             -t <menu timeout>:
                        Specify boot menu timeout, in seconds


    The following example ks-addon.cfg, used with the -a option, sets up an
    initial IP interface at boot time by defining a |VLAN| on an Ethernet
    interface and has it use DHCP to request an IP address:

    .. code-block:: none

        #### start ks-addon.cfg
        OAM_DEV=enp0s3
        OAM_VLAN=1234

        cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$OAM_DEV
        DEVICE=$OAM_DEV
        BOOTPROTO=none
        ONBOOT=yes
        LINKDELAY=20
        EOF

        cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$OAM_DEV.$OAM_VLAN
        DEVICE=$OAM_DEV.$OAM_VLAN
        BOOTPROTO=dhcp
        ONBOOT=yes
        VLAN=yes
        LINKDELAY=20
        EOF
        #### end ks-addon.cfg

    After updating the ISO image, create a bootable USB with the ISO or put the
    ISO on a PXEBOOT server.

#.  At the subcloud location, install the |prod| software from a USB
    device or a |PXE| Boot Server on the server designated as controller-0.

    .. include:: /_includes/installing-a-subcloud-without-redfish-platform-management-service.rest
       :start-after: begin-ref-1
       :end-before: end-ref-1

#.  At the subcloud location, verify that the |OAM| interface on the subcloud
    controller has been properly configured by the kickstart file added to the
    ISO.

#.  Log in to the subcloud's controller-0 and ping the Central Cloud's floating
    |OAM| IP Address.

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
          ghcr.io:
            url: registry.central:9001/ghcr.io
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


    Where <sysinv\_password\> can be found by running the following command
    as 'sysadmin' on the Central Cloud:

    .. code-block:: none

        $ keyring get sysinv services

    This configuration uses the local registry on your central cloud. If you
    prefer to use the default external registries, make the following
    substitutions for the **docker\_registries** and
    **additional\_local\_registry\_images** sections of the file.

    .. code-block:: none

        docker_registries:
          defaults:
           username: <your_wrs-aws.io_username>
           password: <your_wrs-aws.io_password>

    .. note::

        If you have a reason not to use the Central Cloud's local registry you
        can pull the images from another local private docker registry.

#.  You can use the Central Cloud's local registry to pull images on subclouds.
    The Central Cloud's local registry's HTTPS certificate must have the
    Central Cloud's |OAM| IP, **registry.local** and **registry.central** in the
    certificate's |SAN| list. For example, a valid certificate contains a |SAN|
    list **"DNS.1: registry.local DNS.2: registry.central IP.1: <floating
    management\> IP.2: <floating OAM\>"**.

    If required, run the following command on the Central Cloud prior to
    bootstrapping the subcloud to install the new certificate for the Central
    Cloud with the updated |SAN| list:

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install -m docker_registry path_to_cert

    .. only:: partner

        .. include:: /_includes/installing-a-subcloud-without-redfish-platform-management-service.rest
            :start-after: begin-prepare-files-to-copy-deployment-config
            :end-before: end-prepare-files-to-copy-deployment-config

#.  At the Central Cloud / System Controller, monitor the progress of the
    subcloud bootstrapping and deployment by using the deploy status field of
    the :command:`dcmanager subcloud list` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list
        +----+-----------+------------+--------------+---------------+---------+
        | id | name      | management | availability | deploy status | sync    |
        +----+-----------+------------+--------------+---------------+---------+
        |  1 | subcloud1 | unmanaged  | online       | complete      | unknown |
        +----+-----------+------------+--------------+---------------+---------+

    The deploy status field has the following values:

    **Bootstrapping**
        This status indicates that the Ansible bootstrap of |prod-long|
        Platform software on the subcloud's controller-0 is in progress.

    **Complete**
        This status indicates that subcloud deployment is complete.

    The subcloud bootstrapping and deployment can take up to 30 minutes.

    .. caution::
        If there is a failure during bootstrapping, you must delete the
        subcloud before re-adding it, using the :command:`dcmanager subcloud
        add` command. For more information on deleting, managing or unmanaging
        a subcloud, see :ref:`Managing Subclouds Using the CLI
        <managing-subclouds-using-the-cli>`.

#.  You can also monitor detailed logging of the subcloud bootstrapping and
    deployment by monitoring the following log files on the active controller
    in the Central Cloud.

    ``/var/log/dcmanager/ansible/<subcloud\_name>\_bootstrap.log``

    For example:

    .. code-block:: none

        controller-0:/home/sysadmin# tail /var/log/dcmanager/ansible/subcloud1_bootstrap.log
        k8s.gcr.io: {password: secret, url: null}
        quay.io: {password: secret, url: null}
        )

        TASK [bootstrap/bringup-essential-services : Mark the bootstrap as completed] ***
        changed: [subcloud1]

        PLAY RECAP *********************************************************************
        subcloud1                  : ok=230  changed=137  unreachable=0    failed=0


.. rubric:: |postreq|

.. _installing-a-subcloud-without-redfish-platform-management-service-ul-ixy-lpv-kmb:

-   Provision the newly installed and bootstrapped subcloud.  For detailed
    |prod| deployment procedures for the desired deployment configuration of
    the subcloud, see the post-bootstrap steps of the |_link-inst-book|.

-   Check and update docker registry credentials on the subcloud:

    .. code-block:: none

        REGISTRY="docker-registry"
        SECRET_UUID='system service-parameter-list | fgrep
        $REGISTRY | fgrep auth-secret | awk '{print $10}''
        SECRET_REF='openstack secret list | fgrep $
        {SECRET_UUID} | awk '{print $2}''
        openstack secret get ${SECRET_REF} --payload -f value

    The secret payload should be :command:`username: sysinv password:<password>`.
    If the secret payload is :command:`username: admin password:<password>`,
    see, :ref:`Updating Docker Registry Credentials on a
    Subcloud <updating-docker-registry-credentials-on-a-subcloud>` for more
    information.

-   For more information on bootstrapping and deploying, see the procedure
    `Install a subcloud
    <https://docs.starlingx.io/deploy_install_guides/r5_release/distributed_cloud/index.html#install-a-subcloud>`__,
    step 4.


