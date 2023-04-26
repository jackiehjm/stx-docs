..
.. _create-the-registry-secrets:

===================================
Create the Registries' Auth-Secrets
===================================

This step must be performed only if no entries were listed when displaying the
registries' auth-secrets. When required, use the appropriate username and
password.

.. rubric:: |proc|

To create the auth-secrets for the new registries, use the following command:

.. code-block:: none

    NEW_USERNAME_PASSWORD="username:docker password:********"

    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry
    do
    openstack secret store -n ${registry}-secret -p "${NEW_USERNAME_PASSWORD}"
    secret_uuid=`openstack secret list |grep ${registry}-secret | awk '{print $2}' | awk -F/ '{print $6}'`
    system service-parameter-add docker  ${registry} auth-secret=${secret_uuid}
    done

You will get the following output:

.. code-block:: none

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/d82f1653-4718-429c-b6d5-0fc3e27d32f9 |
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

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 68d68fec-36a7-445a-9b2e-4fdae5f24d16 |
    | service     | docker                               |
    | section     | docker-registry                      |
    | name        | auth-secret                          |
    | value       | d82f1653-4718-429c-b6d5-0fc3e27d32f9 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/69219fb7-4072-4391-ac13-fe429e8f1e2f |
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

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 8f153a9a-b249-4e50-8789-19a66b3f6f72 |
    | service     | docker                               |
    | section     | quay-registry                        |
    | name        | auth-secret                          |
    | value       | 69219fb7-4072-4391-ac13-fe429e8f1e2f |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/60369415-00be-4777-b16d-f2f8641cb079 |
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

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 6ed71e2c-b845-43a0-8827-fff8520135cf |
    | service     | docker                               |
    | section     | elastic-registry                     |
    | name        | auth-secret                          |
    | value       | 60369415-00be-4777-b16d-f2f8641cb079 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/6c45003f-29c3-4353-a55d-05bc55e278a7 |
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

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 43934f0f-08c4-48b8-92b5-14d2504f8053 |
    | service     | docker                               |
    | section     | gcr-registry                         |
    | name        | auth-secret                          |
    | value       | 6c45003f-29c3-4353-a55d-05bc55e278a7 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/dc79fe94-598d-4776-af59-9879f4253082 |
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

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 4e531e3d-9c8f-47e2-8919-68b50ba06a74 |
    | service     | docker                               |
    | section     | k8s-registry                         |
    | name        | auth-secret                          |
    | value       | dc79fe94-598d-4776-af59-9879f4253082 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+

    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | http://controller:9311/v1/secrets/d88d2562-2a58-43fb-ab42-d5e63c6bf500 |
    | Name          | registryk8s-registry-secret                                            |
    | Created       | None                                                                   |
    | Status        | None                                                                   |
    | Content types | None                                                                   |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | opaque                                                                 |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | fa8c3e00-b1b0-469b-8d73-5362f8d99725 |
    | service     | docker                               |
    | section     | registryk8s-registry                 |
    | name        | auth-secret                          |
    | value       | d88d2562-2a58-43fb-ab42-d5e63c6bf500 |
    | personality | None                                 |
    | resource    | None                                 |
    +-------------+--------------------------------------+


To update the registry secrets, go to :ref:`Update
the Registries' Auth-Secrets <update-the-registry-secrets>`.