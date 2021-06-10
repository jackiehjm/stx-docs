..
.. _update-the-registry-secrets:

===================================
Update the Registries' Auth-Secrets
===================================

This step must be performed only if there are existing entries when displaying
the registries' auth-secrets.

When required, use the appropriate username and password.

.. rubric:: |proc|

To update the auth-secrets for the new registries, use the following command:

.. code-block:: none

    NEW_USERNAME_PASSWORD="username:docker password:********"

    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry
    do
    secret=`openstack secret list | grep ${registry}-secret | awk '{print $2}'`
    openstack secret delete ${secret}
    openstack secret store -n ${registry}-secret -p "${NEW_USERNAME_PASSWORD}"
    secret_uuid=`openstack secret list |grep ${registry}-secret | awk '{print $2}' | awk -F/ '{print $6}'`
    system service-parameter-modify docker  ${registry} auth-secret=${secret_uuid}
    done

You will get the following output:

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/d71b2577-1204-4c65-89b3-a29562343b2c |
    | Name          | docker-registry-secret                                                 |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

.. code-block:: none

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 9c268c25-e971-4e2c-927e-78f2f0332b63 |
    | service     | docker                               |
    | section     | docker-registry                      |
    | name        | auth-secret                          |
    | value       | d71b2577-1204-4c65-89b3-a29562343b2c |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/7d7c0bff-eaed-4a5a-8877-dbedc7491c95 |
    | Name          | quay-registry-secret                                                   |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

.. code-block:: none

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | fa85e427-1f97-4e4c-9ab8-f048344b0fd0 |
    | service     | docker                               |
    | section     | quay-registry                        |
    | name        | auth-secret                          |
    | value       | 7d7c0bff-eaed-4a5a-8877-dbedc7491c95 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/40e6f308-62b5-4f90-b457-b6770864de8d |
    | Name          | elastic-registry-secret                                                |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

.. code-block:: none

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 009eff20-ed1a-4259-998e-616dd40fb3da |
    | service     | docker                               |
    | section     | elastic-registry                     |
    | name        | auth-secret                          |
    | value       | 40e6f308-62b5-4f90-b457-b6770864de8d |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/a7d4319d-a6b9-41c1-9de1-ad7c56678a48 |
    | Name          | gcr-registry-secret                                                    |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

.. code-block:: none

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 665e3183-f27a-4fc6-a2a5-59cd041ee00e |
    | service     | docker                               |
    | section     | gcr-registry                         |
    | name        | auth-secret                          |
    | value       | a7d4319d-a6b9-41c1-9de1-ad7c56678a48 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/52126ffe-6e1c-4295-b4b0-6095787c87ed |
    | Name          | k8s-registry-secret                                                    |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

.. code-block:: none

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 0b02bf15-e830-4196-a867-6e52bcbd0c6e |
    | service     | docker                               |
    | section     | k8s-registry                         |
    | name        | auth-secret                          |
    | value       | 52126ffe-6e1c-4295-b4b0-6095787c87ed |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

To verify the registry secret changes, go to :ref:`Verify the Registries'
Secret Configuration Changes
<verify-the-registry-secret-changes-and-secret-key-in-system-database>`.