
..
.. _validate-existing-registry-and-new-url:

=================================================
Display Updated Registries' URLs and Auth-Secrets
=================================================

To display the updated URLs, use the following command:

.. code-block:: none

    for registry in docker-registry quay-registry elastic-registry gcr-registry k8s-registry
    do
    uuid=`system service-parameter-list |grep $registry | grep url | awk '{print $2}'`
    url_path=`system service-parameter-show $uuid | grep value | awk '{print $4}'`
    echo $registry URL is $url_path
    done

You will get the following output:

.. code-block:: none

    docker-registry URL is new-registry.domain.com:9001/product-abc/starlingx/docker.io
    quay-registry URL is new-registry.domain.com:9001/product-abc/starlingx/quay.io
    elastic-registry URL is new-registry.domain.com:9001/product-abc/starlingx/docker.elastic.co
    gcr-registry URL is new-registry.domain.com:9001/product-abc/starlingx/gcr.io
    k8s-registry URL is new-registry.domain.com:9001/product-abc/starlingx/k8s.gcr.io

If the existing registries used authentication, use the following command to
display their auth-secrets:

.. code-block:: none

    system service-parameter-list | grep auth-secret

You will get the following output:

.. code-block:: none

    | 8dd9200f-5a14-43c0-afb9-941f0c571613 | docker   | docker-registry  | auth-secret                 | 19c8700b-0907-4fdb-bb4d-d4c23d9a644b                                             | None        | None     |
    | 44cb60f9-d51a-40d2-a376-c4f019f440ef | docker   | elastic-registry | auth-secret                 | d66dd561-e4a6-499a-b235-72a7e9dd1634                                             | None        | None     |
    | 24f183c0-bc8c-4d64-90ac-7619c862298c | docker   | gcr-registry     | auth-secret                 | 60723957-ab68-44cc-ab94-4a8b09c9e852                                             | None        | None     |
    | d438b4a1-72ae-459d-9074-76435a545aca | docker   | k8s-registry     | auth-secret                 | b2ab23d8-b878-41ae-bb5b-7bdba0f44f64                                             | None        | None     |
    | 37ac7a03-4bda-4367-9452-a14772958864 | docker   | quay-registry    | auth-secret                 | 58150478-c74b-496a-bcaf-98973835cc03                                             | None        | None     |

If the output result is similar to the authentication above, go to :ref:`Update the Registries' Auth-Secrets
<update-the-registry-secrets>`.

If the output result is blank, go to :ref:`Create the Registries' Auth-Secrets
<create-the-registry-secrets>`.
