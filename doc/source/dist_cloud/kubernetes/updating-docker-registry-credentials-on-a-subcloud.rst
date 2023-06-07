
.. qdu1595389242059
.. _updating-docker-registry-credentials-on-a-subcloud:

===========================================================================
Update Credentials Used by Subcloud for Install Registry (registry.central)
===========================================================================

On a subcloud that uses the System Controller's Docker registry
(registry.central) as its install registry, you should use the
System Controller's sysinv service credentials for accessing registry.central.
This makes access to registry.central independent of changes to the Distributed
Cloud's Keystone admin user password.

.. warning::

    If the following registry information/credentials are changed, a new subcloud
    backup must be taken to avoid having a backup that contains old registry
    credentials.

Use the following procedure to update credentials used by the Subcloud to access
its install registry (registry.central) to the ``sysinv`` service credentials of
the System Controller.

.. rubric:: |proc|

.. _updating-docker-registry-credentials-on-a-subcloud-steps-ywx-wyt-kmb:

#.  On the System Controller, get the password for the sysinv services.

    .. code-block:: none

        $ keyring get sysinv services

#.  On each subcloud, run the following script to update the Docker registry
    credentials to sysinv:

    .. code-block:: none

        $ ./update_docker_registry_auth.sh sysinv <sysinv_password>

    Where **./update\_docker\_registry\_auth.sh** script is:

    .. code-block:: none

        #!/bin/bash -e

        USAGE="usage: ${0##*/} <username> <password>"

        if [ "$#" -ne 2 ]
        then
          echo Missing arguments.
          echo $USAGE
          echo
          exit
        fi

        NEW_CREDS="username:$1 password:$2"

        echo

        for REGISTRY in docker-registry quay-registry elastic-registry gcr-registry k8s-registry
        do

          echo -n "Updating" $REGISTRY "credentials ."
          SECRET_UUID=`system service-parameter-list | fgrep $REGISTRY | fgrep auth-secret | awk '{print $10}'`
          if [ -z "$SECRET_UUID" ]
          then
           echo "No $REGISTRY entry in service-parameters"
           echo
           continue
          fi
          SECRET_REF=`openstack secret list | fgrep ${SECRET_UUID} | awk '{print $2}'`
          echo -n "."
          SECRET_VALUE=`openstack secret get ${SECRET_REF} --payload -f value`
          echo -n "."

          openstack secret delete ${SECRET_REF} > /dev/null
          echo -n "."
          NEW_SECRET_VALUE=$NEW_CREDS
          openstack secret store -n ${REGISTRY}-secret -p "${NEW_SECRET_VALUE}" > /dev/null
          echo -n "."
          NEW_SECRET_REF=`openstack secret list | fgrep ${REGISTRY}-secret | awk '{print $2}'`
          NEW_SECRET_UUID=`echo "${NEW_SECRET_REF}" | awk -F/ '{print $6}'`
          system service-parameter-modify docker $REGISTRY auth-secret="${NEW_SECRET_UUID}" > /dev/null
          echo -n "."
          echo " done."

          echo -n "Validating $REGISTRY credentials updated to:  "
          SECRET_UUID=`system service-parameter-list | fgrep $REGISTRY | fgrep auth-secret | awk '{print $10}'`
          if [ -z "$SECRET_UUID" ]
          then
           continue
          fi
          SECRET_REF=`openstack secret list | fgrep ${SECRET_UUID} | awk '{print $2}'`
          SECRET_VALUE=`openstack secret get ${SECRET_REF} --payload -f value`
          echo $SECRET_VALUE

          echo

        done


