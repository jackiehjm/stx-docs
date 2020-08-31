
.. jzo1552681837074
.. _configure-the-keystone-token-expiration-time:

============================================
Configure the Keystone Token Expiration Time
============================================

You can change the default Keystone token expiration setting. This may be
required to provide sustained access for operations that take more than an
hour.

.. rubric:: |context|

By default, the Keystone token expiration time is set to 3600 seconds \(1
hour\). This is the amount of time a token remains valid. The new setting
must be between 3600 seconds and 14400 seconds.

.. rubric:: |proc|

#.  On the active controller, become the Keystone admin user.

    .. code-block:: none

        $ source /etc/platform/openrc

#.  Ensure that the token\_expiration parameter is defined for the identity
    service.

    .. code-block:: none

        $ system service-parameter-list | grep token_expiration

        | 712e4a45-777c-4e83-9d56-5042cde482f7 | identity | config | token_expiration | 3600


#.  Modify the service parameter using the following command:

    .. code-block:: none

        $ system service-parameter-modify identity config token_expiration=7200

#.  Apply the configuration change.

    .. code-block:: none

        $ system service-parameter-apply identity

        Applying identity service parameters

    Allow a few minutes for the change to take an effect.


