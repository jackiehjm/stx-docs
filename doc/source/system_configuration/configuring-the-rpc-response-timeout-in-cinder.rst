
.. apa1590511404706
.. _configuring-the-rpc-response-timeout-in-cinder:

============================================
Configure the RPC Response Timeout in Cinder
============================================

You can change the Cinder |RPC| response timeout for all hosts using a helm
override.

.. rubric:: |proc|

#.  Create the Cinder overrides files.

    .. code-block:: none

        ~(keystone_admin)]$ cat <<EOF > ~/cinder-overrides.yaml
        conf:
          cinder:
            DEFAULT:
              rpc_response_timeout: 30
        EOF

#.  Update the Cinder overrides.

    .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update --values /home/sysadmin/cinder-overrides.yaml |prefix|-openstack cinder openstack --reuse-values

#.  Update |prefix|-openstack to apply the update.

    .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

#.  Confirm that the update has applied successfully.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl exec -n openstack <cinder-volume-pod-name> -- grep rpc_response_timeout /etc/cinder/cinder.conf