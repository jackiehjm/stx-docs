.. _migrate-releases-from-helm-v2-to-helm-v3-a6066193c2a8:

========================================
Migrate Releases from Helm v2 to Helm v3
========================================

.. rubric:: |context|

After upgrading a cluster, end users' Helm releases are not upgraded from
version 2. Run a custom script to migrate the end users' Helm releases or
installs to Helm v3.

.. rubric:: |proc|

#.  Install the /helm-2to3 plugin.

    .. code-block:: none

        ~(keystone-admin)]$ mkdir plugin
        wget https://github.com/helm/helm-2to3/releases/download/v0.9.0/helm-2to3_0.9.0_linux_amd64.tar.gz
        pushd plugin/
        tar -xvzf ../helm-2to3_0.9.0_linux_amd64.tar.gz
        mkdir bin
        cp 2to3 bin
        popd
        export HELM_LINTER_PLUGIN_NO_INSTALL_HOOK=true
        helm plugin install ./plugin

#.  Move the helm2 config to helm3.

    .. code-block:: none

        ~(keystone-admin)]$ helm 2to3 move config

#.  Choose a Helm v2 release to migrate.

    .. code-block:: none

        ~(keystone-admin)]$ helmv2-cli -- helm list -a

#.  Migrate a helm2 release, for example, myApplication.

    .. code-block:: none

        ~(keystone-admin)]$ ./migrate_helm_release.py myApplication

#.  Check if it migrated successfully.

    .. code-block:: none

        ~(keystone-admin)]$ helm list -A -a

#.  The migrated release should not appear in helm2.

    .. code-block:: none

        ~(keystone-admin)]$ helmv2-cli -- helm list -a
