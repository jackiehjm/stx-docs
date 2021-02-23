
.. qyd1591806439568
.. _listing-uploaded-device-images:

===========================
List Uploaded Device Images
===========================

Use the :command:`device-image-list` command to review currently uploaded
images.

.. rubric:: |proc|

-   Run the command as shown:

    .. code-block:: none

        ~(keystone_admin)$ system device-image-list
        +------------+----------------+------------+------------+--------------+---------------+---------------+------+-------------+---------------+----------------+
        | uuid       | bitstream_type | pci_vendor | pci_device | bitstream_id | key_signature | revoke_key_id | name | description | image_version | applied_labels |
        +------------+----------------+------------+------------+--------------+---------------+---------------+------+-------------+---------------+----------------+
        | 12032cbe...| functional     | 8086       | 0b30       | abcd         | None          | None          | None | None        | None          | None           |
        | 14bd033c...| key-revocation | 8086       | 0b30       | None         | None          | 123           | None | None        | None          | None           |
        | 04ab84e3...| key-revocation | 8086       | 0b30       | None         | None          | 555           | None | None        | None          | None           |
        | 0b15ad7b...| root-key       | 8086       | 0b30       | None         | a123          | None          | None | None        | None          | None           |
        +------------+----------------+------------+------------+--------------+---------------+---------------+------+-------------+---------------+----------------+
