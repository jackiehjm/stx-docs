
.. dkn1600946881404
.. _dkn1600946881404:

======================================================
Assign a Dedicated VLAN ID to a Target Project Network
======================================================

To assign a dedicated VLAN segment ID you must first enable the Neutron
**segments** plugin.

.. rubric:: |proc|

#.  Create a Helm overrides file to customize your Neutron configuration.

    The file must load the **segments** plugin. For example:

    .. code-block:: none

        ...
        conf:
        neutron:
           DEFAULT:
             service_plugins:
             - router
             - network_segment_range
             - segments
        ...

#.  If you have not done so already, upload the |prefix|-openstack application
    charts.

    For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system application-upload |prefix|-openstack-20.10-0.tgz

#.  Update the |prefix|-openstack application using the overrides file created above.

    Assuming you named the file neutron-overrides.yaml, run:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update |prefix|-openstack neutron openstack --values neutron-overrides.yaml

    You can check on the status of the update using the
    :command:`system helm-override-show` command. For example:

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-show |prefix|-openstack neutron openstack
        +--------------------+---------------------------------------------------------------------------------------------------------------------+
        | Property           | Value                                                                                                               |
        +--------------------+---------------------------------------------------------------------------------------------------------------------+
        | attributes         | enabled: true                                                                                                       |
        |                    |                                                                                                                     |
        | combined_overrides | conf:                                                                                                               |
        |                    |   dhcp_agent:                                                                                                       |
        |                    |     DEFAULT:                                                                                                        |
        |                    |       interface_driver: networking_avs.neutron.agent.avs_manager.interface.VSwitchInterfaceDriver                   |
        |                    |   neutron:                                                                                                          |
        |                    |                                                                                                                     |
        | ...                | ...                                                                                                                 |
        |                    |                                                                                                                     |
        | user_overrides     | conf:                                                                                                               |
        |                    |   neutron:                                                                                                          |
        |                    |     DEFAULT:                                                                                                        |
        |                    |       service_plugins:                                                                                              |
        |                    |       - router                                                                                                      |
        |                    |       - network_segment_range                                                                                       |
        |                    |       - segments                                                                                                    |
        |                    |                                                                                                                     |
        +--------------------+---------------------------------------------------------------------------------------------------------------------+


#.  Apply the |prefix|-openstack application.

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

#.  You can now assign the VLAN network type to a datanetwork.

    #.  Identify the name of the data network to assign.

        List the available data networks and identify one to use in the heat
        template as:

        .. code-block:: none

            physical_network: <datanetworkname>

        In this example, we use **datanet-1**.

    #.  Create a heat template.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > my_heat_template.yml
            heat_template_version: 2017-09-01

            resources:

              external01:
                type: OS::Neutron::Net
                properties:
                  name: external001
                  shared: "true"

              # Network segement
              segement01:
                type: OS::Neutron::Segment
                properties:
                  network: { get_resource: external01 }
                  network_type: "vlan"
                  physical_network: "datanet-1"
                  segmentation_id: 2111

              external01-subnet:
                type: OS::Neutron::Subnet
                properties:
                  network: { get_resource: external01 }
                  name: external02-subnet
                  cidr: 10.10.10.0/24
                  segment: { get_resource: segement01 }
            EOF

    #.  Apply the template.

        .. code-block:: none

            ~(keystone_admin)]$ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
            ~(keystone_admin)]$ openstack stack create -t my_heat_template.yml --wait test1-st
            2020-10-16 21:20:34Z [test1-st]: CREATE_IN_PROGRESS Stack CREATE started
            2020-10-16 21:20:34Z [test1-st.external01]: CREATE_IN_PROGRESS state changed
            2020-10-16 21:20:35Z [test1-st.external01]: CREATE_COMPLETE state changed
            2020-10-16 21:20:35Z [test1-st.segement01]: CREATE_IN_PROGRESS state changed
            2020-10-16 21:20:37Z [test1-st.segement01]: CREATE_COMPLETE state changed
            2020-10-16 21:20:37Z [test1-st.external01-subnet]: CREATE_IN_PROGRESS state changed
            2020-10-16 21:20:38Z [test1-st.external01-subnet]: CREATE_COMPLETE state changed
            2020-10-16 21:20:38Z [test1-st]: CREATE_COMPLETE Stack CREATE completed successfully


#.  Confirm the configuration.

    #.  List network segments.

        .. code-block:: none

            ~(keystone_admin)]$ openstack network segment list
            +--------------------------------------+--------------------------------------------+--------------------------------------+--------------+---------+
            | ID                                   | Name                                       | Network                              | Network Type | Segment |
            +--------------------------------------+--------------------------------------------+--------------------------------------+--------------+---------+
            | 502e3f4f-6187-4737-b1f5-1be7fd3fc45e | test1-st-segement01-mx6fa5eonzrr           | 6bbd3e4e-9419-49c6-a68a-ed51fbc1cab7 | vlan         |    2111 |
            | faf63edf-63f0-4e9b-b930-5fa8f43b5484 | None                                       | 865b9576-1815-4734-a7e4-c2d0dd31d19c | vlan         |    2001 |
            +--------------------------------------+--------------------------------------------+--------------------------------------+--------------+---------+

    #.  List subnets.

        .. code-block:: none

            ~(keystone_admin)]$ openstack subnet list
            +------------...----+---------------------+---------------...-----+------------------+
            | ID         ...    | Name                | Network       ...     | Subnet           |
            +------------...----+---------------------+---------------...-----+------------------+
            | 0f64c277-82...f2f | external01-subnet   | 6bbd3e4e-9419-...cab7 | 10.10.10.0/24    |
            | bb9848b6-4b...ddc | subnet-temp         | 865b9576-1815-...d19c | 192.168.17.0/24  |
            +------------...----+---------------------+-----------------------+------------------+

        In this example, the subnet external01-subnet uses a dedicated segment ID.

    #.  Listing details for the subnet shows that it uses the segment ID created earlier.

        .. code-block:: none

            ~(keystone_admin)]$ openstack subnet show 0f64c277-82d7-4161-aa47-fc4cfadacf2f

        The output from this command is a row from ascii table output, it
        displays the following:

        .. code-block:: none

            |grep segment | segment_id | 502e3f4f-6187-4737-b1f5-1be7fd3fc45e |

    .. note::
        Dedicated segment IDs should not be in the range created using the
        :command:`openstack network segment range create` commands. This can
        cause conflict errors.