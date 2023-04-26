..
.. _about-changing-external-registries-for-starlingx-installation:

=============================================================
About Changing External Registries for StarlingX Installation
=============================================================

You can reassign the external registries used for |prod| installs, upgrades,
and application updates.

When installing and upgrading |prod| or applying and updating |prod|
applications, container images are pulled from external registries, for various
services. By default, these container images are pulled from the following
public registries: ``k8s.gcr.io``, ``gcr.io``, ``quay.io``, and ``docker.io``.
During installation, specifically during the bootstrap step, these external registries
can be overridden using the 'docker_registries' variable in the bootstrap
override file.  This task provides a procedure for changing these external
registries **after** installing |prod|.

.. rubric:: |context|

For convenience, many of the procedures are implemented in bash loops. If during
the loops errors occur the procedure will fail.  |prod| recommends to
capture the existing settings before running the commands.

.. rubric:: |prereq|

Make sure the following conditions are true:

* no alarm is present
* both controllers are online and unlocked
* all applications required are properly applied
* in the case of a subcloud in a distributed cloud deployment, the subcloud is in
  sync with the system controller
* the auth-secret, Url, and type exist for: ``system service-parameter-list | grep registry``

This is an example of the output:

.. code-block:: none

  | 16485f1e-757c-46a9-a366-0820b0f2ab77 | docker   | docker-registry      | auth-secret  | d76d3a01-7d28-4e17-a614-f10b7eb49438                                | None        | None     |
  | 4436a7ab-11bc-4adb-aa9a-d15fe7a5a337 | docker   | docker-registry      | type         | docker                                                              | None        | None     |
  | e9ac3877-bc1c-4bd0-8d4e-6ead5a09b07c | docker   | docker-registry      | url          | old-registry.domain.com:5001/product-abc/starlingx/docker.io        | None        | None     |
  | 3f44da5a-020d-42af-a15c-bf54da1e4c94 | docker   | elastic-registry     | auth-secret  | de5195da-a791-4d05-9bb2-0a106d65dd33                                | None        | None     |
  | afbc4d14-5359-4b54-9431-01fe83440cf6 | docker   | elastic-registry     | type         | docker                                                              | None        | None     |
  | 05644812-daee-43a0-89e3-45006a6807fd | docker   | elastic-registry     | url          | old-registry.domain.com:5001/product-abc/starlingx/docker.elastic.co| None        | None     |
  | 76c15302-62ec-44d8-8352-ae8e681dfb02 | docker   | gcr-registry         | auth-secret  | 772f88cb-3355-4663-8a95-026409b629cb                                | None        | None     |
  | 5d4004ed-c212-4cb0-b309-82225cc011a9 | docker   | gcr-registry         | type         | docker                                                              | None        | None     |
  | 18d8a51b-99b1-4caf-8e98-740dc3bdfd74 | docker   | gcr-registry         | url          | old-registry.domain.com:5001/product-abc/starlingx/gcr.io           | None        | None     |
  | 64e8a11f-3be9-4086-992a-948a92f8441b | docker   | k8s-registry         | auth-secret  | 4ba49153-fb12-4db6-9509-779ac4f1f2fa                                | None        | None     |
  | eca50140-b082-4229-8ca3-562abd6e3693 | docker   | k8s-registry         | type         | docker                                                              | None        | None     |
  | 497a935c-c8fc-422e-88d3-e9cbd6d12a95 | docker   | k8s-registry         | url          | old-registry.domain.com:5001/product-abc/starlingx/k8s.gcr.io       | None        | None     |
  | a84328a0-3219-4b54-b4fa-5903f25f70ea | docker   | quay-registry        | auth-secret  | c293a43d-0e4b-4dec-a5f4-baffb65e07f0                                | None        | None     |
  | 96b6eb45-b101-4bcb-8168-3f9f79baaa7d | docker   | quay-registry        | type         | docker                                                              | None        | None     |
  | 0fe2e1b9-8005-4ff8-98c2-ba0ad66103b9 | docker   | quay-registry        | url          | old-registry.domain.com:5001/product-abc/starlingx/quay.io          | None        | None     |
  | d88d2562-2a58-43fb-ab42-d5e63c6bf500 | docker   | registryk8s-registry | type         | docker                                                              | None        | None     |
  | fa8c3e00-b1b0-469b-8d73-5362f8d99725 | docker   | registryk8s-registry | url          | old-registry.domain.com:5001/product-abc/starlingx/registry.k8s.io  | None        | None     |
  | f3449be4-b8d5-43fd-8493-ede6429f411f | docker   | registryk8s-registry | auth-secret  | a48cfbac-849e-42cb-b012-b0b4f23bf2b9                                | None        | None     |


The new registry uses **username** and **password** authentication. Its path is
the same as the existing registry path. For example if ``docker.io`` path is
`old-registry.domain.com:5001/product-abc/starlingx/docker.io`
on the existing registry, then the new registry must be
`new-registry.domain.com:9001/product-abc/starlingx/docker.io`.

To change a registry, see :ref:`Change the Registries' URLs
<change-the-registry-url>`.