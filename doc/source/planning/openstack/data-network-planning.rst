
.. jow1404333738594
.. _data-network-planning:

=====================
Data Network Planning
=====================

Data networks are the payload-carrying networks used implicitly by end users
when they move traffic over their project networks.

You can review details for existing data networks using OpenStack Horizon Web
interface or the CLI.

When planning data networks, you must consider the following guidelines:


.. _data-network-planning-ul-cmp-rl2-4n:

-   From the point of view of the projects, all networking happens over the
    project networks created by them, or by the **admin** user on their behalf.
    Projects are not necessarily aware of the available data networks. In fact,
    they cannot create project networks over data networks not already
    accessible to them. For this reason, the system administrator must ensure
    that proper communication mechanisms are in place for projects to request
    access to specific data networks when required.

    For example, a project may be interested in creating a new project network
    with access to a specific network access device in the data center, such as
    an access point for a wireless transport. In this case, the system
    administrator must create a new project network on behalf of the project,
    using a |VLAN| ID in the project's segmentation range that provides
    connectivity to the said network access point.

-   Consider how different offerings of bandwidth, throughput commitments, and
    class-of-service, can be used by your users. Having different data network
    offerings available to your projects enables end users to diversify their
    own portfolio of services. This in turn gives the |prod-os| administration
    an opportunity to put different revenue models in place.

-   For the IPv4 address plan, consider the following:


    -   Project networks attached to a public network, such as the Internet,
        have to have external addresses assigned to them. You must therefore
        plan for valid definitions of their IPv4 subnets and default gateways.

    -   As with the |OAM| network, you must ensure that suitable firewall
        services are in place on any project network with a public address.


-   Segmentation ranges may be owned by the administrator, a specific project,
    or may be shared by all projects. With this ownership model:

    -   A base deployment scenario has each compute node using a single data
        interface defined over a single data network. In this scenario, all
        required project networks can be instantiated making use of the
        available |VLANs| or |VNIs| in each corresponding segmentation range.
        You may need more than one data network when the underlying physical
        networks demand different |MTU| sizes, or when boundaries between data
        networks are dictated by policy or other non-technical considerations.

    -   Segmentation ranges can be reserved and assigned on-demand without
        having to lock and unlock the compute nodes. This facilitates
        day-to-day operations which can be performed without any disruption to
        the running environment.

-   In some circumstances, data networks can be configured to support |VLAN|
    Transparent mode on project networks. In this mode |VLAN| tagged packets
    are encapsulated within a data network segment without removing or
    modifying the guest |VLAN| tag\(s).
