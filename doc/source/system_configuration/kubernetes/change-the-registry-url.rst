
..
.. _change-the-registry-url:

===========================
Change the Registries' URLs
===========================

Set the variable NEW_URL_START to the new registry and port, and change the
registries' URLs using the following command:

.. code-block:: none

    NEW_URL_START=new-registry.domain.com:9001
    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry
    do
    uuid=`system service-parameter-list |grep $registry | grep url | awk '{print $2}'`
    url_path=`system service-parameter-show $uuid | grep value | awk '{print $4}' | cut -d '/' -f 2-`
    system service-parameter-modify docker $registry url=$NEW_URL_START/$url_path
    done

.. rubric:: |result|

You will get the following output:

.. code-block:: none

    +-------------+--------------------------------------------------------------------------+
    | Property    | Value                                                                    |
    +-------------+--------------------------------------------------------------------------+
    | uuid        | 1f88c265-60a9-49b7-860b-785be9d832fc                                     |
    | service     | docker                                                                   |
    | section     | docker-registry                                                          |
    | name        | url                                                                      |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/docker.io             |
    | personality | None                                                                     |
    | resource    | None                                                                     |
    +-------------+--------------------------------------------------------------------------+

    +-------------+------------------------------------------------------------------------+
    | Property    | Value                                                                  |
    +-------------+------------------------------------------------------------------------+
    | uuid        | 459fde69-ee5f-4375-9817-cc7bc2bb06cb                                   |
    | service     | docker                                                                 |
    | section     | quay-registry                                                          |
    | name        | url                                                                    |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/quay.io             |
    | personality | None                                                                   |
    | resource    | None                                                                   |
    +-------------+------------------------------------------------------------------------+

    +-------------+----------------------------------------------------------------------------------+
    | Property    | Value                                                                            |
    +-------------+----------------------------------------------------------------------------------+
    | uuid        | c7537ee4-1dff-4627-9f99-3380a54a51e0                                             |
    | service     | docker                                                                           |
    | section     | elastic-registry                                                                 |
    | name        | url                                                                              |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/docker.elastic.co             |
    | personality | None                                                                             |
    | resource    | None                                                                             |
    +-------------+----------------------------------------------------------------------------------+

    +-------------+-----------------------------------------------------------------------+
    | Property    | Value                                                                 |
    +-------------+-----------------------------------------------------------------------+
    | uuid        | 144194d1-9c03-4db0-a336-c1a32467b1bd                                  |
    | service     | docker                                                                |
    | section     | gcr-registry                                                          |
    | name        | url                                                                   |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/gcr.io             |
    | personality | None                                                                  |
    | resource    | None                                                                  |
    +-------------+-----------------------------------------------------------------------+

    +-------------+---------------------------------------------------------------------------+
    | Property    | Value                                                                     |
    +-------------+---------------------------------------------------------------------------+
    | uuid        | 99800eff-c681-4dbd-8897-c5c5636f5fa1                                      |
    | service     | docker                                                                    |
    | section     | k8s-registry                                                              |
    | name        | url                                                                       |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/k8s.gcr.io             |
    | personality | None                                                                      |
    | resource    | None                                                                      |
    +-------------+---------------------------------------------------------------------------+

    +-------------+---------------------------------------------------------------------------+
    | Property    | Value                                                                     |
    +-------------+---------------------------------------------------------------------------+
    | uuid        | ea52a3cd-5aae-425a-967e-5a2bc19a1398                                      |
    | service     | docker                                                                    |
    | section     | registryk8s-registry                                                      |
    | name        | url                                                                       |
    | value       | new-registry.domain.com:9001/product-abc/starlingx/registry.k8s.io        |
    | personality | None                                                                      |
    | resource    | None                                                                      |
    +-------------+---------------------------------------------------------------------------+


To validate the registry, see :ref:`Display Updated Registries' URLs and Auth-Secrets
<validate-existing-registry-and-new-url>`.