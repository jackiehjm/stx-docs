=============================
Mirror OpenDev Repo to GitHub
=============================

This section describes the steps to create a Zuul job to sync an OpenDev
repository to a GitHub repository.

.. contents::
   :local:
   :depth: 1

----------------------------------------------------
Create Zuul job to sync OpenDev repository to GitHub
----------------------------------------------------

#. Prepare GitHub repository.

   #. Create a new repository under github.com/starlingx. If possible, use the
      same repository name as original OpenDev repository.

   #. Grant 'write' permission to the starlingx-github user. Zuul will use the
      starlingx-github user to sync the repository.

#. Generate an SSH key.

   Zuul is needed to generate an SSH key. Refer to the
   `Zuul Quick-Start <https://zuul-ci.org/docs/zuul/tutorials/quick-start.html>`_
   for Zuul installation instructions.

   From a server that has the Zuul tool installed, run the following command,
   where <repo> is the name of the repository. The SSH key is at the end of the
   output after <fieldname>: tag.

   .. code-block:: yaml

      zuul/tools/encrypt_secret.py --infile ./starlingx.github@gmail.com --strip --tenant \
      openstack https://zuul.opendev.org starlingx/<repo>

      writing RSA key
      Public key length: 4096 bits (512 bytes)
      Max plaintext length per chunk: 470 bytes
      Input plaintext length: 3246 bytes
      Number of chunks: 7

      - secret:
          name: <name>
          data:
            <fieldname>: <ssh_key>

#. Add a new job to Zuul.

   Create a new job in .zuul.yaml in the root directory of the repository. The
   new job should look like the example below. Make sure to replace <repo> with
   the actual repository name. Replace <ssh_key> with the actual SSH key
   generated in the previous step.

   .. code-block:: yaml

      - job:
         name: stx-<repo>-upload-git-mirror
         parent: upload-git-mirror
         description: Mirrors opendev.org/starlingx/<repo> to github.com/starlingx/<repo>
         vars:
           git_mirror_repository: starlingx/<repo>
         secrets:
           - name: git_mirror_credentials
             secret: stx-<repo>-github-secret
             pass-to-parent: true

       - secret:
         name: stx-<repo>-github-secret
         data:
           user: git
           host: github.com
           # yamllint disable-line rule:line-length
           host_key: github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
           ssh_key: <ssh_key>

#. Set the new job as a Zuul post job.

   Add the job (named stx-<repo>-upload-git-mirror) to the post job section of
   the .zuul.yaml file. If there isn't an existing post job, create a new post
   job section. The .zuul.yaml post job section should look like the example
   below. Make sure <repo> is replaced with the actual repository name.

   Example .zuul.yaml post job section:

   .. code-block:: yaml

       - project:
         post:
           jobs:
             stx-<repo>-upload-git-mirror

----------------
Example Zuul job
----------------

An example of adding a Zuul job to sync a repository from opendev.org/starlingx
to github.com/starlingx can be found at:

https://opendev.org/starlingx/config/commit/5df1f3a89a6e1ef699fc6030a18902faf45daf88
