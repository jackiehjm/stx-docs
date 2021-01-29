
.. cmk1582149379500
.. _applying-a-custom-branding-tarball-to-running-systems:

==================================================
Apply a Custom Branding Tarball to Running Systems
==================================================

You can apply the custom branding tarball to running systems.

Complete the following steps to apply the custom branding tarball:

.. rubric:: |proc|

.. _applying-a-custom-branding-tarball-to-running-systems-steps-ayv-tqy-hkb:

#.  Delete any previous branding tarball from /opt/branding.

#.  Copy the new branding tarball to the /opt/branding directory on the
    active controller.

#.  Restart the Horizon Web interface.

    .. code-block:: none

        # sudo service horizon restart

#.  Lock, and unlock the inactive controller to apply the new configuration.