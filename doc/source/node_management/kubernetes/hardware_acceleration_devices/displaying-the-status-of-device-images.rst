
.. fdr1591809924245
.. _displaying-the-status-of-device-images:

===================================
Display the Status of Device Images
===================================

Use the :command:`device-image-state-list` command to review the state of
applied device images

.. rubric:: |proc|

-   Run the following command.

    .. code-block:: none

        ~(keystone_admin)$ system device-image-state-list

    This will produce output similar to:

    .. code-block:: none

        +--------------+--------------------+--------------------------------------+---------+-------------------+------------+
        | hostname     | PCI device address | Device image uuid                    | status  | Update start time | updated_at |
        +--------------+--------------------+--------------------------------------+---------+-------------------+------------+
        | controller-0 | 0000:b3:00.0       | 12032cbe-1d78-4813-847a-649e3bb1fb4d | pending | None              | None       |
        +--------------+--------------------+--------------------------------------+---------+-------------------+------------+
