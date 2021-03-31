
.. jow1411739340460
.. _adding-segmentation-ranges-using-the-cli:

=====================================
Add Segmentation Ranges Using the CLI
=====================================

You can use the CLI to add segmentation ranges to data networks.

.. rubric:: |proc|

.. _adding-segmentation-ranges-using-the-cli-steps-scn-pxd-4p:

#.  Use the :command:`openstack network segment range` command to create
    VLAN/VXLAN segmentation ranges.

    This example creates segmentation ranges on data network **data-net-a**.

    .. code-block:: none

        ~(keystone_admin)]$ openstack network segment range create segment-a-common \
            --description "Shared segmentation range"
            --physical-network data-net-a \
            --network-type vlan \
            --minimum 10 \
            --maximum 10 \

        ~(keystone_admin)]$ openstack network segment range create segment-a-project1 \
            --private \
            --project ${project1_UUID} \
            --physical-network data-net-a \
            --network-type vlan \
            --minimum 623
            --maximum 623

        ~(keystone_admin)]$ openstack network segment range create segment-a-project2 \
            --private \
            --project ${project2_UUID} \
            --physical-network data-net-b \
            --network-type vlan \
            --minimum 664 \
            --maximum 680

    where

    **<name>**
        name of the segment is a positional argument and can be supplied at the
        beginning or the end of the :command:`openstack network segment range
        create` command.

        This is not a named option.

    **description**
        is a description of the segmentation range.

    **private**
        is an flag to denote this is a segmentation range for a single project.

    **project**
        is the name or UUID of the project associated with the range.

    **physical-network**
        is the data network associated with the range.

    **network type**
        is the network type \(VLAN/VXLAN\) of the range.

    **minimum**
        is the minimum value of the segmentation range.

    **maximum**
        is the maximum value of the segmentation range.

.. rubric:: |result|

You can also obtain information about segmentation ranges using the following command:

.. code-block:: none

    ~(keystone_admin)]$ openstack network segment range show <range_name_or_uuid>