
.. jcc1605727727548
.. _config-and-management-using-container-backed-remote-clis-and-clients:

============================================
Use Container-backed Remote CLIs and Clients
============================================

Remote openstack |CLIs| can be used in any shell after sourcing the generated
remote |CLI|/client RC file. This RC file sets up the required environment
variables and aliases for the remote |CLI| commands.

.. note::
    For a Distributed Cloud system, navigate to **Project** \> **Central Cloud Regions** \> **RegionOne** \>
    and download the **Openstack RC file**.

.. rubric:: |context|

.. note::
    If you specified repositories that require authentication when configuring
    the container-backed remote |CLIs|, you must perform a :command:`docker
    login` to that repository before using remote |CLIs| for the first time

.. rubric:: |prereq|

.. _config-and-management-using-container-backed-remote-clis-and-clients-ul-lgr-btf-14b:

-   Consider adding the following command to your .login or shell rc file, such
    that your shells will automatically be initialized with the environment
    variables and aliases for the remote |CLI| commands. Otherwise, execute it
    before proceeding:

    .. code-block:: none

        $ source remote_client_openstack.sh

-   You must have completed the configuration steps in :ref:`Configure Remote
    CLIs <configure-remote-clis-and-clients>` before proceeding.

.. rubric:: |proc|

-   Test workstation access to the remote OpenStack |CLI|.

    Enter your OpenStack password when prompted.

    .. note::
        The first usage of a command will be slow as it requires that the
        docker image supporting the remote clients be pulled from the remote
        registry.

    .. code-block:: none

        root@myclient:/home/user/remote_cli_wd# source remote_client_openstack.sh
        Please enter your OpenStack Password for project admin as user admin:
        root@myclient:/home/user/remote_cli_wd# openstack endpoint list
        +----------------------------------+-----------+--------------+-----------------+---------+-----------+------------------------------------------------------------+
        | ID                               | Region    | Service Name | Service Type    | Enabled | Interface | URL                                                        |
        +----------------------------------+-----------+--------------+-----------------+---------+-----------+------------------------------------------------------------+
        | 0342460b877d4d0db407580a2bb13733 | RegionOne | glance       | image           | True    | internal  | http://glance.openstack.svc.cluster.local/                 |
        | 047a2a63a53a4178b8ae1d093487e99e | RegionOne | keystone     | identity        | True    | internal  | http://keystone.openstack.svc.cluster.local/v3             |
        | 05d5d4bbffb842fea0f81c9eb2784f05 | RegionOne | keystone     | identity        | True    | public    | http://keystone.openstack.svc.cluster.local/v3             |
        | 07195197201441f9b065dde45c94ef2b | RegionOne | keystone     | identity        | True    | admin     | http://keystone.openstack.svc.cluster.local/v3             |
        | 0f5c6d0bc626409faedb207b84998e74 | RegionOne | heat-cfn     | cloudformation  | True    | admin     | http://cloudformation.openstack.svc.cluster.local/v1       |
        | 16806fa22ca744298e5a7ce480bcb885 | RegionOne | cinderv2     | volumev2        | True    | admin     | http://cinder.openstack.svc.cluster.local/v2/%(tenant_id)s |
        | 176cd2168303457fbaf24fca96c6195e | RegionOne | neutron      | network         | True    | admin     | http://neutron.openstack.svc.cluster.local/                |
        | 21bd7488f8e44a9787f7b3301e666da8 | RegionOne | heat         | orchestration   | True    | admin     | http://heat.openstack.svc.cluster.local/v1/%(project_id)s  |
        | 356fa0758af44a72adeec421ccaf2f2a | RegionOne | nova         | compute         | True    | admin     | http://nova.openstack.svc.cluster.local/v2.1/%(tenant_id)s |
        | 35a42c23cb8841958885b8b01defa839 | RegionOne | fm           | faultmanagement | True    | admin     | http://fm.openstack.svc.cluster.local/                     |
        | 37dfe2902a834efdbdcd9f2b9cf2c6e7 | RegionOne | cinder       | volume          | True    | internal  | http://cinder.openstack.svc.cluster.local/v1/%(tenant_id)s |
        | 3d94abf91e334a74bdb01d8fad455a38 | RegionOne | cinderv2     | volumev2        | True    | public    | http://cinder.openstack.svc.cluster.local/v2/%(tenant_id)s |
        | 433f1e8860ff4d57a7eb64e6ae8669bd | RegionOne | cinder       | volume          | True    | public    | http://cinder.openstack.svc.cluster.local/v1/%(tenant_id)s |
        | 454b21f41806464580a1f6290cb228ec | RegionOne | placement    | placement       | True    | public    | http://placement.openstack.svc.cluster.local/              |
        | 561be1aa00da4e4fa64791110ed99852 | RegionOne | heat-cfn     | cloudformation  | True    | public    | http://cloudformation.openstack.svc.cluster.local/v1       |
        | 6068407def6b4a38b862c89047319f77 | RegionOne | cinderv3     | volumev3        | True    | admin     | http://cinder.openstack.svc.cluster.local/v3/%(tenant_id)s |
        | 77e886bc903a4484a25944c1e99bdf1f | RegionOne | nova         | compute         | True    | internal  | http://nova.openstack.svc.cluster.local/v2.1/%(tenant_id)s |
        | 7c3e0ce3b69d45878c1152473719107c | RegionOne | fm           | faultmanagement | True    | internal  | http://fm.openstack.svc.cluster.local/                     |
        +----------------------------------+-----------+--------------+-----------------+---------+-----------+------------------------------------------------------------+
        root@myclient:/home/user/remote_cli_wd# openstack volume list --all-projects
        +--------------------------------------+-----------+-----------+------+-------------+
        | ID                                   | Name      | Status    | Size | Attached to |
        +--------------------------------------+-----------+-----------+------+-------------+
        | f2421d88-69e8-4e2f-b8aa-abd7fb4de1c5 | my-volume | available |    8 |             |
        +--------------------------------------+-----------+-----------+------+-------------+
        root@myclient:/home/user/remote_cli_wd#

    .. note::
        Some commands used by remote |CLI| are designed to leave you in a shell
        prompt, for example:

        .. code-block:: none

            root@myclient:/home/user/remote_cli_wd# openstack

        In some cases the mechanism for identifying commands that should leave
        you at a shell prompt does not identify them correctly. If you
        encounter such scenarios, you can force-enable or disable the shell
        options using the <FORCE\_SHELL> or <FORCE\_NO\_SHELL> variables before
        the command.

        You cannot use both variables at the same time.

-   If you need to run a remote |CLI| command that references a local file, then
    that file must be copied to or created in the working directory specified on
    the ./config\_client.sh command and referenced as under /wd/ in the actual
    command.

    For example:

    .. code-block:: none

        root@myclient:/home/user# cd $HOME/remote_cli_wd
        root@myclient:/home/user/remote_cli_wd# openstack image create --public
        --disk-format qcow2 --container-format bare --file ubuntu.qcow2
        ubuntu_image



