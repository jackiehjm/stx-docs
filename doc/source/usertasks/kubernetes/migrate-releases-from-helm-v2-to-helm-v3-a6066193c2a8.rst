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

        export HELM_LINTER_PLUGIN_NO_INSTALL_HOOK=true
        helm plugin install /usr/local/share/helm/plugins/2to3

#.  Fetch existing helmv2 config.

    .. code-block:: none

        cat >get_helmv2_config.sh<<'EOF'
        JSONPATH='{range .items[*]}{"\n"}{@.metadata.name}:{@.metadata.deletionTimestamp}{range @.status.conditions[*]}{":"}{@.type}={@.status}{end}{end}'
        ARMADA_PODS=( $(kubectl get pods -n armada \
                        --kubeconfig=/etc/kubernetes/admin.conf \
                        --selector=application=armada,component=api \
                        --field-selector status.phase=Running \
                        --output=jsonpath="$JSONPATH") )
        if [ $#ARMADA_PODS[@] -eq 0 ]; then
            echo "$NAME: ERROR - Could not find armada pod."
            exit 1
        fi# Get first available Running and Ready armada pod, with tiller container
        POD=""
        for LINE in "$ARMADA_PODS[@]"; do
            # match only Ready pods with nil deletionTimestamp
            if [[ $LINE =~ ::.*Ready=True ]]; then
                # extract pod name, it is first element delimited by :
                A=$( cut -d ':' -f 1 - <<< "$LINE" )
                P=$A[0]
            else
                continue
            fi
            kubectl  --kubeconfig=/etc/kubernetes/admin.conf \
                cp armada/$P:tmp/.helm "$HOME"/.helm -c tiller
            RC=$?
            if [ $RC -eq 0 ]; then
                echo "$NAME: helmv2 config copied to $HOME/.helm"
                break
            else
                echo "$NAME: ERROR - failed to copy helm config from helmv2 (tiller) to host. (RETURNED: $RC)"
                exit 1
            fi
        done
        EOF


#.  Move the helm2 config to helm3.

    .. code-block:: none

        ~(keystone-admin)]$ helm 2to3 move config

#.  Choose a Helm v2 release to migrate.

    .. code-block:: none

        ~(keystone-admin)]$ helmv2-cli -- helm list -a

#.  Migrate a helm2 release, for example, myApplication.

    .. code-block:: none

        ~(keystone-admin)]$ migrate_helm_release.py myApplication

    .. note::

        The script ``migrate_helm_release.py`` is part of the |prod| release
        package.

#.  Check if it migrated successfully.

    .. code-block:: none

        ~(keystone-admin)]$ helm list -A -a

#.  The migrated release should not appear in helm2.

    .. code-block:: none

        ~(keystone-admin)]$ helmv2-cli -- helm list -a
