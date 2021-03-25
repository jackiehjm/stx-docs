
.. svy1588343679366
.. _enable-public-use-of-the-cert-manager-acmesolver-image:

======================================================
Enable Public Use of the cert-manager-acmesolver Image
======================================================

When an arbitrary non-admin user creates a certificate with an external |CA|,
cert-manager dynamically creates a pod \(image=cert-manager-acmesolver\)
and an ingress in the user-specified namespace in order to handle the
http01 challenge from the external CA.

.. rubric:: |context|

As part of the application-apply of cert-manager at bootstrap time, the
cert-manager-acmesolver image has been pulled from an external registry and
pushed to
registry.local:9001:/quay.io/jetstack/cert-manager-acmesolver:<tag>.
However, this repository within registry.local is secured such that only
**admin** can access these images.

The registry.local:9001:/quay.io/jetstack/cert-manager-acmesolver:<tag>
image needs to be copied by **admin** into a public repository,
registry.local:9001:/public. If you have not yet set up a public
repository, see |admintasks-doc|: :ref:`Setting up a Public Repository
<setting-up-a-public-repository>`.

.. rubric:: |proc|

#.  Determine the image tag of cert-manager-acmesolver image.

    .. code-block:: none

        ~(keystone_admin)$ system registry-image-tags quay.io/jetstack/cert-manager-acmesolver

#.  Copy the cert-manager-acmesolver image, and replace <TAG> with the tag
    you want to copy from previous step.

    .. code-block:: none

        $ sudo docker login registry.local:9001
        username: admin
        password: <admin-password>
        $
        $ sudo docker pull registry.local:9001/quay.io/jetstack/cert-manager-acmesolver:<TAG>
        $ sudo docker tag registry.local:9001/quay.io/jetstack/cert-manager-acmesolver:<TAG>  registry.local:9001/public/cert-manager-acmesolver:<TAG>
        $ sudo docker push registry.local:9001/public/cert-manager-acmesolver:<TAG>

#.  Update the cert-manager application to use this public image.

    #.  Create an overrides file.

        .. code-block:: none

            ~(keystone_admin)$ cat <<EOF > cm-override-values.yaml
            acmesolver:
              image:
                repository: registry.local:9001/public/cert-manager-acmesolver
            EOF


    #.  Apply the overrides.

        .. code-block:: none

            ~(keystone_admin)$ system helm-override-update --values cm-override-values.yaml cert-manager cert-manager cert-manager

    #.  Reapply cert-manager.

        .. code-block:: none

            ~(keystone_admin)$ system application-apply cert-manager


