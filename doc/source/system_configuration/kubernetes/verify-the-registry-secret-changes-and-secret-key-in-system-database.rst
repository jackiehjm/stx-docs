..
.. _verify-the-registry-secret-changes-and-secret-key-in-system-database:

===================================================
Verify the Registries' Secret Configuration Changes
===================================================

To verify the registries' secret configuration changes, use the following command:

.. code-block:: none

    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry icr-registry ghcr-registry registryk8s-registry
    do
    echo $registry
    secret_uuid=`openstack secret list |grep ${registry}-secret | awk '{print $2}'`
    openstack secret get -d $secret_uuid
    done

You will get the following output:

docker-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

quay-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

elastic-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

gcr-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

k8s-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

icr-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

ghcr-registry

.. table::
    :widths: auto

    +---------+-----------------------------------+
    | Field   | Value                             |
    +---------+-----------------------------------+
    | Payload | username:docker password:******** |
    +---------+-----------------------------------+

To verify if the configured registries' secret is properly linked to the
registry entries in the service parameter table, use the following command:

.. code-block:: none

    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry icr-registry ghcr-registry
    do
    echo $registry
    uuid=`system service-parameter-list |grep  $registry | grep auth-secret | awk '{print $2}'`
    url=`system service-parameter-show ${uuid} | grep value | awk '{print $4}'`
    secret_uuid=`openstack secret list |grep ${registry}-secret | awk '{print $2}'| awk -F/ '{print $6}'`
    echo $url $secret_uuid
    if [ "${url}" != "${secret_uuid}" ]; then
    echo "**** ${registry} not correct"
    fi
    done

You will get the following output:

.. code-block:: none

    docker-registry
    1ee140e8-3246-4435-8dfc-5c37277767a2 1ee140e8-3246-4435-8dfc-5c37277767a2
    quay-registry
    657b91e8-e214-4fee-b391-0ad2ce9124de 657b91e8-e214-4fee-b391-0ad2ce9124de
    elastic-registry
    3f816e1c-7892-42e9-b269-f02bc14504fa 3f816e1c-7892-42e9-b269-f02bc14504fa
    gcr-registry
    4c58aa1a-2026-49d2-8f9c-f3f6b4b34eb1 4c58aa1a-2026-49d2-8f9c-f3f6b4b34eb1
    k8s-registry
    96d722e6-ab97-4185-9b97-64ee90c6162c 96d722e6-ab97-4185-9b97-64ee90c6162c
    icr-registry
    6fdaf773-a253-4b48-b9ff-d9dce1401c33 6fdaf773-a253-4b48-b9ff-d9dce1401c33
    ghcr-registry
    56b03b2b-7685-449d-ade4-3d8c4e73649f 56b03b2b-7685-449d-ade4-3d8c4e73649f

To add the CA Certificate, go to :ref:`Add the CA Certificate for New Registry
<add-the-ca-certificate-for-new-registry>`.